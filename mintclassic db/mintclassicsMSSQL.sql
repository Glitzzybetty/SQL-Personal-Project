-- Create database
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'mintclassics')
BEGIN
    CREATE DATABASE mintclassics;
END
GO

USE mintclassics;
GO

-------------------------------
-- Drop table if it exists
IF OBJECT_ID('dbo.offices', 'U') IS NOT NULL 
DROP TABLE dbo.offices;
GO

-- Create the offices table
CREATE TABLE dbo.offices (
    officeCode VARCHAR(10) NOT NULL PRIMARY KEY,
    city VARCHAR(50) NOT NULL,
    phone VARCHAR(50) NOT NULL,
    addressLine1 VARCHAR(50) NOT NULL,
    addressLine2 VARCHAR(50) NULL,
    state VARCHAR(50) NULL,
    country VARCHAR(50) NOT NULL,
    postalCode VARCHAR(15) NOT NULL,
    territory VARCHAR(10) NOT NULL
);
GO

--------------------------------------------
-- Drop table if it exists
IF OBJECT_ID('dbo.employees', 'U') IS NOT NULL 
DROP TABLE dbo.employees;
GO

-- Create the employees table
CREATE TABLE dbo.employees (
    employeeNumber INT NOT NULL PRIMARY KEY,
    lastName VARCHAR(50) NOT NULL,
    firstName VARCHAR(50) NOT NULL,
    extension VARCHAR(10) NOT NULL,
    email VARCHAR(100) NOT NULL,
    officeCode VARCHAR(10) NOT NULL,
    reportsTo INT NULL,
    jobTitle VARCHAR(50) NOT NULL,
    CONSTRAINT FK_employees_reportsTo FOREIGN KEY (reportsTo) REFERENCES dbo.employees (employeeNumber),
    CONSTRAINT FK_employees_officeCode FOREIGN KEY (officeCode) REFERENCES dbo.offices (officeCode)
);
GO

-- Create an index on reportsTo
CREATE INDEX IX_employees_reportsTo 
ON dbo.employees (reportsTo);
GO

-- Create an index on officeCode
CREATE INDEX IX_employees_officeCode 
ON dbo.employees (officeCode);
GO
--------------------

-- Table structure for table customers
-- Drop table if it exists
IF OBJECT_ID('dbo.customers', 'U') IS NOT NULL 
DROP TABLE dbo.customers;
GO

-- Create the customers table
CREATE TABLE dbo.customers (
    customerNumber INT NOT NULL PRIMARY KEY,
    customerName VARCHAR(50) NOT NULL,
    contactLastName VARCHAR(50) NOT NULL,
    contactFirstName VARCHAR(50) NOT NULL,
    phone VARCHAR(50) NOT NULL,
    addressLine1 VARCHAR(50) NOT NULL,
    addressLine2 VARCHAR(50) NULL,
    city VARCHAR(50) NOT NULL,
    state VARCHAR(50) NULL,
    postalCode VARCHAR(15) NULL,
    country VARCHAR(50) NOT NULL,
    salesRepEmployeeNumber INT NULL,
    creditLimit DECIMAL(10,2) NULL,
    CONSTRAINT FK_customers_employees FOREIGN KEY (salesRepEmployeeNumber) REFERENCES dbo.employees (employeeNumber)
);
GO

-- Create an index on salesRepEmployeeNumber
CREATE INDEX IX_customers_salesRepEmployeeNumber 
ON dbo.customers (salesRepEmployeeNumber);
GO

--------------------------------
-- Table structure for table 'orders'

-- Drop table if it exists (optional in MSSQL)
IF OBJECT_ID('orders', 'U') IS NOT NULL
    DROP TABLE orders;
GO

-- Create table 'orders'
CREATE TABLE orders (
  orderNumber int NOT NULL,
  orderDate date NOT NULL,
  requiredDate date NOT NULL,
  shippedDate date NULL,
  status varchar(15) NOT NULL,
  comments text,
  customerNumber int NOT NULL,
  PRIMARY KEY (orderNumber),
  FOREIGN KEY (customerNumber) REFERENCES customers (customerNumber)
);
GO

-------------------
-- Table structure for table 'productlines'

-- Drop table if it exists (optional in MSSQL)
IF OBJECT_ID('productlines', 'U') IS NOT NULL
    DROP TABLE productlines;
GO

-- Create table 'productlines'
CREATE TABLE productlines (
  productLine varchar(50) NOT NULL,
  textDescription varchar(4000) NULL,
  htmlDescription nvarchar(max) NULL,
  image varbinary(max) NULL,
  PRIMARY KEY (productLine)
);
GO

-----------
-- Table structure for table 'warehouses'

-- Drop table if it exists (optional in MSSQL)
IF OBJECT_ID('warehouses', 'U') IS NOT NULL
    DROP TABLE warehouses;
GO

-- Create table 'warehouses'
CREATE TABLE warehouses (
  warehouseCode char(1) NOT NULL,
  warehouseName varchar(45) NOT NULL,
  warehousePctCap varchar(50) NOT NULL,
  PRIMARY KEY (warehouseCode)
);
GO

------------
-- Table structure for table 'products'

-- Drop table if it exists (optional in MSSQL)
IF OBJECT_ID('products', 'U') IS NOT NULL
    DROP TABLE products;
GO

-- Create table 'products'
CREATE TABLE products (
  productCode varchar(15) NOT NULL,
  productName varchar(70) NOT NULL,
  productLine varchar(50) NOT NULL,
  productScale varchar(10) NOT NULL,
  productVendor varchar(50) NOT NULL,
  productDescription text NOT NULL,
  quantityInStock smallint NOT NULL,
  warehouseCode char(1) NOT NULL,
  buyPrice decimal(10,2) NOT NULL,
  MSRP decimal(10,2) NOT NULL,
  PRIMARY KEY (productCode),
  FOREIGN KEY (productLine) REFERENCES productlines (productLine),
  FOREIGN KEY (warehouseCode) REFERENCES warehouses (warehouseCode)
);
GO
----------------------
-- Drop table if it exists
IF OBJECT_ID('dbo.orderdetails', 'U') IS NOT NULL 
DROP TABLE dbo.orderdetails;
GO

-- Create the orderdetails table
CREATE TABLE dbo.orderdetails (
    orderNumber INT NOT NULL,
    productCode VARCHAR(15) NOT NULL,
    quantityOrdered INT NOT NULL,
    priceEach DECIMAL(10, 2) NOT NULL,
    orderLineNumber SMALLINT NOT NULL,
    PRIMARY KEY (orderNumber, productCode),
    FOREIGN KEY (orderNumber) REFERENCES dbo.orders (orderNumber),
    FOREIGN KEY (productCode) REFERENCES dbo.products (productCode)
);
GO
-----------------------------------------------
-- Table structure for table 'payments'

-- Drop table if it exists (optional in MSSQL)
IF OBJECT_ID('payments', 'U') IS NOT NULL
    DROP TABLE payments;
GO

-- Create table 'payments'
CREATE TABLE payments (
  customerNumber int NOT NULL,
  checkNumber varchar(50) NOT NULL,
  paymentDate date NOT NULL,
  amount decimal(10,2) NOT NULL,
  PRIMARY KEY (customerNumber, checkNumber),
  FOREIGN KEY (customerNumber) REFERENCES customers (customerNumber)
);
GO

-------------------------