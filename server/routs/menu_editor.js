const express = require('express');
const router = express.Router();
const { MongoClient } = require('mongodb');

const uri = 'mongodb+srv://root:manoj@cluster0.ao5mhwl.mongodb.net/?retryWrites=true&w=majority';

// Create a new MongoClient
const client = new MongoClient(uri, { useNewUrlParser: true, useUnifiedTopology: true });

let database;
let collection1;
let collection2;

(async () => {
  try {
    await client.connect();
    database = client.db('test');
    collection1 = database.collection('std_menu');
    collection2 = database.collection('kaa1_menu');
    console.log("Connected to database");
  } catch (err) {
    console.error("Failed to connect to database", err);
  }
})();


router.get('/tag', async (req, res) => {
  try {
    // Use aggregation to get distinct tags
    const tags = await collection1.distinct("std_itm_tag");

    res.status(200).json(tags);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Error fetching foods details' });
  }
});


router.get('/displayName', async (req, res) => {
  try {
    // Use aggregation to get distinct tags
    const displayNames = await collection1.distinct("std_itm_dispname");

    res.status(200).json(displayNames);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Error fetching foods details' });
  }
});



router.get('/item/:displayName', async (req, res) => {
  try {
    // Get the displayName from the request parameters

    console.log(`Display name is ${req.params.displayName}`);
    const displayName = req.params.displayName;

    // Find the item with the given displayName
    const item = await collection1.findOne({ std_itm_name: displayName });

    console.log(item);

    if (!item) {
      return res.status(404).json({ error: 'Item not found' });
    }

    // Return the item properties
    res.status(200).json(item);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Error fetching item details' });
  }
});



// router.get('/regional', async (req, res) => {
//   try {
//     const [regional1, regional2] = await Promise.all([
//       collection1.distinct('std_itm_regional'),
//       collection2.distinct('ritem_regional')
//     ]);

//     const allRegional = [...regional1, ...regional2];
//     const subRegional = [...new Set(allRegional)];

//     res.status(200).json(subRegional);
//   } catch (err) {
//     console.error(err);
//     res.status(500).json({ error: 'Error fetching foods details' });
//   }
// });


router.get('/cuisine', async (req, res) => {
  try {
    // Fetch distinct cuisines from collection2
    const cuisines2 = await collection2.distinct('ritem_cuisine');

    // If you want unique cuisines (in case of duplicates), use Set
    const uniqueCuisines = [...new Set(cuisines2)];

    // Send the response
    res.status(200).json(uniqueCuisines);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Error fetching cuisine details' });
  }
});


// router.get('/subCategory/:category', async (req, res) => {
//   try {
//     const categoryParam = req.params.category;

//     const [subCategories1, subCategories2] = await Promise.all([
//       collection1.distinct('std_itm_subcat', { std_itm_cat: categoryParam }),
//       collection2.distinct('ritem_subCategory', { ritem_category: categoryParam })
//     ]);

//     const allSubCategories = [...subCategories1, ...subCategories2];
//     const uniqueSubCategories = [...new Set(allSubCategories)];

//     res.status(200).json(uniqueSubCategories);
//   } catch (err) {
//     console.error(err);
//     res.status(500).json({ error: 'Error fetching subCategory details' });
//   }
// });


// router.get('/cuisine', async (req, res) => {
//   try {
//     const [cuisines1, cuisines2] = await Promise.all([
//       collection1.distinct('std_itm_cuisine_2'),
//       collection2.distinct('ritem_cuisine')
//     ]);

//     const allCuisines = [...cuisines1, ...cuisines2];
//     const subCuisine = [...new Set(allCuisines)];

//     res.status(200).json(subCuisine);
//   } catch (err) {
//     console.error(err);
//     res.status(500).json({ error: 'Error fetching foods details' });
//   }
// });

router.get('/subCategory/:category', async (req, res) => {
  try {
    const categoryParam = req.params.category;

    // Fetch distinct subcategories from collection2 based on the category parameter
    const subCategories = await collection2.distinct('ritem_subCategory', {
      ritem_category: categoryParam
    });

    // Ensure unique subcategories (optional, as distinct already returns unique values)
    const uniqueSubCategories = [...new Set(subCategories)];

    res.status(200).json(uniqueSubCategories);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Error fetching subcategory details' });
  }
});


router.get('/cuisine', async (req, res) => {
  try {
    // Fetch distinct cuisines from collection2
    const cuisines = await collection2.distinct('ritem_cuisine');

    // Ensure unique cuisines (optional)
    const uniqueCuisines = [...new Set(cuisines)];

    res.status(200).json(uniqueCuisines);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Error fetching cuisine details' });
  }
});


router.get('/tag/:tagName', async (req, res) => {
  try {
    const { tagName } = req.params;
    const { searchTerm } = req.query; // Retrieve the searchTerm query parameter

    // Connect to the MongoDB database
    await client.connect();

    // Specify the database and collection
    const database = client.db('test');
    const collection = database.collection('std_menu');

    // Construct the query based on tagName and searchTerm
    const query = {
      std_itm_tag: tagName,
      std_itm_dispname: { $regex: new RegExp(searchTerm, 'i') } // Case-insensitive regex match
    };

    // Fetch documents matching the query
    const items = await collection.find(query, { projection: { std_itm_dispname: 1 } }).toArray();

    // Extract the std_itm_dispname values into a list
    const displayNames = items.map(item => item.std_itm_dispname);

    // Send the list of display names as a JSON response
    res.status(200).json(displayNames);

  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Error fetching items by tag and search term' });
  }
});


module.exports = router;