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

ALTER TABLE [dbo].[Vorlesungen] DROP CONSTRAINT [fk_Vorlesungen_Professoren];
ALTER TABLE [dbo].[Prüfungen] DROP CONSTRAINT [fk_Prüfungen_Professoren];
ALTER TABLE [dbo].[Assistenten] DROP CONSTRAINT [fk_Assistenten_Professoren];


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

CREATE TABLE [dbo].[Studenten](
    [Matrikelnummer] [int] IDENTITY(1,1) NOT NULL,
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

INSERT [dbo].[Professor] ([Vorname], [Nachname], [Geburtsdatum], [Geburtsort], [Raum])
VALUES 
('Albert', 'Einstein', '1879-03-14', 'Ulm', '14'),
('Marie', 'Curie', '1867-11-07', 'Warschau', '12'),
('Peter', 'Von Matt', '1937-05-20', 'Luzern', '8'),
('Nikola', 'Tesla', '1856-07-10', 'Smiljan', '13'),
('Wilhelm Conrad', 'Röntgen', '1845-03-27', 'Lennep', '10'),
('Jean-Paul', 'Sartre', '1905-06-21', 'Paris', '1'),
('Jacobus', 'van t Hoff', '1852-08-30', 'Rotterdam', '3');

INSERT [dbo].[Vorlesungen] ([Titel], [ProfessorID], [VorgängerID])
VALUES 
(N'Ethik', 3, NULL),
(N'Elektrotechnik', 4, NULL),
(N'Sprachtheorie', 3, NULL),
(N'Radiologie', 5, 2),
(N'Allgemeine Relativitätstheorie', 1, NULL),
(N'Quantenphysik', 1, 4),
(N'Kinetik', 7, NULL),
(N'Literaturgeschichte', 3, NULL),
(N'Astrophysik', 1, NULL),
(N'Biochemie', 7, NULL),
(N'Physikalische Chemie', 2, NULL);
GO

SET IDENTITY_INSERT [dbo].[Studenten] ON;

INSERT INTO [dbo].[Studenten] ([Matrikelnummer], [Vorname], [Nachname], [Eintrittsdatum], [Wohnort])
VALUES 
('09-4845-0', 'Eliane', 'Burri', '2019-10-01', '3005 Bern'),
('12-5776-4', 'Guido', 'Duss', '2019-10-01', '4500 Solothurn'),
('09-7270-8', 'Gertrud', 'Zollinger', '2019-10-01', '3600 Thun'),
('08-5694-8', 'Giorgio', 'Antonelli', '2018-10-01', '6204 Sempach'),
('13-3963-7', 'Miguel', 'Sanchez', '2019-10-01', NULL),
('09-6537-7', 'Zoran', 'Stefanovski', '2019-10-01', '3000 Bern'),
('10-4336-3', 'Luis', 'Prieto', '2019-10-01', '4000 Basel'),
('13-4372-1', 'Martin', 'Isler', '2019-10-01', NULL),
('09-1079-4', 'Paolo', 'Di Lavello', '2019-10-01', '5400 Baden'),
('10-5068-5', 'Rolf', 'Meier', '2019-10-01', '5430 Wettingen'),
('09-9370-0', 'Marco', 'Maggi', '2019-10-01', '8918 Unterlunkhofen'),
('09-0523-5', 'Heike', 'Kurmann', '2019-10-01', '6280 Hochdorf'),
('09-9376-6', 'Lelzim', 'Krasniqi', '2019-10-01', '2905 Courtedoux'),
('14-0556-8', 'Jean-Paul', 'Léchenne', '2019-10-01', '4500 Solothurn'),
('09-0665-1', 'Roger', 'Détraz', '2017-10-01', '3215 Lurtigen'),
('11-8456-6', 'Hans', 'Dubach', '2018-10-01', '3000 Bern'),
('10-3201-8', 'Yvonne', 'Keller', '2019-10-01', NULL),
('12-0948-3', 'Priska', 'Weber', '2019-10-01', '4125 Riehen'),
('13-3225-2', 'Heidi', 'Dubuis', '2019-10-01', '6213 Knutwil'),
('13-5660-2', 'Slobodan', 'Stojanovic', '2019-10-01', '4132 Muttenz'),
('07-0633-6', 'Bruno', 'Zobrist', '2018-10-01', '5242 Birr'),
('10-1471-6', 'Slobodanka', 'Babaja', '2019-10-01', '4600 Olten'),
('10-2466-6', 'Roger', 'Gugler', '2018-10-01', '3400 Burgdorf'),
('13-3704-2', 'Marian', 'Genkinger', '2019-10-01', NULL),
('12-8867-9', 'Michele', 'Dell Amore', '2019-10-01', '4900 Langenthal');

SET IDENTITY_INSERT [dbo].[Studenten] OFF;

INSERT INTO [dbo].[Vorlesungsbesuche] ([Matrikelnummer], [VorlesungID])
VALUES 
('07-0633-6', (SELECT VorlesungID FROM Vorlesungen WHERE Titel = 'Physikalische Chemie')),
('09-0665-1', (SELECT VorlesungID FROM Vorlesungen WHERE Titel = 'Kinetik')),
('09-1079-4', (SELECT VorlesungID FROM Vorlesungen WHERE Titel = 'Biochemie')),
('09-4845-0', (SELECT VorlesungID FROM Vorlesungen WHERE Titel = 'Elektrotechnik')),
('09-4845-0', (SELECT VorlesungID FROM Vorlesungen WHERE Titel = 'Radiologie')),
('09-7270-8', (SELECT VorlesungID FROM Vorlesungen WHERE Titel = 'Biochemie')),
('09-9370-0', (SELECT VorlesungID FROM Vorlesungen WHERE Titel = 'Literaturgeschichte')),
('10-3201-8', (SELECT VorlesungID FROM Vorlesungen WHERE Titel = 'Kinetik')),
('08-5694-8', (SELECT VorlesungID FROM Vorlesungen WHERE Titel = 'Literaturgeschichte')),
('12-5776-4', (SELECT VorlesungID FROM Vorlesungen WHERE Titel = 'Elektrotechnik')),
('12-8867-9', (SELECT VorlesungID FROM Vorlesungen WHERE Titel = 'Ethik')),
('13-3704-2', (SELECT VorlesungID FROM Vorlesungen WHERE Titel = 'Ethik')),
('13-3704-2', (SELECT VorlesungID FROM Vorlesungen WHERE Titel = 'Literaturgeschichte')),
('13-3704-2', (SELECT VorlesungID FROM Vorlesungen WHERE Titel = 'Sprachtheorie')),
('13-3963-7', (SELECT VorlesungID FROM Vorlesungen WHERE Titel = 'Sprachtheorie')),
('13-3963-7', (SELECT VorlesungID FROM Vorlesungen WHERE Titel = 'Ethik')),
('13-3963-7', (SELECT VorlesungID FROM Vorlesungen WHERE Titel = 'Literaturgeschichte')),
('13-4372-1', (SELECT VorlesungID FROM Vorlesungen WHERE Titel = 'Kinetik')),
('13-5660-2', (SELECT VorlesungID FROM Vorlesungen WHERE Titel = 'Elektrotechnik')),
('13-5660-2', (SELECT VorlesungID FROM Vorlesungen WHERE Titel = 'Allgemeine Relativitätstheorie')),
('13-5660-2', (SELECT VorlesungID FROM Vorlesungen WHERE Titel = 'Kinetik')),
('14-0556-8', (SELECT VorlesungID FROM Vorlesungen WHERE Titel = 'Allgemeine Relativitätstheorie'));

INSERT INTO Assistenten (Vorname, Nachname, Geburtsdatum, ProfessorID)
VALUES
('Lionel', 'Messi', '1987-06-24', NULL),
('Xherdan', 'Shaqiri', '1991-10-10', 4),
('Sami', 'Khedira', '1987-04-04', 3),
('Cristiano', 'Ronaldo', '1985-02-05', 3),
('Wayne', 'Rooney', '1985-10-24', NULL),
('Arjen', 'Robben', '1984-01-23', 7),
('Andrea', 'Pirlo', '1979-05-19', 1),
('Robert', 'Lewandowski', '1988-08-21', 3),
('Luis', 'Suàrez', '1987-01-24', 5),
('Alexis', 'Sanchez', '1988-12-19', 2)

INSERT INTO [dbo].[Prüfungen] ([Matrikelnummer], [VorlesungID], [ProfessorID], [Prüfung_Termin], [Note])
VALUES 
('12-8867-9', (SELECT VorlesungID FROM Vorlesungen WHERE Titel = 'Ethik'), (SELECT ProfessorID FROM Professor WHERE Vorname = 'Jean-Paul' AND Nachname = 'Sartre'), NULL, NULL),
('13-5660-2', (SELECT VorlesungID FROM Vorlesungen WHERE Titel = 'Kinetik'), (SELECT ProfessorID FROM Professor WHERE Vorname = 'Jacobus' AND Nachname = 'van t Hoff'), NULL, NULL),
('09-4845-0', (SELECT VorlesungID FROM Vorlesungen WHERE Titel = 'Elektrotechnik'), (SELECT ProfessorID FROM Professor WHERE Vorname = 'Nikola' AND Nachname = 'Tesla'), '2020-10-25 00:00', 6.0),
('09-4845-0', (SELECT VorlesungID FROM Vorlesungen WHERE Titel = 'Radiologie'), (SELECT ProfessorID FROM Professor WHERE Vorname = 'Marie' AND Nachname = 'Curie'), NULL, NULL),
('09-9370-0', (SELECT VorlesungID FROM Vorlesungen WHERE Titel = 'Literaturgeschichte'), (SELECT ProfessorID FROM Professor WHERE Vorname = 'Peter' AND Nachname = 'Von Matt'), '2020-03-03 15:30', 4.0),
('09-0665-1', (SELECT VorlesungID FROM Vorlesungen WHERE Titel = 'Kinetik'), (SELECT ProfessorID FROM Professor WHERE Vorname = 'Jacobus' AND Nachname = 'van t Hoff'), '2020-05-28 10:00', 5.5),
('10-3201-8', (SELECT VorlesungID FROM Vorlesungen WHERE Titel = 'Kinetik'), (SELECT ProfessorID FROM Professor WHERE Vorname = 'Jacobus' AND Nachname = 'van t Hoff'), '2020-05-30 10:00', 2.5),
('08-5694-8', (SELECT VorlesungID FROM Vorlesungen WHERE Titel = 'Literaturgeschichte'), (SELECT ProfessorID FROM Professor WHERE Vorname = 'Peter' AND Nachname = 'Von Matt'), NULL, NULL),
('13-3963-7', (SELECT VorlesungID FROM Vorlesungen WHERE Titel = 'Literaturgeschichte'), (SELECT ProfessorID FROM Professor WHERE Vorname = 'Peter' AND Nachname = 'Von Matt'), '2021-05-27 09:00', 3.5),
('13-3963-7', (SELECT VorlesungID FROM Vorlesungen WHERE Titel = 'Sprachtheorie'), (SELECT ProfessorID FROM Professor WHERE Vorname = 'Peter' AND Nachname = 'Von Matt'), NULL, NULL),
('13-3704-2', (SELECT VorlesungID FROM Vorlesungen WHERE Titel = 'Sprachtheorie'), (SELECT ProfessorID FROM Professor WHERE Vorname = 'Peter' AND Nachname = 'Von Matt'), '2021-05-27 08:30', 5.0),
('13-3704-2', (SELECT VorlesungID FROM Vorlesungen WHERE Titel = 'Literaturgeschichte'), (SELECT ProfessorID FROM Professor WHERE Vorname = 'Peter' AND Nachname = 'Von Matt'), '2020-03-10 10:00', 4.5),
('12-5776-4', (SELECT VorlesungID FROM Vorlesungen WHERE Titel = 'Elektrotechnik'), (SELECT ProfessorID FROM Professor WHERE Vorname = 'Nikola' AND Nachname = 'Tesla'), '2021-05-26 10:00', 5.5),
('14-0556-8', (SELECT VorlesungID FROM Vorlesungen WHERE Titel = 'Allgemeine Relativitätstheorie'), (SELECT ProfessorID FROM Professor WHERE Vorname = 'Albert' AND Nachname = 'Einstein'), NULL, NULL),
('09-7270-8', (SELECT VorlesungID FROM Vorlesungen WHERE Titel = 'Biochemie'), (SELECT ProfessorID FROM Professor WHERE Vorname = 'Wilhelm Conrad' AND Nachname = 'Röntgen'), '2020-05-25 08:30', 4.5);

