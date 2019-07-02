DROP DATABASE IF EXISTS AdventureWorks;
CREATE DATABASE AdventureWorks CHARACTER SET utf8mb4;
USE AdventureWorks;

------------------------------------------------------
----------------- Table StateProvince ----------------
------------------------------------------------------
DROP TABLE IF EXISTS StateProvince;
CREATE TABLE StateProvince(
    StateProvinceID int NOT NULL,
    StateProvinceCode varchar(3) NOT NULL,
    CountryRegionCode varchar(3) NOT NULL,
    Name varchar(50) NOT NULL,
    ModifiedDate varchar(100));
Alter Table StateProvince ADD Primary KEY (StateProvinceID);

-- -----------------------Insert data -------------------

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/AW/StateProvince.txt'
INTO TABLE StateProvince
FIELDS TERMINATED BY '\t' 
LINES TERMINATED BY '\n'; 

------------------------------------------------------
----------------------- Table Address ----------------
------------------------------------------------------

DROP TABLE IF EXISTS Address;
CREATE TABLE Address(
    AddressID int NOT NULL,
    AddressLine1 varchar(100) NOT NULL,
    AddressLine2 varchar(100),
    City varchar(50),
    StateProvinceID int NOT NULL,
    PostalCode varchar(20) NOT NULL,
    ModifiedDate varchar(100));
Alter Table Address ADD Primary KEY (AddressID);
    
-- -----------------Import des données ---------------

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/AW/Address.txt'
INTO TABLE Address
FIELDS TERMINATED BY '\t' 
LINES TERMINATED BY '\n'; 

-- -----------------Add the foreign key ---------------
Alter table Address ADD CONSTRAINT FK_Address_StateProvince FOREIGN KEY (StateProvinceID)     
    REFERENCES StateProvince (StateProvinceID)     
    ON DELETE CASCADE    
    ON UPDATE CASCADE;

------------------------------------------------------
----------------Table ProductSubcategory--------------
------------------------------------------------------

DROP TABLE IF EXISTS ProductSubcategory;
CREATE TABLE ProductSubcategory(
    ProductSubcategoryID int NOT NULL,
    Name varchar(25),
    ModifiedDate varchar(25)
    );
Alter Table ProductSubcategory ADD Primary KEY (ProductSubcategoryID);

-- -----------------------Insert data -------------------
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/AW/ProductSubcategory.txt'
INTO TABLE ProductSubcategory
FIELDS TERMINATED BY '\t' 
LINES TERMINATED BY '\n'; 

------------------------------------------------------
--------------------- Table Product ------------------
------------------------------------------------------

DROP TABLE IF EXISTS Product;
CREATE TABLE Product(
    ProductID int NOT NULL,
    Name varchar(35) NOT NULL,
    ProductNum varchar(25) NOT NULL,
    ProductSubcategoryID varchar(25),
    ModifiedDate varchar(100) NOT NULL
    );
Alter Table Product ADD Primary KEY (ProductID);
-- -----------------------Insert data -------------------
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/AW/Product.txt'
INTO TABLE Product
FIELDS TERMINATED BY '\t' 
LINES TERMINATED BY '\n'; 
-- -----------------Replace space by NULL ---------------
UPDATE Product SET ProductSubcategoryID=nullif(ProductSubcategoryID, '');
-- -----------------Change data type ---------------
Alter table Product modify ProductSubcategoryID int null;
Alter table Product modify ModifiedDate datetime;
-- -----------------Add the foreign key ---------------
Alter table Product ADD CONSTRAINT FK_Product_ProductSubcategory
FOREIGN KEY (ProductSubcategoryID)     
    REFERENCES ProductSubcategory (ProductSubcategoryID)     
    ON DELETE CASCADE    
    ON UPDATE CASCADE;


------------------------------------------------------
--------------- Table SalesOrderDetail ---------------
------------------------------------------------------

DROP TABLE IF EXISTS SalesOrderDetail;
CREATE TABLE SalesOrderDetail(
    SalesOrderID int NOT NULL,
    SalesOrderDetailID int NOT NULL,
    CarrierTrackingNumber varchar(25) NULL, 
    OrderQty smallint NOT NULL,
    ProductID int NOT NULL,
    SpecialOfferID int NOT NULL,
    UnitPrice Decimal(10,3) NOT NULL,
    UnitPriceDiscount Decimal(10,3)NOT NULL,
    ModifiedDate varchar(25) NOT NULL
    );

-- -----------------------Insert data -------------------
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/SalesOrderDetail.txt'
INTO TABLE SalesOrderDetail
FIELDS TERMINATED BY '\t' 
LINES TERMINATED BY '\n'; 

-----------------------Add new columns -------------------

Alter Table SalesOrderDetail ADD LineTotal Decimal(10,3);
Alter table SalesOrderDetail DROP LineTotal;
UPDATE SalesOrderDetail SET LineTotal= UnitPrice * (1.0 -UnitPriceDiscount) * OrderQty;


------------------------------------------------------
--------------- Table SalesOrderDetail ---------------
------------------------------------------------------

DROP TABLE IF EXISTS SalesOrderHeader;
CREATE TABLE SalesOrderHeader(
    SalesOrderID int NOT NULL,
    SalesOrderDetailID int NOT NULL,
    CarrierTrackingNumber varchar(25) NULL, 
    OrderQty smallint NOT NULL,
    ProductID int NOT NULL,
    SpecialOfferID int NOT NULL,
    UnitPrice Decimal(10,3) NOT NULL,
    UnitPriceDiscount Decimal(10,3)NOT NULL,
    ModifiedDate varchar(25) NOT NULL
    );