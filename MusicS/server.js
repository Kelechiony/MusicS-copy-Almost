const express = require('express');
const bodyParser = require('body-parser');
const sql = require('mssql');

const app = express();
const port = process.env.PORT || 3000;

app.use(bodyParser.json());

const dbConfig = {
    user: 'your-db-username',
    password: 'your-db-password',
    server: 'connect2024.database.windows.net',
    database: 'your-database-name',
    options: {
        encrypt: true
    }
};

sql.connect(dbConfig).then(pool => {
    app.post('/signup', async (req, res) => {
        const { firstName, lastName, email, username, password } = req.body;

        try {
            const result = await pool.request()
                .input('FirstName', sql.VarChar, firstName)
                .input('LastName', sql.VarChar, lastName)
                .input('Email', sql.VarChar, email)
                .input('Username', sql.VarChar, username)
                .input('Password', sql.VarChar, password) // You should hash the password before storing
                .query('INSERT INTO Users (FirstName, LastName, Email, Username, Password) VALUES (@FirstName, @LastName, @Email, @Username, @Password)');

            res.status(200).send('User registered successfully');
        } catch (err) {
            console.error(err);
            res.status(500).send('Error registering user');
        }
    });
}).catch(err => {
    console.error('Database connection failed: ', err);
});

app.listen(port, () => {
    console.log(`Server is running on port ${port}`);
});

