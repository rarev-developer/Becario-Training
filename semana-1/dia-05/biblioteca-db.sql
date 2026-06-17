IF EXISTS (SELECT name FROM sys.databases WHERE name = 'BibliotecaDB')
    DROP DATABASE BibliotecaDB;
GO

CREATE DATABASE BibliotecaDB;
GO

USE BibliotecaDB;
GO

CREATE TABLE Categories (
    Id          INT IDENTITY(1,1) NOT NULL,
    Name        NVARCHAR(100) NOT NULL,
    Description NVARCHAR(500) NULL,
    CONSTRAINT PK_Categories PRIMARY KEY (Id)
);

CREATE TABLE Authors (
    Id          INT IDENTITY(1,1) NOT NULL,
    FirstName   NVARCHAR(100) NOT NULL,
    LastName    NVARCHAR(100) NOT NULL,
    Nationality NVARCHAR(100) NULL,
    BirthYear   INT NULL,
    CONSTRAINT PK_Authors PRIMARY KEY (Id)
);

CREATE TABLE Books (
    Id          INT IDENTITY(1,1) NOT NULL,
    Title       NVARCHAR(300) NOT NULL,
    ISBN        NVARCHAR(20) NOT NULL,
    PublishYear INT NULL,
    Pages       INT NULL,
    CategoryId  INT NOT NULL,
    IsAvailable BIT NOT NULL CONSTRAINT DF_Books_IsAvailable DEFAULT 1,
    CONSTRAINT PK_Books PRIMARY KEY (Id),
    CONSTRAINT UQ_Books_ISBN UNIQUE (ISBN),
    CONSTRAINT FK_Books_Categories FOREIGN KEY (CategoryId) REFERENCES Categories(Id)
);

CREATE TABLE BookAuthors (
    BookId   INT NOT NULL,
    AuthorId INT NOT NULL,
    CONSTRAINT PK_BookAuthors PRIMARY KEY (BookId, AuthorId),
    CONSTRAINT FK_BookAuthors_Books FOREIGN KEY (BookId) REFERENCES Books(Id),
    CONSTRAINT FK_BookAuthors_Authors FOREIGN KEY (AuthorId) REFERENCES Authors(Id)
);

CREATE TABLE Members (
    Id             INT IDENTITY(1,1) NOT NULL,
    Name           NVARCHAR(200) NOT NULL,
    Email          NVARCHAR(200) NOT NULL,
    Phone          NVARCHAR(20) NULL,
    MembershipDate DATETIME2 NOT NULL CONSTRAINT DF_Members_MembershipDate DEFAULT GETDATE(),
    IsActive       BIT NOT NULL CONSTRAINT DF_Members_IsActive DEFAULT 1,
    CONSTRAINT PK_Members PRIMARY KEY (Id),
    CONSTRAINT UQ_Members_Email UNIQUE (Email)
);

CREATE TABLE Loans (
    Id         INT IDENTITY(1,1) NOT NULL,
    BookId     INT NOT NULL,
    MemberId   INT NOT NULL,
    LoanDate   DATETIME2 NOT NULL CONSTRAINT DF_Loans_LoanDate DEFAULT GETDATE(),
    DueDate    DATETIME2 NOT NULL,
    ReturnDate DATETIME2 NULL,
    Status     NVARCHAR(20) NOT NULL CONSTRAINT DF_Loans_Status DEFAULT 'Active',
    CONSTRAINT PK_Loans PRIMARY KEY (Id),
    CONSTRAINT FK_Loans_Books FOREIGN KEY (BookId) REFERENCES Books(Id),
    CONSTRAINT FK_Loans_Members FOREIGN KEY (MemberId) REFERENCES Members(Id),
    CONSTRAINT CK_Loans_Status CHECK (Status IN ('Active', 'Returned', 'Overdue'))
);
GO

CREATE INDEX IX_Books_CategoryId ON Books(CategoryId);
CREATE INDEX IX_Loans_BookId ON Loans(BookId);
CREATE INDEX IX_Loans_MemberId ON Loans(MemberId);
GO

INSERT INTO Categories (Name, Description) VALUES
('Ficcion', 'Novelas y cuentos de ficcion'),
('Ciencia', 'Libros de divulgacion cientifica'),
('Historia', 'Libros sobre eventos historicos');

INSERT INTO Authors (FirstName, LastName, Nationality, BirthYear) VALUES
('Gabriel', 'Garcia Marquez', 'Colombiana', 1927),
('Isaac', 'Asimov', 'Estadounidense', 1920),
('Yuval Noah', 'Harari', 'Israeli', 1976);

INSERT INTO Books (Title, ISBN, PublishYear, Pages, CategoryId, IsAvailable) VALUES
('Cien Anios de Soledad', '978-0307474728', 1967, 417, 1, 1),
('Fundacion', '978-0553293357', 1951, 255, 2, 1),
('Sapiens', '978-0062316097', 2011, 443, 3, 1);

INSERT INTO BookAuthors (BookId, AuthorId) VALUES
(1, 1), 
(2, 2),  
(3, 3); 

INSERT INTO Members (Name, Email, Phone) VALUES
('Ricardo Arevalo', 'ricardo@example.com', '3312345678'),
('Maria Lopez', 'maria@example.com', '3398765432');

INSERT INTO Loans (BookId, MemberId, LoanDate, DueDate, Status) VALUES
(1, 1, GETDATE(), DATEADD(DAY, 14, GETDATE()), 'Active'),
(2, 2, GETDATE(), DATEADD(DAY, 14, GETDATE()), 'Active');

UPDATE Books SET IsAvailable = 0 WHERE Id IN (1, 2);
GO
