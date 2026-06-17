IF EXISTS (SELECT name FROM sys.databases WHERE name = 'InventoryDB')
    DROP DATABASE InventoryDB;
GO

CREATE DATABASE InventoryDB;
GO

USE InventoryDB;
GO

-- TABLAS
CREATE TABLE Users (
    Id           INT IDENTITY(1,1) NOT NULL,
    Username     NVARCHAR(50) NOT NULL,
    Email        NVARCHAR(200) NOT NULL,
    PasswordHash NVARCHAR(500) NOT NULL,
    Role         NVARCHAR(20) NOT NULL CONSTRAINT DF_Users_Role DEFAULT 'User',
    IsActive     BIT NOT NULL CONSTRAINT DF_Users_IsActive DEFAULT 1,
    CreatedAt    DATETIME2 NOT NULL CONSTRAINT DF_Users_CreatedAt DEFAULT GETDATE(),
    UpdatedAt    DATETIME2 NULL,
    CONSTRAINT PK_Users PRIMARY KEY (Id),
    CONSTRAINT UQ_Users_Username UNIQUE (Username),
    CONSTRAINT UQ_Users_Email UNIQUE (Email),
    CONSTRAINT CK_Users_Role CHECK (Role IN ('Admin', 'Manager', 'User'))
);

CREATE TABLE Categories (
    Id          INT IDENTITY(1,1) NOT NULL,
    Name        NVARCHAR(100) NOT NULL,
    Description NVARCHAR(500) NULL,
    IsActive    BIT NOT NULL CONSTRAINT DF_Categories_IsActive DEFAULT 1,
    CreatedAt   DATETIME2 NOT NULL CONSTRAINT DF_Categories_CreatedAt DEFAULT GETDATE(),
    UpdatedAt   DATETIME2 NULL,
    CONSTRAINT PK_Categories PRIMARY KEY (Id)
);

CREATE TABLE Products (
    Id          INT IDENTITY(1,1) NOT NULL,
    CategoryId  INT NOT NULL,
    Name        NVARCHAR(200) NOT NULL,
    Description NVARCHAR(1000) NULL,
    Price       DECIMAL(18, 2) NOT NULL,
    Stock       INT NOT NULL CONSTRAINT DF_Products_Stock DEFAULT 0,
    MinStock    INT NOT NULL CONSTRAINT DF_Products_MinStock DEFAULT 5,
    IsActive    BIT NOT NULL CONSTRAINT DF_Products_IsActive DEFAULT 1,
    CreatedAt   DATETIME2 NOT NULL CONSTRAINT DF_Products_CreatedAt DEFAULT GETDATE(),
    UpdatedAt   DATETIME2 NULL,
    CONSTRAINT PK_Products PRIMARY KEY (Id),
    CONSTRAINT FK_Products_Categories FOREIGN KEY (CategoryId) REFERENCES Categories(Id),
    CONSTRAINT CK_Products_Price CHECK (Price >= 0),
    CONSTRAINT CK_Products_Stock CHECK (Stock >= 0)
);

CREATE TABLE InventoryMovements (
    Id            INT IDENTITY(1,1) NOT NULL,
    ProductId     INT NOT NULL,
    UserId        INT NOT NULL,
    MovementType  NVARCHAR(3) NOT NULL,
    Quantity      INT NOT NULL,
    PreviousStock INT NOT NULL,
    CurrentStock  INT NOT NULL,
    Notes         NVARCHAR(500) NULL,
    CreatedAt     DATETIME2 NOT NULL CONSTRAINT DF_InventoryMovements_CreatedAt DEFAULT GETDATE(),
    CONSTRAINT PK_InventoryMovements PRIMARY KEY (Id),
    CONSTRAINT FK_InventoryMovements_Products FOREIGN KEY (ProductId) REFERENCES Products(Id),
    CONSTRAINT FK_InventoryMovements_Users FOREIGN KEY (UserId) REFERENCES Users(Id),
    CONSTRAINT CK_MovementType CHECK (MovementType IN ('IN', 'OUT')),
    CONSTRAINT CK_Quantity CHECK (Quantity > 0)
);
GO

-- INDICES
CREATE INDEX IX_Products_CategoryId ON Products(CategoryId);
CREATE INDEX IX_Products_IsActive ON Products(IsActive);
CREATE INDEX IX_InventoryMovements_ProductId ON InventoryMovements(ProductId);
CREATE INDEX IX_InventoryMovements_UserId ON InventoryMovements(UserId);
GO

-- DATOS INICIALES
INSERT INTO Users (Username, Email, PasswordHash, Role) VALUES
('admin',    'admin@inventory.com',  'HASH_PLACEHOLDER', 'Admin'),
('manager1', 'manager@inventory.com','HASH_PLACEHOLDER', 'Manager'),
('user1',    'user1@inventory.com',  'HASH_PLACEHOLDER', 'User');

INSERT INTO Categories (Name, Description) VALUES
('Electronicos',   'Dispositivos y equipos electronicos en general'),
('Computadoras',   'Laptops, desktops y componentes'),
('Perifericos',    'Dispositivos de entrada/salida'),
('Almacenamiento', 'Discos, SSDs y memorias'),
('Networking',     'Equipos de red y conectividad');

INSERT INTO Products (CategoryId, Name, Description, Price, Stock, MinStock) VALUES
(2, 'Laptop Dell Inspiron 15', 'Core i5 11th, 8GB RAM, 256GB SSD', 15000.00, 10, 3),
(2, 'Laptop HP Pavilion 14',   'Core i7 12th, 16GB RAM, 512GB SSD', 18500.00, 5, 2),
(1, 'Monitor Samsung 24"',     'Full HD 1080p, IPS, 75Hz', 4500.00, 8, 2),
(3, 'Mouse Logitech MX Master 3', 'Inalambrico, 4000 DPI', 1200.00, 25, 5),
(3, 'Teclado Mecanico Redragon K552', 'RGB, switches red', 1500.00, 15, 5),
(4, 'SSD Samsung 870 EVO 1TB', 'SATA III, 560MB/s', 2800.00, 20, 5),
(4, 'Memoria USB Kingston 64GB', 'USB 3.0, 200MB/s', 350.00, 50, 10),
(5, 'Router TP-Link Archer C6', 'WiFi 5, AC1200, doble banda', 1100.00, 12, 3),
(1, 'Webcam Logitech C920', 'Full HD 1080p, autoenfoque', 1800.00, 8, 2),
(3, 'Auriculares Sony WH-1000XM4', 'ANC, 30h bateria', 6500.00, 4, 1);
GO