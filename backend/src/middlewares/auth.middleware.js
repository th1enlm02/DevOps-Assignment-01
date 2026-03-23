const jwt = require('jsonwebtoken');

module.exports = (req, res, next) => {
    const apiKey = req.headers['x-api-key'];
    const authHeader = req.headers['authorization'];

    if (apiKey && apiKey === process.env.API_KEY) {
        return next();
    }

    if (authHeader) {
        const token = authHeader.split(' ')[1]; // Bearer <token>

        try {
            const decoded = jwt.verify(token, process.env.JWT_SECRET);
            req.user = decoded;
            return next();
        } catch (error) {
            return res.status(403).json({ error: 'Invalid token' });
        }
    }

    return res.status(401).json({ error: 'Unauthorized' });
}
