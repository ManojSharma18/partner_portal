const { LiveMenuNew } = require('../models/live_menu_new'); // Make sure the path is correct
const { LiveMenuHistory } = require('../models/live_menu_history'); // Assuming this is another model file
const { Mymenu } = require('../models/my_menu');

function getYesterdayDate() {
    const today = new Date();
    today.setDate(today.getDate() - 1);
    const year = today.getFullYear();
    const month = String(today.getMonth() + 1).padStart(2, '0');
    const day = String(today.getDate()).padStart(2, '0');
    return `${year}-${month}-${day}`;
}

function getSixthdayDate() {
    const today = new Date();
    today.setDate(today.getDate() + 6);
    const year = today.getFullYear();
    const month = String(today.getMonth() + 1).padStart(2, '0');
    const day = String(today.getDate()).padStart(2, '0');
    return `${year}-${month}-${day}`;
}

async function syncLiveMenuToHistory() {
    try {
        const yesterdayDate = getYesterdayDate();
        console.log(`Sync started for date: ${yesterdayDate} at ${new Date().toISOString()}`);

        // Find items with the date of yesterday
        const liveMenuItems = await LiveMenuNew.find({ date: yesterdayDate });

        if (liveMenuItems.length === 0) {
            console.log("No items found for yesterday's date.");
            return;
        }

        // Map the live menu items to history items format
        const historyItems = liveMenuItems.map(item => ({
            ritem_UId: item.ritem_UId,
            ritem_dispname: item.ritem_dispname,
            ritem_availability: item.ritem_availability,
            ritem_category: item.ritem_category,
            ritem_tag: item.ritem_tag,
            ritem_available_type: item.ritem_available_type,
            day: item.day,
            date: item.date,
            meals_session_count: item.meals_session_count,
            createdAt: new Date(), // Optionally add a timestamp
        }));

        // Insert the items into the LiveMenuHistory collection
        const result = await LiveMenuHistory.insertMany(historyItems);

        console.log(`${result.length} items successfully copied to history.`);

        // Remove the items from the LiveMenuNew collection
        await LiveMenuNew.deleteMany({ date: yesterdayDate });

        console.log(`Sync completed successfully at ${new Date().toISOString()}`);
    } catch (error) {
        console.error("Error syncing LiveMenu to LiveMenuHistory:", error);
    }
}

async function syncMyMenuToLiveMenu() {
    try {

        const today = new Date();
        const sixthDayFromToday = new Date(today);
        sixthDayFromToday.setDate(today.getDate() + 6);

        const dayOfWeek = sixthDayFromToday.toLocaleString('en-US', { weekday: 'short' });
        const dateString = sixthDayFromToday.toISOString().split('T')[0];

        const sixthdayDate = getSixthdayDate();
        console.log(`Sync started for date: ${sixthdayDate} at ${new Date().toISOString()}`);

        const menuItems = await Mymenu.find({
            ritem_availability: true,
            ritem_available_type: 1,
        });

        const liveMenuItems = menuItems.map(menuItem => {
            return {
                ritem_UId: menuItem.ritem_UId,
                ritem_dispname: menuItem.ritem_dispname,
                ritem_availability: menuItem.ritem_availability,
                ritem_category: menuItem.ritem_category,
                ritem_tag: menuItem.ritem_tag,
                ritem_available_type: menuItem.ritem_available_type,
                day: dayOfWeek,
                date: dateString,
                meals_session_count: {

                    breakfast: {
                        Enabled: true,
                        session1: {
                            Enabled: true,
                            availableCount: menuItem.fp_unit_avail_days_and_meals[dayOfWeek].BreakfastSession1
                        },
                        session2: {
                            Enabled: true,
                            availableCount: menuItem.fp_unit_avail_days_and_meals[dayOfWeek].BreakfastSession2
                        },
                        session3: {
                            Enabled: true,
                            availableCount: menuItem.fp_unit_avail_days_and_meals[dayOfWeek].BreakfastSession3
                        },
                    },
                    lunch: {
                        Enabled: true,
                        session1: {
                            Enabled: true,
                            availableCount: menuItem.fp_unit_avail_days_and_meals[dayOfWeek].LunchSession1
                        },
                        session2: {
                            Enabled: true,
                            availableCount: menuItem.fp_unit_avail_days_and_meals[dayOfWeek].LunchSession2
                        },
                        session3: {
                            Enabled: true,
                            availableCount: menuItem.fp_unit_avail_days_and_meals[dayOfWeek].LunchSession3
                        },
                    },
                    dinner: {
                        Enabled: true,
                        session1: {
                            Enabled: true,
                            availableCount: menuItem.fp_unit_avail_days_and_meals[dayOfWeek].DinnerSession1
                        },
                        session2: {
                            Enabled: true,
                            availableCount: menuItem.fp_unit_avail_days_and_meals[dayOfWeek].DinnerSession2
                        },
                        session3: {
                            Enabled: true,
                            availableCount: menuItem.fp_unit_avail_days_and_meals[dayOfWeek].DinnerSession3
                        },
                    },

                },
            };
        });

        if (liveMenuItems.length > 0) {
            const insertedData = await LiveMenuNew.insertMany(liveMenuItems);
            console.log(insertedData);
            console.log("LiveMenuNew documents inserted successfully");
        } else {
            console.log("No items found for LiveMenuNew insertion");
        }

    } catch (error) {
        console.error("Error syncing LiveMenu to LiveMenuHistory:", error);
    }
}

module.exports = {
    syncMyMenuToLiveMenu,
    syncLiveMenuToHistory,
};
