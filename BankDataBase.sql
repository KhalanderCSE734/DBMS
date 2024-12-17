CREATE DATABASE IF NOT EXISTS Bank ;
USE Bank;

CREATE TABLE Branch (
    BranchName VARCHAR(50) PRIMARY KEY,
    BranchCity VARCHAR(50),
    Assets Float
);

CREATE TABLE BankAccount (
    AccNo INT PRIMARY KEY,
    BranchName VARCHAR(50),
    Balance INT,
    FOREIGN KEY (BranchName) REFERENCES Branch(BranchName)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE BankCustomer (
    CustomerName VARCHAR(50),
    CustomerStreet VARCHAR(50),
    CustomerCity VARCHAR(50),
    PRIMARY KEY (CustomerName)
);

CREATE TABLE Depositor (
    CustomerName VARCHAR(50),
    AccNo INT,
    PRIMARY KEY (CustomerName,AccNo),
    FOREIGN KEY (CustomerName) REFERENCES BankCustomer(CustomerName),
    FOREIGN KEY (AccNo) REFERENCES BankAccount(AccNo)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE Loan (
    LoanNumber INT PRIMARY KEY,
    BranchName VARCHAR(50),
    Amount INT,
    FOREIGN KEY (BranchName) REFERENCES Branch(BranchName)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);


INSERT INTO Branch (BranchName, BranchCity, Assets) VALUES
('SBI_Charniapet', 'Bangalore', 50000),
('SBI_ResidencyRoad', 'Bangalore', 10000),
('SBI_ShivajiRoad', 'Bombay', 20000),
('SBI_ParliamentRoad', 'Delhi', 20000),
('SBI_Jantarmantar', 'Delhi', 20000);

INSERT INTO BankAccount (AccNo, BranchName, Balance) VALUES
(1, 'SBI_Charniapet', 5000),
(2, 'SBI_ResidencyRoad', 6000),
(3, 'SBI_ShivajiRoad', 7000),
(4, 'SBI_ParliamentRoad', 8000),
(5, 'SBI_Jantarmantar', 9000),
(6, 'SBI_Charniapet', 2000),
(7, 'SBI_ShivajiRoad', 3000),
(8, 'SBI_ResidencyRoad', 4000),
(9, 'SBI_ShivajiRoad', 5000),
(10, 'SBI_ParliamentRoad', 4000),
(11, 'SBI_Jantarmantar', 5000);





INSERT INTO BankCustomer (CustomerName, CustomerStreet, CustomerCity) VALUES
('Avinash', 'Bull_Temple_Road', 'Bangalore'),
('Dinesh', 'Bannerghatta_Road', 'Bangalore'),
('Mohan', 'NationalCollege_Road', 'Bangalore'),
('Nikhil', 'Akbar_Road', 'Delhi'),
('Ravi', 'Prithviraj_Road', 'Delhi');

INSERT INTO Depositor (CustomerName, AccNo) VALUES
('Avinash', 1),
('Dinesh', 2),
('Nikhil', 4),
('Ravi', 5),
('Avinash', 8),
('Nikhil', 9),
('Dinesh', 10),
('Nikhil', 11);


INSERT INTO Loan (LoanNumber, BranchName, Amount) VALUES
(1, 'SBI_Charniapet', 20000),
(2, 'SBI_ResidencyRoad', 10000),
(3, 'SBI_ShivajiRoad', 3000),
(4, 'SBI_ParliamentRoad', 4000),
(5, 'SBI_Jantarmantar', 5000);





/*


Example for creating temporary table for use

CREATE TABLE PERSON_OWNS AS
SELECT P.driver_id, P.name, O.reg_num
FROM PERSON P
JOIN OWNS O ON P.driver_id = O.driver_id;


*/



SELECT BranchName, Assets/100000 AS assetsInLakhs
FROM Branch;



-- 3.)
ALTER TABLE Branch RENAME COLUMN Assets TO assets_in_Lakhs;

UPDATE Branch
SET assets_in_Lakhs = assets_in_Lakhs/100000.00;

;

-- 4.)

SELECT CustomerName,COUNT(CustomerName)
FROM Depositor
WHERE AccNo IN (
SELECT AccNo
FROM BankAccount
WHERE BranchName='SBI_ResidencyRoad'
)
GROUP BY CustomerName
HAVING COUNT(CustomerName)>=2;


-- 5.)

CREATE VIEW VirtualLoan(BranchName,LoanAmount)
AS 
SELECT BranchName, SUM(Amount)
FROM Loan
GROUP BY BranchName;

SELECT * FROM VirtualLoan;



SELECT DISTINCT dp.CustomerName
FROM Branch br INNER JOIN BankAccount ba
ON br.BranchName=ba.BranchName AND br.BranchCity = "Delhi"
INNER JOIN Depositor dp
ON ba.AccNo = dp.AccNo;






SELECT L.LoanNumber,L.BranchName,L.Amount,B.BranchName
FROM BankAccount B, Loan L
WHERE B.BranchName=L.BranchName
GROUP BY B.BranchName;







SELECT B.BranchName,COUNT(B.BranchName)
FROM BankAccount B, Loan L
WHERE B.BranchName=L.BranchName
GROUP BY B.BranchName;




SELECT CustomerName FROM Depositor
WHERE AccNo IN (
SELECT AccNo FROM BankAccount
WHERE BranchName IN (
SELECT BranchName FROM Branch
        WHERE BranchCity = 'Delhi'
    )
)
GROUP BY CustomerName
HAVING COUNT(CustomerName) = (
SELECT COUNT(BranchName) FROM Branch
     WHERE BranchCity = 'Delhi'
);

 
 -- Extra queries
 -- 1.)
 SELECT d.CustomerName 
 FROM Branch br 
 INNER JOIN BankAccount ba
 ON br.BranchName = ba.BranchName AND br.BranchCity = "Delhi"
 INNER JOIN Depositor d
 ON ba.AccNo = d.AccNo
 GROUP BY d.CustomerName 
 HAVING COUNT(d.CustomerName)=ALL(
	SELECT COUNT(BranchName) FROM Branch WHERE BranchCity = 'Delhi'
 );


-- 4.)

SELECT BranchName,Assets,BranchCity
FROM Branch
WHERE Assets > ALL(
	SELECT Assets FROM Branch WHERE BranchCity = 'Bangalore'
) AND BranchCity !='Bangalore';


-- 5.)

DELETE FROM Branch
WHERE BranchCity ='Bombay';

-- 6.)

UPDATE BankAccount
SET Balance = Balance + ((5/100)*Balance);




SELECT * FROM Branch;
SELECT * FROM BankAccount;
SELECT * FROM BankCustomer;
SELECT * FROM Depositor;
SELECT * FROM Loan;
