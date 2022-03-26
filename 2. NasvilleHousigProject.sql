select *
from NashvilleHousing

-- Standarize Date Format

select SaleDateConverted, CONVERT(Date, SaleDate)
from NashvilleHousing


ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate)

select SaleDateConverted, SaleDate
from NashvilleHousing

--Populate Property Adress Data

select *
from NashvilleHousing
order by ParcelID



select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.propertyAddress, b.PropertyAddress)
from NashvilleHousing a
JOIN NashvilleHousing b
on a.ParcelID = b.parcelID
AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.propertyAddress, b.PropertyAddress)
from NashvilleHousing a
JOIN NashvilleHousing b
on a.ParcelID = b.parcelID
AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

-- Breaking out Adress into Individual Columns (adress, city, state)

select PropertyAddress
from NashvilleHousing

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address
,SUBSTRING(PropertyAddress,  CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) as City
from NashvilleHousing

ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(225);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)


ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress,  CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))


select *
from NashvilleHousing

select OwnerAddress
from NashvilleHousing

select
PARSENAME(REPLACE(OwnerAddress, ',' , '.'),3 ) 
,PARSENAME(REPLACE(OwnerAddress, ',' , '.'),2 ) 
,PARSENAME(REPLACE(OwnerAddress, ',' , '.'),1 ) 
from NashvilleHousing

ALTER TABLE NashvilleHousing
Add OwnerSplitAdress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAdress = PARSENAME(REPLACE(OwnerAddress, ',' , '.'),3 )

ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',' , '.'),2 )

ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',' , '.'),1 ) 


select *
from NashvilleHousing


-- changing Y and N for Yes and No in "Sold as Vacant" field

select Distinct SoldAsVacant, COUNT(SoldAsVacant)
from NashvilleHousing
group by SoldAsVacant


select SoldAsVacant
, CASE when SoldAsVacant ='Y' THEN 'Yes'
	   when SoldAsVacant ='N' THEN 'No'
       ELSE SoldAsVacant
	   END
from NashvilleHousing

Update NashvilleHousing
SET SoldAsVacant = CASE when SoldAsVacant ='Y' THEN 'Yes'
	   when SoldAsVacant ='N' THEN 'No'
       ELSE SoldAsVacant
	   END


-- Remove Duplicates
WITH RowNumCTE as(
select *,
ROW_NUMBER() OVER(
PARTITION BY ParcelID, 
             PropertyAddress, 
			 SalePrice, 
			 SaleDate, 
			 LegalReference
			 ORDER BY
			 UniqueID) as row_num
from NashvilleHousing
)
SELECT * from RowNumCTE
where row_num > 1
--order by PropertyAddress


-- Delete Unused Columns


select *
from NashvilleHousing

ALTER TABLE NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE NashvilleHousing
DROP COLUMN SaleDate
