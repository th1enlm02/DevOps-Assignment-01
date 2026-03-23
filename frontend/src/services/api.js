import axios from 'axios';

const API = axios.create({
    baseURL: process.env.REACT_APP_API_URL,
    headers: {
        'Content-Type': 'application/json',
        'x-api-key': process.env.REACT_APP_API_KEY
    },
});

export const searchUsers = async (name) => {
    return API.get(`/users?name=${name}`)
}

export const updateUsers = async (data) => {
    return API.post('/users', data)
}
