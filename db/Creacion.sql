DROP TABLE IF EXISTS FactTable;
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
	EmployeeLastName NVARCHAR(50) NOT NULL,
	VacationHours SMALLINT NOT NULL,
	GenderName NVARCHAR(30) NOT NULL, -- Hay que hacer transformacion para ponerlo explicito
	HireDate DATE NOT NULL,
	MaritalStatus NVARCHAR(20) NOT NULL
);

CREATE TABLE DimTerritoryCountry
(
    [TerritoryKey] INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [TerritoryID] INT NOT NULL,
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
	OrderDateKey INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[DayName] NVARCHAR(10) NOT NULL,
	DayNumber TINYINT NOT NULL,
	[MonthName] NVARCHAR(10) NOT NULL,
	[MonthNumber] TINYINT NOT NULL,
	[YearNumber] SMALLINT NOT NULL,

	CONSTRAINT UQ_OrderDueDate UNIQUE (DayNumber, [MonthNumber], [YearNumber])
);

CREATE TABLE DimDueDate
(
	DueDateKey INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[DayName] NVARCHAR(10) NOT NULL,
	DayNumber TINYINT NOT NULL,
	[MonthName] NVARCHAR(10) NOT NULL,
	[MonthNumber] TINYINT NOT NULL,
	[YearNumber] SMALLINT NOT NULL,

	CONSTRAINT UQ_DimDueDate UNIQUE (DayNumber, [MonthNumber], [YearNumber])
);


CREATE TABLE DimShipDate
(
	ShipDateKey INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[DayName] NVARCHAR(10) NOT NULL,
	DayNumber TINYINT NOT NULL,
	[MonthName] NVARCHAR(10) NOT NULL,
	MonthNumber TINYINT NOT NULL,
	YearNumber SMALLINT NOT NULL,

	CONSTRAINT UQ_ShipDueDate UNIQUE (DayNumber, [MonthNumber], [YearNumber])
);


CREATE TABLE DimCategory(
    CategoryDimKey INT IDENTITY(1,1) PRIMARY KEY,
	CategoryId INT UNIQUE,
    CategoryName nvarchar(50),
);


CREATE TABLE DimSubCategory (
    SubCategoryDimKey INT IDENTITY (1,1) PRIMARY KEY,
    SubCategoryDimID INT NOT NULL,
    SubCategoryName NVARCHAR(50),
	ProductCategoryFKey INT

    CONSTRAINT FK_DimSubCategory FOREIGN KEY (ProductCategoryFKey)
	REFERENCES DimCategory(CategoryDimKey)
);

CREATE TABLE DimProduct(
    ProductKey INT IDENTITY(1,1) NOT NULL,
	ProductId INT UNIQUE,
    ProductName NVARCHAR(50) NOT NULL,
    SubCategoryDimKey INT NULL,
    SizeName nvarchar(50) NULL,
    StyleName nchar(2) NULL,
    ColorName nvarchar(15) NULL,
    ClassName nchar(2) NULL,
	ModelId INT,

    ProductModelName nvarchar(50) NULL,
    PRIMARY KEY (ProductKey),

    CONSTRAINT FK_DimProduct FOREIGN KEY (SubCategoryDimKey) 
	REFERENCES DimSubCategory(SubCategoryDimKey)
);

CREATE TABLE FactTable(
	CustomerLocationFKey INT NOT NULL,
	StoreLocationFKey INT NOT NULL,
	ProductFKey INT NOT NULL,
	EmployeeFKey INT NOT NULL UNIQUE,
	DueDateFKey INT NOT NULL,
	ShipDateFKey INT NOT NULL,
	OrderDateFKey INT NOT NULL,
	UnitPrice MONEY NOT NULL,
	Quantity INT NOT NULL,

	CONSTRAINT PK_FactTable PRIMARY KEY(CustomerLocationFKey, StoreLocationFKey, ProductFKey,
				EmployeeFKey, DueDateFKey, ShipDateFKey, OrderDateFKey),

	CONSTRAINT FK_FTCustomer FOREIGN KEY (CustomerLocationFKey)
	REFERENCES DimCustomerLocation(CustomerKey),

	CONSTRAINT FK_FTStore FOREIGN KEY (StoreLocationFKey)
	REFERENCES DimStoreLocation(StoreKey),

	CONSTRAINT FK_FTProduct FOREIGN KEY (ProductFKey)
	REFERENCES DimProduct(ProductKey),

	CONSTRAINT FK_FTEmployee FOREIGN KEY (EmployeeFKey)
	REFERENCES DimEmployee(EmployeeKey),

	CONSTRAINT FK_FTDueDate FOREIGN KEY (DueDateFKey)
	REFERENCES DimDueDate(DueDateKey),

	CONSTRAINT FK_FTShipDate FOREIGN KEY (ShipDateFKey)
	REFERENCES DimShipDate(ShipDateKey),

	CONSTRAINT FK_FTOrderDate FOREIGN KEY (OrderDateFKey)
	REFERENCES DimOrderDate(OrderDateKey)
);