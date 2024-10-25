USE [Projekt]
GO

CREATE DATABASE [Projekt]
GO

CREATE TABLE [dbo].[Professor](
    [ProfessorID] [int] IDENTITY(1,1) NOT NULL,
    [Vorname] [varchar](50) NOT NULL,
    [Nachname] [varchar](50) NOT NULL,
    [Geburtsdatum] [date] NOT NULL,
    [Raum] [varchar](10) NOT NULL,
    [Geburtsort] [varchar](50) NOT NULL,
    CONSTRAINT [pk_Professoren] PRIMARY KEY CLUSTERED ([ProfessorID]),
    CONSTRAINT [uk_Raum] UNIQUE ([Raum])
);

CREATE TABLE [dbo].[Vorlesungen](
    [VorlesungID] [int] IDENTITY(1,1) NOT NULL,
    [Titel] [varchar](100) NOT NULL,
    [ProfessorID] [int] NOT NULL,
    [VorgängerID] [int] NULL,
    CONSTRAINT [pk_Vorlesungen] PRIMARY KEY CLUSTERED ([VorlesungID]),
    CONSTRAINT [fk_Vorlesungen_Professoren] FOREIGN KEY ([ProfessorID]) REFERENCES [dbo].[Professor]([ProfessorID]),
    CONSTRAINT [fk_VorgängerID] FOREIGN KEY ([VorgängerID]) REFERENCES [dbo].[Vorlesungen]([VorlesungID])
);

CREATE TABLE [dbo].[Studenten](
    [Matrikelnummer] [varchar](10) NOT NULL,
    [Vorname] [varchar](50) NOT NULL,
    [Nachname] [varchar](50) NOT NULL,
    [Eintrittsdatum] [date] NOT NULL,
    [Wohnort] [varchar](50) NULL,
    CONSTRAINT [pk_Studenten] PRIMARY KEY CLUSTERED ([Matrikelnummer])
);


CREATE TABLE Assistenten(
    AssistentenID INT IDENTITY(1,1),
    Vorname VARCHAR(100) NOT NULL,
    Nachname VARCHAR(100) NOT NULL,
    Geburtsdatum DATE NOT NULL,
    ProfessorID INT,
    CONSTRAINT pk_Assistenten PRIMARY KEY (AssistentenID)
);

CREATE TABLE [dbo].[Prüfungen](
    [PrüfungID] [int] IDENTITY(1,1) NOT NULL,
    [Matrikelnummer] [varchar](10) NOT NULL,
    [VorlesungID] [int] NOT NULL,
    [ProfessorID] [int] NOT NULL,
    [Prüfung_Termin] [datetime] NULL,
    [Note] [decimal](2,1) NULL CHECK ([Note] BETWEEN 1.0 AND 6.0),
    CONSTRAINT [pk_Prüfungen] PRIMARY KEY CLUSTERED ([PrüfungID]),
    CONSTRAINT [fk_Prüfungen_Studenten] FOREIGN KEY ([Matrikelnummer]) REFERENCES [dbo].[Studenten]([Matrikelnummer]),
    CONSTRAINT [fk_Prüfungen_Vorlesungen] FOREIGN KEY ([VorlesungID]) REFERENCES [dbo].[Vorlesungen]([VorlesungID]),
    CONSTRAINT [fk_Prüfungen_Professoren] FOREIGN KEY ([ProfessorID]) REFERENCES [dbo].[Professor]([ProfessorID])
);


CREATE TABLE [dbo].[Voraussetzungen](
    [VorlesungID] [int] NOT NULL,
    [VoraussetzungID] [int] NOT NULL,
    CONSTRAINT [pk_Voraussetzungen] PRIMARY KEY ([VorlesungID], [VoraussetzungID]),
    CONSTRAINT [fk_Voraussetzungen_Vorlesungen1] FOREIGN KEY ([VorlesungID]) REFERENCES [dbo].[Vorlesungen]([VorlesungID]),
    CONSTRAINT [fk_Voraussetzungen_Vorlesungen2] FOREIGN KEY ([VoraussetzungID]) REFERENCES [dbo].[Vorlesungen]([VorlesungID])
);

CREATE TABLE [dbo].[Vorlesungsbesuche](
    [Matrikelnummer] [varchar](10) NOT NULL,
    [VorlesungID] [int] NOT NULL,
    CONSTRAINT [fk_Vorlesungsbesuche_Studenten] FOREIGN KEY ([Matrikelnummer]) REFERENCES [dbo].[Studenten]([Matrikelnummer]),
    CONSTRAINT [fk_Vorlesungsbesuche_Vorlesungen] FOREIGN KEY ([VorlesungID]) REFERENCES [dbo].[Vorlesungen]([VorlesungID])
);
