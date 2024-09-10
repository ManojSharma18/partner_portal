const express = require("express");
const router = express.Router();
const mongoose = require("mongoose");
const { LiveMenuNew } = require("../models/live_menu_new");

router.post("/", async (req, res) => {
  console.log(req.body);

  try {
    // Ensure the request body is an array
    if (!Array.isArray(req.body)) {
      return res
        .status(400)
        .json({ error: "Data should be an array of objects." });
    }

    // Extract the array from the request body
    const liveMenuItems = req.body;

    // Determine today's and tomorrow's dates
    const today = new Date();
    const tomorrow = new Date(today);
    tomorrow.setDate(today.getDate() + 1);

    const todayDate = today.toISOString().split("T")[0]; // Format: YYYY-MM-DD
    const tomorrowDate = tomorrow.toISOString().split("T")[0];

    // Create a map to track existing items by ritem_UId
    const existingItemsMap = new Map();

    // Fetch existing items based on ritem_UId from the collection
    for (const item of liveMenuItems) {
      const existingItem = await LiveMenuNew.findOne({
        ritem_UId: item.ritem_UId,
      });
      if (existingItem) {
        existingItemsMap.set(item.ritem_UId, existingItem);
        break;
        console.log("Exisintg items are", existingItemsMap);
      }
    }

    // Filter out items with today's and tomorrow's dates if existing items are found
    const filteredItems = liveMenuItems.filter((item) => {
      if (existingItemsMap.has(item.ritem_UId)) {
        // Skip items with today's or tomorrow's dates
        return item.date !== todayDate && item.date !== tomorrowDate;
      }
      // Include item if no existing item found
      return true;
    });

    // Use mongoose insertMany to handle multiple data
    const savedData = await LiveMenuNew.insertMany(filteredItems);

    // Respond with the inserted items
    return res.status(201).json(savedData);
  } catch (e) {
    console.error("Error occurred while posting data:", e);
    res.status(500).json({ error: "Could not post your data" });
  }
});

router.post("/fromLiveMenu", async (req, res) => {
  console.log(req.body);

  try {
    // Ensure the request body is an array
    if (!Array.isArray(req.body)) {
      return res
        .status(400)
        .json({ error: "Data should be an array of objects." });
    }

    // Extract the array from the request body
    const liveMenuItems = req.body;

    // Use mongoose insertMany to handle multiple data
    const savedData = await LiveMenuNew.insertMany(liveMenuItems);

    // Respond with the inserted items
    return res.status(201).json(savedData);
  } catch (e) {
    console.error("Error occurred while posting data:", e);
    res.status(500).json({ error: "Could not post your data" });
  }
});

router.get("/", async (req, res) => {
  try {
    const liveMenu = await LiveMenuNew.find();

    return res.status(200).json(liveMenu);
  } catch (e) {
    console.log("error", e);
    res.status(500).json({ message: "Unable to fetch items" });
  }
});

router.get("/date/:date", async (req, res) => {
  try {
    const dateParam = req.params.date;

    // Ensure the date is in the correct format
    const liveMenu = await LiveMenuNew.find({ date: dateParam });

    return res.status(200).json(liveMenu);
  } catch (e) {
    console.log("error", e);
    res.status(500).json({ message: "Unable to fetch items" });
  }
});

router.delete("/fromLiveMenu", async (req, res) => {
  try {
    const { ritem_UId, date } = req.body;

    // Find and delete the item matching both ritem_UId and date
    const result = await LiveMenuNew.findOneAndDelete({
      ritem_UId: ritem_UId,
      date: date,
    });

    if (result) {
      return res.status(200).json({ message: "Item deleted successfully" });
    } else {
      return res.status(404).json({ message: "Item not found" });
    }
  } catch (e) {
    console.log(e);
    return res.status(500).json({ message: "Unable to delete item" });
  }
});

router.put("/fromLiveMenu", async (req, res) => {
  try {
    const { ritem_UId, date, updateData } = req.body;

    const update = await LiveMenuNew.updateOne(
      { ritem_UId, date: date },
      { $set: updateData },
      { new: true, runValidators: true }
    );

    if (update) {
      return res.status(200).json({ message: "Item updated successfully" });
    } else {
      return res.status(404).json({ message: "Item not found" });
    }
  } catch (e) {
    console.log(e);
    return res.status(500).json({ message: "Unable to delete item" });
  }
});

router.delete("/", async (req, res) => {
  try {
    const { ritem_UId } = req.body; // Destructure ritem_UId from req.body

    // Get today's start and end
    const todayStart = new Date();
    todayStart.setUTCHours(0, 0, 0, 0);
    todayStart.setUTCHours(todayStart.getDate() - 1);

    const todayEnd = new Date(todayStart);
    todayEnd.setUTCHours(23, 59, 59, 999);

    // Get tomorrow's start and end
    const tomorrowStart = new Date(todayStart);
    tomorrowStart.setDate(tomorrowStart.getDate() + 1);

    const tomorrowEnd = new Date(tomorrowStart);
    tomorrowEnd.setUTCHours(23, 59, 59, 999);

    console.log("Today's start:", todayStart.toISOString());
    console.log("Today's end:", todayEnd.toISOString());
    console.log(
      "Tomorrow's start:",
      tomorrowStart.toISOString().substring(0, 10)
    );
    console.log("Tomorrow's end:", tomorrowEnd.toISOString().substring(0, 10));

    // Query to find items that should be deleted
    const query = {
      ritem_UId,
      $or: [
        { date: { $lt: todayStart.toISOString().substring(0, 10) } }, // Dates before today
        { date: { $gt: tomorrowEnd.toISOString().substring(0, 10) } }, // Dates after tomorrow
      ],
    };

    console.log("Query:", query);

    // Delete items where ritem_UId matches and the date is not today or tomorrow
    const deletedItems = await LiveMenuNew.deleteMany(query);

    if (deletedItems.deletedCount > 0) {
      return res.status(200).json({
        message: "Items deleted successfully",
        deletedCount: deletedItems.deletedCount,
      });
    } else {
      return res
        .status(404)
        .json({ message: "No matching items found to delete" });
    }
  } catch (e) {
    console.error("Error:", e.message);
    return res
      .status(500)
      .json({ error: "Could not delete the items", details: e.message });
  }
});

router.put("/", async (req, res) => {
  try {
    console.log(req.body);
    // Validate the input
    if (!Array.isArray(req.body)) {
      return res
        .status(400)
        .json({ error: "Data should be an array of objects." });
    }

    // Extract the list of updates from the request body
    const updates = req.body;

    // Validate each update object
    for (const update of updates) {
      if (!update.ritem_UId || !update.date || !update.updateData) {
        return res.status(400).json({
          error: "Each update must include ritem_UId, date, and updateData.",
        });
      }
    }

    // Perform the updates in parallel using Promise.all
    const updateResults = await Promise.all(
      updates.map(async (update) => {
        const { ritem_UId, date, updateData } = update;
        const formattedDate = new Date(date);

        // Update the document(s) based on ritem_UId and date
        const updatedItem = await LiveMenuNew.updateOne(
          { ritem_UId, date: date },
          { $set: updateData },
          { new: true, runValidators: true }
        );

        // Return the result for each update
        return {
          ritem_UId,
          date: date,
          matchedCount: updatedItem.matchedCount,
          modifiedCount: updatedItem.modifiedCount,
        };
      })
    );

    // Filter out successful and unsuccessful updates
    const successfulUpdates = updateResults.filter(
      (result) => result.modifiedCount > 0
    );
    const failedUpdates = updateResults.filter(
      (result) => result.matchedCount === 0
    );

    // Respond with the summary of updates
    return res.status(200).json({
      message: `${successfulUpdates.length} items updated successfully.`,
      failedUpdates,
      successfulUpdates,
    });
  } catch (e) {
    console.error("Error occurred while updating data:", e);
    return res
      .status(500)
      .json({ error: "Could not update your data", details: e.message });
  }
});

// router.post('/book-items', async (req, res) => {
//     const { cartItems, date, meal } = req.body; // Expect cartItems, date, and meal from the request body
//     const session = await mongoose.startSession(); // Start a session for transaction

//     session.startTransaction(); // Start a transaction

//     try {
//         const unavailableItems = [];

//         // Loop through each cart item and check its availability for the specific date and meal
//         for (const item of cartItems) {
//             const { ritem_uID, quantity } = item;

//             // Query the database for the specific item, date, and meal within the transaction
//             const menuItem = await LiveMenuNew.findOne({
//                 ritem_UId: ritem_uID,
//                 date: date, // e.g., '2024-08-16'
//                 [`meals_session_count.${meal}.Enabled`]: true
//             }).session(session); // Ensure query is part of the session

//             if (!menuItem) {
//                 // If the item is not found or not enabled for the meal, add to unavailable items
//                 unavailableItems.push(item);
//             } else {
//                 // Check available count in all sessions for that meal
//                 const totalAvailable = (menuItem.meals_session_count[meal].session1.availableCount)
//                     + (menuItem.meals_session_count[meal].session2.availableCount)
//                     + (menuItem.meals_session_count[meal].session3.availableCount);

//                 console.log("Total count", totalAvailable);

//                 if (totalAvailable < quantity) {
//                     unavailableItems.push(item);
//                 } else {
//                     // Reduce the available count from sessions in sequence until quantity is met
//                     let remainingQuantity = quantity;

//                     for (const session of ['session1', 'session2', 'session3']) {
//                         if (remainingQuantity > 0) {
//                             const sessionAvailable = menuItem.meals_session_count[meal][session].availableCount || 0;
//                             const quantityToDeduct = Math.min(remainingQuantity, sessionAvailable);

//                             menuItem.meals_session_count[meal][session].availableCount -= quantityToDeduct;
//                             remainingQuantity -= quantityToDeduct;
//                         }
//                     }

//                     // Save updated menu item within the transaction
//                     await menuItem.save({ session });
//                 }
//             }
//         }

//         if (unavailableItems.length > 0) {
//             await session.abortTransaction(); // Roll back all operations if any item is unavailable
//             session.endSession();
//             return res.status(200).json({
//                 success: false,
//                 message: 'Some items are not available',
//                 unavailableItems
//             });
//         }

//         await session.commitTransaction(); // Commit the transaction if all items are successfully booked
//         session.endSession();

//         res.status(200).json({
//             success: true,
//             message: 'All items booked successfully'
//         });

//     } catch (error) {
//         await session.abortTransaction(); // Roll back all operations if an error occurs
//         session.endSession();
//         console.error(error);
//         res.status(500).json({
//             success: false,
//             message: 'Internal server error'
//         });
//     }
// });

router.post("/book-items", async (req, res) => {
  const { cartItems, date, meal, session: selectedSession } = req.body; // Include the session in the request body
  const session = await mongoose.startSession(); // Start a session for transaction

  session.startTransaction(); // Start a transaction

  try {
    const unavailableItems = [];

    // Loop through each cart item and check its availability for the specific date, meal, and session
    for (const item of cartItems) {
      const { ritem_uID, quantity } = item;

      // Query the database for the specific item, date, meal, and session within the transaction
      const menuItem = await LiveMenuNew.findOne({
        ritem_UId: ritem_uID,
        date: date,
        [`meals_session_count.${meal}.${selectedSession}.Enabled`]: true, // Ensure session-specific query
      }).session(session); // Ensure query is part of the session

      if (!menuItem) {
        // If the item is not found or not enabled for the session, add to unavailable items
        unavailableItems.push(item);
      } else {
        // Check the available count in the specific session for that meal
        const sessionAvailableCount =
          menuItem.meals_session_count[meal][selectedSession].availableCount ||
          0;

        console.log(
          `Available count in ${selectedSession}:`,
          sessionAvailableCount
        );

        if (sessionAvailableCount < quantity) {
          unavailableItems.push(item);
        } else {
          // Deduct the quantity from the available count in the specified session
          menuItem.meals_session_count[meal][selectedSession].availableCount -=
            quantity;

          // Save updated menu item within the transaction
          await menuItem.save({ session });
        }
      }
    }

    if (unavailableItems.length > 0) {
      await session.abortTransaction(); // Roll back all operations if any item is unavailable
      session.endSession();
      return res.status(200).json({
        success: false,
        message: "Some items are not available",
        unavailableItems,
      });
    }

    await session.commitTransaction(); // Commit the transaction if all items are successfully booked
    session.endSession();

    res.status(200).json({
      success: true,
      message: "All items booked successfully",
    });
  } catch (error) {
    await session.abortTransaction(); // Roll back all operations if an error occurs
    session.endSession();
    console.error(error);
    res.status(500).json({
      success: false,
      message: "Internal server error",
    });
  }
});

module.exports = router;
