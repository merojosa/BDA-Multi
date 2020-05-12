DROP TABLE IF EXISTS DimProduct;
DROP TABLE IF EXISTS DimEmployee;
DROP TABLE IF EXISTS DimStoreLocation;
DROP TABLE IF EXISTS DimCustomerLocation;
DROP TABLE IF EXISTS DimTerritoryCountry;
DROP TABLE IF EXISTS DimOrderDate;
DROP TABLE IF EXISTS DimSubCategory;
DROP TABLE IF EXISTS DimCategory;
DROP TABLE IF EXISTS DimDueDate;
DROP TABLE IF EXISTS DimShipDate;

CREATE TABLE DimEmployee
(
	EmployeeKey INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	BusinessEntityId INT NOT NULL UNIQUE,
	EmployeeFirstName NVARCHAR(50) NOT NULL,
	EmployeeMiddleName NVARCHAR(50) NOT NULL,
	EmployeeLastName NVARCHAR(50) NOT NULL,
	VacationHours SMALLINT NOT NULL,
	GenderName NVARCHAR(30) NOT NULL, -- Hay que hacer transformacion para ponerlo explicito
	HireDate DATE NOT NULL,
	MaritalStatus NCHAR(1) NOT NULL
);

CREATE TABLE DimTerritoryCountry
(
    [TerritoryKey] INT NOT NULL PRIMARY KEY,
    [TerritoryID] INT IDENTITY(1,1) NOT NULL,
    [TerritoryName] NVARCHAR(50) NOT NULL,
    [CountryRegionCode] NVARCHAR(3) NOT NULL,
    [CountryRegionName] NVARCHAR(50) NOT NULL
);

CREATE TABLE DimStoreLocation
(
	StoreKey INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	BusinessEntityId INT NOT NULL UNIQUE,
	StoreName NVARCHAR(50) NOT NULL,
	SalesLastYear MONEY NOT NULL,
	SalesYTD MONEY NOT NULL,
	TerritoryFKey INT NOT NULL,

	CONSTRAINT FK_DimStoreLocation FOREIGN KEY (TerritoryFKey)
	REFERENCES DimTerritoryCountry([TerritoryKey])
);

CREATE TABLE DimCustomerLocation
(
    [CustomerKey] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [CustomerId] INT NOT NULL UNIQUE ,
    TerritoryFKey INT NOT NULL,

	CONSTRAINT FK_DimCustomerLocation FOREIGN KEY (TerritoryFKey)
	REFERENCES DimTerritoryCountry([TerritoryKey])
);


CREATE TABLE DimOrderDate
(
	OrderDateKey INT NOT NULL PRIMARY KEY,
	[DayName] NVARCHAR(10) NOT NULL,
	DayNumber TINYINT NOT NULL,
	[MonthName] NVARCHAR(10) NOT NULL,
	[MonthNumber] TINYINT NOT NULL,
	[YearNumber] SMALLINT NOT NULL,
);

CREATE TABLE DimDueDate
(
	DueDateKey INT NOT NULL PRIMARY KEY,
	[DayName] NVARCHAR(10) NOT NULL,
	DayNumber TINYINT NOT NULL,
	[MonthName] NVARCHAR(10) NOT NULL,
	[MonthNumber] TINYINT NOT NULL,
	[YearNumber] SMALLINT NOT NULL,
);


CREATE TABLE DimShipDate
(
	ShipDateKey INT NOT NULL PRIMARY KEY,
	[DayName] NVARCHAR(10) NOT NULL,
	DayNumber TINYINT NOT NULL,
	[MonthName] NVARCHAR(10) NOT NULL,
	MonthNumber TINYINT NOT NULL,
	YearNumber SMALLINT NOT NULL,
);


CREATE TABLE DimCategory(
    CategoryDimKey INT IDENTITY(1,1) PRIMARY KEY,
    CategoryName nvarchar(50),
);


CREATE TABLE DimSubCategory (
    SubCategoryDimID INT IDENTITY (1,1) NOT NULL PRIMARY KEY,
    CategoryDimKey INT NULL,
    SubCategoryName NVARCHAR(50),
    CONSTRAINT FK_DimSubCategory FOREIGN KEY (CategoryDimKey)
	REFERENCES DimCategory(CategoryDimKey)
);

CREATE TABLE DimProduct(
    ProductKey INT IDENTITY(1,1) NOT NULL,
    ProductName nvarchar(25) NOT NULL,
    SubCategoryDimID INT NULL,
    SizeName nvarchar(50) NULL,
    StyleName nchar(2) NULL,
    ColorName nvarchar(15) NOT NULL,
    ClassName nchar(2) NULL,
    ProductModelName nvarchar(50) NULL,
    PRIMARY KEY (ProductKey),
    CONSTRAINT FK_DimProduct FOREIGN KEY (SubCategoryDimID) 
	REFERENCES DimSubCategory(SubCategoryDimID)
);