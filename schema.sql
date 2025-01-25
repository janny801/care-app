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
