# Diagrama ER - Sistema de Inventario

```
+------------------+         +-----------------------+
|      USERS       |         |      CATEGORIES        |
+------------------+         +-----------------------+
| Id (PK)          |         | Id (PK)                |
| Username         |         | Name                   |
| Email            |         | Description            |
| PasswordHash     |         | IsActive                |
| Role             |         | CreatedAt               |
| IsActive         |         | UpdatedAt               |
| CreatedAt        |         +-----------+-------------+
| UpdatedAt        |                     | 1
+--------+---------+                     |
         | 1                             | N
         |                     +---------v-------------+
         | N                   |       PRODUCTS         |
+--------v-----------------+   +------------------------+
|  INVENTORY_MOVEMENTS     |   | Id (PK)                |
+---------------------------+  | CategoryId (FK)        |
| Id (PK)                  |   | Name                   |
| ProductId (FK)           +---| Description             |
| UserId (FK)               |  | Price                  |
| MovementType (IN/OUT)     |  | Stock                  |
| Quantity                  |  | MinStock                |
| PreviousStock             |  | IsActive                |
| CurrentStock              |  | CreatedAt               |
| Notes                     |  | UpdatedAt               |
| CreatedAt                 |  +------------------------+
+---------------------------+
```

## Relaciones

- Categories 1:N Products → una categoria tiene muchos productos, un producto pertenece a una sola categoria
- Users 1:N InventoryMovements → un usuario hace muchos movimientos, un movimiento lo hace un solo usuario
- Products 1:N InventoryMovements → un producto tiene muchos movimientos, un movimiento es de un solo producto
