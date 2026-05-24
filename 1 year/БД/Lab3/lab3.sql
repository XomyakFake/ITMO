DROP TABLE IF EXISTS MeetingStatus CASCADE;
DROP TABLE IF EXISTS MeetingRegistration CASCADE;
DROP TABLE IF EXISTS Meeting CASCADE;
DROP TABLE IF EXISTS Person CASCADE;
DROP TABLE IF EXISTS Location CASCADE;
DROP TABLE IF EXISTS Street CASCADE;
DROP TABLE IF EXISTS City CASCADE;
DROP TABLE IF EXISTS Capital CASCADE;
DROP TABLE IF EXISTS Countryy CASCADE;
DROP TRIGGER IF EXISTS meet_trigger ON MeetingRegistration;

CREATE TABLE Countryy (ID SERIAL PRIMARY KEY, Name VARCHAR(50) NOT NULL, Population INT CHECK (Population >= 0), Continent VARCHAR(50) NOT NULL);

CREATE TABLE Capital (ID SERIAL PRIMARY KEY, Name VARCHAR(50) NOT NULL, Population INT CHECK (Population >= 0), CountryID INT UNIQUE NOT NULL REFERENCES Countryy(ID));

CREATE TABLE City (ID SERIAL PRIMARY KEY, Name VARCHAR(50) NOT NULL,Population INT CHECK (Population >= 0), IsCapital BOOLEAN DEFAULT FALSE , CountryID INT NOT NULL REFERENCES Countryy(ID));

CREATE TABLE Street (ID SERIAL PRIMARY KEY, Name VARCHAR(50) NOT NULL, PostalCode VARCHAR(20), CityID INT NOT NULL REFERENCES City(ID));

CREATE TABLE Location (ID SERIAL PRIMARY KEY, Name VARCHAR(50) NOT NULL, Type VARCHAR(50) NOT NULL, Coordinates VARCHAR(100), StreetID INT REFERENCES Street(ID));

CREATE TABLE Person (ID SERIAL PRIMARY KEY,Name VARCHAR(20) NOT NULL, Gender VARCHAR(1) CHECK (Gender IN ('M', 'F')), Emotion VARCHAR(50), LocationID INT NOT NULL REFERENCES Location(ID));

CREATE TABLE Meeting (ID SERIAL PRIMARY KEY, LocationID INT NOT NULL REFERENCES Location(ID), Purpose TEXT, StartTime TIMESTAMP NOT NULL, EndTime TIMESTAMP CHECK (EndTime >= StartTime) NOT NULL);

CREATE TABLE MeetingRegistration (PersonID INT NOT NULL REFERENCES Person(ID), MeetingID INT NOT NULL REFERENCES Meeting(ID), PlannedTime TIMESTAMP, Role VARCHAR(50), PRIMARY KEY (PersonID, MeetingID));

CREATE TABLE MeetingStatus (ID SERIAL PRIMARY KEY, MeetingID INT NOT NULL REFERENCES Meeting(ID), Status VARCHAR(50) NOT NULL, ChangeDate TIMESTAMP NOT NULL CHECK (ChangeDate <= CURRENT_TIMESTAMP));


INSERT INTO Countryy (Name, Population, Continent) VALUES ('Россия', 146000000, 'Европа');
INSERT INTO City (Name, Population, CountryID) VALUES ('Москва', 13000000, 1);
INSERT INTO Street (Name, CityID) VALUES ('Ленина', 1);
INSERT INTO Location (Name, Type, StreetID) VALUES ('Кабинет 404', 'Офис', 1);

INSERT INTO Person (Name, Gender, LocationID) VALUES ('Иван', 'M', 1);
INSERT INTO Person (Name, Gender, LocationID) VALUES ('Маша', 'F', 1);

INSERT INTO Meeting (LocationID, Purpose, StartTime, EndTime) 
VALUES (1, 'Утренний созвон', '2026-05-24 10:00:00', '2026-05-24 11:00:00');

INSERT INTO Meeting (LocationID, Purpose, StartTime, EndTime) 
VALUES (1, 'Вечерний созвон', '2026-05-24 18:00:00', '2026-05-24 20:00:00');

INSERT INTO Meeting (LocationID, Purpose, StartTime, EndTime) 
VALUES (1, 'Вечерний созвон №2', '2026-05-24 18:30:00', '2026-05-24 20:30:00');



CREATE OR REPLACE FUNCTION meet_func()
RETURNS TRIGGER AS
$$
DECLARE
  start_time TIMESTAMP;
  end_time TIMESTAMP;
  flag BOOLEAN;
BEGIN
  SELECT StartTime, EndTime
  INTO start_time, end_time
  FROM Meeting 
  WHERE ID = NEW.MeetingID;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Встречи с ID % не существует', NEW.MeetingID;
  END IF;

  IF end_time < CURRENT_TIMESTAMP THEN
    RAISE EXCEPTION 'Встреча уже завершилась';
  END IF;

  SELECT EXISTS ( 
    SELECT 1 FROM MeetingRegistration mr
    JOIN Meeting m ON mr.MeetingID = m.ID
    WHERE mr.PersonID = NEW.PersonID AND mr.MeetingID != NEW.MeetingID
    AND m.StartTime < end_time AND m.EndTime > start_time
  ) INTO flag;

  IF flag THEN
    RAISE EXCEPTION 'Человек с ID % уже зарегистрирован на другую встречу в это время', NEW.PersonID;
  end IF;

  RETURN NEW;

END;
$$ LANGUAGE plpgsql;
  
  

CREATE TRIGGER meet_treeger BEFORE INSERT OR UPDATE ON MeetingRegistration FOR EACH ROW EXECUTE FUNCTION meet_func();



-- ТЕСТЫ
INSERT INTO MeetingRegistration (PersonID, MeetingID, Role) 
VALUES (1, 2, 'Разработчик');

INSERT INTO MeetingRegistration (PersonID, MeetingID, Role) 
VALUES (2, 999, 'Слушатель');

INSERT INTO MeetingRegistration (PersonID, MeetingID, Role) 
VALUES (2, 1, 'Слушатель');

INSERT INTO MeetingRegistration (PersonID, MeetingID, Role) 
VALUES (1, 3, 'Докладчик');
