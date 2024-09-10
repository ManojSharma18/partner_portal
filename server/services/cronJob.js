const cron = require('node-cron');
const { syncLiveMenuToHistory } = require('./syncService');
const { syncMyMenuToLiveMenu } = require('./syncService');

function setupCronJob() {
    cron.schedule('1 0 * * *', () => {  // Every day at 12:01 AM
        console.log('Running sync job at 12:25 AM...');
        syncMyMenuToLiveMenu();
        syncLiveMenuToHistory();
    });

    console.log('Cron job scheduled to run at 12:01 AM every day.');
}

module.exports = setupCronJob;
