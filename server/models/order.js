const mongoose = require('mongoose');

// Define the schema for orders
const orderSchema = new mongoose.Schema({
  fp_unit_ford_id : { type: String, required: true },
  fp_unit_name : { type: String, required: true },
  fp_unit_ford_date : { type: String, required: true },
  fp_unit_ford_time : { type: String, required: true },
  c_uid : { type: String, required: true },
  c_mobno : { type: String, required: true },
  fp_unit_ford_amt : { type: Number, required: true },
  fp_unit_ford_status: { type: String, required: true },
  d_name: { type: String, required: true },
  d_mob: { type: String, required: true },
//   budgetType: { type: String, required: true },
   fp_unit_ford_items: [
    {
      itemName: { type: String, required: true },
      count: { type: Number, required: true },
      price: { type: Number, required: true }   
    } 
  ],
  fp_unit_ford_cmode: { type: String, required: true },
  fp_unit_ford_meal: { type: String, required: true },
  fp_unit_ford_meal_Session: { type: String, required: true },
  fp_unit_ford_type: { type: String, required: true }
}, { collection: 'kaa001_order_details' } );

// Create a Mongoose model based on the schema
const Order = mongoose.model('Order', orderSchema); 
module.exports = {Order,orderSchema}; 
   