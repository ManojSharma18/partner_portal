const express = require('express');
const router = express.Router();
const { LiveMenu } = require('../models/live_menu');


const getDayName = (index) => ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'][index];

router.post('/', async (req, res) => {

    console.log(req.body);

    try {
        const {
            ritem_name,
            ritem_UId,
            ritem_dispname,
            ritem_priceRange,
            ritem_itemType,
            ritem_itemSubType,
            ritem_comboType,
            ritem_rawSource,
            ritem_category,
            ritem_cuisine,
            ritem_regional,
            ritem_subCategory,
            ritem_normalPrice,
            ritem_half_normalPrice,
            ritem_packagePrice,
            ritem_preorderPrice,
            ritem_half_preorderPrice,
            ritem_tag,
            ritem_available_type,
            fp_unit_avail_days_and_meals,
            ritem_availability,
            ritem_description,
            ritem_cuisine_description,
            ritem_normalFinalPrice,
            ritem_half_normalFinalPrice,
            ritem_preorderFinalPrice,
            ritem_half_preorderFinalPrice,
            ritem_half_price,
            ritem_consumption_mode,
            fp_unit_sessions
        } = req.body;

        const existingItem = await LiveMenu.findOne({ ritem_UId });



        if (existingItem) {

            let existingItem_fp_unit_avail_days_and_meals = existingItem.fp_unit_avail_days_and_meals;

            const currentDate = new Date();
            const todayIndex = currentDate.getDay();
            const tomorrowIndex = (todayIndex + 1) % 7;

            const today = getDayName(todayIndex);
            const tomorrow = getDayName(tomorrowIndex);

            const mergedData = { ...existingItem_fp_unit_avail_days_and_meals };

            for (const day in fp_unit_avail_days_and_meals) {
                if (day !== today && day !== tomorrow) {
                    // Update only days other than today and tomorrow
                    mergedData[day] = {
                        ...fp_unit_avail_days_and_meals[day] // Override with new data
                    };
                }
            }

            existingItem.ritem_UId = ritem_UId;
            existingItem.ritem_dispname = ritem_dispname;
            existingItem.ritem_normalPrice = ritem_normalPrice;
            existingItem.ritem_normalFinalPrice = ritem_normalFinalPrice;
            existingItem.ritem_available_type = ritem_available_type;
            existingItem.fp_unit_avail_days_and_meals = mergedData
            const savedLiveMenu = await existingItem.save();

            return res.status(201).json(savedLiveMenu);

        } else {
            const newLivemenu = new LiveMenu({
                ritem_UId,
                ritem_name,
                ritem_dispname,
                ritem_priceRange,
                ritem_itemType,
                ritem_itemSubType,
                ritem_comboType,
                ritem_rawSource,
                ritem_category,
                ritem_cuisine,
                ritem_regional,
                ritem_subCategory,
                ritem_normalPrice,
                ritem_half_normalPrice,
                ritem_packagePrice,
                ritem_preorderPrice,
                ritem_half_preorderPrice,
                ritem_tag,
                ritem_available_type,
                fp_unit_avail_days_and_meals,
                fp_unit_sessions,
                ritem_availability,
                ritem_description,
                ritem_cuisine_description,
                ritem_normalFinalPrice,
                ritem_half_normalFinalPrice,
                ritem_preorderFinalPrice,
                ritem_half_preorderFinalPrice,
                ritem_half_price,
                ritem_consumption_mode,
                fp_unit_sessions
            });

            const savedLivemenu = await newLivemenu.save();
            res.status(201).json(savedLivemenu);
        }

    } catch (error) {
        console.error(error);
        res.status(500).json({ message: "Server Error" });
    }
});


router.post('/moveToLiveMenu/', async (req, res) => {

    console.log(req.body);

    try {
        const {
            ritem_name,
            ritem_UId,
            ritem_dispname,
            ritem_priceRange,
            ritem_itemType,
            ritem_itemSubType,
            ritem_comboType,
            ritem_rawSource,
            ritem_category,
            ritem_cuisine,
            ritem_regional,
            ritem_subCategory,
            ritem_normalPrice,
            ritem_half_normalPrice,
            ritem_packagePrice,
            ritem_preorderPrice,
            ritem_half_preorderPrice,
            ritem_tag,
            ritem_available_type,
            fp_unit_avail_days_and_meals,
            ritem_availability,
            ritem_description,
            ritem_cuisine_description,
            ritem_normalFinalPrice,
            ritem_half_normalFinalPrice,
            ritem_preorderFinalPrice,
            ritem_half_preorderFinalPrice,
            ritem_half_price,
            ritem_consumption_mode,
            fp_unit_sessions
        } = req.body;

        const newLivemenu = new LiveMenu({
            ritem_UId,
            ritem_name,
            ritem_dispname,
            ritem_priceRange,
            ritem_itemType,
            ritem_itemSubType,
            ritem_comboType,
            ritem_rawSource,
            ritem_category,
            ritem_cuisine,
            ritem_regional,
            ritem_subCategory,
            ritem_normalPrice,
            ritem_half_normalPrice,
            ritem_packagePrice,
            ritem_preorderPrice,
            ritem_half_preorderPrice,
            ritem_tag,
            ritem_available_type,
            fp_unit_avail_days_and_meals,
            fp_unit_sessions,
            ritem_availability,
            ritem_description,
            ritem_cuisine_description,
            ritem_normalFinalPrice,
            ritem_half_normalFinalPrice,
            ritem_preorderFinalPrice,
            ritem_half_preorderFinalPrice,
            ritem_half_price,
            ritem_consumption_mode,
            fp_unit_sessions
        });

        const savedLivemenu = await newLivemenu.save();
        res.status(201).json(savedLivemenu);

    } catch (error) {
        console.error(error);
        res.status(500).json({ message: "Server Error" });
    }
});



router.get('/', async (req, res) => {
    try {
        const foods = await LiveMenu.find();
        res.json(foods);
    } catch (err) {
        res.status(500).json({ error: 'Error fetching foods details' });
    }
});


router.delete('/', async (req, res) => {
    try {
        console.log(req.body);
        const ritem_UId = req.body.ritem_UId;

        // Check if the uId is provided
        if (!ritem_UId) {
            return res.status(400).json({ error: 'uId is required' });
        }

        // Find and delete the item
        const item = await LiveMenu.findOneAndDelete({ ritem_UId });

        if (!item) {
            // If no item is found
            return res.status(404).json({ error: 'Item not found' });
        }

        // Respond with success message
        return res.status(200).json({ message: 'Item deleted successfully' });

    } catch (err) {
        console.error('Error deleting item:', err);
        // Return an appropriate error message
        res.status(500).json({ error: 'Error deleting item' });
    }
});

module.exports = router;