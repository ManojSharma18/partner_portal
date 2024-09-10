const mongoose = require('mongoose');

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


const liveMenuNewSchema = new mongoose.Schema({
    ritem_UId: {
        type: String,
        required: true,
    },

    ritem_dispname: {
        type: String,
        required: true
    },

    ritem_availability: {
        type: Boolean,

    },

    ritem_category: {
        type: String,

    },

    ritem_tag: {
        type: String,
        required: true
    },

    ritem_available_type: {
        type: Number,
        default: 0
    },

    day: {
        type: String
    },

    date: {
        type: String
    },

    meals_session_count: {
        type: {
            breakfast: mealSchemas,
            lunch: mealSchemas,
            dinner: mealSchemas,
        },
        default: {
            breakfast: {
                Enabled: false,
                session1: {
                    Enabled: false,
                    availableCount: 0
                },
                session2: {
                    Enabled: false,
                    availableCount: 0
                },
                session3: {
                    Enabled: false,
                    availableCount: 0
                },
            },
            lunch: {
                Enabled: false,
                session1: {
                    Enabled: false,
                    availableCount: 0
                },
                session2: {
                    Enabled: false,
                    availableCount: 0
                },
                session3: {
                    Enabled: false,
                    availableCount: 0
                },
            },
            dinner: {
                Enabled: false,
                session1: {
                    Enabled: false,
                    availableCount: 0
                },
                session2: {
                    Enabled: false,
                    availableCount: 0
                },
                session3: {
                    Enabled: false,
                    availableCount: 0
                },
            },
        },
        required: true,
        _id: false
    },


}, { collection: 'kaa1_live_menu_new' });

const LiveMenuNew = mongoose.model("LiveMenuNew", liveMenuNewSchema);
module.exports = { LiveMenuNew, liveMenuNewSchema }; 