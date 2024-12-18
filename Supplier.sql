CREATE DATABASE IF NOT EXISTS Supplier;
USE Supplier;


DESC SUPPLIERS;
DESC PARTS;
DESC CATALOG;



-- Create SUPPLIERS table
CREATE TABLE SUPPLIERS (
    sid INT PRIMARY KEY,
    sname VARCHAR(50),
    city VARCHAR(50)
);

-- Create PARTS table
CREATE TABLE PARTS (
    pid INT PRIMARY KEY,
    pname VARCHAR(50),
    color VARCHAR(20)
);

-- Create CATALOG table
CREATE TABLE CATALOG (
    sid INT,
    pid INT,
    cost DOUBLE,
    PRIMARY KEY (sid, pid),
    FOREIGN KEY (sid) REFERENCES SUPPLIERS(sid),
    FOREIGN KEY (pid) REFERENCES PARTS(pid)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

INSERT INTO SUPPLIERS (sid, sname, city) VALUES
(10001, 'Acme Widget', 'Bangalore'),
(10002, 'Johns', 'Kolkata'),
(10003, 'Vimal', 'Mumbai'),
(10004, 'Reliance', 'Delhi');

INSERT INTO PARTS (pid, pname, color) VALUES
(20001, 'Book', 'Red'),
(20002, 'Pen', 'Red'),
(20003, 'Pencil', 'Green'),
(20004, 'Mobile', 'Green'),
(20005, 'Charger', 'Black');

INSERT INTO CATALOG (sid, pid, cost) VALUES
(10001, 20001, 10),
(10001, 20002, 10),
(10001, 20003, 30),
(10001, 20004, 10),
(10001, 20005, 10),
(10002, 20001, 10),
(10002, 20002, 20),
(10003, 20003, 30),
(10004, 20003, 40);




SELECT DISTINCT p.PNAME
FROM SUPPLIERS s
INNER JOIN CATALOG c
ON s.SID = c.SID
INNER JOIN PARTS p
ON c.PID = p.PID;






SELECT SNAME
FROM SUPPLIERS
WHERE SID IN (
	SELECT SID 
    FROM CATALOG
    WHERE PID IN (
		SELECT PID 
        FROM PARTS
        WHERE COLOR = "RED"
    )
    GROUP BY SID
    HAVING COUNT(SID)=(SELECT COUNT(*) FROM PARTS WHERE COLOR = "RED")
);

SELECT PNAME 
FROM PARTS 
WHERE PID IN(
	SELECT PID 
    FROM CATALOG 
    WHERE SID IN (
		SELECT SID 
        FROM SUPPLIERS
        WHERE SNAME = "Acme Widget" 
    )
) AND PID NOT IN (
	SELECT PID FROM CATALOG WHERE SID NOT IN (SELECT SID FROM SUPPLIERS WHERE SNAME = "Acme Widget" )
);






-- 3.)

SELECT pname FROM PARTS
WHERE pid IN (
	SELECT pid FROM CATALOG
);

-- 4.)

SELECT sname FROM SUPPLIERS
WHERE sid IN (
	SELECT sid FROM CATALOG
    GROUP BY sid
    HAVING COUNT(sid) = (
		SELECT COUNT(pid) FROM PARTS
    )
);

-- 5.)

SELECT DISTINCT(s.sname)
FROM PARTS p
JOIN CATALOG c
ON p.pid = c.pid AND p.color = "Red"
JOIN SUPPLIERS s
ON s.sid = c.sid;


-- 6.)

SELECT pname,pid 
FROM PARTS
WHERE pid NOT IN (
	SELECT DISTINCT(pid) 
    FROM CATALOG
    WHERE sid NOT IN (
		SELECT sid FROM SUPPLIERS WHERE sname = "Acme Widget"
    )
);


-- 7.)
SELECT SNAME 
FROM SUPPLIERS
WHERE SID IN (
	SELECT c.SID 
    FROM CATALOG c
    WHERE c.cost>(
		SELECT AVG(c1.cost)
        FROM CATALOG c1
        WHERE c.PID = c1.PID
	)
);




-- 8.)

SELECT c.SID,p.PID,p.PNAME,c.COST
FROM PARTS p, CATALOG c
WHERE c.PID = p.PID
AND 
c.COST = (
	SELECT MAX(c1.COST)
    FROM CATALOG c1
    WHERE c1.PID = c.PID
);        


SELECT p.PID, p.PNAME, s.SNAME, c.COST
FROM PARTS p
JOIN CATALOG c ON p.PID = c.PID
JOIN SUPPLIERS s ON c.SID = s.SID
WHERE c.COST = (
    SELECT MAX(c1.COST)
    FROM CATALOG c1
    WHERE c1.PID = c.PID
);

SELECT * FROM SUPPLIERS;
SELECT * FROM PARTS;
SELECT * FROM CATALOG;

