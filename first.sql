
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

