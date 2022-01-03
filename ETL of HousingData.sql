-- Cleaning Data in SQL Queries


Select * 
From [Portfolio Project]..NashvilleHousing 

-- Standardize date format


Select SaleDateConverted, CONVERT(date,SaleDate)
From [Portfolio Project]..NashvilleHousing 

Update NashvilleHousing Set
SaleDate = CONVERT(date,SaleDate)


Alter Table [Portfolio Project]..NashvilleHousing
add SaleDateConverted Date;

Update [Portfolio Project]..NashvilleHousing Set
SaleDateConverted = CONVERT(date,SaleDate)


----------------------------------------------------------------------------------------
--Standardize Addressing

Select PropertyAddress 
from [Portfolio Project]..NashvilleHousing
where PropertyAddress is null

Select * 
from [Portfolio Project]..NashvilleHousing
where PropertyAddress is null

--Join Nashville with itself to transform the null values
Select *
from [Portfolio Project]..NashvilleHousing a
join [Portfolio Project]..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

  

-- Update a table with b table
Update a 
Set PropertyAddress =ISNULL(a.PropertyAddress, b.PropertyAddress)
from [Portfolio Project]..NashvilleHousing a
join [Portfolio Project]..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


--Breaking out Address into Individual columns (Address,City, State)

Select PropertyAddress
from [Portfolio Project]..NashvilleHousing

Select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address
--	Charindex(',', propertyAddress)
from [Portfolio Project]..NashvilleHousing

Select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address,
Substring(propertyaddress, charindex(',', propertyaddress)+1, len(propertyaddress)) as address
--	Charindex(',', propertyAddress)
from [Portfolio Project]..NashvilleHousing


Alter Table [Portfolio Project]..NashvilleHousing
add PropertySplitAddress Nvarchar(255);

Update [Portfolio Project]..NashvilleHousing Set
PropertySplitAddress  = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)


Alter Table [Portfolio Project]..NashvilleHousing
add PropertySplitCity Nvarchar(255);

Update [Portfolio Project]..NashvilleHousing Set
PropertySplitCity = Substring(propertyaddress, charindex(',', propertyaddress)+1, len(propertyaddress))

 

 Select ownerAddress
 from [Portfolio Project]..NashvilleHousing

 Select 
 PARSENAME(Replace(OwnerAddress,',', '.'), 3),
  PARSENAME(Replace(OwnerAddress,',', '.'), 2),
   PARSENAME(Replace(OwnerAddress,',', '.'), 1)
 From [Portfolio Project]..NashvilleHousing

 Alter Table [Portfolio Project]..NashvilleHousing
add OwnerSplitAddress Nvarchar(255);

Update [Portfolio Project]..NashvilleHousing Set
OwnerSplitAddress  = PARSENAME(Replace(OwnerAddress,',', '.'), 3)

Alter Table [Portfolio Project]..NashvilleHousing
add OwnerSplitCity Nvarchar(255);

Update [Portfolio Project]..NashvilleHousing Set
OwnerSplitCity  = PARSENAME(Replace(OwnerAddress,',', '.'), 2)

Alter Table [Portfolio Project]..NashvilleHousing
add OwnerSplitState Nvarchar(255);

Update [Portfolio Project]..NashvilleHousing Set
OwnerSplitState  = PARSENAME(Replace(OwnerAddress,',', '.'), 1)


----------------------------------------------------------------------------------------------------------
--Change Y and N to Yes and No in "sold as Vacant" field

Select Distinct(soldasVacant), Count(SoldAsVacant)
from [Portfolio Project]..NashvilleHousing
Group by SoldAsVacant
order by 2


Select SoldAsVacant, 
Case when SoldAsVacant = 'Y' Then 'Yes'
		when SoldAsVacant = 'N' then 'No'
		Else SoldAsVacant
		End
from [Portfolio Project]..NashvilleHousing


--Update the new rolls

Update [Portfolio Project]..NashvilleHousing
Set SoldAsVacant = Case when SoldAsVacant = 'Y' Then 'Yes'
		when SoldAsVacant = 'N' then 'No'
		Else SoldAsVacant
		End

--------------------
--Remove Duplicates
With RowNumCTE AS(
Select *,
		ROW_NUMBER() over(
		partition by parcelID,
						PropertyAddress,
						SalePrice,
						SaleDate,
						LegalReference
						Order by
							uniqueId
							) row_num
From [Portfolio Project]..NashvilleHousing)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



Select *
From [Portfolio Project]..NashvilleHousing

---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns



Select *
From [Portfolio Project]..NashvilleHousing


ALTER TABLE [Portfolio Project]..NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate
