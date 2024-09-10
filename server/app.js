
const express = require('express');
const mongoose = require("mongoose");
const cors = require('cors');
const setupCronJob = require('./services/cronJob');
const cron = require('node-cron');


const url = 'mongodb+srv://root:manoj@cluster0.ao5mhwl.mongodb.net/?retryWrites=true&w=majority';
const app = express();

app.use(express.json());

app.use(cors());

app.use(express.urlencoded({
  extended: true
}));

const myMenuRouter = require('./routs/my_menus');
app.use('/mymenu', myMenuRouter)

const menuEditorRouter = require('./routs/menu_editor');
app.use('/menuEditor', menuEditorRouter)

const orderRouter = require('./routs/orders');
app.use('/orders', orderRouter)

const subscriptionOrderRouter = require('./routs/subscription_orders');
app.use('/subscriptionOrders', subscriptionOrderRouter)

const liveMenuRouter = require('./routs/live_menu')
app.use('/liveMenu', liveMenuRouter)

const liveMenuNewRouter = require('./routs/live_menus_new')
app.use('/liveMenuNew', liveMenuNewRouter);

const manageSettingsRouter = require('./routs/manage_settings')
app.use('/manageSetting', manageSettingsRouter);


mongoose.connect(url, { useNewUrlParser: true });

const con = mongoose.connection;

con.on('error', (err) => {
  console.error('MongoDB connection Error', err);
});

con.on('connected', async () => {
  console.log('MongoDB connected...');
  startServer();

  setupCronJob();

});


function startServer() {
  const port = 3000;
  app.listen(3000, () => {
    console.log(`Server is running on port ${port}`);
  });
}


const port = 4000;

app.listen(port, () => {
  console.log('Server is running on port 4000 😍');
});
