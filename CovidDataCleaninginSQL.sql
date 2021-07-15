select * 
from Nashvillehousing


-- standardize date format

select date_format(saledate, '%d/%m/%Y')
FROM Nashvillehousing;




-- update '' empty text to null

UPDATE Nashvillehousing
   SET propertyaddress = CASE WHEN propertyaddress = '' THEN NULL ELSE propertyaddress 
END


-- Populate property address data

SELECT *
FROM Nashvillehousing
WHERE propertyaddress IS NULL


SELECT 
    a.parcelid, a.propertyaddress, b.parcelid, b.propertyaddress, IFNULL(a.propertyaddress, b.propertyaddress)
FROM
    Nashvillehousing a
        JOIN
    Nashvillehousing b ON a.ParcelID=b.parcelID 
    and a.UniqueID <> b.UniqueID
WHERE a.propertyaddress IS NULL

UPDATE Nashvillehousing a
	JOIN
    Nashvillehousing b ON a.ParcelID= b.ParcelID 
    and a.UniqueID <> b.UniqueID
SET a.PropertyAddress = IFNULL(a.propertyaddress, b.propertyaddress)
WHERE a.propertyaddress IS NULL




-- breaking out Address into Individual Columns (Address, City, State)

SELECT propertyaddress
from nashvillehousing


SELECT
SUBSTRING(propertyaddress, 1, LOCATE(',',Propertyaddress) -1 ) as Address,
 SUBSTRING(propertyaddress, LOCATE(',', Propertyaddress) +1 , CHAR_LENGTH(PropertyAddress)) as Address
from nashvillehousing


ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(propertyaddress, 1, LOCATE(',',Propertyaddress) -1 )

ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(propertyaddress, LOCATE(',', Propertyaddress) +1 , CHAR_LENGTH(PropertyAddress))


SELECT *
from nashvillehousing

-- breaking out OwnerAddress into Individual Columns (Address, City)

SELECT
SUBSTRING(owneraddress, 1, LOCATE(',',owneraddress) -1 ),
 SUBSTRING(owneraddress, LOCATE(',', owneraddress) +1 , CHAR_LENGTH(owneraddress)) 
from nashvillehousing

DROP TABLE IF EXISTS OwnerSplitAddress
ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = SUBSTRING(owneraddress, 1, LOCATE(',',owneraddress) -1 )

ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = SUBSTRING(owneraddress, LOCATE(',', owneraddress) +1 , CHAR_LENGTH(owneraddress))


-- Change Y and N to Yes and No in 'Sold as Vacant' column

SELECT DISTINCT(SoldasVacant), COUNT(SoldasVacant)
FROM NashvilleHousing
GROUP BY SoldasVacant
ORDER BY 2


SELECT SoldasVacant,
 CASE When SoldasVacant = 'Y' THEN 'YES'
      When SoldasVacant = 'N' THEN 'NO'
      ELSE SoldasVacant
      END
From NashvilleHousing


UPDATE NashvilleHousing
 SET SoldasVacant = CASE When SoldasVacant = 'Y' THEN 'YES'
      When SoldasVacant = 'N' THEN 'NO'
      ELSE SoldasVacant
      END



-- delete unused columns

SELECT *
FROM NashvilleHousing


ALTER TABLE NashvilleHousing
	DROP COLUMN OwnerAddress,
    DROP COLUMN TaxDistrict,
    DROP COLUMN PropertyAddress:
   
    
ALTER TABLE NashvilleHousing  
DROP COLUMN SaleDateConverted;