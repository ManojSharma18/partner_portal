import { DynamoDBClient } from "@aws-sdk/client-dynamodb";
import {
  GetCommand,
  TransactWriteCommand,
  ScanCommand,
  UpdateCommand,
  PutCommand,
} from "@aws-sdk/lib-dynamodb"; // Use lib-dynamodb for commands

import { SNSClient } from "@aws-sdk/client-sns";

const docClient = new DynamoDBClient({ region: "us-east-1" });
const sns = new SNSClient({ region: "us-east-1" });

export const handler = async (event) => {
  const transactItems = [];
  const unavailableItems = [];

  for (const record of event.Records) {
    const message = JSON.parse(record.body);
    const parsedMessage = JSON.parse(message.Message);
    const { userId, cartItems, date, meal, selectedSession, cartId } =
      parsedMessage;

    console.log("Cart items", cartItems);
    console.log("Received message:", message);

    if (!Array.isArray(cartItems)) {
      console.error("cartItems is not an array or undefined:", cartItems);
      continue; // Skip processing this record if cartItems is not valid
    }

    let status = "Failed";
    try {
      for (const item of cartItems) {
        const { ritem_UId, quantity } = item;

        // Query the database for the specific item, date, meal, and session
        const params = {
          TableName: "LiveMenuNew",
          Key: {
            ritem_UId: String(ritem_UId),
            date: String(date),
          },
          ProjectionExpression: `meals_session_count.${meal}.${selectedSession}.Enabled, meals_session_count.${meal}.${selectedSession}.availableCount`,
        };

        const menuItem = await docClient.send(new GetCommand(params));

        if (
          !menuItem.Item ||
          !menuItem.Item.meals_session_count[meal][selectedSession].Enabled
        ) {
          unavailableItems.push(item);
          status = "Failed";
          await updateOrder(userId, cartId, status);
          console.log("Some items are unavailable:", unavailableItems);
          return;
        } else {
          const sessionAvailableCount =
            menuItem.Item.meals_session_count[meal][selectedSession]
              .availableCount || 0;
          if (sessionAvailableCount < quantity) {
            unavailableItems.push(item);
            status = "Failed";
            await updateOrder(userId, cartId, status);
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
            await updateOrder(userId, cartId, status);
          }
        }
      }

      // Execute the transaction
      if (transactItems.length > 0) {
        await docClient.send(
          new TransactWriteCommand({ TransactItems: transactItems })
        );
        console.log("Booking processed successfully.");
      }

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
            status: "Successfull",
          },
        };

        await docClient.send(new PutCommand(orderParams));
        console.log(
          `Inserted booking for user ${userId} into ${
            tableNameMap[meal.toLowerCase()]
          }`
        );
      }
    } catch (error) {
      console.error("Error processing booking request:", error);
    }
  }
};

const fetchLastOrderId = async (mealOrder) => {
  const params = {
    TableName: mealOrder,
    Limit: 1000, // Adjust this if your table has more items. You can paginate if needed.
  };

  try {
    const data = await docClient.send(new ScanCommand(params));

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
    await docClient.send(new UpdateCommand(updateListHistory));
    console.log(`Updated status for user ${userId} in r_list_history to `);
  } catch (err) {
    console.error(
      `Error updating status for user ${userId} in r_list_history:`,
      err
    );
  }
}
