# Diagrama ER - Sistema de Biblioteca

```
+------------------+         +----------------------------+
|     AUTHORS      |         |          CATEGORIES         |
+------------------+         +----------------------------+
| Id (PK)          |         | Id (PK)                     |
| FirstName        |         | Name                         |
| LastName         |         | Description                  |
| Nationality       |         +-------------+----------------+
| BirthYear         |                       | 1
+--------+----------+                       |
         | N                                | N
         |                          +--------v---------+
         |                          |      BOOKS        |
         |                          +--------------------+
         |                          | Id (PK)            |
         |  N:M                     | Title              |
         +----------+               | ISBN               |
                     |               | PublishYear        |
            +--------v--------+      | Pages              |
            |  BOOK_AUTHORS    |      | CategoryId (FK)    +----+
            +-------------------+     | IsAvailable        |    |
            | BookId (FK)       +-----+--------------------+    |
            | AuthorId (FK)     |                                |
            +-------------------+                                |
                                                                  | N
                                                                  |
+------------------+                                    +--------v--------+
|     MEMBERS       |                                    |      LOANS       |
+--------------------+                                   +--------------------+
| Id (PK)            |                                    | Id (PK)            |
| Name               |          1                  N      | BookId (FK)        |
| Email              +----------------------------------->| MemberId (FK)      |
| Phone              |                                    | LoanDate           |
| MembershipDate     |                                    | DueDate            |
| IsActive           |                                    | ReturnDate         |
+--------------------+                                    | Status             |
                                                            +--------------------+
```

## Relaciones

- Authors N:M Books (resuelta con tabla intermedia BookAuthors) → un libro puede tener varios autores, un autor puede tener varios libros
- Categories 1:N Books → una categoria agrupa muchos libros
- Members 1:N Loans → un miembro puede tener varios prestamos
- Books 1:N Loans → un libro puede tener varios prestamos a lo largo del tiempo (no simultaneos si IsAvailable=0)
