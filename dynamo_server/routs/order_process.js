const express = require("express");
const router = express.Router();
const AWS = require("aws-sdk");
const sqs = new AWS.SQS({ region: "us-east-1" });
const sns = new AWS.SNS({ region: "us-east-1" });

const docClient = new AWS.DynamoDB.DocumentClient({ region: "us-east-1" });

router.post("/book-items", async (req, res) => {
  const { userId, cartItems, date, meal, session: selectedSession } = req.body;

  console.log("Cart Items", req.body);

  const cartId = await fetchLastCartId();

  // Prepare the message to be published to SNS
  const snsMessage = {
    Message: JSON.stringify({
      userId: userId,
      cartItems: cartItems,
      date: date,
      cartId: cartId,
      meal: meal,
      selectedSession: selectedSession,
    }),
    TopicArn: "arn:aws:sns:us-east-1:746669234475:MyTopic.fifo",
    MessageGroupId: "BookingGroup", // Required for FIFO topics
    MessageDeduplicationId: `${new Date().toISOString()}-${Math.random()}`, // Ensures deduplication
  };

  try {
    // Publish the message to SNS
    console.log("Sending message to SNS", snsMessage);

    const data = await sns.publish(snsMessage).promise();
    console.log("Message sent to SNS", data);

    // Insert the request into r_list_history
    const historyParams = {
      TableName: "r-list_history",
      Item: {
        userId: userId,
        cartId: String(cartId),
        cartItems: cartItems,
        date: date,
        meal: meal,
        session: selectedSession,
        timestamp: new Date().toISOString(),
        status: "Pending",
      },
    };

    await docClient.put(historyParams).promise();
    console.log(`Inserted request for user ${userId} into r_list_history`);

    res.status(200).json({
      success: true,
      message: "Booking request received. Processing will happen shortly.",
      cartId: cartId,
    });
  } catch (error) {
    console.error("Error sending message to SNS:", error);
    res.status(500).json({
      success: false,
      message: "Failed to send booking request",
    });
  }
});

// Declare pendingRequests with let instead of const
// let pendingRequests = []; // Initialize with an empty array

// New endpoint to check order status
router.get("/booking-status/:cartId", async (req, res) => {
  const { cartId } = req.params;
  const { userId } = req.query;

  try {
    // Query r_list_history to get the current status of the booking
    const params = {
      TableName: "r-list_history",
      Key: {
        userId: userId,
        cartId: cartId,
      },
      ProjectionExpression: "#s",
      ExpressionAttributeNames: {
        "#s": "status", // Alias for reserved keyword 'status'
      },
    };

    console.log(params);

    const result = await docClient.get(params).promise();

    console.log(result);

    if (result.Item) {
      return res.status(200).json({
        success: true,
        status: result.Item.status,
      });
    }

    res.status(404).json({
      success: false,
      message: "Booking not found",
    });
  } catch (error) {
    console.error("Error fetching booking status:", error);
    res.status(500).json({
      success: false,
      message: "Failed to fetch booking status",
    });
  }
});

const fetchLastCartId = async () => {
  const params = {
    TableName: "r-list_history",
    Limit: 1000, // Adjust this if your table has more items. You can paginate if needed.
  };

  try {
    const data = await docClient.scan(params).promise(); // Use scan to get all items

    if (data.Items.length > 0) {
      // Sort the items by cartId (assuming cartId is numeric)
      data.Items.sort(
        (a, b) => parseInt(b.cartId, 10) - parseInt(a.cartId, 10)
      );

      // Get the cartId from the last record (which is now the first in the sorted array)
      const lastCartId = parseInt(data.Items[0].cartId, 10);
      return lastCartId + 1;
    } else {
      // If no records exist, start from cartId 1
      return 1;
    }
  } catch (err) {
    console.error("Error fetching last cartId:", err);
    throw new Error("Failed to fetch last cartId");
  }
};

module.exports = router;
