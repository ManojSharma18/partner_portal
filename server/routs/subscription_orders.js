const express = require('express');
const router = express.Router();
const {SubscriptionOrder} = require('../models/subscription_order'); 

router.post('/subscriptionOrder', async (req, res) => {
    try {
        const orders = req.body; // Assuming req.body is an array of orders
    
        // Validate if req.body is an array and contains orders
        if (!Array.isArray(orders) || orders.length === 0) {
          return res.status(400).json({ message: "Invalid or empty order list" });
        }
    
        const savedOrders = [];
        for (const orderData of orders) {
          const newOrder = new SubscriptionOrder(orderData);
          const savedOrder = await newOrder.save();
          savedOrders.push(savedOrder);
        }
    
        res.status(201).json(savedOrders); // Return array of saved orders
      } catch (error) {
        res.status(400).json({ message: error.message });
      }
  });

  router.get('/subscriptionOrder', async (req, res) => {
    try {
      const orders = await SubscriptionOrder.find();
  
      res.status(200).json(orders);
    } catch (error) {
      console.error('Error fetching orders:', error);
      res.status(500).json({ message: 'Error fetching orders' });
    }
  }); 

  router.put('/subscriptionOrder/:id', async (req, res) => {
    const ordId = req.params.id;
    const updateFields = req.body;

    console.log(req.body); 
   
    try {
        const updatedOrder = await SubscriptionOrder.findByIdAndUpdate(
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