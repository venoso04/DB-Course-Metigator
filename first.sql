
CREATE DATABASE PMDB; 
GO

USE PMDB ; 
GO

CREATE SCHEMA PM; 
GO

CREATE TABLE PM.Companies
(
    CRNNO       int         primary key,
    CompanyName varchar(50) not null
)
GO

CREATE TABLE PM.Managers
(
    Id       int            not null ,
    Email varchar(100) not null, 
    PRIMARY KEY (Id)
)
GO

CREATE TABLE PM.Projects
(
    PRJNO       int            not null ,
    Title varchar(50) not null, 
    ManagerId int FOREIGN KEY REFERENCES PM.Managers(Id),
    InitialCost decimal(18,2) not null,
    StartDate datetime,
    Parked bit,
    CRNNO int not null, 
    FOREIGN KEY (CRNNO) REFERENCES PM.Companies(CRNNO),
    PRIMARY KEY (PRJNO )
)
GO

CREATE TABLE PM.Technology
(
    Id       int            not null ,
    Name varchar(100) not null, 
    PRIMARY KEY (Id)
)
GO

CREATE TABLE PM.ProjectTechnology
(
    PRJNO       int            not null FOREIGN KEY REFERENCES PM.Projects(PRJNO) ,
    TechnologyId int not null FOREIGN KEY REFERENCES PM.Technology(Id), 
    PRIMARY KEY (PRJNO, TechnologyId)
)
GO

ALTER TABLE PM.Managers
ADD CONSTRAINT UN_EMAIL UNIQUE(Email)
GO

ALTER TABLE PM.Projects
ADD CONSTRAINT DFT_PARKED 
DEFAULT 0 FOR Parked
GO

INSERT INTO PM.Companies (CRNNO , CompanyName) VALUES (101 , N'Company A');
INSERT INTO PM.Companies (CRNNO , CompanyName) VALUES (102 , N'Company B');
INSERT INTO PM.Companies (CRNNO , CompanyName) VALUES (103 , N'Company C');
INSERT INTO PM.Companies (CRNNO , CompanyName) VALUES (104 , N'Company D');
INSERT INTO PM.Companies VALUES (105 , N'Company E');
INSERT INTO PM.Companies VALUES 
(106 , N'Company F'),
(107 , N'Company G');

GO

-- Managers
INSERT INTO PM.Managers (Id, Email) VALUES 
(1, 'manager1@mail.com'),
(2, 'manager2@mail.com'),
(3, 'manager3@mail.com');
GO

-- Projects (make sure CRNNO values already exist in PM.Companies)
INSERT INTO PM.Projects (PRJNO, Title, ManagerId, InitialCost, StartDate, Parked, CRNNO) VALUES
(201, 'Project Alpha', 1, 10000.00, '2024-01-01', 0, 101),
(202, 'Project Beta', 2, 20000.00, '2024-02-01', 0, 101),
(203, 'Project Gamma', 3, 15000.00, '2024-03-01', 1, 103);
GO

-- Technology
INSERT INTO PM.Technology (Id, Name) VALUES
(1, 'Node.js'),
(2, 'PostgreSQL'),
(3, 'Redis');
GO

-- ProjectTechnology
INSERT INTO PM.ProjectTechnology (PRJNO, TechnologyId) VALUES
(201, 1),
(202, 2),
(203, 3);
GO



 -- SELECT , WHERE , Comparision & Logicals ops , like
SELECT * 
FROM PM.Projects
WHERE InitialCost >= 15000 AND Title like '%B%';
GO


-- TOP

SELECT TOP 2 * From PM.Projects

SELECT TOP 25 PERCENT * From PM.Projects


-- ORDER BY

SELECT * FROM PM.Projects ORDER BY InitialCost , StartDate DESC;


-- GROUP BY , Aggregate funcs , HAVING
USE PMDB;
SELECT ManagerId , COUNT(*) AS ProjectCount FROM PM.Projects WHERE Parked = 0 GROUP BY ManagerId HAVING COUNT(*) <= 1 ;

-- DISTINCT
SELECT DISTINCT Parked  FROM PM.Projects

-- INNER JOIN , Aliasing

SELECT P.PRJNO AS N'رقم المشروع' , P.Title , M.Email FROM PM.Projects AS P
INNER JOIN PM.Managers AS M 
ON P.ManagerId = M.Id 


--LEFT JOIN

SELECT P.PRJNO , P.Title , C.CompanyName FROM PM.Companies AS C 
LEFT JOIN PM.Projects AS P
ON P.CRNNO = C.CRNNO

-- Update
SELECT * FROM PM.Projects
SELECT * FROM PM.ProjectTechnology
SELECT * FROM PM.Technology
UPDATE PM.Projects
SET StartDate = '2022-07-10'
WHERE PRJNO = 203 ;


UPDATE PM.Projects SET InitialCost = InitialCost * 1.05
WHERE PRJNO IN (
    SELECT PRJNO FROM PM.ProjectTechnology WHERE  TechnologyId IN (
        SELECT Id FROM PM.Technology AS T WHERE T.Name = N'Redis'
    )
)
