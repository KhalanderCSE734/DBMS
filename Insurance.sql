-- Create the database
CREATE DATABASE Insurance;

-- Use the created database
USE Insurance;

-- Table 1: PERSON
CREATE TABLE PERSON (
    driver_id VARCHAR(10) PRIMARY KEY,
    name VARCHAR(50),
    address VARCHAR(100)
);

-- Table 2: CAR
CREATE TABLE CAR (
    reg_num VARCHAR(10) PRIMARY KEY,
    model VARCHAR(50),
    year INT
);

-- Table 3: OWNS
CREATE TABLE OWNS (
    driver_id VARCHAR(10),
    reg_num VARCHAR(10),
    PRIMARY KEY (driver_id, reg_num),
    FOREIGN KEY (driver_id) REFERENCES PERSON(driver_id),
    FOREIGN KEY (reg_num) REFERENCES CAR(reg_num)
);

-- Table 4: ACCIDENT
CREATE TABLE ACCIDENT (
    report_num INT PRIMARY KEY,
    accident_date DATE,
    location VARCHAR(100)
);

-- Table 5: PARTICIPATE
CREATE TABLE PARTICIPATE (
    driver_id VARCHAR(10),
    reg_num VARCHAR(10),
    report_num INT,
    damage_amount DOUBLE,
    PRIMARY KEY (driver_id, reg_num, report_num),
    FOREIGN KEY (driver_id) REFERENCES PERSON(driver_id),
    FOREIGN KEY (reg_num) REFERENCES CAR(reg_num),
    FOREIGN KEY (report_num) REFERENCES ACCIDENT(report_num)
);

-- Insert data into PERSON table
INSERT INTO PERSON (driver_id, name, address) VALUES
('A01', 'Richard', 'Srinivas nagar'),
('A02', 'Pradeep', 'Rajaji nagar'),
('A03', 'Smith', 'Ashok nagar'),
('A04', 'Venu', 'N R Colony'),
('A05', 'Jhon', 'Hanumanth nagar');

-- Insert data into CAR table
INSERT INTO CAR (reg_num, model, year) VALUES
('KA052250', 'Indica', 1990),
('KA031181', 'Lancer', 1957),
('KA095477', 'Toyota', 1998),
('KA053408', 'Honda', 2008),
('KA041702', 'Audi', 2005);

-- Insert data into OWNS table
INSERT INTO OWNS (driver_id, reg_num) VALUES
('A01', 'KA052250'),
('A02', 'KA053408'),
('A03', 'KA031181'),
('A04', 'KA095477'),
('A05', 'KA041702');

-- Insert data into ACCIDENT table
INSERT INTO ACCIDENT (report_num, accident_date, location) VALUES
(11, '2003-01-01', 'Mysore Road'),
(12, '2004-02-04', 'South end Circle'),
(13, '2003-01-21', 'Bull temple Road'),
(14, '2008-02-17', 'Mysore Road'),
(15, '2005-03-04', 'Kanakapura Road');

-- Insert data into PARTICIPATE table
INSERT INTO PARTICIPATE (driver_id, reg_num, report_num, damage_amount) VALUES
('A01', 'KA052250', 11, 10000),
('A02', 'KA053408', 12, 50000),
('A03', 'KA095477', 13, 25000),
('A04', 'KA031181', 14, 3000),
('A05', 'KA041702', 15, 5000);

SELECT accident_date,location
FROM ACCIDENT; 

UPDATE PARTICIPATE
SET damage_amount=25000
WHERE reg_num="KA053408" AND report_num=12;

INSERT INTO ACCIDENT 
(report_num,accident_date,location)
VALUES
(16,'1989-03-13',"Bengalore Road");


SELECT driver_id 
FROM PARTICIPATE
WHERE damage_amount>=25000;


SELECT *
FROM ACCIDENT a,PARTICIPATE p
WHERE a.report_num=p.report_num AND a.accident_date LIKE "2008%";


SELECT * 
FROM PARTICIPATE
ORDER BY damage_amount desc;


SELECT AVG(damage_amount)
FROM PARTICIPATE;


/*
DELETE FROM PARTICIPATE
WHERE damage_amount<(
	SELECT AVG(damage_amount)
	FROM PARTICIPATE
);

*/

-- The above query won't work so alternative is 

SET @avg_damage_amount = (SELECT AVG(damage_amount) FROM PARTICIPATE);

DELETE FROM PARTICIPATE
WHERE damage_amount< @avg_damage_amount;

SELECT p.name 
FROM PERSON p, PARTICIPATE pt
WHERE pt.damage_amount>@avg_damage_amount AND p.driver_id = pt.driver_id;

SELECT MAX(damage_amount) FROM PARTICIPATE;

