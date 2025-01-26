const express = require('express');
const mysql = require('mysql2');
const bcrypt = require('bcrypt');
const bodyParser = require('body-parser');

const app = express();
const port = 3000;

// Middleware
app.use(bodyParser.urlencoded({ extended: true }));
app.use(express.static('public'));

// MySQL Connection
const db = mysql.createConnection({
    host: 'localhost',
    user: 'root', // Replace with your MySQL username
    password: 'janred0801', // Replace with your MySQL password
    database: 'flower_care_app'
});

db.connect((err) => {
    if (err) throw err;
    console.log('Connected to MySQL database.');
});

// Configure EJS as the view engine
app.set('view engine', 'ejs');

// Route to serve the home page
app.get('/', (req, res) => {
    res.sendFile(__dirname + '/index.html'); // Serve the index.html file
});

// Login Route
app.post('/login', (req, res) => {
    const { username, password } = req.body;

    console.log('Login attempt:', { username, password }); // Log username and password

    const query = 'SELECT * FROM Users WHERE username = ?';
    db.query(query, [username], async (err, results) => {
        if (err) {
            console.error('Database error:', err);
            return res.send(`
                <h1>Login Error</h1>
                <p>Internal Server Error. Please try again later.</p>
                <a href="/">Go Back</a>
            `);
        }

        if (results.length === 0) {
            return res.send(`
                <h1>Login Error</h1>
                <p>Invalid username or password.</p>
                <a href="/">Go Back</a>
            `);
        }

        const user = results[0];
        const isPasswordMatch = await bcrypt.compare(password, user.password);
        if (!isPasswordMatch) {
            return res.send(`
                <h1>Login Error</h1>
                <p>Invalid username or password.</p>
                <a href="/">Go Back</a>
            `);
        }

        // Fetch the flowers related to the user
        const flowerQuery = 'SELECT * FROM Flowers WHERE userId = ? AND is_locked = 0'; // Fetch only unlocked flowers
        db.query(flowerQuery, [user.id], (err, flowerResults) => {
            if (err) {
                console.error('Database error:', err);
                return res.send(`
                    <h1>Data Fetch Error</h1>
                    <p>Could not retrieve flower data. Please try again later.</p>
                    <a href="/">Go Back</a>
                `);
            }

            // Render the userDashboard view with flower data
            res.render('userDashboard', {
                username: username,
                flowers: flowerResults // Pass the flower data to the front end
            });
        });
    });
});

// Register Route
app.post('/register', async (req, res) => {
    console.log('Received registration request:', req.body);

    const { username, password } = req.body;

    // Check if the username already exists
    const checkUserQuery = 'SELECT * FROM Users WHERE username = ?';
    db.query(checkUserQuery, [username], async (err, results) => {
        if (err) {
            console.error('Database error during check:', err);
            return res.send(`
                <h1>Registration Error</h1>
                <p>Internal Server Error. Please try again later.</p>
                <a href="/">Go Back</a>
            `);
        }

        if (results.length > 0) {
            return res.send(`
                <h1>Registration Error</h1>
                <p>Username already exists. Please choose another username.</p>
                <a href="/">Go Back</a>
            `);
        }

        // Hash the password
        const hashedPassword = await bcrypt.hash(password, 10);

        // Insert the new user into the database
        const insertUserQuery = 'INSERT INTO Users (username, password) VALUES (?, ?)';
        db.query(insertUserQuery, [username, hashedPassword], (err) => {
            if (err) {
                console.error('Database error during insert:', err);
                return res.send(`
                    <h1>Registration Error</h1>
                    <p>Internal Server Error. Please try again later.</p>
                    <a href="/">Go Back</a>
                `);
            }

            res.send(`
                <h1>Registration Successful!</h1>
                <p>Your account has been created successfully.</p>
                <a href="/">Go Back to Login</a>
            `);
        });
    });
});

// Start the Server
app.listen(port, () => {
    console.log(`Server is running on http://localhost:${port}`);
});
