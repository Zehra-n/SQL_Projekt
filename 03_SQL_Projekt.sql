
USE [Projekt]
GO

--1In welchem Raum arbeitet der Professor Peter Von Matt?  
SELECT Raum AS Raum_PeterVonMatt FROM Professor WHERE Vorname = 'Peter' AND Nachname = 'Von Matt';

--2Wie viele Studenten haben ihr Studium vor dem 1.1.2019 begonnen?    
SELECT COUNT(*) AS Studenten_Vor2019 FROM Studenten WHERE Eintrittsdatum < '2019-01-01';

--3Wie viele Assistenten haben keinen Chef (d.h. arbeiten für keinen Professor)?   
SELECT COUNT(*) AS Keinen_Chef FROM Assistenten WHERE ProfessorID IS NULL;

--4Wie heissen die Assistenten, die an zweiter Stelle ihres Vornamens den Buchstaben "r" haben?
SELECT Vorname, Nachname FROM Assistenten WHERE Vorname LIKE '_r%';

--5Wie alt ist der älteste Assistent? Geburtsdatum reicht. 
SELECT MIN(Geburtsdatum) AS Aelteste_Assistent FROM Assistenten;

--6Zähle die Studenten, deren Matrikel-Nr. mit der Zeichenfolge "13-" beginnt. 
SELECT COUNT(*) AS MatrikelNr_13 FROM Studenten Where Matrikelnummer LIKE '13_%';

--7Gib Vorname und Nachname aller Studenten aus, in deren Vornamen mindestens einmal der Buchstabe "a" vorkommt. Sortiere die Ausgabe nach Nachnamen absteigend. 
SELECT Vorname, Nachname FROM Studenten WHERE Vorname LIKE '%a%' ORDER BY Nachname DESC;

--8Für wie viele Prüfungen steht bereits eine Note fest? 
SELECT COUNT(*) AS Noten_Fest FROM Prüfungen WHERE Note IS NOT NULL;

--9Wie viele Studenten sind für die Vorlesung "Kinetik" eingeschrieben? 
SELECT COUNT(*) AS Studenten_Kinetik FROM Vorlesungsbesuche WHERE VorlesungID = (SELECT VorlesungID FROM Vorlesungen WHERE Titel = 'Kinetik');

--10Wie heissen die Studenten (Vor- und Nachname), die mindestens 3 Vorlesungen  besuchen? 
SELECT Vorname, Nachname FROM Studenten WHERE Matrikelnummer IN (SELECT Matrikelnummer FROM Vorlesungsbesuche GROUP BY Matrikelnummer HAVING COUNT(*) >= 3);

--11Wie viele Prüfungen nimmt der Professor Jacobus van 't Hoff ab?  
SELECT COUNT(*) FROM Prüfungen WHERE ProfessorID = (SELECT ProfessorID FROM Professor WHERE Vorname = 'Jacobus' AND Nachname = 'van t Hoff');

--12Wie oft wurde an Prüfungen die Note 5.5 vergeben? 
SELECT COUNT(*) FROM Prüfungen WHERE Note= 5.5;

--13Wie viele Studenten wohnen in Bern oder in Basel? 
SELECT COUNT(*) FROM Studenten WHERE Wohnort LIKE '%Bern%' OR Wohnort LIKE '%Basel%';

--14Bei wie vielen Studenten ist der Wohnort nicht bekannt? 
SELECT COUNT(*) FROM Studenten WHERE Wohnort IS NULL;

--15Wie heisst der älteste Assistent mit Vorna18men? 
SELECT TOP 1 Vorname, Nachname, Geburtsdatum FROM Assistenten ORDER BY Geburtsdatum ASC;

--16Was ist die Durchschnittsnote aller Prüfungen, die der Student mit der Matrikel-Nummer 13-3704-2 geschrieben hat?
SELECT AVG(Note) AS Durchschnittsnote FROM Prüfungen WHERE Matrikelnummer = '13-3704-2';

--Bonus Auswertungen

--Bonus1
SELECT v1.Vorlesung AS Vorgänger, v2.Vorlesung AS Nachfolger
FROM Voraussetzungen vor
INNER JOIN Vorlesungen v1 ON vor.VoraussetzungID = v1.VorlesungID
INNER JOIN Vorlesungen v2 ON vor.VorlesungID = v2.VorlesungID
WHERE (v2.Vorlesung = 'Radiologie' AND v1.Vorlesung = 'Elektrotechnik')
   OR (v2.Vorlesung = 'Quantenphysik' AND v1.Vorlesung = 'Radiologie');

--Bonus2
SELECT Vorname, Nachname, Geburtsdatum,
       CASE 
           WHEN ProfessorID IS NOT NULL THEN 'Hat einen Chef'
           ELSE 'Hat keinen Chef'
       END AS Chef_Status
FROM Assistenten
WHERE Geburtsdatum = (SELECT MIN(Geburtsdatum) FROM Assistenten);
