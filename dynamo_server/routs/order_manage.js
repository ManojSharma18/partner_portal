const express = require("express");
const router = express.Router();
const AWS = require("aws-sdk");
const sqs = new AWS.SQS({ region: "us-east-1" });

const docClient = new AWS.DynamoDB.DocumentClient({ region: "us-east-1" });

router.post("/", (req, res) => {
  const {
    ritem_UId,
    ritem_dispname,
    ritem_availability,
    ritem_category,
    ritem_tag,
    ritem_available_type,
    day,
    date,
    meals_session_count,
  } = req.body;

  const params = {
    TableName: "LiveMenuNew",
    Item: {
      ritem_UId,
      ritem_dispname,
      ritem_availability,
      ritem_category,
      ritem_tag,
      ritem_available_type,
      day,
      date,
      meals_session_count,
    },
  };

  docClient.put(params, (err, data) => {
    if (err) {
      console.error(
        "Unable to add item. Error JSON:",
        JSON.stringify(err, null, 2)
      );
      res.status(500).send({
        message: "Error adding item to DynamoDB",
        error: err,
      });
    } else {
      console.log("Added item:", JSON.stringify(data, null, 2));
      res.status(201).send({
        message: "Item added successfully",
        data: params.Item,
      });
    }
  });
});

router.get("/", (req, res) => {
  const params = {
    TableName: "LiveMenuNew",
  };

  docClient.scan(params, (err, data) => {
    if (err) {
      console.error(
        "Unable to scan the table. Error JSON:",
        JSON.stringify(err, null, 2)
      );
      res.status(500).send({
        message: "Error fetching items from DynamoDB",
        error: err,
      });
    } else {
      console.log("Scan succeeded:", JSON.stringify(data, null, 2));
      res.status(200).send({
        message: "Items fetched successfully",
        data: data.Items,
      });
    }
  });
});

router.get("/date/:date", async (req, res) => {
  const dateParam = req.params.date;

  console.log(dateParam);

  const params = {
    TableName: "LiveMenuNew",
    FilterExpression: "#date = :dateValue",
    ExpressionAttributeNames: {
      "#date": "date",
    },
    ExpressionAttributeValues: {
      ":dateValue": dateParam,
    },
  };

  try {
    const data = await docClient.scan(params).promise();

    if (data.Items.length === 0) {
      return res
        .status(404)
        .json({ message: "No items found for the given date" });
    }

    res.status(200).json(data.Items);
  } catch (e) {
    console.error("Error fetching items by date:", e);
    res.status(500).json({ message: "Unable to fetch items" });
  }
});

const allOrders = [];

// router.post("/book-items", async (req, res) => {
//   const { cartItems, date, meal, session: selectedSession } = req.body;

//   console.log("CArt Items ", req.body);

//   // Prepare the transaction parameters
//   const transactItems = [];
//   const unavailableItems = [];

//   try {
//     // Loop through each cart item to prepare the transaction
//     for (const item of cartItems) {
//       console.log(item);
//       const { ritem_UId, quantity } = item;

//       // Query the database for the specific item, date, meal, and session
//       const params = {
//         TableName: "LiveMenuNew",
//         Key: {
//           ritem_UId: String(ritem_UId), // Ensure proper key names and types
//           date: String(date), // Partition key // Sort key
//         },
//         ProjectionExpression: `meals_session_count.${meal}.${selectedSession}.Enabled, meals_session_count.${meal}.${selectedSession}.availableCount`,
//       };

//       console.log(params);
//       const menuItem = await docClient.get(params).promise();
//       //   console.log("Working");

//       console.log("Menu item", menuItem);

//       if (
//         !menuItem.Item ||
//         !menuItem.Item.meals_session_count[meal][selectedSession].Enabled
//       ) {
//         // If the item is not found or not enabled for the session, add to unavailable items
//         unavailableItems.push(item);
//       } else {
//         // Check the available count in the specific session for that meal
//         const sessionAvailableCount =
//           menuItem.Item.meals_session_count[meal][selectedSession]
//             .availableCount || 0;

//         if (sessionAvailableCount < quantity) {
//           unavailableItems.push(item);
//         } else {
//           // Prepare the update parameters for transaction
//           transactItems.push({
//             Update: {
//               TableName: "LiveMenuNew",
//               Key: {
//                 ritem_UId: String(ritem_UId), // Ensure proper key names and types
//                 date: String(date), // Sort key
//               },
//               UpdateExpression: `SET meals_session_count.${meal}.${selectedSession}.availableCount =:newCount`,
//               ExpressionAttributeValues: {
//                 ":newCount": sessionAvailableCount - quantity,
//               },
//             },
//           });
//         }
//       }
//     }

//     if (unavailableItems.length > 0) {
//       return res.status(200).json({
//         success: false,
//         message: "Some items are not available",
//         unavailableItems,
//       });
//     }

//     if (transactItems.length === 0) {
//       return res.status(400).json({
//         success: false,
//         message: "No valid transactions to process",
//       });
//     }

//     // Execute transaction
//     const transactParams = {
//       TransactItems: transactItems,
//     };

//     console.log(
//       "Transaction Parameters:",
//       JSON.stringify(transactParams, null, 2)
//     );

//     await docClient.transactWrite({ TransactItems: transactItems }).promise();

//     console.log("All Orders are", allOrders);

//     res.status(200).json({
//       success: true,
//       message: "All items booked successfully",
//     });
//   } catch (error) {
//     console.error("Error processing transaction:", error);
//     res.status(500).json({
//       success: false,
//       message: "Internal server error",
//     });
//   }
// });

router.post("/book-items", async (req, res) => {
  const { userId, cartItems, date, meal, session: selectedSession } = req.body;

  console.log("Cart Items", req.body);

  const cartId = await fetchLastCartId();

  // Prepare the message to be sent to the queue
  const sqsMessage = {
    MessageBody: JSON.stringify({
      userId,
      cartItems,
      date,
      cartId,
      meal,
      selectedSession,
    }),
    QueueUrl: "https://sqs.us-east-1.amazonaws.com/746669234475/order.fifo", // Replace with your SQS queue URL
    MessageGroupId: "BookingRequests", // For FIFO queues to maintain order
    MessageDeduplicationId: `${new Date().toISOString()}-${Math.random()}`,
  };

  try {
    // Send the message to the SQS queue\
    console.log(sqsMessage);

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

    try {
      await docClient.put(historyParams).promise();
      console.log(`Inserted request for user ${userId} into r_list_history`);

      // requestStatusMap.set(`${userId}-${quantity}`, "Pending");
    } catch (err) {
      console.error(
        `Error inserting request for user ${userId} into r_list_history:`,
        err
      );
    }

    const data = await sqs.sendMessage(sqsMessage).promise();
    console.log("Message sent to SQS", data);

    res.status(200).json({
      success: true,
      message: "Booking request received. Processing will happen shortly.",
      cartId: cartId,
    });
  } catch (error) {
    console.error("Error sending message to SQS:", error);
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

// const fetchLastOrderId = async (mealOrder) => {
//   const params = {
//     TableName: mealOrder,
//     Limit: 1000, // Adjust this if your table has more items. You can paginate if needed.
//   };

//   try {
//     const data = await docClient.scan(params).promise();

//     if (data.Items.length > 0) {
//       data.Items.sort((a, b) => parseInt(b.ordId, 10) - parseInt(a.ordId, 10));
//       const lastOrderId = parseInt(data.Items[0].ordId, 10);
//       return lastOrderId + 1;
//     } else {
//       return 1;
//     }
//   } catch (err) {
//     console.error("Error fetching last orderId:", err);
//     throw new Error("Failed to fetch last orderId");
//   }
// };

// router.post("/book-items", async (req, res) => {
//   const { userId, cartItems, date, meal, session: selectedSession } = req.body;

//   // Add each cart item to the pending list
//   cartItems.forEach((item) => {
//     pendingRequests.push({
//       userId,
//       ritem_UId: item.ritem_UId,
//       quantity: item.quantity,
//       date,
//       meal,
//       selectedSession,
//     });
//   });

//   // Process the bookings for each item in the cart
//   try {
//     const processedItems = await Promise.all(
//       cartItems.map((item) =>
//         processBookings(item.ritem_UId, date, meal, selectedSession)
//       )
//     );

//     res.status(200).json({
//       success: true,
//       message: `Booking request processed`,
//       processedItems,
//     });
//   } catch (error) {
//     console.error("Error processing booking:", error);
//     res.status(500).json({
//       success: false,
//       message: "Internal server error",
//     });
//   }
// });

// const processBookings = async (itemId, date, meal, selectedSession) => {
//   const itemRequests = pendingRequests.filter(
//     (request) => request.ritem_UId === itemId
//   );

//   // Sort requests by quantity in descending order
//   itemRequests.sort((a, b) => b.quantity - a.quantity);

//   // Get current availability
//   const params = {
//     TableName: "LiveMenuNew",
//     Key: {
//       ritem_UId: String(itemId), // Ensure proper key names and types
//       date: String(date),
//     },
//     ProjectionExpression: `meals_session_count.${meal}.${selectedSession}.Enabled, meals_session_count.${meal}.${selectedSession}.availableCount`,
//   };

//   const menuItem = await docClient.get(params).promise();
//   let sessionAvailableCount =
//     menuItem.Item?.meals_session_count[meal][selectedSession]?.availableCount ||
//     0;

//   const successfulBookings = [];
//   const failedBookings = [];

//   const requestStatusMap = new Map();

//   let cartId;

//   console.log("Item request", itemRequests);

//   // Process each request
//   for (const request of itemRequests) {
//     const { userId, quantity } = request;

//     cartId = await fetchLastCartId();

//     // Insert the request into r_list_history
//     const historyParams = {
//       TableName: "r-list_history",
//       Item: {
//         userId: userId,
//         cartId: String(cartId),
//         ritem_UId: itemId,
//         date: date,
//         meal: meal,
//         session: selectedSession,
//         quantity: quantity,
//         timestamp: new Date().toISOString(),
//         status: "Pending",
//       },
//     };

//     try {
//       await docClient.put(historyParams).promise();
//       console.log(`Inserted request for user ${userId} into r_list_history`);

//       requestStatusMap.set(`${userId}-${quantity}`, "Pending");
//     } catch (err) {
//       console.error(
//         `Error inserting request for user ${userId} into r_list_history:`,
//         err
//       );
//     }

//     console.log(sessionAvailableCount, quantity);

//     if (sessionAvailableCount >= quantity) {
//       // Update availability and record successful booking
//       sessionAvailableCount -= quantity;
//       successfulBookings.push({ userId, itemId, quantity });
//       requestStatusMap.set(`${userId}-${quantity}`, "Confirmed");

//       // Prepare the update parameters for transaction
//       try {
//         await docClient
//           .update({
//             TableName: "LiveMenuNew",
//             Key: {
//               ritem_UId: String(itemId),
//               date: String(date),
//             },
//             UpdateExpression: `SET meals_session_count.${meal}.${selectedSession}.availableCount = :newCount`,
//             ExpressionAttributeValues: {
//               ":newCount": sessionAvailableCount,
//               ":currentCount":
//                 menuItem.Item.meals_session_count[meal][selectedSession]
//                   .availableCount,
//             },
//             ConditionExpression: `meals_session_count.${meal}.${selectedSession}.availableCount = :currentCount`,
//           })
//           .promise();
//       } catch (updateError) {
//         console.error("Error updating availability:", updateError);
//         requestStatusMap.set(`${userId}-${quantity}`, "Failed");
//       }
//     } else {
//       failedBookings.push({ userId, itemId, quantity });
//       requestStatusMap.set(`${userId}-${quantity}`, "Failed");
//     }
//   }

//   // Add successful bookings to the corresponding order table
//   const tableNameMap = {
//     breakfast: "orders_breakfast",
//     lunch: "orders_lunch",
//     dinner: "orders_dinner",
//   };

//   for (const booking of successfulBookings) {
//     const ordId = await fetchLastOrderId(tableNameMap[meal.toLowerCase()]);

//     // console.log("ord Id", ordId);

//     const orderParams = {
//       TableName: tableNameMap[meal.toLowerCase()],
//       Item: {
//         userId: booking.userId,
//         ordId: String(ordId),
//         ritem_UId: booking.itemId,
//         date: date,
//         meal: meal,
//         session: selectedSession,
//         quantity: booking.quantity,
//         timestamp: new Date().toISOString(),
//         status: "Confirmed", // Or any other status you want to set
//       },
//     };

//     try {
//       await docClient.put(orderParams).promise();
//       console.log(
//         `Inserted booking for user ${booking.userId} into ${
//           tableNameMap[meal.toLowerCase()]
//         }`
//       );
//     } catch (err) {
//       console.error(
//         `Error inserting booking for user ${booking.userId} into ${
//           tableNameMap[meal.toLowerCase()]
//         }:`,
//         err
//       );
//     }
//   }

//   //   console.log(requestStatusMap);

//   // Update status in r-list_history based on requestStatusMap
//   for (const [key, status] of requestStatusMap) {
//     const [userId, quantity] = key.split("-");

//     const updateParams = {
//       TableName: "r-list_history",
//       Key: {
//         userId: userId,
//         cartId: String(cartId),
//       },
//       UpdateExpression: "SET #status = :status",
//       ExpressionAttributeNames: {
//         "#status": "status",
//       },
//       ExpressionAttributeValues: {
//         ":status": status,
//       },
//     };

//     // console.log("UpdateParams", updateParams);

//     try {
//       await docClient.update(updateParams).promise();
//       console.log(
//         `Updated status for user ${userId} in r_list_history to ${status}`
//       );
//     } catch (err) {
//       console.error(
//         `Error updating status for user ${userId} in r_list_history:`,
//         err
//       );
//     }
//   }

//   // Clear processed requests
//   pendingRequests = pendingRequests.filter(
//     (request) =>
//       !successfulBookings.some((success) => success.userId === request.userId)
//   );
//   pendingRequests = [];

//   return { successfulBookings, failedBookings };
// };

module.exports = router;
