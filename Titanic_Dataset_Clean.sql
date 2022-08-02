-- Titanic Data cleaning

USE new_database;

SELECT *
FROM new_database.titanic


SELECT *, SUBSTRING_INDEX(Name, ",", 1) AS Family_Name
FROM titanic;
ALTER TABLE new_database.titanic
ADD COLUMN Family_Name varchar(100)
UPDATE new_database.titanic
SET Family_Name = SUBSTRING_INDEX(Name, ",", 1)

SELECT *, SUBSTRING_INDEX(Name, ".", -1) AS Other_Names
FROM titanic;
ALTER TABLE new_database.titanic
ADD COLUMN Other_Names varchar(100)
UPDATE new_database.titanic
SET Other_Names = SUBSTRING_INDEX(Name, ".", -1)

SELECT *, SUBSTRING_INDEX(SUBSTRING_INDEX(Name, ".", 1), ",", -1) AS Title
FROM titanic;
ALTER TABLE new_database.titanic
ADD COLUMN Title varchar(100)
UPDATE new_database.titanic
SET Title = SUBSTRING_INDEX(SUBSTRING_INDEX(Name, ".", 1), ",", -1)

-- Converting the lower case letters of Sex column to Proper case letters
SELECT Sex, CONCAT(UPPER(SUBSTRING(Sex, 1,1)), LOWER(SUBSTRING(Sex,2, LENGTH(Sex)))) AS Proper_Sex
FROM titanic;
UPDATE new_database.titanic
SET Sex = CONCAT(UPPER(SUBSTRING(Sex, 1,1)), LOWER(SUBSTRING(Sex,2, LENGTH(Sex))))

-- After splitting the ambiguous names into family_name, Other_names, and Title, I am deleting the parent Name column.
ALTER TABLE new_database.titanic
DROP COLUMN Name

WITH Duplicate_check AS(
SELECT *, ROW_NUMBER() OVER (PARTITION BY Family_Name, Other_Names, Age, Ticket) AS Row_Num
FROM new_database.titanic)
SELECT *
FROM Duplicate_check
WHERE Row_Num != 1

-- Checking for family members
WITH Family_members AS(
SELECT *, ROW_NUMBER() OVER (PARTITION BY Family_Name) AS Row_Num
FROM new_database.titanic)
SELECT *
FROM Family_members
WHERE Row_Num != 1
ORDER BY Family_Name

-- Translating the life status from numerical data into descriptive information
SELECT CASE
			WHEN Status = 0 THEN "Died"
            WHEN Status = 1 THEN "Survived"
            ELSE Status
            END
FROM new_database.titanic

UPDATE new_database.titanic
SET Status = CASE
				WHEN Status = 0 THEN "Died"
				WHEN Status = 1 THEN "Survived"
				ELSE Status
				END
 
 -- Translating the boarding class from numerical data into descriptive information
SELECT CASE 
			WHEN Pclass = 1 THEN "First_Class"
            WHEN Pclass = 2 THEN "Second_Class"
            WHEN Pclass = 3 THEN "Third_Class"
            ELSE Pclass
            END
FROM new_database.titanic

UPDATE new_database.titanic
SET Pclass = CASE 
			WHEN Pclass = 1 THEN "First_Class"
            WHEN Pclass = 2 THEN "Second_Class"
            WHEN Pclass = 3 THEN "Third_Class"
            ELSE Pclass
            END
 
 -- Translating the Embarkment inital into descriptive information
SELECT CASE
			WHEN Embarked = "S" THEN "Southampton"
			WHEN Embarked = "C" THEN "Cherboug"
            WHEN Embarked = "Q" THEN "Queenstown"
            ELSE Embarked
            END
FROM new_database.titanic

UPDATE new_database.titanic
SET Embarked = CASE
					WHEN Embarked = "S" THEN "Southampton"
					WHEN Embarked = "C" THEN "Cherboug"
					WHEN Embarked = "Q" THEN "Queenstown"
					ELSE Embarked
					END