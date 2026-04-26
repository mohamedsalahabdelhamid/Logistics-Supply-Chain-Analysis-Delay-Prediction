-- ==============================================================================
-- 1. CREATE AND USE THE PROJECT DATABASE
-- ==============================================================================

-- Create the database for the project
CREATE DATABASE LogisticsDataMiningProjDB;
GO

-- Switch context to ensure all tables and data into project database
USE LogisticsDataMiningProjDB;
GO

-- ==============================================================================
-- 2. CREATE REFERENCE TABLES (No Foreign Keys)
-- ==============================================================================

CREATE TABLE Countries 
(
    CountryID INT PRIMARY KEY,
    CountryName VARCHAR(100) NOT NULL,
    Region VARCHAR(50),
    Probability FLOAT 
);
GO

CREATE TABLE ShipmentStatusLookup 
(
    StatusID INT PRIMARY KEY,
    StatusName VARCHAR(50) NOT NULL
);
GO

CREATE TABLE FailureReasonLookup 
(
    ReasonID INT PRIMARY KEY,
    FailureReason VARCHAR(150) NOT NULL
);
GO

CREATE TABLE MaterialLookup 
(
    MaterialID INT PRIMARY KEY,
    MaterialName VARCHAR(150) NOT NULL
);
GO

-- ==============================================================================
-- 3. CREATE CORE ENTITY TABLES
-- ==============================================================================
CREATE TABLE Hubs 
(
    HubID INT PRIMARY KEY,
    HubName VARCHAR(150) NOT NULL,
    City VARCHAR(100),
    CountryID INT,
    FOREIGN KEY (CountryID) REFERENCES Countries(CountryID)
);
GO

CREATE TABLE Customers 
(
    CustomerID INT PRIMARY KEY,
    Name VARCHAR(150) NOT NULL,
    Address VARCHAR(500),
    ContactInfo VARCHAR(100), -- Allows NULLs for your EDA missing values
    CountryID INT,
    CustomerType VARCHAR(20), -- 'B2B' or 'B2C'
    FOREIGN KEY (CountryID) REFERENCES Countries(CountryID)
);
GO

-- ==============================================================================
-- 4. CREATE STAFF & COURIERS TABLES
-- ==============================================================================
CREATE TABLE Employees 
(
    EmployeeID INT PRIMARY KEY,
    Name VARCHAR(150) NOT NULL,
    HubID INT,
    Role VARCHAR(50),
    FOREIGN KEY (HubID) REFERENCES Hubs(HubID)
);
GO

CREATE TABLE Couriers 
(
    CourierID INT PRIMARY KEY,
    CourierName VARCHAR(150) NOT NULL,
    HubID INT,
    CompanyName VARCHAR(100),
    FOREIGN KEY (HubID) REFERENCES Hubs(HubID)
);
GO

-- ==============================================================================
-- 5. CREATE TRANSACTIONAL TABLES
-- ==============================================================================

CREATE TABLE Shipments 
(
    ShipmentID INT PRIMARY KEY,
    TrackingNumber VARCHAR(50) NOT NULL,
    SenderID INT,
    ReceiverID INT,
    OriginHubID INT,
    DestinationHubID INT,
    CreatedDate DATETIME,
    PromisedDeliveryDate DATETIME,
    DeliveredDate DATETIME, 
    ServiceType VARCHAR(50),
    PackageWeight_KG DECIMAL(10,2),
    PackageVolume_CM3 DECIMAL(10,2),
    DeclaredValue DECIMAL(12,2), 
    ShippingFee DECIMAL(10,2),
    StatusID INT, -- Foreign Key to ShipmentStatusLookup
    MaterialID INT, -- Foreign Key to MaterialLookup
    FinalFailureReasonID INT,    

    FOREIGN KEY (SenderID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (ReceiverID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (OriginHubID) REFERENCES Hubs(HubID),
    FOREIGN KEY (DestinationHubID) REFERENCES Hubs(HubID),
    FOREIGN KEY (StatusID) REFERENCES ShipmentStatusLookup(StatusID),
    FOREIGN KEY (MaterialID) REFERENCES MaterialLookup(MaterialID),
    FOREIGN KEY (FinalFailureReasonID) REFERENCES FailureReasonLookup(ReasonID)
);
GO

CREATE TABLE Payments 
(
    PaymentID INT PRIMARY KEY,
    ShipmentID INT,
    Amount DECIMAL(12,2),
    PaymentDate DATETIME,
    PaymentMethod VARCHAR(50),
    FOREIGN KEY (ShipmentID) REFERENCES Shipments(ShipmentID)
);
GO

-- ==============================================================================
-- 6. ASSUMED TRANSACTIONAL TABLES (Tracking, Attempts, and POD)
-- ==============================================================================

CREATE TABLE TrackingEvents 
(
    EventID INT PRIMARY KEY, -- Pre-assigned in CSV data
    ShipmentID INT,
    EventTime DATETIME,
    HubID INT NULL, -- Can be NULL if the event happens in transit
    Status VARCHAR(50),
    EventDescription VARCHAR(255),
    FOREIGN KEY (ShipmentID) REFERENCES Shipments(ShipmentID),
    FOREIGN KEY (HubID) REFERENCES Hubs(HubID)
);
GO

CREATE TABLE DeliveryAttempts 
(
    AttemptID INT PRIMARY KEY,
    ShipmentID INT,
    CourierID INT,
    AttemptTime DATETIME,
    IsSuccessful BIT, -- 1 for Yes, 0 for No
    FailureReasonID INT NULL, -- NULL if successful
    FOREIGN KEY (ShipmentID) REFERENCES Shipments(ShipmentID),
    FOREIGN KEY (CourierID) REFERENCES Couriers(CourierID),
    FOREIGN KEY (FailureReasonID) REFERENCES FailureReasonLookup(ReasonID)
);
GO

CREATE TABLE ProofOfDelivery 
(
    PODID INT PRIMARY KEY,
    ShipmentID INT,
    PODType VARCHAR(50),
    LoggedTime DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (ShipmentID) REFERENCES Shipments(ShipmentID)
);
GO

-- ==============================================================================
-- 7. BULK INSERT DATA TABELS
-- ==============================================================================

BULK INSERT Countries
FROM '/var/opt/mssql/data/Countries.csv'
WITH
(
    FIRSTROW = 2, 
    FIELDTERMINATOR = ',', 
    ROWTERMINATOR = '0x0a'
);
GO

BULK INSERT ShipmentStatusLookup
FROM '/var/opt/mssql/data/ShipmentStatusLookup.csv'
WITH 
(
    FIRSTROW = 2, 
    FIELDTERMINATOR = ',', 
    ROWTERMINATOR = '0x0a'
);
GO

BULK INSERT FailureReasonLookup
FROM '/var/opt/mssql/data/FailureReasonLookup.csv'
WITH 
(
    FIRSTROW = 2, 
    FIELDTERMINATOR = ',', 
    ROWTERMINATOR = '0x0a'
);
GO

BULK INSERT MaterialLookup
FROM '/var/opt/mssql/data/MaterialLookup.csv'
WITH 
(
    FIRSTROW = 2, 
    FIELDTERMINATOR = ',', 
    ROWTERMINATOR = '0x0a'
);
GO

BULK INSERT Hubs
FROM '/var/opt/mssql/data/Hubs.csv'
WITH 
(
    FIRSTROW = 2, 
    FIELDTERMINATOR = ',', 
    ROWTERMINATOR = '0x0a'
);
GO

BULK INSERT Customers
FROM '/var/opt/mssql/data/Customers.csv'
WITH 
(
    FORMAT = 'CSV',          
    FIELDQUOTE = '"',        
    FIRSTROW = 2, 
    FIELDTERMINATOR = ',', 
    ROWTERMINATOR = '0x0a'
);
GO

BULK INSERT Couriers
FROM '/var/opt/mssql/data/Couriers.csv'
WITH 
(
    FIRSTROW = 2, 
    FIELDTERMINATOR = ',', 
    ROWTERMINATOR = '0x0a'
);
GO

BULK INSERT Employees
FROM '/var/opt/mssql/data/Employees.csv'
WITH 
(
    FIRSTROW = 2, 
    FIELDTERMINATOR = ',', 
    ROWTERMINATOR = '0x0a'
);
GO

BULK INSERT Payments
FROM '/var/opt/mssql/data/Payments.csv'
WITH 
(
    FIRSTROW = 2, 
    FIELDTERMINATOR = ',', 
    ROWTERMINATOR = '0x0a'
);
GO

BULK INSERT Shipments
FROM '/var/opt/mssql/data/Shipments.csv'
WITH 
(   
	FIELDQUOTE = '"',        
    FIRSTROW = 2, 
    FIELDTERMINATOR = ',', 
    ROWTERMINATOR = '0x0a'
);
GO

BULK INSERT TrackingEvents
FROM '/var/opt/mssql/data/TrackingEvents.csv'
WITH 
(
	FIRSTROW = 2, 
	FIELDTERMINATOR = ',', 
	ROWTERMINATOR = '0x0a'
);
GO

BULK INSERT DeliveryAttempts
FROM '/var/opt/mssql/data/DeliveryAttempts.csv'
WITH 
(
	FIRSTROW = 2, 
	FIELDTERMINATOR = ',', 
	ROWTERMINATOR = '0x0a'
);
GO

BULK INSERT ProofOfDelivery
FROM '/var/opt/mssql/data/ProofOfDelivery.csv'
WITH 
(
	FIRSTROW = 2, 
	FIELDTERMINATOR = ',', 
	ROWTERMINATOR = '0x0a'
);
GO

-- ==============================================================================
-- 8. QUERIES TO ANSWER REQUESTED QUESTIONS
-- ==============================================================================
-- ==============================================================================
-- Q1) Shipment Master View
-- ==============================================================================

CREATE VIEW vw_ShipmentMaster AS
SELECT 
    S.ShipmentID, 
    S.TrackingNumber,
    Sender.Name AS SenderName, 
    Receiver.Name AS ReceiverName,
    OH.HubName AS OriginHub, 
    DH.HubName AS DestinationHub,
    S.CreatedDate, 
    SSL.StatusName AS CurrentStatus,
    ML.MaterialName AS MaterialShipped,
    S.DeclaredValue, 
    S.ShippingFee
FROM Shipments S
LEFT JOIN Customers Sender ON S.SenderID = Sender.CustomerID
LEFT JOIN Customers Receiver ON S.ReceiverID = Receiver.CustomerID
LEFT JOIN Hubs OH ON S.OriginHubID = OH.HubID
LEFT JOIN Hubs DH ON S.DestinationHubID = DH.HubID
LEFT JOIN ShipmentStatusLookup SSL ON S.StatusID = SSL.StatusID
LEFT JOIN MaterialLookup ML ON S.MaterialID = ML.MaterialID;
GO

-- And to Query the latest 50 shipments:
SELECT TOP 50 * FROM vw_ShipmentMaster 
ORDER BY CreatedDate DESC;
GO

-- ==============================================================================
-- Q2) Latest Tracking Status per Shipment
-- ==============================================================================

WITH RankedEvents AS 
(
    SELECT 
        S.TrackingNumber,
        TE.EventTime,
        TE.Status,
        H.HubName,
        ROW_NUMBER() OVER(PARTITION BY S.TrackingNumber ORDER BY TE.EventTime DESC) as rn
    FROM TrackingEvents TE
    JOIN Shipments S ON TE.ShipmentID = S.ShipmentID
    LEFT JOIN Hubs H ON TE.HubID = H.HubID
)
SELECT 
    TrackingNumber, 
    EventTime AS LatestEventTime, 
    Status AS LatestStatus, 
    HubName AS LatestHubName
FROM RankedEvents
WHERE rn = 1;
GO

-- ==============================================================================
-- Q3) Tracking Timeline View (Full History)
-- ==============================================================================

CREATE VIEW vw_ShipmentTimeline AS
SELECT 
    S.TrackingNumber, 
    TE.EventTime, 
    H.HubName, 
    TE.Status, 
    TE.EventDescription
FROM TrackingEvents TE
JOIN Shipments S ON TE.ShipmentID = S.ShipmentID
LEFT JOIN Hubs H ON TE.HubID = H.HubID;
GO

-- And to Query the history for a given (Example) Tracking Number ordered by EventTime
SELECT * FROM vw_ShipmentTimeline 
WHERE TrackingNumber = 'TRK-521468638'
ORDER BY EventTime;
GO

-- ==============================================================================
-- Q4) Hub Throughput by Day
-- ==============================================================================

SELECT 
    H.HubName,
    CAST(TE.EventTime AS DATE) AS Date,
    SUM(CASE WHEN TE.Status = 'Arrived' THEN 1 ELSE 0 END) AS ShipmentsArrivedCount,
    SUM(CASE WHEN TE.Status = 'Departed' THEN 1 ELSE 0 END) AS ShipmentsDepartedCount,
    COUNT(*) AS TotalScans
FROM TrackingEvents TE
JOIN Hubs H ON TE.HubID = H.HubID
WHERE TE.EventTime BETWEEN '2026-01-01' AND '2026-03-01' -- to Filter for a specific date range
GROUP BY H.HubName, CAST(TE.EventTime AS DATE);
GO

-- ==============================================================================
-- Q5) Delivery Success Rate by Courier
-- ==============================================================================

SELECT 
    C.CourierName,
    COUNT(*) AS TotalAttempts,
    SUM(CASE WHEN DA.IsSuccessful = 1 THEN 1 ELSE 0 END) AS SuccessfulDeliveries,
    SUM(CASE WHEN DA.IsSuccessful = 0 THEN 1 ELSE 0 END) AS FailedAttempts,
    CAST(SUM(CASE WHEN DA.IsSuccessful = 1 THEN 1.0 ELSE 0.0 END) / NULLIF(COUNT(*), 0) * 100 AS DECIMAL(5,2)) AS SuccessRate_Percent
FROM DeliveryAttempts DA
JOIN Couriers C ON DA.CourierID = C.CourierID
WHERE DA.AttemptTime >= DATEADD(MONTH, -3, GETDATE())
GROUP BY C.CourierName;
GO

-- ==============================================================================
-- Q6) Delivery Attempts Analysis (Reason Codes)
-- ==============================================================================

-- To Get Top 10 Failure Reasons
SELECT TOP 10
    F.FailureReason, 
    COUNT(DA.AttemptID) AS Count
FROM DeliveryAttempts DA
RIGHT JOIN FailureReasonLookup F ON DA.FailureReasonID = F.ReasonID 
                                 AND DA.IsSuccessful = 0
GROUP BY F.FailureReason
ORDER BY Count DESC;
GO

-- To Get Hub/City breakdown for the top 3 reasons
WITH TopReasons AS 
(
    SELECT TOP 3 DA.FailureReasonID
    FROM DeliveryAttempts DA
    WHERE DA.IsSuccessful = 0
    GROUP BY DA.FailureReasonID
    ORDER BY COUNT(*) DESC
)

SELECT 
    F.FailureReason,
    H.HubName,
    H.City,
    COUNT(*) AS BreakdownCount
FROM DeliveryAttempts DA
JOIN FailureReasonLookup F ON DA.FailureReasonID = F.ReasonID
JOIN Couriers C ON DA.CourierID = C.CourierID
JOIN Hubs H ON C.HubID = H.HubID
WHERE DA.FailureReasonID IN (SELECT FailureReasonID FROM TopReasons)
GROUP BY F.FailureReason, H.HubName, H.City
ORDER BY F.FailureReason, BreakdownCount DESC;
GO

-- ==============================================================================
-- Q7) Late Delivery Report
-- ==============================================================================

-- To List shipments delivered late
SELECT 
    S.TrackingNumber, 
    OH.HubName AS OriginHub, 
    DH.HubName AS DestinationHub,
    S.PromisedDeliveryDate, 
    S.DeliveredDate,
    DATEDIFF(DAY, S.PromisedDeliveryDate, S.DeliveredDate) AS DaysLate
FROM Shipments S
JOIN Hubs OH ON S.OriginHubID = OH.HubID
JOIN Hubs DH ON S.DestinationHubID = DH.HubID
WHERE S.DeliveredDate > S.PromisedDeliveryDate;
GO

-- Then To Compute late rate (%) by destination hub
SELECT 
    DH.HubName AS DestinationHub,
    COUNT(S.ShipmentID) AS TotalDelivered,
    CAST(SUM(CASE WHEN S.DeliveredDate > S.PromisedDeliveryDate THEN 1.0 ELSE 0.0 END) / NULLIF(COUNT(S.ShipmentID), 0) * 100 AS DECIMAL(5,2)) AS LateRate_Percent
FROM Shipments S
JOIN Hubs DH ON S.DestinationHubID = DH.HubID
WHERE S.DeliveredDate IS NOT NULL
GROUP BY DH.HubName;
GO

-- ==============================================================================
-- Q8) Stuck Shipments (No Movement)
-- ==============================================================================

WITH RankedEvents AS 
(
    SELECT 
        ShipmentID, 
        EventTime, 
        HubID,
        ROW_NUMBER() OVER(PARTITION BY ShipmentID ORDER BY EventTime DESC) as rn
    FROM TrackingEvents
)

SELECT 
    S.TrackingNumber, 
    SSL.StatusName AS CurrentStatus, 
    RE.EventTime AS LastEventTime, 
    H.HubName AS LastHub
FROM Shipments S
LEFT JOIN RankedEvents RE ON S.ShipmentID = RE.ShipmentID AND RE.rn = 1
LEFT JOIN Hubs H ON RE.HubID = H.HubID
JOIN ShipmentStatusLookup SSL ON S.StatusID = SSL.StatusID
WHERE SSL.StatusName NOT IN ('Delivered', 'Cancelled')
  AND RE.EventTime < DATEADD(HOUR, -48, GETDATE())
ORDER BY RE.EventTime ASC;
GO

-- ==============================================================================
-- Q9) Proof of Delivery (POD) Validation View
-- ==============================================================================

CREATE VIEW vw_PODValidation AS
SELECT 
    S.TrackingNumber,
    S.DeliveredDate,
    CASE WHEN P.PODID IS NOT NULL THEN 'Yes' ELSE 'No' END AS PODExists,
    P.PODType
FROM Shipments S
LEFT JOIN ProofOfDelivery P ON S.ShipmentID = P.ShipmentID
JOIN ShipmentStatusLookup SSL ON S.StatusID = SSL.StatusID
WHERE SSL.StatusName = 'Delivered';
GO

-- To List all delivered shipments missing Proof Of Delivery
SELECT * FROM vw_PODValidation 
WHERE PODExists = 'No';
GO

-- ==============================================================================
-- Q10) Billing & Revenue by Hub
-- ==============================================================================

CREATE VIEW vw_HubRevenueMonthly AS
SELECT 
    CONVERT(VARCHAR(7), S.CreatedDate, 126) AS YearMonth,  -- produces 'yyyy-MM'
    OH.HubName AS OriginHub,
    COUNT(S.ShipmentID) AS TotalShipments,
    SUM(S.ShippingFee) AS TotalShippingFees,
    AVG(S.ShippingFee) AS AvgFeePerShipment
FROM Shipments S
JOIN Hubs OH ON S.OriginHubID = OH.HubID
GROUP BY CONVERT(VARCHAR(7), S.CreatedDate, 126), OH.HubName;
GO

-- To Take a Look at the View Results
SELECT * FROM vw_HubRevenueMonthly 
ORDER BY YearMonth DESC;
GO

-- ==============================================================================
-- 9. DEMONSTRATING CRUD OPERATIONS (Proof of Concept)
-- ==============================================================================

-- 1. CREATE (Insert a new manual record)
INSERT INTO Customers (CustomerID, Name, Address, ContactInfo, CountryID, CustomerType)
VALUES (999999, 'Ahmed Hassan', '121 Nile Street, Cairo', '+201150291997', 3, 'B2C'); -- CountryID 3 is Egypt
GO

-- 2. READ (Select and view the inserted record)
SELECT * FROM Customers 
WHERE CustomerID = 999999;
Go

-- 3. UPDATE (Modify the existing record)
UPDATE Customers
SET CustomerType = 'B2B', Address = '456 Business Park, Cairo'
WHERE CustomerID = 999999;
Go

-- 4. DELETE (Remove the record)
DELETE FROM Customers
WHERE CustomerID = 999999;
GO
