SELECT *
FROM portfolioproject.`nashville housing data for data cleaning`;

-- Standardize the SaleDate format.

-- UPDATE `nashville housing data for data cleaning`
SET SaleDate = STR_TO_DATE(SaleDate, "%M %d,%Y");


-- splitting an ambiguous address into the street address and city. NB The 3rd parameter which are 1, -1 below are used for the direction of counting. So -1 means it wil;l start counting from the back.
SELECT PropertyAddress, SUBSTRING_INDEX(PropertyAddress, ",", 1) AS Street_Address,
		SUBSTRING_INDEX(PropertyAddress, ",", -1) AS City_Address
FROM portfolioproject.`nashville housing data for data cleaning`

-- Created a new column for the street_adrress only
ALTER TABLE portfolioproject.`nashville housing data for data cleaning`
ADD COLUMN Street_Address varchar(200)

-- Created a new column for the city_adrress only
ALTER TABLE portfolioproject.`nashville housing data for data cleaning`
ADD COLUMN City_Address varchar(200)

-- updated the street_address column with only the street name
UPDATE portfolioproject.`nashville housing data for data cleaning`
SET Street_Address = SUBSTRING_INDEX(PropertyAddress, ",", 1)

-- updated the city_address column with only the city name
UPDATE portfolioproject.`nashville housing data for data cleaning`
SET City_Address = SUBSTRING_INDEX(PropertyAddress, ",", -1)

-- Created a new column for the owner_street_adrress only
ALTER TABLE portfolioproject.`nashville housing data for data cleaning`
ADD COLUMN Owner_Street_Address varchar(200)

-- Created a new column for the owner_city_adrress only
ALTER TABLE portfolioproject.`nashville housing data for data cleaning`
ADD COLUMN Owner_City_Address varchar(200)

-- Created a new column for the owner_state_adrress only
ALTER TABLE portfolioproject.`nashville housing data for data cleaning`
ADD COLUMN Owner_State_Address varchar(200)

-- updated the owner_street_address column with only the owner street name
UPDATE portfolioproject.`nashville housing data for data cleaning`
SET Owner_Street_Address = SUBSTRING_INDEX(OwnerAddress, ",", 1)

-- updated the owner_city_address column with only the owner city name
UPDATE portfolioproject.`nashville housing data for data cleaning`
SET Owner_City_Address = SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ",", 2), ",", -1)

-- updated the owner_state_address column with only the owner state name
UPDATE portfolioproject.`nashville housing data for data cleaning`
SET Owner_State_Address = SUBSTRING_INDEX(OwnerAddress, ",", -1)

-- updated the "N" with "No" and also "Y" with "Yes" in the SoldAsVacant column using CASE syntax.
UPDATE portfolioproject.`nashville housing data for data cleaning`
SET SoldAsVacant = CASE	
						WHEN SoldAsVacant = "N" THEN "No"
						WHEN SoldAsVacant = "Y" THEN "Yes"
						ELSE SoldAsVacant
						END;

