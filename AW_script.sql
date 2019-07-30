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
    ModifiedDate datetime
    );
Alter Table ProductSubcategory ADD Primary KEY (ProductSubcategoryID);

-- -----------------------Add Columns -------------------

Alter Table ProductSubcategory ADD Category varchar(50);
UPDATE ProductSubcategory SET Category = "Bikes" where ProductSubcategoryID<=3 ;
UPDATE ProductSubcategory SET Category = "Components" where ProductSubcategoryID<=17 && ProductSubcategoryID>3;
UPDATE ProductSubcategory SET Category = "Clothing" where ProductSubcategoryID<=25 && ProductSubcategoryID>17;
UPDATE ProductSubcategory SET Category = "Accessories" where ProductSubcategoryID>25 && ProductSubcategoryID<=37;


-- -----------------------Insert data -------------------
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/AW/ProductSubcategory.txt'
INTO TABLE ProductSubcategory
FIELDS TERMINATED BY '\t' 
LINES TERMINATED BY '\n'; 

INSERT INTO ProductSubcategory (ProductSubcategoryID,Name,ModifiedDate,Category)
 VALUES (38, 'Bearing', NOW(), 'Components');

INSERT INTO ProductSubcategory (ProductSubcategoryID,Name,ModifiedDate,Category)
 VALUES (39, 'Lock', NOW(), 'Components');

INSERT INTO ProductSubcategory (ProductSubcategoryID,Name,ModifiedDate,Category)
 VALUES (40, 'Paints', NOW(), 'Clothing');

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

-- ------------------------Add data ---------------------
UPDATE Product SET ProductSubcategoryID=39 where Name like "%Lock%" && ProductSubcategoryID is null;

UPDATE Product SET ProductSubcategoryID=38 where Name like "%Bearing%" && ProductSubcategoryID is null;

UPDATE Product SET ProductSubcategoryID=40 where Name like "Paints%" && ProductSubcategoryID is null;


-- -----------------Add the foreign key ---------------
Alter table Product ADD CONSTRAINT FK_Product_ProductSubcategory
FOREIGN KEY (ProductSubcategoryID)     
    REFERENCES ProductSubcategory (ProductSubcategoryID)     
    ON DELETE CASCADE    
    ON UPDATE CASCADE;

-- -----------------Change data type ---------------
Alter table Product modify TotalDue float;

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
Alter Table SalesOrderDetail ADD Primary KEY (SalesOrderID,SalesOrderDetailID);

-- -----------------------Insert data -------------------
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/AW/SalesOrderDetail.txt'
INTO TABLE SalesOrderDetail
FIELDS TERMINATED BY '\t' 
LINES TERMINATED BY '\n'; 

-----------------------Add new columns -------------------

Alter Table SalesOrderDetail ADD LineTotal Decimal(12,6);
-- Alter table SalesOrderDetail DROP LineTotal;
UPDATE SalesOrderDetail SET LineTotal= UnitPrice * (1.0 -UnitPriceDiscount) * OrderQty;

--------------------Add Foreign keys --------------------

Alter Table SalesOrderDetail ADD CONSTRAINT FK_SalesOrderDetail_Product
FOREIGN KEY (ProductID)     
    REFERENCES Product (ProductID)     
    ON DELETE CASCADE    
    ON UPDATE CASCADE;

------------------------------------------------------
--------------- Table SalesOrderHeader ---------------
------------------------------------------------------

DROP TABLE IF EXISTS SalesOrderHeader;
CREATE TABLE SalesOrderHeader(
    SalesOrderID int not null Primary KEY,
    OrderDate datetime,
    DueDate datetime,
    ShipDate datetime,
    OnlineOrder Boolean,
    CustomerID int,
    SalePersonID varchar(25),
    BilltoAddressID int,
    ShiptoAddressID int,
    TotalDue Decimal(12,6),
    ModifiedDate datetime
    );


-- -----------------------Insert data -------------------

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/AW/SalesOrderHeader1.csv'
INTO TABLE SalesOrderHeader
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n'
ignore 1 lines  ; 

--------------------Add Foreign keys --------------------
Alter Table SalesOrderHeader ADD CONSTRAINT FK_SalesOrderHeader_BilltoAddressID
FOREIGN KEY (BilltoAddressID)     
    REFERENCES Address (AddressID)     
    ON DELETE CASCADE    
    ON UPDATE CASCADE;

Alter Table SalesOrderHeader ADD CONSTRAINT FK_SalesOrderHeader_ShiptoAddressID
FOREIGN KEY (ShiptoAddressID)     
    REFERENCES Address (AddressID)     
    ON DELETE CASCADE    
    ON UPDATE CASCADE;


-- -----------------Change data type ---------------
Alter table SalesOrderHeader modify TotalDue float;

------------------------------------------------------
------------------------------------------------------
--------------- Query for Analyse----- ---------------
------------------------------------------------------
------------------------------------------------------


select count(Address.AddressID), StateProvince.CountryRegionCode from Address left join StateProvince on Address.StateProvinceID=StateProvince.StateProvinceID group by StateProvince.CountryRegionCode;

select * from SalesOrderHeader left join Address on Address.AddressID=SalesOrderHeader.ShiptoAddressID left join StateProvince on Address.StateProvinceID=StateProvince.StateProvinceID limit 10;

-- --------------Total Order Number by country------------------ 
select count(*), SalesOrderHeader.OrderDate,StateProvince.CountryRegionCode 
from SalesOrderHeader 
left join Address on Address.AddressID=SalesOrderHeader.ShiptoAddressID 
left join StateProvince on Address.StateProvinceID=StateProvince.stateProvinceID group by SalesOrderHeader.OrderDate 
Having StateProvince.CountryRegionCode ='FR' limit 100;

------------ Top Sales product by category-----------------

select count(*), Product.Name, SalesOrderDetail.UnitPrice, ProductSubcategory.Name AS ProductSubcategory, ProductSubcategory.category
from SalesOrderDetail 
left join Product on SalesOrderDetail.ProductID=Product.ProductID
left join ProductSubcategory on product.ProductSubcategoryID=ProductSubcategory.ProductSubcategoryID
group by Product.ProductID 
Having ProductSubcategory.category= "Clothing" 
-- Having ProductSubcategory.category= "Bikes" 
-- Having ProductSubcategory.category= "Components"
-- Having ProductSubcategory.category= "Accessories"
Order by count(*) desc limit 100;


----------------------- Top ordered Customers ---------------------

-- les clients qui ont le plus nombre de commande
select count(*), CustomerID 
from SalesOrderHeader group by 
CustomerID Order by count(*) desc limit 5;
-- les clients qui ont la somme des commandes le plus élevée 
select sum(TotalDue), count(*), CustomerID 
from SalesOrderHeader group by CustomerID Order by sum(TotalDue) desc limit 5;
-- Top Order Sum 
select TotalDue,CustomerID 
from SalesOrderHeader group by CustomerID Order by TotalDue desc limit 100;



select OrderDate,TotalDue from SalesOrderHeader 
-- where CustomerID=29818; 
-- where CustomerID=29715;
where CustomerID=11176;

select * from Address 
left join stateProvince
on Address.stateProvinceID=StateProvince.StateProvinceID
where AddressID=1104;


select count(*), SalesOrderHeader.OrderDate,StateProvince.CountryRegionCode,Address.City 
from SalesOrderHeader 
left join Address on Address.AddressID=SalesOrderHeader.ShiptoAddressID 
left join StateProvince on Address.StateProvinceID=StateProvince.stateProvinceID group by Address.City 
Having StateProvince.CountryRegionCode ='US';


+---------------+----------+------------+
| sum(TotalDue) | count(*) | CustomerID |
+---------------+----------+------------+
| 989184.082000 |       12 |      29818 |
| 961675.859600 |       12 |      29715 |
| 954021.923500 |       12 |      29722 |
| 919801.818800 |       12 |      30117 |
| 901346.856000 |       12 |      29614 |
+---------------+----------+------------+