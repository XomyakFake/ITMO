DROP TABLE IF EXISTS MeetingStatus CASCADE;
DROP TABLE IF EXISTS MeetingRegistration CASCADE;
DROP TABLE IF EXISTS Meeting CASCADE;
DROP TABLE IF EXISTS Person CASCADE;
DROP TABLE IF EXISTS Location CASCADE;
DROP TABLE IF EXISTS Street CASCADE;
DROP TABLE IF EXISTS City CASCADE;
DROP TABLE IF EXISTS Capital CASCADE;
DROP TABLE IF EXISTS Country CASCADE;

CREATE TABLE Country (ID INT PRIMARY KEY, Name VARCHAR(50) NOT NULL, Population INT CHECK (Population >= 0), Continent VARCHAR(50) NOT NULL);

CREATE TABLE Capital (ID INT PRIMARY KEY, Name VARCHAR(50) NOT NULL, Population INT CHECK (Population >= 0), CountryID INT UNIQUE NOT NULL REFERENCES Country(ID));

CREATE TABLE City (ID INT PRIMARY KEY, Name VARCHAR(50) NOT NULL,Population INT CHECK (Population >= 0), IsCapital BOOLEAN DEFAULT FALSE , CountryID INT NOT NULL REFERENCES Country(ID));

CREATE TABLE Street (ID INT PRIMARY KEY, Name VARCHAR(50) NOT NULL, PostalCode VARCHAR(20), CityID INT NOT NULL REFERENCES City(ID));

CREATE TABLE Location (ID INT PRIMARY KEY, Name VARCHAR(50) NOT NULL, Type VARCHAR(50) NOT NULL, Coordinates VARCHAR(100), StreetID INT REFERENCES Street(ID));

CREATE TABLE Person (ID INT PRIMARY KEY,Name VARCHAR(20) NOT NULL, Gender VARCHAR(1) CHECK IN ('M', 'F'), Emotion VARCHAR(50), LocationID INT NOT NULL REFERENCES Location(ID));

CREATE TABLE Meeting (ID INT PRIMARY KEY, LocationID INT NOT NULL REFERENCES Location(ID), Purpose TEXT, StartTime TIMESTAMP NOT NULL, EndTime TIMESTAMP CHECK (EndTime >= StartTime));

CREATE TABLE MeetingRegistration (PersonID INT NOT NULL REFERENCES Person(ID), MeetingID INT NOT NULL REFERENCES Meeting(ID), PlannedTime TIMESTAMP, Role VARCHAR(50), PRIMARY KEY (PersonID, MeetingID));

CREATE TABLE MeetingStatus (ID INT PRIMARY KEY, MeetingID INT NOT NULL REFERENCES Meeting(ID), Status NOT NULL VARCHAR(50), ChangeDate TIMESTAMP NOT NULL);


INSERT INTO Country (Id, Name, Population, Continent) VALUES (1, 'Россия', 140000000, 'Европа');

INSERT INTO Capital (Id, Name, Population, CountryID) VALUES (1, 'Москва', 12000000, 1);

INSERT INTO City (Id, Name, Population, IsCapital, CountryID) VALUES (1, 'Сургут', 400000, FALSE, 1);

INSERT INTO Street (Id, Name, PostalCode, CityID) VALUES (1, 'Центральный тротуар', '000001', 1);

INSERT INTO Location (Id, Name, Type, StreetID) VALUES (1, 'Место встречи на краю города', 'Открытое пространство', 1);

INSERT INTO Person (Id, Name, Gender, Emotion, LocationID) VALUES (1, 'Олвин', 'M', 'Нетерпеливый', 1), (2, 'Хедрон', 'M', 'Спокойный', 1), (3, 'Шут', 'M', 'Веселый', 1);

INSERT INTO Meeting (Id, LocationID, Purpose, StartTime, EndTime) VALUES (1, 1, 'Личная встреча и приветствие', '2026-03-02 10:00:00', '2026-03-02 10:30:00');

INSERT INTO MeetingRegistration (PersonID, MeetingID, PlannedTime, Role) VALUES (1, 1, '2026-03-02 09:50:00', 'Участник'), (2, 1, '2026-03-02 10:00:00', 'Участник'), (3, 1, '2026-03-02 10:00:00', 'Организатор');

INSERT INTO MeetingStatus (Id, MeetingID, Status, ChangeDate) VALUES (1, 1, 'Запланирована', '2026-03-01 12:00:00'), (2, 1, 'Проведена', '2026-03-02 10:30:00');
