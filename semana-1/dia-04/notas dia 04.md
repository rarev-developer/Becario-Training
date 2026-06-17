## Revision y Documentacion

1. WHERE filtra filas individuales, HAVING filtra grupos despues de hacer el GROUP BY

2. Sirve para comparar filas de la misma tabla entre si, por ejemplo encontrar empleados que tienen el mismo jefe o productos de la misma categoria pero distinto id

3. LEFT JOIN cuando necesito ver TODOS los registros de la tabla principal aunque no tengan relacion en la otra tabla, INNER JOIN solo cuando me interesan los que si tienen coincidencia en ambas tablas

4. COUNT(*) cuenta todas las filas sin importar si hay valores NULL, COUNT(columna) solo cuenta las filas donde esa columna especifica no es NULL

## consultas-intermedias.sql

```sql
USE InventoryDB;
GO

CREATE TABLE InventoryMovements (
    Id            INT IDENTITY(1,1) PRIMARY KEY,
    ProductId     INT NOT NULL,
    UserId        INT NOT NULL,
    MovementType  NVARCHAR(3) NOT NULL CHECK (MovementType IN ('IN', 'OUT')),
    Quantity      INT NOT NULL CHECK (Quantity > 0),
    Notes         NVARCHAR(500) NULL,
    CreatedAt     DATETIME2 NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (ProductId) REFERENCES Products(Id),
    FOREIGN KEY (UserId) REFERENCES Users(Id)
);

INSERT INTO InventoryMovements (ProductId, UserId, MovementType, Quantity, Notes) VALUES
(1, 1, 'IN',  20, 'Compra inicial'),
(1, 2, 'OUT',  5, 'Venta a cliente A'),
(2, 1, 'IN',  10, 'Reposicion'),
(3, 3, 'OUT',  3, 'Venta online'),
(4, 2, 'IN',  30, 'Compra mayorista'),
(4, 2, 'OUT', 10, 'Venta a empresa B'),
(5, 1, 'IN',  15, 'Compra inicial');
GO

-- 1. JOIN: productos con su categoria
-- Muestra todos los productos activos junto con el nombre de su categoria
SELECT
    p.Id,
    p.Name AS ProductName,
    p.Price,
    p.Stock,
    c.Name AS CategoryName
FROM Products p
INNER JOIN Categories c ON p.CategoryId = c.Id
WHERE p.IsActive = 1
ORDER BY c.Name, p.Name;

-- 2. LEFT JOIN: categorias con conteo de productos, incluyendo las que no tienen
SELECT
    c.Name AS CategoryName,
    COUNT(p.Id) AS ProductCount
FROM Categories c
LEFT JOIN Products p ON c.Id = p.CategoryId AND p.IsActive = 1
GROUP BY c.Id, c.Name
ORDER BY ProductCount DESC;

-- 3. GROUP BY + funciones de agregacion: estadisticas por categoria
SELECT
    c.Name AS Category,
    COUNT(p.Id)  AS TotalProducts,
    SUM(p.Stock) AS TotalStock,
    AVG(p.Price) AS AvgPrice,
    MIN(p.Price) AS MinPrice,
    MAX(p.Price) AS MaxPrice
FROM Categories c
LEFT JOIN Products p ON c.Id = p.CategoryId AND p.IsActive = 1
GROUP BY c.Id, c.Name
ORDER BY TotalProducts DESC;

-- 4. GROUP BY + HAVING: categorias con mas de 2 productos activos
SELECT
    c.Name AS Category,
    COUNT(p.Id) AS ProductCount
FROM Categories c
INNER JOIN Products p ON c.Id = p.CategoryId
WHERE p.IsActive = 1
GROUP BY c.Id, c.Name
HAVING COUNT(p.Id) > 2
ORDER BY ProductCount DESC;

-- 5. JOIN triple: movimientos con nombre de producto y de usuario
SELECT
    m.Id,
    p.Name AS Product,
    u.Username AS User,
    m.MovementType AS Type,
    m.Quantity,
    m.CreatedAt
FROM InventoryMovements m
INNER JOIN Products p ON m.ProductId = p.Id
INNER JOIN Users u ON m.UserId = u.Id
ORDER BY m.CreatedAt DESC;

-- 6. GROUP BY + HAVING: productos con mas de 5 unidades vendidas
SELECT
    p.Name AS Product,
    SUM(m.Quantity) AS TotalSold
FROM InventoryMovements m
INNER JOIN Products p ON m.ProductId = p.Id
WHERE m.MovementType = 'OUT'
GROUP BY p.Id, p.Name
HAVING SUM(m.Quantity) > 5
ORDER BY TotalSold DESC;

-- 7. Valor total del inventario por categoria
SELECT
    c.Name AS Category,
    SUM(p.Price * p.Stock) AS InventoryValue
FROM Products p
INNER JOIN Categories c ON p.CategoryId = c.Id
WHERE p.IsActive = 1
GROUP BY c.Id, c.Name
ORDER BY InventoryValue DESC;

-- 8. Subconsulta: productos con precio mayor al promedio general
SELECT Name, Price
FROM Products
WHERE Price > (SELECT AVG(Price) FROM Products)
ORDER BY Price DESC;

-- 9. Usuarios que nunca han hecho movimientos (LEFT JOIN + IS NULL)
SELECT u.Username, u.Email, u.Role
FROM Users u
LEFT JOIN InventoryMovements m ON u.Id = m.UserId
WHERE m.Id IS NULL;


```
