const express = require('express');
const router = express.Router();
const { Mymenu } = require('../models/my_menu'); 


router.post('/', async (req, res) => {
   
    try {
        const {
            std_itm_name,
            std_itm_dispname,
            std_itm_subTag,
            std_itm_priceRange,
            std_itm_itemType,
            std_itm_itemSubType,
            std_itm_comboType,
            std_itm_rawSource,
            std_itm_category,
            std_itm_cuisine,
            std_itm_regional,
            std_itm_subCategory,
            std_itm_normalPrice,
            std_itm_packagePrice,
            std_itm_preorderPrice,
            fp_unit_avail_days_and_meals,
            fp_unit_sessions,
            std_itm_availability
        } = req.body;

        const newMymenu = new Mymenu({
            std_itm_name,
            std_itm_dispname,
            std_itm_subTag,
            std_itm_priceRange,
            std_itm_itemType,
            std_itm_itemSubType,
            std_itm_comboType,
            std_itm_rawSource,
            std_itm_category,
            std_itm_cuisine,
            std_itm_regional,
            std_itm_subCategory,
            std_itm_normalPrice,
            std_itm_packagePrice,
            std_itm_preorderPrice,
            fp_unit_avail_days_and_meals,
            fp_unit_sessions,
            std_itm_availability
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
            std_itm_name,
            std_itm_dispname,
            std_itm_subTag,
            std_itm_priceRange,
            std_itm_itemType,
            std_itm_itemSubType,
            std_itm_comboType,
            std_itm_rawSource,
            std_itm_category,
            std_itm_cuisine,
            std_itm_regional,
            std_itm_subCategory,
            std_itm_normalPrice,
            std_itm_packagePrice,
            std_itm_preorderPrice,
            std_itm_tag,
            fp_unit_avail_days_and_meals,
            fp_unit_sessions,
            std_itm_availability
        } = req.body;

        std_itm_tag = std_itm_tag.trim();

        let newDispname = std_itm_dispname;

        if (std_itm_dispname.toLowerCase() === 'sample') {
            // Use a regex to find all items starting with "sample" followed by a number
            const regex = /^sample(\d+)$/i;
            const items = await Mymenu.find({ std_itm_dispname: { $regex: regex } });

            // Extract the numbers from the matching items
            const numbers = items.map(item => {
                const match = item.std_itm_dispname.match(regex);
                return match ? parseInt(match[1], 10) : 0;
            });

            // Find the highest number
            const highestNumber = numbers.length > 0 ? Math.max(...numbers) : 0;

            // Set the new display name to "sample" followed by the next highest number
            newDispname = `sample${highestNumber + 1}`;
        }

        // Count the total number of documents in the collection
        const totalDocuments = await Mymenu.countDocuments();

        // Create a unique UId based on the total number of documents
        const std_itm_UId = `kaa001_i${totalDocuments + 1}`;

        const newMymenu = new Mymenu({
            std_itm_UId,
            std_itm_name,
            std_itm_dispname: newDispname,
            std_itm_subTag,
            std_itm_priceRange,
            std_itm_itemType,
            std_itm_itemSubType,
            std_itm_comboType,
            std_itm_rawSource,
            std_itm_category,
            std_itm_cuisine,
            std_itm_regional,
            std_itm_subCategory,
            std_itm_normalPrice,
            std_itm_packagePrice,
            std_itm_preorderPrice,
            std_itm_tag,
            fp_unit_avail_days_and_meals,
            fp_unit_sessions,
            std_itm_availability
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
            std_itm_name,
            std_itm_dispname,
            std_itm_subTag,
            std_itm_priceRange,
            std_itm_itemType,
            std_itm_itemSubType,
            std_itm_comboType,
            std_itm_rawSource,
            std_itm_category,
            std_itm_cuisine,
            std_itm_regional,
            std_itm_subCategory,
            std_itm_normalPrice,
            std_itm_packagePrice,
            std_itm_preorderPrice,
            std_itm_tag,
            fp_unit_avail_days_and_meals,
            fp_unit_sessions,
            std_itm_availability
        } = req.body;

        const updateFields = {
            std_itm_name,
            std_itm_dispname,
            std_itm_subTag,
            std_itm_priceRange,
            std_itm_itemType,
            std_itm_itemSubType,
            std_itm_comboType,
            std_itm_rawSource,
            std_itm_category,
            std_itm_cuisine,
            std_itm_regional,
            std_itm_subCategory,
            std_itm_normalPrice,
            std_itm_packagePrice,
            std_itm_preorderPrice,
            std_itm_tag, 
            fp_unit_avail_days_and_meals,
            fp_unit_sessions,
            std_itm_availability
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

router.delete('/tag/:std_itm_tag', async (req, res) => {
    try {
        const { std_itm_tag } = req.params;
        
        const deletedItems = await Mymenu.deleteMany({ std_itm_tag });

        if (deletedItems.deletedCount === 0) {
            return res.status(404).json({ message: "No items found with the given tag" });
        }

        res.status(200).json({ message: "Items deleted successfully", deletedCount: deletedItems.deletedCount });
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: "Server Error" });
    }
});


router.put('/updateByTag/:std_itm_tag', async (req, res) => {
    try {
        const { std_itm_tag: newStdItmTag } = req.body; // New tag from request body

        // Check if newStdItmTag is provided in the request body
        if (!newStdItmTag) {
            return res.status(400).json({ message: "New std_itm_tag is required in the request body" });
        }

        const updatedMymenus = await Mymenu.updateMany(
            { std_itm_tag: req.params.std_itm_tag },
            { $set: { std_itm_tag: newStdItmTag } }
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

router.put('/updateByTag/availability/:std_itm_tag', async (req, res) => {
    try {
        const { std_itm_availability } = req.body; // New availability from request body

        console.log(std_itm_availability) 

        // Check if std_itm_availability is provided in the request body
        if (std_itm_availability === undefined || std_itm_availability === null) {
            return res.status(400).json({ message: "New std_itm_availability is required in the request body" });
        }

        const updatedMymenus = await Mymenu.updateMany(
            { std_itm_tag: req.params.std_itm_tag },
            { $set: { std_itm_availability: std_itm_availability } }
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
