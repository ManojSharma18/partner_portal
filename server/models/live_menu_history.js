const mongoose = require('mongoose');

// Assuming similar structure to LiveMenuNew

const sessionSchemas = new mongoose.Schema(
    {
        availableCount: { type: Number, default: 0 },
        Enabled: { type: Boolean },
    },
    { _id: false }
);

const mealSchemas = new mongoose.Schema(
    {
        Enabled: { type: Boolean },
        session1: sessionSchemas,
        session2: sessionSchemas,
        session3: sessionSchemas

    },
    { _id: false }
);


const liveMenuHistorySchema = new mongoose.Schema({
    ritem_UId: {
        type: String,
        required: true,
    },
    ritem_dispname: {
        type: String,
        required: true,
    },
    ritem_availability: {
        type: Boolean,
    },
    ritem_category: {
        type: String,
    },
    ritem_tag: {
        type: String,
        required: true,
    },
    ritem_available_type: {
        type: Number,
        default: 0,
    },
    day: {
        type: String,
    },
    date: {
        type: String,
    },
    meals_session_count: {
        type: {
            breakfast: mealSchemas,
            lunch: mealSchemas,
            dinner: mealSchemas,
        },
        required: true,
        _id: false,
    },
    // Additional fields for history tracking, e.g., timestamps
    createdAt: {
        type: Date,
        default: Date.now,
    },
}, { collection: 'kaa1_live_menu_history' });

const LiveMenuHistory = mongoose.model("LiveMenuHistory", liveMenuHistorySchema);

module.exports = { LiveMenuHistory };
