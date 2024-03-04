
CREATE TABLE Users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE,
    password VARCHAR(100),
    email VARCHAR(100),
    balance DECIMAL(10, 2)
);

CREATE TABLE TransactionTypes (
    transaction_type_id SERIAL PRIMARY KEY,
    transaction_type_name VARCHAR(20) UNIQUE
);

INSERT INTO TransactionTypes (transaction_type_name) VALUES ('Deposit'), ('Withdrawal');

CREATE TABLE Transactions (
    transaction_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES Users(user_id),
    transaction_type_id INT REFERENCES TransactionTypes(transaction_type_id),
    amount DECIMAL(10, 2),
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Games (
    game_id SERIAL PRIMARY KEY,
    game_name VARCHAR(100),
    description TEXT
    -- Add other relevant fields for games
);


Tables:
Users Table:

Fields:
UserID (Primary Key, Auto-increment, Integer)
Username (Unique, Varchar)
Password (Varchar)
Transactions Table:

Fields:
TransactionID (Primary Key, Auto-increment, Integer)
UserID (Foreign Key referencing Users.UserID)
TransactionType (Enum: 'Deposit', 'Withdrawal')
Amount (Decimal)
TransactionDate (DateTime)


--1) List all users having 3 deposits or more:
SELECT UserID, Username
FROM Users
WHERE UserID IN (
    SELECT UserID
    FROM Transactions
    WHERE TransactionType = 'Deposit'
    GROUP BY UserID
    HAVING COUNT(*) >= 3
	
--While you could use a JOIN to achieve the same result, the subquery approach is simpler and more intuitive.
);

--2) List all users having only 1 withdrawal:
SELECT UserID, Username
FROM Users
WHERE UserID IN (
    SELECT UserID
    FROM Transactions
    WHERE TransactionType = 'Withdrawal'
    GROUP BY UserID
    HAVING COUNT(*) = 1
);

--3) List 3 users that have made the highest deposits:
SELECT UserID, Username
FROM Users
WHERE UserID IN (
    SELECT UserID
    FROM Transactions
    WHERE TransactionType = 'Deposit'
    GROUP BY UserID
    ORDER BY SUM(Amount) DESC
    LIMIT 3
);

--4) List all deposits for users. Display UserID, UserName, DepositDate, DepositAmount:
SELECT U.UserID, U.Username, T.TransactionDate, T.Amount AS DepositAmount
FROM Users U
INNER JOIN Transactions T ON U.UserID = T.UserID
WHERE T.TransactionType = 'Deposit';

--5)Calculate balances of all users:
SELECT U.UserID, U.Username, 
       COALESCE(SUM(CASE WHEN T.TransactionType = 'Deposit' THEN T.Amount ELSE 0 END), 0) -
       COALESCE(SUM(CASE WHEN T.TransactionType = 'Withdrawal' THEN T.Amount ELSE 0 END), 0) AS Balance
FROM Users U
LEFT JOIN Transactions T ON U.UserID = T.UserID
GROUP BY U.UserID, U.Username;


























