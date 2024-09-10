const AWS = require("aws-sdk");
const dynamoDB = new AWS.DynamoDB({ region: "us-east-1" });

const params = {
  TableName: "LiveMenuNew",
  KeySchema: [
    { AttributeName: "ritem_UId", KeyType: "HASH" }, // Partition key
    { AttributeName: "date", KeyType: "RANGE" }, // Sort key
  ],
  AttributeDefinitions: [
    { AttributeName: "ritem_UId", AttributeType: "S" }, // String type
    { AttributeName: "date", AttributeType: "S" }, // String type
  ],
  ProvisionedThroughput: {
    ReadCapacityUnits: 5,
    WriteCapacityUnits: 5,
  },
};

dynamoDB.createTable(params, (err, data) => {
  if (err) {
    console.error(
      "Unable to create table. Error JSON:",
      JSON.stringify(err, null, 2)
    );
  } else {
    console.log(
      "Created table. Table description JSON:",
      JSON.stringify(data, null, 2)
    );
  }
});
