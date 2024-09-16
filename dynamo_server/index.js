const express = require("express");
const bodyParser = require("body-parser");
const cors = require("cors");
const AWS = require("aws-sdk");
const sqs = new AWS.SQS({ region: "us-east-1" });

const app = express();
const port = 3090;

app.use(cors());

app.use(bodyParser.json());

const docClient = new AWS.DynamoDB.DocumentClient({ region: "us-east-1" });

// const liveMenuNewRouter = require("./routs/order_manage");
// app.use("/liveMenu", liveMenuNewRouter);

const orderProcessRouter = require("./routs/order_process");
app.use("/orderProcess", orderProcessRouter);

const QUEUE_URL =
  "https://sqs.us-east-1.amazonaws.com/746669234475/MyQueue.fifo";

async function processBookingRequest(message) {
  const { userId, cartItems, date, meal, selectedSession, cartId } = JSON.parse(
    message.Body
  );

  const transactItems = [];
  const unavailableItems = [];
  let status = "Failed";

  console.log("I am here");

  try {
    for (const item of cartItems) {
      const { ritem_UId, quantity } = item;

      console.log("item", item);

      // Query the database for the specific item, date, meal, and session
      const params = {
        TableName: "LiveMenuNew",
        Key: {
          ritem_UId: String(ritem_UId),
          date: String(date),
        },
        ProjectionExpression: `meals_session_count.${meal}.${selectedSession}.Enabled, meals_session_count.${meal}.${selectedSession}.availableCount`,
      };

      const menuItem = await docClient.get(params).promise();

      if (
        !menuItem.Item ||
        !menuItem.Item.meals_session_count[meal][selectedSession].Enabled
      ) {
        unavailableItems.push(item);
        status = "Failed";
        updateOrder(userId, cartId, status);
        console.log("Some items are unavailable:", unavailableItems);
        return;
      } else {
        const sessionAvailableCount =
          menuItem.Item.meals_session_count[meal][selectedSession]
            .availableCount || 0;
        status = "Failed";
        if (sessionAvailableCount < quantity) {
          unavailableItems.push(item);
          status = "Failed";
          updateOrder(userId, cartId, status);
          console.log("Some items are unavailable:", unavailableItems);
          return;
        } else {
          transactItems.push({
            Update: {
              TableName: "LiveMenuNew",
              Key: {
                ritem_UId: String(ritem_UId),
                date: String(date),
              },
              UpdateExpression: `SET meals_session_count.${meal}.${selectedSession}.availableCount = :newCount`,
              ExpressionAttributeValues: {
                ":newCount": sessionAvailableCount - quantity,
              },
            },
          });
          status = "Successfull";
          updateOrder(userId, cartId, status);
        }
      }
    }

    // const updateListHistory = {
    //   TableName: "r-list_history",
    //   Key: {
    //     userId: userId,
    //     cartId: String(cartId),
    //   },
    //   UpdateExpression: "SET #status = :status",
    //   ExpressionAttributeNames: {
    //     "#status": "status",
    //   },
    //   ExpressionAttributeValues: {
    //     ":status": status,
    //   },
    // };

    // try {
    //   await docClient.update(updateListHistory).promise();
    //   console.log(`Updated status for user ${userId} in r_list_history to `);
    // } catch (err) {
    //   console.error(
    //     `Error updating status for user ${userId} in r_list_history:`,
    //     err
    //   );
    // }

    if (unavailableItems.length > 0) {
      console.log("Some items are unavailable:", unavailableItems);
      return;
    }

    if (transactItems.length === 0) {
      console.log("No valid transactions to process.");
      return;
    }

    // Execute the transaction
    await docClient.transactWrite({ TransactItems: transactItems }).promise();
    console.log("Booking processed successfully.");
    if (status === "Successfull") {
      const tableNameMap = {
        breakfast: "orders_breakfast",
        lunch: "orders_lunch",
        dinner: "orders_dinner",
      };

      const ordId = await fetchLastOrderId(tableNameMap[meal.toLowerCase()]);

      const orderParams = {
        TableName: tableNameMap[meal.toLowerCase()],
        Item: {
          userId: userId,
          ordId: String(ordId),
          cartItems: cartItems,
          date: date,
          meal: meal,
          session: selectedSession,
          timestamp: new Date().toISOString(),
          status: "Successfull", // Or any other status you want to set
        },
      };

      try {
        await docClient.put(orderParams).promise();
        console.log(
          `Inserted booking for user ${userId} into ${
            tableNameMap[meal.toLowerCase()]
          }`
        );
      } catch (err) {
        console.error(
          `Error inserting booking for user ${userId} into ${
            tableNameMap[meal.toLowerCase()]
          }:`,
          err
        );
      }
    }
  } catch (error) {
    console.error("Error processing booking request:", error);
  }
}

const fetchLastOrderId = async (mealOrder) => {
  const params = {
    TableName: mealOrder,
    Limit: 1000, // Adjust this if your table has more items. You can paginate if needed.
  };

  try {
    const data = await docClient.scan(params).promise();

    if (data.Items.length > 0) {
      data.Items.sort((a, b) => parseInt(b.ordId, 10) - parseInt(a.ordId, 10));
      const lastOrderId = parseInt(data.Items[0].ordId, 10);
      return lastOrderId + 1;
    } else {
      return 1;
    }
  } catch (err) {
    console.error("Error fetching last orderId:", err);
    throw new Error("Failed to fetch last orderId");
  }
};

async function updateOrder(userId, cartId, status) {
  const updateListHistory = {
    TableName: "r-list_history",
    Key: {
      userId: userId,
      cartId: String(cartId),
    },
    UpdateExpression: "SET #status = :status",
    ExpressionAttributeNames: {
      "#status": "status",
    },
    ExpressionAttributeValues: {
      ":status": status,
    },
  };

  try {
    await docClient.update(updateListHistory).promise();
    console.log(`Updated status for user ${userId} in r_list_history to `);
  } catch (err) {
    console.error(
      `Error updating status for user ${userId} in r_list_history:`,
      err
    );
  }
}

async function pollSQSQueue() {
  const params = {
    QueueUrl: QUEUE_URL,
    MaxNumberOfMessages: 10, // Adjust based on how many you want to process at once
    WaitTimeSeconds: 10, // Long polling
  };

  try {
    const data = await sqs.receiveMessage(params).promise();

    console.log(data);
    if (data.Messages) {
      for (const message of data.Messages) {
        await processBookingRequest(message);

        // Delete the message after successful processing
        const deleteParams = {
          QueueUrl: QUEUE_URL,
          ReceiptHandle: message.ReceiptHandle,
        };
        await sqs.deleteMessage(deleteParams).promise();
        console.log("Message deleted from queue:", message.MessageId);
      }
    }
  } catch (error) {
    console.error("Error receiving messages from SQS:", error);
  }
}

// setInterval(pollSQSQueue, 3000);

app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});
