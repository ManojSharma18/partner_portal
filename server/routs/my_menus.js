const express = require('express');
const router = express.Router();
const { Mymenu } = require('../models/my_menu'); 


router.post('/', async (req, res) => {
    console.log(req.body)
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

router.get('/', async (req, res) => { 
    try { 
      const foods = await Mymenu.find();
      res.json(foods);
    } catch (err) {
      res.status(500).json({ error: 'Error fetching foods details' }); 
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

module.exports = router;
