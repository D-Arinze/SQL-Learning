
-- I partitioned by LandUse and also sorted by saleprice in descending order so as to extract the top 3 expensive properties using a CTE and ROW_NUMBER function.
WITH TOP_THREE AS 
				(SELECT OwnerName, LandUse, ROW_NUMBER() OVER (PARTITION BY LandUse) ROW_NUM, SalePrice
				FROM portfolioproject.`nashville housing data for data cleaning`)
                
SELECT *
FROM TOP_THREE
WHERE ROW_NUM < 4

-- I partitioned by those 5 columns because I aim to seek duplicated rows. any multiple row containing thesame date for those 5 columns tells us that it is duplicated.
-- NB: Using Partion by syntax, it also sorts the 1st column stated in Ascending Order and not just segmentation alone.
SELECT UniqueID, ParcelID, LandUse,SaleDate, 
		ROW_NUMBER() OVER (PARTITION BY ParcelID, LandUse, PropertyAddress, SaleDate, SalePrice) ROW_NUM, SalePrice
FROM portfolioproject.`nashville housing data for data cleaning`
-- The above gives us the selected row numbers including those that are duplicates; If we want to view those that are duplicates (ie ROW_NUM > 1), 
-- we should use a where condition indicating that ROW_NUM > 1, but we cannot use this with the ROW_NUMBER window function directly, unless we make it a subquery and use a where condition in the main query 
-- therefore we use the expression below to see this; As below
SELECT *
FROM (SELECT UniqueID, ParcelID, LandUse,SaleDate, ROW_NUMBER() OVER (PARTITION BY ParcelID, LandUse, PropertyAddress, SaleDate, SalePrice) ROW_NUM, SalePrice
				FROM portfolioproject.`nashville housing data for data cleaning`) AS ROW_NUM1
WHERE ROW_NUM > 1


-- We cannot delete based on where condition is ROW_NUM because mysql doesn't support deleting using such a window function, 
-- so we first use a column already present in the table such as UniqueID.
SELECT UniqueID
FROM(
SELECT *
FROM (SELECT UniqueID, ParcelID, LandUse,SaleDate, ROW_NUMBER() OVER (PARTITION BY ParcelID, LandUse, PropertyAddress, SaleDate, SalePrice) ROW_NUM, SalePrice
				FROM portfolioproject.`nashville housing data for data cleaning`) AS ROW_NUM1
WHERE ROW_NUM > 1) AS ROW_NUM2


-- We can now delete the duplicated rows based on where condition with reference to UniqueID column; then below code deletes these duplicates; We use two subqueries
DELETE
FROM portfolioproject.`nashville housing data for data cleaning`
WHERE UniqueID IN
(SELECT UniqueID
FROM(
SELECT *
FROM (SELECT UniqueID, ParcelID, LandUse,SaleDate, ROW_NUMBER() OVER (PARTITION BY ParcelID, LandUse, PropertyAddress, SaleDate, SalePrice) ROW_NUM, SalePrice
				FROM portfolioproject.`nashville housing data for data cleaning`) AS ROW_NUM1
WHERE ROW_NUM > 1) AS ROW_NUM2)


SELECT *, COUNT(UniqueID) 
FROM portfolioproject.`nashville housing data for data cleaning`




