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
