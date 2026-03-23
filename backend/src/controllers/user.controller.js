const userService = require('../services/user.service');

const searchUser = async (req, res) => {
    try {
        const { name } = req.query;
        const users = await userService.searchUser(name);
        res.json(users);    
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

const updateUser = async (req, res) => {
    try {
        const users = req.body;
        await userService.updateUser(users);
        res.json({ message: 'Users updated successfully' });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

module.exports = {
    searchUser,
    updateUser
};
