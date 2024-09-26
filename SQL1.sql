CREATE DATABASE IF NOT EXISTS stationary;

USE stationary;

SHOW DATABASES;

CREATE TABLE products(
	productID INT PRIMARY KEY,
    productCODE VARCHAR(50),
    name VARCHAR(50),
    quantity INT,
    price DOUBLE
);

INSERT INTO products
(productID, productCODE, name, quantity,price)
VALUES
(1001,"PEN","Pen Red",5000,1.23),
(1002,"PEN", "Pen Blue",8000,1.25),
(1003,"PEN","Pen Black",2000,1.25),
(1004,"PEC","Pencil 2B",10000,0.48),
(1005,"PEC","Pencil 2H",8000,0.49);

DESC products;

SELECT * FROM products;

ALTER TABLE products ADD consumerNum INT;
ALTER TABLE products ADD deliverDATE date;

UPDATE products
SET deliverDATE = '10-08-2024' 
WHERE productCODE = "PEN";

UPDATE products
SET deliverDATE = '23-03-2023'
WHERE productCODE = "PEC";

UPDATE goods
SET buyerNum = 100 
WHERE productCODE = "PEN";

UPDATE products
SET consumerNum = 200 
WHERE productCODE = "PEC";


UPDATE products
SET consumerNum = 200 
WHERE productID = 1004;

UPDATE products
SET buyerNum = 200 
WHERE productID = 1004;


ALTER TABLE products RENAME COLUMN consumerNum TO buyerNum;

ALTER TABLE products RENAME TO goods;

ALTER TABLE goods DROP COLUMN price;

DELETE FROM goods WHERE productID = 1004;

SELECT * FROM goods;







