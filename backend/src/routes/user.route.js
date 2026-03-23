const express = require('express');
const router = express.Router();
const userController = require('../controllers/user.controller');
const auth = require('../middlewares/auth.middleware');

// Middleware for authentication
router.use(auth);

router.get('/users', userController.searchUser);
router.post('/users', userController.updateUser);

module.exports = router;
