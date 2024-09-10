const express = require('express');
const router = express.Router();
const { Mymenu } = require('../models/my_menu');


router.post('/', async (req, res) => {

    try {
        const {
            ritem_name,
            ritem_dispname,
            ritem_subTag,
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
            ritem_packagePrice,
            ritem_preorderPrice,
            ritem_normalFinalPrice,
            ritem_preorderFinalPrice,
            fp_unit_avail_days_and_meals,
            fp_unit_sessions,
            ritem_availability
        } = req.body;

        const newMymenu = new Mymenu({
            ritem_name,
            ritem_dispname,
            ritem_subTag,
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
            ritem_packagePrice,
            ritem_preorderPrice,
            ritem_normalFinalPrice,
            ritem_preorderFinalPrice,

            fp_unit_avail_days_and_meals,
            fp_unit_sessions,
            ritem_availability
        });

        const savedMymenu = await newMymenu.save();
        res.status(201).json(savedMymenu);
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: "Server Error" });
    }
});


router.post('/addSection', async (req, res) => {
    try {
        let {
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
            ritem_consumption_mode
        } = req.body;

        ritem_tag = ritem_tag.trim();
        ritem_dispname = ritem_dispname.trim();

        let newDispname = ritem_dispname;
        let ritem_UId;

        const regex1 = /^kaa001_i(\d+)$/i;

        // Parallelize the two queries
        const [itemsSample, itemsUid] = await Promise.all([
            ritem_dispname.toUpperCase() === 'SAMPLE' ? Mymenu.find({ ritem_dispname: { $regex: /^SAMPLE(\d+)$/i } }, 'ritem_dispname') : [],
            Mymenu.find({ ritem_UId: { $regex: regex1 } }, 'ritem_UId')
        ]);

        if (ritem_dispname.toUpperCase() === 'SAMPLE') {
            const numbers = itemsSample.map(item => {
                const match = item.ritem_dispname.match(/^SAMPLE(\d+)$/i);
                return match ? parseInt(match[1], 10) : 0;
            });

            const highestNumber = numbers.length > 0 ? Math.max(...numbers) : 0;
            newDispname = `SAMPLE${highestNumber + 1}`;
        }

        const numbers1 = itemsUid.map(item => {
            const match = item.ritem_UId.match(regex1);
            return match ? parseInt(match[1], 10) : 0;
        });

        const highestNumber1 = numbers1.length > 0 ? Math.max(...numbers1) : 0;
        ritem_UId = `kaa001_i${highestNumber1 + 1}`;

        const newMymenu = new Mymenu({
            ritem_UId,
            ritem_name: newDispname,
            ritem_dispname: newDispname,
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
            ritem_consumption_mode
        });

        const savedMymenu = await newMymenu.save();
        res.status(201).json(savedMymenu);
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: "Server Error" });
    }
});


router.get('/', async (req, res) => {
    try {
        const foods = await Mymenu.find();
        res.json(foods);
    } catch (err) {
        res.status(500).json({ error: 'Error fetching foods details' });
    }
});

router.put('/updateSection/:id', async (req, res) => {
    try {

        const {
            ritem_name,
            ritem_dispname,
            ritem_priceRange,
            ritem_itemType,
            ritem_itemSubType,
            ritem_comboType,
            ritem_rawSource,
            ritem_category,
            ritem_cuisine,
            ritem_available_type,
            ritem_regional,
            ritem_subCategory,
            ritem_normalPrice,
            ritem_half_normalPrice,
            ritem_packagePrice,
            ritem_preorderPrice,
            ritem_half_preorderPrice,
            ritem_tag,
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
            ritem_consumption_mode
        } = req.body;

        const updateFields = {
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
            ritem_available_type,
            ritem_consumption_mode
        };

        const updatedMymenu = await Mymenu.findByIdAndUpdate(req.params.id, updateFields, { new: true });

        if (!updatedMymenu) {
            return res.status(404).json({ message: "Item not found" });
        }

        res.status(200).json(updatedMymenu);
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: "Server Error" });
    }
});

router.put('/:id', async (req, res) => {
    const menuId = req.params.id;
    const updateFields = req.body;

    console.log(req.body);
    console.log(req.body);

    // req.body.ritem_dispname = req.body.ritem_dispname.trim();

    try {
        const updatedMenu = await Mymenu.findByIdAndUpdate(
            menuId,
            updateFields,
            { new: true } // To return the updated document 
        );

        if (!updatedMenu) {
            return res.status(404).json({ message: 'LiveMenu not found' });
        }

        res.status(200).json(updatedMenu);
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Server Error' });
    }

});


router.delete('/:id', async (req, res) => {
    try {
        console.log(req.params);
        const { id } = req.params;

        const deletedMymenu = await Mymenu.findByIdAndDelete(id);

        if (!deletedMymenu) {
            return res.status(404).json({ message: "Item not found" });
        }

        res.status(200).json({ message: "Item deleted successfully", deletedMymenu });
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: "Server Error" });
    }
});

router.delete('/tag/:ritem_tag', async (req, res) => {
    try {
        const { ritem_tag } = req.params;

        const deletedItems = await Mymenu.deleteMany({ ritem_tag });

        if (deletedItems.deletedCount === 0) {
            return res.status(404).json({ message: "No items found with the given tag" });
        }

        res.status(200).json({ message: "Items deleted successfully", deletedCount: deletedItems.deletedCount });
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: "Server Error" });
    }
});


router.put('/updateByTag/:ritem_tag', async (req, res) => {
    try {
        console.log(req.body);

        console.log(req.params)

        const { ritem_tag: newStdItmTag } = req.body; // New tag from request body

        // Check if newStdItmTag is provided in the request body
        if (!newStdItmTag) {
            return res.status(400).json({ message: "New std_itm_tag is required in the request body" });
        }

        const oldStdItmTag = req.params.ritem_tag;

        // Ensure the tags are strings and handle any possible case inconsistencies
        const formattedOldStdItmTag = oldStdItmTag.toString().trim();
        const formattedNewStdItmTag = newStdItmTag.toString().trim();

        // Update many documents that match the old tag with the new tag
        const updatedMymenus = await Mymenu.updateMany(
            { ritem_tag: formattedOldStdItmTag },
            { $set: { ritem_tag: formattedNewStdItmTag } }
        );

        // Check if any documents were matched and updated
        if (updatedMymenus.matchedCount === 0) {
            return res.status(404).json({ message: "No items found with the given tag" });
        }

        res.status(200).json({ message: "Items updated successfully", updatedCount: updatedMymenus.modifiedCount });
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: "Server Error" });
    }
});


router.put('/updateByTag/availability/:ritem_tag', async (req, res) => {
    try {
        const { ritem_availability } = req.body; // New availability from request body

        console.log(ritem_availability)

        // Check if std_itm_availability is provided in the request body
        if (ritem_availability === undefined || ritem_availability === null) {
            return res.status(400).json({ message: "New std_itm_availability is required in the request body" });
        }

        const updatedMymenus = await Mymenu.updateMany(
            { ritem_tag: req.params.ritem_tag },
            { $set: { ritem_availability: ritem_availability } }
        );

        if (updatedMymenus.matchedCount === 0) {
            return res.status(404).json({ message: "No items found with the given tag" });
        }

        res.status(200).json({ message: "Items updated successfully", updatedCount: updatedMymenus.modifiedCount });
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: "Server Error" });
    }
});

module.exports = router;
