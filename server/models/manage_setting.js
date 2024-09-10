const mongoose = require('mongoose');

const mealSchema = new mongoose.Schema(
    {
        Breakfast: { type: Boolean, default: false },
        Lunch: { type: Boolean, default: false },
        Dinner: { type: Boolean, default: false },
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
},
    { _id: false }
);

const manageSettingSchema = new mongoose.Schema({

    fp_unit_id: {
        type: String
    },

    consumption_mode: {
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
            Sun: { Breakfast: false, Lunch: false, Dinner: false },
            Mon: { Breakfast: false, Lunch: false, Dinner: false },
            Tue: { Breakfast: false, Lunch: false, Dinner: false },
            Wed: { Breakfast: false, Lunch: false, Dinner: false },
            Thu: { Breakfast: false, Lunch: false, Dinner: false },
            Fri: { Breakfast: false, Lunch: false, Dinner: false },
            Sat: { Breakfast: false, Lunch: false, Dinner: false },
        },
    },
    fp_unit_sessions: {
        type: mealTimingSchema,
        default: {
            Breakfast: { Default: {}, Session1: {}, Session2: {}, Session3: {}, Session4: {} },
            Lunch: { Default: {}, Session1: {}, Session2: {}, Session3: {}, Session4: {} },
            Dinner: { Default: {}, Session1: {}, Session2: {}, Session3: {}, Session4: {} },
        },
    },


}, { collection: 'kaa1_manage_setting' });



const ManageSetting = mongoose.model('ManageSetting', manageSettingSchema)
module.exports = { ManageSetting, manageSettingSchema }