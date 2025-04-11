CREATE TABLE Users (
                    UserID INTEGER PRIMARY KEY,
                    Name VARCHAR2(50) NOT NULL,
                    Email VARCHAR2(50) UNIQUE NOT NULL,
                    Phone VARCHAR2(15),
                    Role VARCHAR2(20) NOT NULL
                );

CREATE TABLE Category (
CategoryID INTEGER PRIMARY KEY,
CategoryName VARCHAR(20) UNIQUE NOT NULL,
);

CREATE TABLE Status (
StatusID INTEGER PRIMARY KEY,
StatusDescription VARCHAR(20) NOT NULL
);

CREATE TABLE BuildingInfo (
BuildingCode VARCHAR(4) PRIMARY KEY,
BuildingName VARCHAR(50) UNIQUE NOT NULL,
BuildingAddress VARCHAR(100) NOT NULL
);

CREATE TABLE LocationInfo (
LocationID INTEGER PRIMARY KEY,
BuildingCode VARCHAR(4) NOT NULL,
RoomNumber INTEGER NOT NULL,
FOREIGN KEY (BuildingCode) REFERENCES BuildingInfo(BuildingCode),
UNIQUE (BuildingCode, RoomNumber)
);

CREATE TABLE Item (
                    ItemID INTEGER PRIMARY KEY,
                    Description VARCHAR2(100) NOT NULL,
                    DateReported DATE NOT NULL,
                    CategoryID INTEGER NOT NULL,
                    StatusID INTEGER NOT NULL,
                    LocationID INTEGER NOT NULL,
                    FOREIGN KEY (CategoryID) REFERENCES Category(CategoryID) ON DELETE CASCADE,
                    FOREIGN KEY (StatusID) REFERENCES ItemStatus(StatusID),
                    FOREIGN KEY (LocationID) REFERENCES LocationInfo(LocationID)
                );

CREATE TABLE Report (
                    ReportID INTEGER PRIMARY KEY,
                    ReportType VARCHAR2(20) NOT NULL,
                    ReportDate DATE NOT NULL,
                    UserID INTEGER NOT NULL,
                    ItemID INTEGER NOT NULL,
                    FOREIGN KEY (UserID) REFERENCES Users(UserID),
                    FOREIGN KEY (ItemID) REFERENCES Item(ItemID) ON DELETE CASCADE
                );

CREATE TABLE Claim (
                    ClaimID INTEGER PRIMARY KEY,
                    UserID INTEGER NOT NULL,
                    ItemID INTEGER NOT NULL,
                    ClaimDate DATE NOT NULL,
                    FOREIGN KEY (UserID) REFERENCES Users(UserID),
                    FOREIGN KEY (ItemID) REFERENCES Item(ItemID)ON DELETE CASCADE,
                    UNIQUE (UserID, ItemID)
                );

CREATE TABLE Notification (
                    NotificationID INTEGER PRIMARY KEY,
                    UserID INTEGER NOT NULL,
                    ItemID INTEGER NOT NULL,
                    NotificationDate DATE NOT NULL,
                    FOREIGN KEY (UserID) REFERENCES Users(UserID),
                    FOREIGN KEY (ItemID) REFERENCES Item(ItemID)ON DELETE CASCADE,
                    UNIQUE (UserID, ItemID, NotificationDate)
                );


INSERT INTO ItemStatus (StatusID, StatusDescription) VALUES (ItemStatus_SEQ.NEXTVAL, :statusDescription)
                     RETURNING StatusID INTO :statusId;
INSERT INTO Category (CategoryID, CategoryName)
                     VALUES (Category_SEQ.NEXTVAL, :categoryName)
                     RETURNING CategoryID INTO :categoryId;

INSERT INTO BuildingInfo (BuildingCode, BuildingName, BuildingAddress)
                     VALUES (:code, :name, :address);

INSERT INTO LocationInfo (LocationID, BuildingCode, RoomNumber)
                     VALUES (LocationInfo_SEQ.NEXTVAL, :buildingCode, :roomNumber)
                     RETURNING LocationID INTO :locationId;
INSERT INTO Users (UserID, Name, Email, Phone, Role) VALUES (Users_SEQ.NEXTVAL, :name, :email, :phone, :role) RETURNING UserID INTO :userId;

SELECT CategoryID FROM Category WHERE CategoryID = :categoryId;

SELECT LocationID FROM LocationInfo WHERE LocationID = :locationId;

SELECT UserID FROM Users WHERE UserID = :userId;

SELECT StatusID FROM ItemStatus WHERE StatusDescription = 'Lost';

  INSERT INTO Item (ItemID, Description, DateReported, CategoryID, StatusID, LocationID)
             VALUES (Item_SEQ.NEXTVAL, :description, SYSDATE, :categoryId, :statusId, :locationId)
             RETURNING ItemID INTO :itemId;          
INSERT INTO Report (ReportID, ReportType, ReportDate, UserID, ItemID)
             VALUES (Report_SEQ.NEXTVAL, 'Lost', SYSDATE, :userId, :itemId);

SELECT StatusID FROM ItemStatus WHERE StatusDescription = 'Found';
INSERT INTO Item (ItemID, Description, DateReported, CategoryID, StatusID, LocationID)
             VALUES (Item_SEQ.NEXTVAL, :description, SYSDATE, :categoryId, :statusId, :locationId)
             RETURNING ItemID INTO :itemId;

INSERT INTO Report (ReportID, ReportType, ReportDate, UserID, ItemID)
             VALUES (Report_SEQ.NEXTVAL, 'Found', SYSDATE, :userId, :itemId);

SELECT i.ItemID, i.Description, i.DateReported, c.CategoryName, s.StatusDescription, li.LocationID
             FROM Item i
             JOIN ItemStatus s ON i.StatusID = s.StatusID
             JOIN Category c ON i.CategoryID = c.CategoryID
             JOIN LocationInfo li ON i.LocationID = li.LocationID
             WHERE s.StatusDescription = 'Lost';
 SELECT i.ItemID, i.Description, i.DateReported, c.CategoryName, s.StatusDescription, li.LocationID
             FROM Item i
             JOIN ItemStatus s ON i.StatusID = s.StatusID
             JOIN Category c ON i.CategoryID = c.CategoryID
             JOIN LocationInfo li ON i.LocationID = li.LocationID
             WHERE s.StatusDescription = 'Found';
INSERT INTO Claim (ClaimID, UserID, ItemID, ClaimDate)
             VALUES (Claim_SEQ.NEXTVAL, :userId, :itemId, SYSDATE)
             RETURNING ClaimID INTO :claimId;
 SELECT StatusID FROM ItemStatus WHERE StatusDescription = 'Claimed';

UPDATE Item SET StatusID = :statusId WHERE ItemID = :itemId;

SELECT NotificationID, ItemID, NotificationDate
             FROM Notification WHERE UserID = :userId;

  DELETE FROM Report WHERE UserID = :userId AND ItemID = :itemId;
 WITH ItemCounts AS (
                SELECT li.BuildingCode, c.CategoryID, COUNT(*) AS ItemCount
                FROM Item i
                JOIN LocationInfo li ON i.LocationID = li.LocationID
                JOIN Category c ON i.CategoryID = c.CategoryID
                JOIN ItemStatus s ON i.StatusID = s.StatusID
                WHERE s.StatusDescription = 'Lost'
                GROUP BY li.BuildingCode, c.CategoryID
            ), MaxCounts AS (
                SELECT BuildingCode, MAX(ItemCount) AS MaxCount
                FROM ItemCounts
                GROUP BY BuildingCode
            )
            SELECT bi.BuildingName, c.CategoryName, ic.ItemCount
            FROM ItemCounts ic
            JOIN MaxCounts mc ON ic.BuildingCode = mc.BuildingCode AND ic.ItemCount = mc.MaxCount
            JOIN BuildingInfo bi ON ic.BuildingCode = bi.BuildingCode
            JOIN Category c ON ic.CategoryID = c.CategoryID;

   SELECT u.UserID, u.Name
             FROM Users u
             WHERE NOT EXISTS (
                 SELECT c.CategoryID
                 FROM Category c
                 MINUS
                 SELECT DISTINCT i.CategoryID
                 FROM Item i
                 JOIN Report r ON i.ItemID = r.ItemID
                 WHERE r.UserID = u.UserID;
 SELECT c.ClaimID, c.UserID, u.Name AS UserName, c.ItemID, i.Description AS ItemDescription, c.ClaimDate
             FROM Claim c
             JOIN Users u ON c.UserID = u.UserID
             JOIN Item i ON c.ItemID = i.ItemID;
       