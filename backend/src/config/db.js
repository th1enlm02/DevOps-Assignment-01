// const mongoose = require('mongoose');

// let isConnected = false;

// const connectDB = async () => {
//     if (isConnected) {
//         console.log('MongoDB is already connected');
//         return;
//     }

//     try {
//         await mongoose.connect(process.env.MONGO_URI, {
//             serverSelectionTimeoutMS: 5000
//         });
//         isConnected = true;
//         console.log('MongoDB connected successfully');
//     } catch (error) {
//         console.error('Failed to connect to MongoDB', error);
//         throw error;
//     }
// }

// module.exports = connectDB;

const { DynamoDBClient } = require("@aws-sdk/client-dynamodb");
const { DynamoDBDocumentClient } = require("@aws-sdk/lib-dynamodb");

const client = new DynamoDBClient({
    region: process.env.AWS_REGION || "ap-southeast-1"
});

const docClient = DynamoDBDocumentClient.from(client);

module.exports = docClient;
