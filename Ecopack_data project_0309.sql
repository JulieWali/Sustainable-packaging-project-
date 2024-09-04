
-- LET'S START THIS PROJECT !!!!!!

SELECT* 
FROM ecopack_data;


-- Create duplicate table of the table ecopack_data

CREATE TABLE ecopack_data2
LIKE ecopack_data;
SELECT* 
FROM ecopack_data2;

-- Insert value of ecopack_data into ecopack_data2
INSERT INTO ecopack_data2
SELECT * 
FROM ecopack_data;

-- Change name of the column Product_Id
ALTER TABLE ecopack_data CHANGE ï»¿Product_Id Product_Id VARCHAR(15);
ALTER TABLE ecopack_data2 CHANGE ï»¿Product_Id Product_Id VARCHAR(15);

-- 1. Remove the duplicates values, attribute a row_number first 

-- a. Spot the duplicate values first

WITH THIS_command AS 
(SELECT *, 
row_number () OVER (PARTITION BY Product_Id, Level_of_Packaging, Type_of_Packaging,Type_of_Material, Material, Weight, Quantity, `pourcentage_Recycled Content`,Certifications, Other_Certifications,Form_Rigidity, pourcentage_Opacifiant,Addditives,Qty_shipped,Total_weight) AS Row_num 
FROM ecopack_data2) 
SELECT *
FROM THIS_command
WHERE Row_num > 1;

CREATE TABLE `ecopack_data3` (
  `Product_Id` varchar(15) DEFAULT NULL,
  `Level_of_Packaging` text,
  `Type_of_Packaging` text,
  `Type_of_Material` text,
  `Material` text,
  `Weight` double DEFAULT NULL,
  `Quantity` int DEFAULT NULL,
  `pourcentage_Recycled Content` int DEFAULT NULL,
  `Certifications` text,
  `Other_Certifications` int DEFAULT NULL,
  `Form_Rigidity` text,
  `pourcentage_Opacifiant` int DEFAULT NULL,
  `Addditives` text,
  `Qty_shipped` int DEFAULT NULL,
  `Total_weight` int DEFAULT NULL,
  `the row_number` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

select * from ecopack_data3;
select count(*) from ecopack_data3;

-- c. Insert into ecopck_data3 values from ecopack_data2 + the row number
INSERT INTO ecopack_data3
SELECT*,row_number () OVER (PARTITION BY Product_Id, Level_of_Packaging, Type_of_Packaging,Type_of_Material, Material, Weight, Quantity, `pourcentage_Recycled Content`,Certifications, Other_Certifications,Form_Rigidity, pourcentage_Opacifiant,Addditives,Qty_shipped,Total_weight) AS Row_num 
FROM ecopack_data2;

-- d. Delete duplicated values
DELETE 
FROM ecopack_data3
WHERE `the row_number` > 1;

SELECT * FROM ecopack_data3;

-- 2. Standardize the data

UPDATE ecopack_data3
SET Level_of_Packaging = trim(Level_of_Packaging);

select distinct(Material)
FROM ecopack_data3;

UPDATE ecopack_data3
SET Material = 'CARTON'
WHERE Material LIKE 'CARTO%';

SELECT DISTINCT Type_of_Packaging, TRIM(TRAILING '.' FROM Type_of_Packaging)
FROM ecopack_data3
ORDER BY 1;

SELECT * FROM ecopack_data3;

SELECT * FROM ecopack_data3
WHERE Qty_shipped = 0;

SELECT t1.Qty_shipped, t2.Qty_shipped
FROM ecopack_data3 t2
JOIN ecopack_data3 t1
ON t1.Product_Id = t2.Product_Id
AND t1.Level_of_Packaging = t2.Level_of_Packaging
WHERE t1.Qty_shipped IS NULL 
AND t2.Qty_shipped IS NOT NULL;


UPDATE ecopack_data3 t1 
JOIN ecopack_data3 t2
	ON t1.Product_Id = t2.Product_Id
	AND t1.Level_of_Packaging = t2.Level_of_Packaging
SET t1.Qty_shipped = t2.Qty_shipped
WHERE t1.Qty_shipped = 0
AND t2.Qty_shipped IS NOT NULL;

SELECT * FROM ecopack_data3
where Product_Id = 'DE45789';

UPDATE ecopack_data3
	SET Qty_shipped = 50
WHERE Product_Id = 'DE45789'
AND Level_of_Packaging = 'SECONDARY' ;

UPDATE ecopack_data3
SET Total_weight = Weight * Quantity * Qty_shipped
WHERE Total_weight = 0;

SELECT * FROM ecopack_data3;

ALTER TABLE ecopack_data3 
MODIFY  `pourcentage_Recycled Content` DECIMAL (5,2);

UPDATE ecopack_data3
SET `pourcentage_Recycled Content` = `pourcentage_Recycled Content`/100
WHERE `pourcentage_Recycled Content` IS NOT NULL;

UPDATE ecopack_data3
SET Certifications = 'GRS' 
WHERE Certifications = 'grs';