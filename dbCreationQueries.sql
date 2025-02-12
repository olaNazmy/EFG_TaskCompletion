CREATE TABLE Markets (
    market_ID INT PRIMARY KEY,
    market_name VARCHAR(255),
    city VARCHAR(255),
    country VARCHAR(255)
);
---------------------------------------------
CREATE TABLE Clients (
    client_ID INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    city VARCHAR(100),
    street VARCHAR(255),
    postal_code VARCHAR(20)
);
---------------------------------------------
CREATE TABLE Stocks (
    stock_ID INT PRIMARY KEY,
    stock_name VARCHAR(255),
    symbol VARCHAR(255),
    current_price DECIMAL(10, 2),
    market_ID INT,
    FOREIGN KEY (market_ID) REFERENCES Markets(market_ID)
);
-------------------------------------------------
CREATE TABLE Client_Account_Profiles (
    account_ID INT PRIMARY KEY,
    client_ID INT NOT NULL, -- Ensure client_ID is NOT NULL
    account_type VARCHAR(50) NOT NULL,
    status VARCHAR(50) NOT NULL CHECK (status IN ('active', 'suspended')), -- Constrained to 'active' or 'suspended'
    description TEXT,
    FOREIGN KEY (client_ID) REFERENCES Clients(client_ID)
);
-------------------------------------------------
CREATE TABLE Client_Account_Markets (
    account_ID INT,
    market_ID INT,
    authorization_date DATE DEFAULT GETDATE(), 
    PRIMARY KEY (account_ID, market_ID),
    FOREIGN KEY (account_ID) REFERENCES Client_Account_Profiles(account_ID),
    FOREIGN KEY (market_ID) REFERENCES Markets(market_ID)
);
-------------------------------------------------
CREATE TABLE Orders (
    order_ID INT PRIMARY KEY IDENTITY(1,1), -- Auto-increment order ID
    account_ID INT NOT NULL, 
    stock_ID INT NOT NULL,
    order_type VARCHAR(4) NOT NULL CHECK (order_type IN ('buy', 'sell')), 
    total_quantity INT NOT NULL CHECK (total_quantity > 0), -- Prevent negative or zero values
    order_status VARCHAR(50) NOT NULL DEFAULT 'pending' 
        CHECK (order_status IN ('pending', 'executed', 'canceled')), -- Default to 'pending'
    order_date DATE NOT NULL DEFAULT GETDATE(), -- Set default order date
    FOREIGN KEY (account_id) REFERENCES Client_Account_Profiles(account_id),
    FOREIGN KEY (stock_id) REFERENCES Stocks(stock_ID)
);
-------------------------------------------------
CREATE TABLE Executions (
    execution_ID INT PRIMARY KEY IDENTITY(1,1), 
    order_ID INT NOT NULL, 
    executed_quantity INT NOT NULL CHECK (executed_quantity > 0), 
    executed_price DECIMAL(10, 2) NOT NULL CHECK (executed_price > 0), 
    execution_date DATETIME NOT NULL DEFAULT GETDATE(), 
    FOREIGN KEY (order_ID) REFERENCES Orders(order_ID) ON DELETE CASCADE
);
-------------------------------------------------
CREATE TABLE Invoices (
    invoice_ID INT PRIMARY KEY IDENTITY(1,1), -- Auto-increment invoice ID
    order_ID INT NOT NULL UNIQUE, -- One invoice per order
    total_amount DECIMAL(15, 2) NOT NULL CHECK (total_amount > 0), -- Prevents negative/zero amounts
    invoice_date DATETIME NOT NULL DEFAULT GETDATE(), -- Stores precise invoice time
    FOREIGN KEY (order_ID) REFERENCES Orders(order_ID)
);
------------------------------------------------- HANDLE INVOICE ONLY FOR EXECUTED ORDER
