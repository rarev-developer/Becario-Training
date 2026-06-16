# Entregable Dia 3 - SQL Server Basico
**Nombre:** Ricardo Arevalo

---

## Revision y Documentacion

1. NVARCHAR soporta Unicode, VARCHAR solo soporta ASCII

2. El soft delete te deja recuperar el dato si te equivocas,no rompe relaciones con otras tablas 

3. La integridad referencial garantiza que las relaciones entre tablas sean consistentes, evita datos huerfanos

4. DECIMAL es exacto, ideal para dinero porque no tiene errores de redondeo. FLOAT es aproximado y puede dar resultados raros 
---

## Script InventoryDB.sql

```sql
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'InventoryDB')
    DROP DATABASE InventoryDB;

CREATE DATABASE InventoryDB;
GO

USE InventoryDB;
GO

-- Tabla Categories
CREATE TABLE Categories (
    Id          INT IDENTITY(1,1) PRIMARY KEY,
    Name        NVARCHAR(100) NOT NULL,
    Description NVARCHAR(500) NULL,
    IsActive    BIT NOT NULL DEFAULT 1,
    CreatedAt   DATETIME2 NOT NULL DEFAULT GETDATE(),
    UpdatedAt   DATETIME2 NULL
);

-- Tabla Users
CREATE TABLE Users (
    Id           INT IDENTITY(1,1) PRIMARY KEY,
    Username     NVARCHAR(50) NOT NULL UNIQUE,
    Email        NVARCHAR(200) NOT NULL UNIQUE,
    PasswordHash NVARCHAR(500) NOT NULL,
    Role         NVARCHAR(20) NOT NULL DEFAULT 'User',
    IsActive     BIT NOT NULL DEFAULT 1,
    CreatedAt    DATETIME2 NOT NULL DEFAULT GETDATE(),
    UpdatedAt    DATETIME2 NULL
);

-- Tabla Products
CREATE TABLE Products (
    Id          INT IDENTITY(1,1) PRIMARY KEY,
    CategoryId  INT NOT NULL,
    Name        NVARCHAR(200) NOT NULL,
    Description NVARCHAR(1000) NULL,
    Price       DECIMAL(18, 2) NOT NULL CHECK (Price >= 0),
    Stock       INT NOT NULL DEFAULT 0 CHECK (Stock >= 0),
    MinStock    INT NOT NULL DEFAULT 5,
    IsActive    BIT NOT NULL DEFAULT 1,
    CreatedAt   DATETIME2 NOT NULL DEFAULT GETDATE(),
    UpdatedAt   DATETIME2 NULL,
    FOREIGN KEY (CategoryId) REFERENCES Categories(Id)
);
GO

-- 5 Categorias
INSERT INTO Categories (Name, Description) VALUES
('Electronicos',    'Dispositivos y equipos electronicos'),
('Computadoras',    'Laptops, desktops y accesorios'),
('Perifericos',     'Mouse, teclado, auriculares'),
('Almacenamiento',  'Discos duros, SSDs, memorias USB'),
('Networking',      'Routers, switches, cables de red');

-- 10 Productos
INSERT INTO Products (CategoryId, Name, Description, Price, Stock) VALUES
(2, 'Laptop Dell Inspiron 15', 'Core i5, 8GB RAM, 256GB SSD', 15000.00, 10),
(2, 'Laptop HP Pavilion',      'Core i7, 16GB RAM, 512GB SSD', 18500.00, 5),
(1, 'Monitor Samsung 24"',     'Full HD, IPS, 75Hz',           4500.00,  8),
(3, 'Mouse Logitech MX Master','Inalambrico, ergonomico',       1200.00, 25),
(3, 'Teclado Mecanico Redragon','RGB, switches red',            1500.00, 15),
(4, 'SSD Samsung 1TB',         'NVMe, PCIe 3.0',               2800.00, 20),
(4, 'Memoria USB Kingston 64GB','USB 3.0, 200MB/s lectura',      350.00, 50),
(5, 'Router TP-Link Archer C6','WiFi 5, doble banda',           1100.00, 12),
(1, 'Webcam Logitech C920',    'Full HD 1080p, microfono',      1800.00,  8),
(3, 'Auriculares Sony XM4',    'Cancelacion de ruido',          6500.00,  4);

-- 5 Usuarios
INSERT INTO Users (Username, Email, PasswordHash, Role) VALUES
('admin',    'admin@inventory.com',     'hash_admin_123',  'Admin'),
('jperez',   'juan.perez@emp.com',      'hash_juan_456',   'User'),
('mgarcia',  'maria.garcia@emp.com',    'hash_maria_789',  'User'),
('csanchez', 'carlos.sanchez@emp.com',  'hash_carlos_012', 'User'),
('alopez',   'ana.lopez@emp.com',       'hash_ana_345',    'Manager');
GO

-- Ejercicio 2: Consultas WHERE en Users
SELECT Id, Username, Email, Role FROM Users WHERE IsActive = 1;
SELECT Username, Email FROM Users WHERE Role = 'Admin';
SELECT * FROM Users WHERE Email = 'admin@inventory.com';

-- Ejercicio 3: Consultas en Products
SELECT Name, Price FROM Products WHERE Price BETWEEN 1000 AND 5000 ORDER BY Price;
SELECT Name, Price, Stock FROM Products WHERE CategoryId = 3 AND IsActive = 1;
SELECT Name, Stock FROM Products WHERE Stock < 5 ORDER BY Stock ASC;
SELECT TOP 5 Name, Price FROM Products ORDER BY Price DESC;

-- Ejercicio 4: UPDATE multiple
UPDATE Products
SET Price = Price * 1.10, UpdatedAt = GETDATE()
WHERE CategoryId = 1;

UPDATE Products
SET IsActive = 0, UpdatedAt = GETDATE()
WHERE Stock = 0;

-- Ejercicio 5: Transaccion
BEGIN TRANSACTION;
    UPDATE Products SET Stock = Stock - 1 WHERE Id = 1;
    IF (SELECT Stock FROM Products WHERE Id = 1) < 0
    BEGIN
        ROLLBACK TRANSACTION;
        PRINT 'Error: stock insuficiente';
    END
    ELSE
    BEGIN
        COMMIT TRANSACTION;
        PRINT 'Stock actualizado correctamente';
    END
```
