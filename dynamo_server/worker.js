const AWS = require("aws-sdk");
const docClient = new AWS.DynamoDB.DocumentClient();
const sqs = new AWS.SQS({ region: "us-east-1" });

const QUEUE_URL = "https://sqs.us-east-1.amazonaws.com/746669234475/order.fifo";

async function processBookingRequest(message) {
  const { cartItems, date, meal, selectedSession } = JSON.parse(message.Body);

  const transactItems = [];
  const unavailableItems = [];

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

      const menuItem = await docClient.get(params).promise();
      if (
        !menuItem.Item ||
        !menuItem.Item.meals_session_count[meal][selectedSession].Enabled
      ) {
        unavailableItems.push(item);
      } else {
        const sessionAvailableCount =
          menuItem.Item.meals_session_count[meal][selectedSession]
            .availableCount || 0;
        if (sessionAvailableCount < quantity) {
          unavailableItems.push(item);
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
        }
      }
    }

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
  } catch (error) {
    console.error("Error processing booking request:", error);
  }
}

async function pollSQSQueue() {
  const params = {
    QueueUrl: QUEUE_URL,
    MaxNumberOfMessages: 10, // Adjust based on how many you want to process at once
    WaitTimeSeconds: 20, // Long polling
  };

  try {
    const data = await sqs.receiveMessage(params).promise();
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

// Start polling the queue
setInterval(pollSQSQueue, 5000); // Poll every 5 seconds
