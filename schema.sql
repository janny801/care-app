-- Create the database
CREATE DATABASE IF NOT EXISTS flower_care_app;

-- Use the database
USE flower_care_app;

-- Create the Users table
CREATE TABLE IF NOT EXISTS Users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create the Flowers table
CREATE TABLE IF NOT EXISTS Flowers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    userId INT NOT NULL,
    flower_type VARCHAR(50) NOT NULL,
    is_locked BOOLEAN NOT NULL,
    FOREIGN KEY (userId) REFERENCES Users(id)
);

-- Insert default flowers for new user setup
-- Assuming you might set a trigger or run this manually when a new user is created

-- To add a row for each flower type for a new user, you would typically run these inserts
-- as part of the user registration process in your application logic
-- Here's how to initialize default flowers for a user with a user ID of 1 as an example:

INSERT INTO Flowers (userId, flower_type, is_locked) VALUES (1, 'Rose', FALSE); -- Rose is unlocked
INSERT INTO Flowers (userId, flower_type, is_locked) VALUES (1, 'Tulip', TRUE);  -- Tulip is locked
INSERT INTO Flowers (userId, flower_type, is_locked) VALUES (1, 'Lotus', TRUE);  -- Lotus is locked
INSERT INTO Flowers (userId, flower_type, is_locked) VALUES (1, 'Poppy', TRUE);  -- Poppy is locked
INSERT INTO Flowers (userId, flower_type, is_locked) VALUES (1, 'Sunflower', TRUE); -- Sunflower is locked
