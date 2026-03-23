// const User = require('../models/user.model');
// const mongoose = require('mongoose');

// const searchUser = async (query) => {
//     return await User.find({
//         $or: [
//             { username: { $regex: query, $options: 'i' } },
//             { email: { $regex: query, $options: 'i' } }
//         ]
//     });    
// };

// const updateUser = async (users) => {
//     const ids = users.map(u => new mongoose.Types.ObjectId(u.id));

//     const existingUsers = await User.find({ _id: { $in: ids } });

//     if (existingUsers.length !== users.length) {
//         throw new Error('Some users not found');
//     }

//     const bulkOps = users.map((u) => ({
//         updateOne: {
//             filter: { _id: new mongoose.Types.ObjectId(u.id) },
//             update: {
//                 $set: {
//                     username: u.username,
//                     email: u.email,
//                     birthdate: u.birthdate
//                 }
//             },
//         },
//     }));

//     return await User.bulkWrite(bulkOps);
// };

// module.exports = {
//     searchUser,
//     updateUser
// };


const { ScanCommand, UpdateCommand, GetCommand } = require("@aws-sdk/lib-dynamodb");
const {  } = require("@aws-sdk/lib-dynamodb");

const db = require("../config/db");

const searchUser = async (query) => {
    const res = await db.send(new ScanCommand({
        TableName: "users"
    }));

    const q = query.toLowerCase();

    return res.Items.filter(u =>
        u.username.toLowerCase().includes(q) ||
        u.email.toLowerCase().includes(q)
    );
};

const updateUser = async (users) => {
    for (const u of users) {

        if (!u.id) {
            throw new Error("Missing userId");
        }

        const existing = await db.send(new GetCommand({
            TableName: "users",
            Key: { userId: u.id }
        }));

        if (!existing.Item) {
            throw new Error(`User not found: ${u.id}`);
        }

        let updateExp = "set";
        const values = {};

        if (u.username !== undefined) {
            updateExp += " username = :username,";
            values[":username"] = u.username;
        }

        if (u.email !== undefined) {
            updateExp += " email = :email,";
            values[":email"] = u.email;
        }

        if (u.birthdate !== undefined) {
            updateExp += " birthdate = :birthdate,";
            values[":birthdate"] = u.birthdate;
        }

        updateExp = updateExp.replace(/,$/, "");

        await db.send(new UpdateCommand({
            TableName: "users",
            Key: { userId: u.id },
            UpdateExpression: updateExp,
            ExpressionAttributeValues: values
        }));
    }

    return { message: "Users updated" };
};

module.exports = {
    searchUser,
    updateUser
};
