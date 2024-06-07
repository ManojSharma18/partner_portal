const mongoose = require('mongoose');

const mealSchema = new mongoose.Schema(
    {
      Breakfast: { type: Boolean, default: false ,},
      Lunch: { type: Boolean, default: false },
      Dinner: { type: Boolean, default: false },
      BreakfastSession1 : {type: Boolean, default: false},
      BreakfastSession2 : {type: Boolean, default: false},
      BreakfastSession3 : {type: Boolean, default: false},
      BreakfastSession4 : {type: Boolean, default: false},
      LunchSession1 : {type: Boolean, default: false},
      LunchSession2 : {type: Boolean, default: false},
      LunchSession3 : {type: Boolean, default: false},
      LunchSession4 : {type: Boolean, default: false},
      DinnerSession1 : {type: Boolean, default: false},
      DinnerSession2 : {type: Boolean, default: false},
      DinnerSession3 : {type: Boolean, default: false}, 
      DinnerSession4 : {type: Boolean, default: false},
    },
    { _id: false } 
  );

  const sessionSchema = new mongoose.Schema(
    {
      StartTime: { type: String },
      EndTime: { type: String },
      availableCount: { type: Number,default: 0}, 
      Enabled:{type:Boolean},
    },
    { _id: false } 
  );
  
  const timingSchema = new mongoose.Schema(
    {
      Default: sessionSchema,
      Session1: sessionSchema,
      Session2: sessionSchema,
      Session3: sessionSchema,
      Session4: sessionSchema,
    },
    { _id: false }
  );
  
  const mealTimingSchema = new mongoose.Schema({
    Breakfast: timingSchema,
    Lunch: timingSchema,
    Dinner: timingSchema,
  }, {_id:false});


const mymenuSchema = new mongoose.Schema({
    std_itm_UId: { 
        type: String,
        required: true,
        unique: true  
    },
    std_itm_name: { 
        type: String,
    },
    std_itm_dispname: { 
        type: String,
        required: true
    },
    std_itm_subTag: { 
        type: String,
    },
    totalCount: { 
        type: Number,
        default:0
    },
    std_itm_priceRange: { 
        type: String,
    }, 
    std_itm_itemType: {  
        type: String,   
    },
    std_itm_availability :{
        type:Boolean,
    
    }, 
    std_itm_itemSubType: {   
        type: String,
        
    },
    std_itm_comboType: { 
        type: String,
        
    },
    std_itm_rawSource: { 
        type: String,
       
    },
    std_itm_category: { 
        type: String,
       
    },
    std_itm_subCategory: { 
        type: String,
        
    },
    std_itm_cuisine: { 
        type: String,
        
    },
    std_itm_regional: { 
        type: String,
        
    },

    std_itm_normalPrice: {
        type: Number,
        
    },
    std_itm_packagePrice: {
        type: Number,
        default:0
    },
    std_itm_preorderPrice: {
        type: Number,
        default:0
    },
    std_itm_tag :{
        type: String,
        required: true
    },

    fp_unit_avail_days_and_meals: {
        type: {
            Sun: mealSchema,
            Mon: mealSchema,
            Tue: mealSchema,
            Wed: mealSchema,
            Thu: mealSchema,
            Fri: mealSchema,
            Sat: mealSchema,
        },
        default: {
            Sun: { Breakfast: false, Lunch: false, Dinner: false ,BreakfastSession1 : false, BreakfastSession2 : false, BreakfastSession3 : false, BreakfastSession4 : false, LunchSession1 : false,LunchSession2 : false,LunchSession3 : false,LunchSession4 : false, DinnerSession1 : false,DinnerSession2 : false,DinnerSession3 : false,DinnerSession4 : false},
            Mon: { Breakfast: false, Lunch: false, Dinner: false ,BreakfastSession1 : false, BreakfastSession2 : false, BreakfastSession3 : false, BreakfastSession4 : false, LunchSession1 : false,LunchSession2 : false,LunchSession3 : false,LunchSession4 : false, DinnerSession1 : false,DinnerSession2 : false,DinnerSession3 : false,DinnerSession4 : false },
            Tue: { Breakfast: false, Lunch: false, Dinner: false ,BreakfastSession1 : false, BreakfastSession2 : false, BreakfastSession3 : false, BreakfastSession4 : false, LunchSession1 : false,LunchSession2 : false,LunchSession3 : false,LunchSession4 : false, DinnerSession1 : false,DinnerSession2 : false,DinnerSession3 : false,DinnerSession4 : false},
            Wed: { Breakfast: false, Lunch: false, Dinner: false ,BreakfastSession1 : false, BreakfastSession2 : false, BreakfastSession3 : false, BreakfastSession4 : false, LunchSession1 : false,LunchSession2 : false,LunchSession3 : false,LunchSession4 : false, DinnerSession1 : false,DinnerSession2 : false,DinnerSession3 : false,DinnerSession4 : false},
            Thu: { Breakfast: false, Lunch: false, Dinner: false ,BreakfastSession1 : false, BreakfastSession2 : false, BreakfastSession3 : false, BreakfastSession4 : false, LunchSession1 : false,LunchSession2 : false,LunchSession3 : false,LunchSession4 : false, DinnerSession1 : false,DinnerSession2 : false,DinnerSession3 : false,DinnerSession4 : false},
            Fri: { Breakfast: false, Lunch: false, Dinner: false ,BreakfastSession1 : false, BreakfastSession2 : false, BreakfastSession3 : false, BreakfastSession4 : false, LunchSession1 : false,LunchSession2 : false,LunchSession3 : false,LunchSession4 : false, DinnerSession1 : false,DinnerSession2 : false,DinnerSession3 : false,DinnerSession4 : false},
            Sat: { Breakfast: false, Lunch: false, Dinner: false ,BreakfastSession1 : false, BreakfastSession2 : false, BreakfastSession3 : false, BreakfastSession4 : false, LunchSession1 : false,LunchSession2 : false,LunchSession3 : false,LunchSession4 : false, DinnerSession1 : false,DinnerSession2 : false,DinnerSession3 : false,DinnerSession4 : false,},
        },
        required : true, 
        _id :false 
    },
    fp_unit_sessions:{
        type:mealTimingSchema, 
        default: {
            Breakfast: { Default: {}, Session1: {}, Session2: {}, Session3: {}, Session4: {} },
            Lunch: { Default: {}, Session1: {}, Session2: {}, Session3: {}, Session4: {} },
            Dinner: { Default: {}, Session1: {}, Session2: {}, Session3: {}, Session4: {} },
          },
          required:true
    }
},{ collection: 'kaa001_menu' } );


const Mymenu = mongoose.model("Mymenu", mymenuSchema);
module.exports = {Mymenu, mymenuSchema };