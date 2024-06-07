const express = require('express');
const router = express.Router();
const { MongoClient } = require('mongodb');

const uri = 'mongodb+srv://root:manoj@cluster0.ao5mhwl.mongodb.net/?retryWrites=true&w=majority';

// Create a new MongoClient
const client = new MongoClient(uri, { useNewUrlParser: true, useUnifiedTopology: true });

router.get('/tag', async (req,res) => {
try {
 
    await client.connect(); 

    // Specify the database and collection
    const database = client.db('test');
    const collection = database.collection('std_menu');

    // Fetch all documents from the collection
    const items = await collection.find({}, { projection: { std_itm_tag: 1 } }).toArray();

    // Send the fetched documents as a JSON response
    // Extract the std_itm_cuisine values into a list
    const tags = items.map(item => item.std_itm_tag);

    const subTag = [...new Set(tags)]
    // Send the list of cuisines as a JSON response 
    res.status(200).json(subTag);


} catch (err) {
    res.status(500).json({error: 'Error fetching foods details'});
}
});

router.get('/tag/:tagName', async (req, res) => {
    try {
      const { tagName } = req.params;
  
      // Connect to the database
      await client.connect();
  
      // Specify the database and collection
      const database = client.db('test');
      const collection = database.collection('std_menu'); 
  
      // Fetch all documents with the specified tag
      const items = await collection.find({ std_itm_tag: tagName }, { projection: { std_itm_dispname: 1 } }).toArray();
  
      // Extract the std_itm_dispname values into a list
      const displayNames = items.map(item => item.std_itm_dispname);
  
      // Send the list of display names as a JSON response
      res.status(200).json(displayNames);
  
    } catch (err) {
      console.error(err);
      res.status(500).json({ error: 'Error fetching items by tag' });
    }
  });
  

module.exports = router;