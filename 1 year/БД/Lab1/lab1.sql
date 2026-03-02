DROP TABLE IF EXISTS MeetingStatus CASCADE;
DROP TABLE IF EXISTS MeetingRegistration CASCADE;
DROP TABLE IF EXISTS Meeting CASCADE;
DROP TABLE IF EXISTS Person CASCADE;
DROP TABLE IF EXISTS Location CASCADE;
DROP TABLE IF EXISTS Street CASCADE;
DROP TABLE IF EXISTS City CASCADE;
DROP TABLE IF EXISTS Capital CASCADE;
DROP TABLE IF EXISTS Country CASCADE;

CREATE TABLE Country (ID INT PRIMARY KEY,Name VARCHAR(100) NOT NULL,Population INT,Continent VARCHAR(100));
CREATE TABLE Capital (ID INT PRIMARY KEY,Name VARCHAR(100),Population INT,CountryID INT UNIQUE REFERENCES Country(ID));
CREATE TABLE City (ID INT PRIMARY KEY,Name VARCHAR(100),Population INT,IsCapital BOOLEAN,CountryID INT REFERENCES Country(ID));
CREATE TABLE Street (ID INT PRIMARY KEY,Name VARCHAR(100),PostalCode VARCHAR(20),CityID INT REFERENCES City(ID));
CREATE TABLE Location (ID INT PRIMARY KEY,Name VARCHAR(100),Type VARCHAR(50),Coordinates VARCHAR(100),StreetID INT REFERENCES Street(ID));
CREATE TABLE Person (ID INT PRIMARY KEY,Name VARCHAR(100),Gender VARCHAR(10),Emotion VARCHAR(100),LocationID INT REFERENCES Location(ID));
CREATE TABLE Meeting (ID INT PRIMARY KEY,LocationID INT REFERENCES Location(ID),Purpose TEXT,StartTime TIMESTAMP,EndTime TIMESTAMP);
CREATE TABLE MeetingRegistration (PersonID INT REFERENCES Person(ID),MeetingID INT REFERENCES Meeting(ID),PlannedTime TIMESTAMP,Role VARCHAR(50),PRIMARY KEY (PersonID, MeetingID));
CREATE TABLE MeetingStatus (ID INT PRIMARY KEY,MeetingID INT REFERENCES Meeting(ID),Status VARCHAR(50),ChangeDate TIMESTAMP);

INSERT INTO Country (Id, Name, Population, Continent)
VALUES (1, 'Диаспар', 5000000, 'Неизвестный');

INSERT INTO Capital (Id, Name, Population, CountryID)
VALUES (1, 'Диаспар', 5000000, 1);

INSERT INTO City (Id, Name, Population, IsCapital, CountryID)
VALUES (1, 'Диаспар', 5000000, TRUE, 1);

INSERT INTO Street (Id, Name, PostalCode, CityID)
VALUES (1, 'Центральный тротуар', '000001', 1);

INSERT INTO Location (Id, Name, Type, StreetID)
VALUES (1, 'Место встречи на краю города', 'Открытое пространство', 1);

INSERT INTO Person (Id, Name, Gender, Emotions, LocationID)
VALUES 
(1, 'Олвин', 'M', 'Нетерпеливый', 1),
(2, 'Хедрон', 'M', 'Спокойный', 1),
(3, 'Шут', 'M', 'Реален', 1);

INSERT INTO Meeting (Id, LocationID, Purpose, StartTime, EndTime)
VALUES (1, 1, 'Личная встреча и приветствие', 
        '2026-03-02 10:00:00', 
        '2026-03-02 10:30:00');

INSERT INTO MeetingRegistration (PersonID, MeetingID, PlannedArrival, Role)
VALUES
(1, 1, '2026-03-02 09:50:00', 'Участник'),
(2, 1, '2026-03-02 10:00:00', 'Участник'),
(3, 1, '2026-03-02 10:00:00', 'Участник');

INSERT INTO MeetingStatus (Id, MeetingID, Status, ChangeDate)
VALUES
(1, 1, 'Запланирована', '2026-03-01 12:00:00'),
(2, 1, 'Проведена', '2026-03-02 10:30:00');
