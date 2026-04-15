DROP TABLE IF EXISTS MeetingStatus CASCADE;
DROP TABLE IF EXISTS MeetingRegistration CASCADE;
DROP TABLE IF EXISTS Meeting CASCADE;
DROP TABLE IF EXISTS Person CASCADE;
DROP TABLE IF EXISTS Location CASCADE;
DROP TABLE IF EXISTS Street CASCADE;
DROP TABLE IF EXISTS City CASCADE;
DROP TABLE IF EXISTS Capital CASCADE;
DROP TABLE IF EXISTS Country CASCADE;

CREATE TABLE Country (ID SERIAL PRIMARY KEY, Name VARCHAR(50) NOT NULL, Population INT CHECK (Population >= 0), Continent VARCHAR(50) NOT NULL);

CREATE TABLE Capital (ID SERIAL PRIMARY KEY, Name VARCHAR(50) NOT NULL, Population INT CHECK (Population >= 0), CountryID INT UNIQUE NOT NULL REFERENCES Country(ID));

CREATE TABLE City (ID SERIAL PRIMARY KEY, Name VARCHAR(50) NOT NULL,Population INT CHECK (Population >= 0), IsCapital BOOLEAN DEFAULT FALSE , CountryID INT NOT NULL REFERENCES Country(ID));

CREATE TABLE Street (ID SERIAL PRIMARY KEY, Name VARCHAR(50) NOT NULL, PostalCode VARCHAR(20), CityID INT NOT NULL REFERENCES City(ID));

CREATE TABLE Location (ID SERIAL PRIMARY KEY, Name VARCHAR(50) NOT NULL, Type VARCHAR(50) NOT NULL, Coordinates VARCHAR(100), StreetID INT REFERENCES Street(ID));

CREATE TABLE Person (ID SERIAL PRIMARY KEY,Name VARCHAR(20) NOT NULL, Gender VARCHAR(1) CHECK (Gender IN ('M', 'F')), Emotion VARCHAR(50), LocationID INT NOT NULL REFERENCES Location(ID));

CREATE TABLE Meeting (ID SERIAL PRIMARY KEY, LocationID INT NOT NULL REFERENCES Location(ID), Purpose TEXT, StartTime TIMESTAMP NOT NULL, EndTime TIMESTAMP CHECK (EndTime >= StartTime));

CREATE TABLE MeetingRegistration (PersonID INT NOT NULL REFERENCES Person(ID), MeetingID INT NOT NULL REFERENCES Meeting(ID), PlannedTime TIMESTAMP, Role VARCHAR(50), PRIMARY KEY (PersonID, MeetingID));

CREATE TABLE MeetingStatus (ID SERIAL PRIMARY KEY, MeetingID INT NOT NULL REFERENCES Meeting(ID), Status VARCHAR(50) NOT NULL, ChangeDate TIMESTAMP NOT NULL CHECK (ChangeDate <= CURRENT_TIMESTAMP));


INSERT INTO Country (Name, Population, Continent) VALUES ('Россия', 140000000, 'Европа');

INSERT INTO Capital (Name, Population, CountryID) VALUES ('Москва', 12000000, 1);

INSERT INTO City (Name, Population, IsCapital, CountryID) VALUES ('Сургут', 400000, FALSE, 1);

INSERT INTO Street (Name, PostalCode, CityID) VALUES ('Центральный тротуар', '000001', 1);

INSERT INTO Location (Name, Type, StreetID) VALUES ('Место встречи на краю города', 'Открытое пространство', 1);

INSERT INTO Person (Name, Gender, Emotion, LocationID) VALUES ('Олвин', 'M', 'Нетерпеливый', 1), ('Хедрон', 'M', 'Спокойный', 1), ('Шут', 'M', 'Веселый', 1);

INSERT INTO Meeting (LocationID, Purpose, StartTime, EndTime) VALUES (1, 'Личная встреча и приветствие', '2026-03-02 10:00:00', '2026-03-02 10:30:00');

INSERT INTO MeetingRegistration (PersonID, MeetingID, PlannedTime, Role) VALUES (1, 1, '2026-03-02 09:50:00', 'Участник'), (2, 1, '2026-03-02 10:00:00', 'Участник'), (3, 1, '2026-03-02 10:00:00', 'Организатор');

INSERT INTO MeetingStatus (MeetingID, Status, ChangeDate) VALUES (1, 'Запланирована', '2020-03-01 12:00:00');

INSERT INTO Street (Name, PostalCode, CityID) VALUES  ('Улица 1', '000002', 1), ('Улица 2', '000003', 1);

INSERT INTO Location (Name, Type, StreetID) VALUES ('Парк', 'Открытое пространство', 2), ('Кафе', 'Закрытое помещение', 3);

INSERT INTO Meeting (LocationID, Purpose, StartTime, EndTime) VALUES 
(1, 'Встреча 1', '2026-01-12 10:00:00', '2026-01-12 11:00:00'),
(1, 'Встреча 2', '2026-02-12 10:00:00', '2026-02-12 11:00:00'),
(1, 'Встреча 3', '2026-03-12 10:00:00', '2026-03-12 11:00:00'),
(1, 'Встреча 4', '2026-04-12 10:00:00', '2026-04-12 11:00:00'),
(1, 'Встреча 5', '2026-05-12 10:00:00', '2026-05-12 11:00:00'),
(1, 'Встреча 6', '2026-06-12 10:00:00', '2026-06-12 11:00:00'),
(1, 'Встреча 7', '2026-01-16 10:00:00', '2026-01-16 11:00:00'),
(1, 'Встреча 8', '2026-02-16 10:00:00', '2026-02-16 11:00:00'),
(1, 'Встреча 9', '2026-03-16 10:00:00', '2026-03-16 11:00:00'),
(1, 'Встреча 10', '2026-04-16 10:00:00', '2026-04-16 11:00:00'),
  
(2, 'Встреча 11', '2026-01-12 10:00:00', '2026-01-12 11:00:00'),
(2, 'Встреча 12', '2026-02-12 10:00:00', '2026-02-12 11:00:00'),
(2, 'Встреча 13', '2026-03-12 10:00:00', '2026-03-12 11:00:00'),
(2, 'Встреча 14', '2026-04-12 10:00:00', '2026-04-12 11:00:00'),
(2, 'Встреча 15', '2026-05-12 10:00:00', '2026-05-12 11:00:00'),
(2, 'Встреча 16', '2026-06-12 10:00:00', '2026-06-12 11:00:00'),
(2, 'Встреча 17', '2026-01-16 10:00:00', '2026-01-16 11:00:00'),
(2, 'Встреча 18', '2026-02-16 10:00:00', '2026-02-16 11:00:00'),
(2, 'Встреча 19', '2026-03-16 10:00:00', '2026-03-16 11:00:00'),
(2, 'Встреча 20', '2026-04-16 10:00:00', '2026-04-16 11:00:00'),

(3, 'Встреча 21', '2026-01-12 10:00:00', '2026-01-12 11:00:00'),
(3, 'Встреча 22', '2026-02-12 10:00:00', '2026-02-12 11:00:00'),
(3, 'Встреча 23', '2026-03-12 10:00:00', '2026-03-12 11:00:00'),
(3, 'Встреча 24', '2026-04-12 10:00:00', '2026-04-12 11:00:00'),
(3, 'Встреча 25', '2026-05-12 10:00:00', '2026-05-12 11:00:00'),
(3, 'Встреча 26', '2026-06-12 10:00:00', '2026-06-12 11:00:00'),
(3, 'Встреча 27', '2026-01-16 10:00:00', '2026-01-16 11:00:00'),
(3, 'Встреча 28', '2026-02-16 10:00:00', '2026-02-16 11:00:00'),
(3, 'Встреча 29', '2026-03-16 10:00:00', '2026-03-16 11:00:00'),
(3, 'Встреча 30', '2026-04-16 10:00:00', '2026-04-16 11:00:00');
