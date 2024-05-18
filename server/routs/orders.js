const express = require('express');
const router = express.Router();
const {Order} = require('../models/order'); 

router.post('/order', async (req, res) => {
    try {
      const newOrder = new Order(req.body); 
      const savedOrder = await newOrder.save();
      res.status(201).json(savedOrder); 
    } catch (error) {
      res.status(400).json({ message: error.message });
    }
  });

  router.get('/order', async (req, res) => {
    try {
      const orders = await Order.find();
  
      res.status(200).json(orders);
    } catch (error) {
      console.error('Error fetching orders:', error);
      res.status(500).json({ message: 'Error fetching orders' });
    }
  }); 

  router.put('/order/:id', async (req, res) => {
    const ordId = req.params.id;
    const updateFields = req.body;

    console.log(req.body);
   
    try {
        const updatedOrder = await Order.findByIdAndUpdate(
            ordId,
            updateFields,
            { new: true } // To return the updated document 
        );
 
        if (!updatedOrder) {
            return res.status(404).json({ message: 'LiveMenu not found' }); 
        }

        res.status(200).json(updatedOrder); 
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Server Error' });
    }
}); 
 
  module.exports = router;