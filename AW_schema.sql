DROP DATABASE IF EXISTS AdventureWorks;
CREATE DATABASE AdventureWorks CHARACTER SET utf8mb4;
USE AdventureWorks;

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
    ModifiedDate varchar(25) NOT NULL);


LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/SalesOrderDetail.txt'
INTO TABLE SalesOrderDetail
FIELDS TERMINATED BY '\t' 
LINES TERMINATED BY '\n'; 


Alter Table SalesOrderDetail ADD LineTotal Decimal(10,3);
Alter table SalesOrderDetail DROP LineTotal;
UPDATE SalesOrderDetail SET LineTotal= UnitPrice * (1.0 -UnitPriceDiscount) * OrderQty;

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
    ModifiedDate varchar(25) NOT NULL,
    );


DROP TABLE IF EXISTS Product;
CREATE TABLE Product(
    ProductID int NOT NULL,
    Name varchar(25) NOT NULL,
    ProductSubcategoryID int,
    ModifiedDate varchar(25) NOT NULL
    );

DROP TABLE IF EXISTS ProductSubcategory;
CREATE TABLE ProductSubcategory(
    ProductSubcategoryID int NOT NULL,
    ProductID int NOT NULL,
    Name varchar(25),
    ModifiedDate varchar(25) NOT NULL
    );


DROP TABLE IF EXISTS StateProvince;
CREATE TABLE StateProvince(
    StateProvinceID int NOT NULL,
    StateProvinceCode varchar(3) NOT NULL,
    CountryRegionCode varchar(3) NOT NULL,
    Name varchar(50) NOT NULL,
    ModifiedDate varchar(100));
Alter Table StateProvince ADD Primary KEY (StateProvinceID);

-- Import des données Table StatProvince--

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/AW/StateProvince.txt'
INTO TABLE StateProvince
FIELDS TERMINATED BY '\t' 
LINES TERMINATED BY '\n'; 

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
Alter table Address ADD CONSTRAINT FK_Address_StateProvince FOREIGN KEY (StateProvinceID)     
    REFERENCES StateProvince (StateProvinceID)     
    ON DELETE CASCADE    
    ON UPDATE CASCADE    
;    
-- Import des données Table Address --
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/AW/Address.txt'
INTO TABLE Address
FIELDS TERMINATED BY '\t' 
LINES TERMINATED BY '\n'; 