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

-- Create a trigger to insert default flowers for each new user
DELIMITER $$

CREATE TRIGGER after_user_insert
AFTER INSERT ON Users
FOR EACH ROW
BEGIN
    INSERT INTO Flowers (userId, flower_type, is_locked) VALUES (NEW.id, 'Rose', FALSE);
    INSERT INTO Flowers (userId, flower_type, is_locked) VALUES (NEW.id, 'Tulip', TRUE);
    INSERT INTO Flowers (userId, flower_type, is_locked) VALUES (NEW.id, 'Lotus', TRUE);
    INSERT INTO Flowers (userId, flower_type, is_locked) VALUES (NEW.id, 'Poppy', TRUE);
    INSERT INTO Flowers (userId, flower_type, is_locked) VALUES (NEW.id, 'Sunflower', TRUE);
END$$

DELIMITER ;
