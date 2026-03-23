// const mongoose = require('mongoose');
// const User = require('../models/user.model');
// const dotenv = require('dotenv');

// dotenv.config();

// mongoose.connect(process.env.MONGO_URI);

// (async () => {
//     await User.insertMany([
//         { username: 'John Doe', email: 'john@email.com', birthdate: new Date('1990-01-01'), password: 'password123' },
//         { username: 'John Smith', email: 'johnsmith@email.com', birthdate: new Date('1990-01-01'), password: 'password123' },
//         { username: 'Jane Smith', email: 'janesmith@email.com', birthdate: new Date('1992-05-15'), password: 'password456' }
//     ]);
//     console.log('Database seeded successfully');
//     process.exit(0);
// })();

const { PutCommand } = require("@aws-sdk/lib-dynamodb");
const { v4: uuidv4 } = require("uuid");
const db = require("../config/db");

(async () => {
    const users = [
        { username: 'John Doe', email: 'john@email.com', birthdate: '1990-01-01', password: 'password123' },
        { username: 'John Smith', email: 'johnsmith@email.com', birthdate: '1990-01-01', password: 'password123' },
        { username: 'Jane Smith', email: 'janesmith@email.com', birthdate: '1992-05-15', password: 'password456' }
    ];

    for (const u of users) {
        await db.send(new PutCommand({
            TableName: "users",
            Item: {
                userId: uuidv4(),
                ...u,
                createdAt: new Date().toISOString(),
                updatedAt: new Date().toISOString()
            }
        }));
    }

    console.log("Seeded successfully");
})();
