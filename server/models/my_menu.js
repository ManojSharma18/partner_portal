const mongoose = require('mongoose');

const mealSchema = new mongoose.Schema(
    {
        BreakfastSession1: { type: Number, default: 0, },
        BreakfastSession2: { type: Number, default: 0, },
        BreakfastSession3: { type: Number, default: 0, },
        LunchSession1: { type: Number, default: 0, },
        LunchSession2: { type: Number, default: 0, },
        LunchSession3: { type: Number, default: 0, },
        DinnerSession1: { type: Number, default: 0, },
        DinnerSession2: { type: Number, default: 0, },
        DinnerSession3: { type: Number, default: 0, },
    },
    { _id: false }
);

const sessionSchema = new mongoose.Schema(
    {
        StartTime: { type: String },
        EndTime: { type: String },
        Enabled: { type: Boolean },
    },
    { _id: false }
);

const timingSchema = new mongoose.Schema(
    {
        Session1: sessionSchema,
        Session2: sessionSchema,
        Session3: sessionSchema,
    },
    { _id: false }
);

const mealTimingSchema = new mongoose.Schema({
    Breakfast: timingSchema,
    Lunch: timingSchema,
    Dinner: timingSchema,
}, { _id: false });


const mymenuSchema = new mongoose.Schema({
    ritem_UId: {
        type: String,
        required: true,
        unique: true
    },
    ritem_name: {
        type: String,
    },
    ritem_dispname: {
        type: String,
        required: true
    },

    ritem_priceRange: {
        type: String,
    },
    ritem_itemType: {
        type: String,
    },
    ritem_availability: {
        type: Boolean,

    },
    ritem_half_price: {
        type: Boolean,

    },
    ritem_itemSubType: {
        type: String,

    },
    ritem_comboType: {
        type: String,

    },
    ritem_rawSource: {
        type: String,

    },
    ritem_category: {
        type: String,

    },
    ritem_subCategory: {
        type: String,

    },
    ritem_cuisine: {
        type: String,

    },
    ritem_cuisine_description: {
        type: String,
    },
    ritem_description: {
        type: String,
    },
    ritem_regional: {
        type: String,

    },

    ritem_normalPrice: {
        type: Number,
    },
    ritem_half_normalPrice: {
        type: Number,
    },
    ritem_packagePrice: {
        type: Number,
        default: 0
    },
    ritem_preorderPrice: {
        type: Number,
        default: 0
    },
    ritem_half_preorderPrice: {
        type: Number,
        default: 0
    },
    ritem_normalFinalPrice: {
        type: Number,
        default: 0
    },
    ritem_half_normalFinalPrice: {
        type: Number,
        default: 0
    },
    ritem_preorderFinalPrice: {
        type: Number,
        default: 0
    },
    ritem_half_preorderFinalPrice: {
        type: Number,
        default: 0
    },
    ritem_tag: {
        type: String,
        required: true
    },

    ritem_available_type: {
        type: Number,
        default: 0
    },

    ritem_consumption_mode: {
        type: [String],
        default: []
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
            Sun: {
                BreakfastSession1: 0, BreakfastSession2: 0, BreakfastSession3: 0, LunchSession1: 0, LunchSession2: 0, LunchSession3: 0, DinnerSession1: 0, DinnerSession2: 0, DinnerSession3: 0,
            },
            Mon: {
                BreakfastSession1: 0, BreakfastSession2: 0, BreakfastSession3: 0, LunchSession1: 0, LunchSession2: 0, LunchSession3: 0, DinnerSession1: 0, DinnerSession2: 0, DinnerSession3: 0,
            },
            Tue: {
                BreakfastSession1: 0, BreakfastSession2: 0, BreakfastSession3: 0, LunchSession1: 0, LunchSession2: 0, LunchSession3: 0, DinnerSession1: 0, DinnerSession2: 0, DinnerSession3: 0,
            },
            Wed: {
                BreakfastSession1: 0, BreakfastSession2: 0, BreakfastSession3: 0, LunchSession1: 0, LunchSession2: 0, LunchSession3: 0, DinnerSession1: 0, DinnerSession2: 0, DinnerSession3: 0,
            },
            Thu: {
                BreakfastSession1: 0, BreakfastSession2: 0, BreakfastSession3: 0, LunchSession1: 0, LunchSession2: 0, LunchSession3: 0, DinnerSession1: 0, DinnerSession2: 0, DinnerSession3: 0,
            },
            Fri: {
                BreakfastSession1: 0, BreakfastSession2: 0, BreakfastSession3: 0, LunchSession1: 0, LunchSession2: 0, LunchSession3: 0, DinnerSession1: 0, DinnerSession2: 0, DinnerSession3: 0,
            },
            Sat: {
                BreakfastSession1: 0, BreakfastSession2: 0, BreakfastSession3: 0, LunchSession1: 0, LunchSession2: 0, LunchSession3: 0, DinnerSession1: 0, DinnerSession2: 0, DinnerSession3: 0,
            },
        },
        required: true,
        _id: false
    },
    fp_unit_sessions: {
        type: mealTimingSchema,
        default: {
            Breakfast: { Session1: {}, Session2: {}, Session3: {}, },
            Lunch: { Session1: {}, Session2: {}, Session3: {}, },
            Dinner: { Session1: {}, Session2: {}, Session3: {}, },
        },
        required: true
    }
}, { collection: 'kaa1_menu' });


const Mymenu = mongoose.model("Mymenu", mymenuSchema);
module.exports = { Mymenu, mymenuSchema };