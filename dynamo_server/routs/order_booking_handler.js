const AWS = require("aws-sdk");
const docClient = new AWS.DynamoDB.DocumentClient({ region: "us-east-1" });
const sns = new AWS.SNS({ region: "us-east-1" });

exports.handler = async (event) => {
  const transactItems = [];
  const unavailableItems = [];

  for (const record of event.Records) {
    const message = JSON.parse(record.body);
    const { userId, cartItems, date, meal, selectedSession, cartId } = message;

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

        const menuItem = await docClient.get(params).promise();

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
        await docClient
          .transactWrite({ TransactItems: transactItems })
          .promise();
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

        await docClient.put(orderParams).promise();
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
