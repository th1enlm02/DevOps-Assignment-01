const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const morgan = require('morgan');
const useRoutes = require('./routes/user.route');
const authRoutes = require('./routes/auth.route');

const app = express();

app.use(express.json());
app.use(cors({ origin: "*" }));
app.use(helmet());
app.use(morgan('dev'));

app.use ('/api', [useRoutes, authRoutes]);

module.exports = app;
