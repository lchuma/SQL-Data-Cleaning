--Cleaning Dat in SQL Queries
use [Portfolio Project]

select *
from [Portfolio Project]..NashvilleHousing

-- Standardize Date Format


select SaleDateConverted, CONVERT(Date,SaleDate)
from [Portfolio Project]..NashvilleHousing

UPDATE NashvilleHousing
set SaleDate = CONVERT(Date,SaleDate)

Alter Table Nashvillehousing 
add SaleDateConverted Date;

UPDATE NashvilleHousing
set SaleDateConverted = CONVERT(Date,SaleDate)


--Populate Property Addrress data


select *
from [Portfolio Project]..NashvilleHousing
--where PropertyAddress is Null
order by ParcelID


select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
from [Portfolio Project]..NashvilleHousing a
Join [Portfolio Project]..NashvilleHousing b
on a.ParcelID= b.ParcelID
and a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null

Update a
Set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from [Portfolio Project]..NashvilleHousing a
Join [Portfolio Project]..NashvilleHousing b
on a.ParcelID= b.ParcelID
and a.[UniqueID ]<> b.[UniqueID ]

--Breaking out address into Individual Columns  (Address, City, State)

Select PropertyAddress
From [Portfolio Project]..NashvilleHousing
--where propertyaddress in null
--order by ParcelID	

Select SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress )-1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress )+1, len(PropertyAddress))as Address
From [Portfolio Project]..NashvilleHousing



Alter Table Nashvillehousing 
add PropertySplitAddress nvarchar (255);

UPDATE NashvilleHousing
set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress )-1)


Alter Table Nashvillehousing 
add PropertySplitCity nvarchar (255);

UPDATE NashvilleHousing
set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress )+1, len(PropertyAddress))

select *
From [Portfolio Project]..NashvilleHousing

--Splitting Owner Address in a different way than the top formula

select OwnerAddress
From [Portfolio Project]..NashvilleHousing


select
PARSENAME(REPLACE(OwnerAddress, ',','.') ,3),
PARSENAME(REPLACE(OwnerAddress, ',','.') ,2),
PARSENAME(REPLACE(OwnerAddress, ',','.') ,1)
From [Portfolio Project]..NashvilleHousing

Alter Table Nashvillehousing 
add OwnerSplitAddress nvarchar (255);

UPDATE NashvilleHousing
set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',','.') ,3)


Alter Table Nashvillehousing 
add OwnerSplitCity nvarchar (255);

UPDATE NashvilleHousing
set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',','.') ,2)
Alter Table Nashvillehousing 
add OwnerSplitState nvarchar (255);

UPDATE NashvilleHousing
set OwnerSplitState= PARSENAME(REPLACE(OwnerAddress, ',','.') ,1)

select *
From [Portfolio Project]..NashvilleHousing


--Change Y and N to Yes and NO in "Sold as Vacant" field

Select distinct (SoldAsVacant), count(SoldAsVacant)  ---trying to see how many Y an N do we have
From [Portfolio Project]..NashvilleHousing
Group by SoldAsVacant
order by 2


select SoldAsVacant,
Case When SoldAsVacant = 'Y' Then 'YES' 
     when SoldAsVacant = 'N' Then 'No'
     Else SoldAsVacant
     End
From [Portfolio Project]..NashvilleHousing


Update NashvilleHousing
Set SoldAsVacant =
Case When SoldAsVacant = 'Y' Then 'YES' 
     when SoldAsVacant = 'N' Then 'No'
     Else SoldAsVacant
     End

	 ----Remove Duplicatesele

	 With RowNumCTE AS (                     -- We applied CTE

	 select *,
	 Row_Number () over (
	 Partition By ParcelID,
	              PropertyAddress,
				  SalePrice,
				  SaleDate,
				  LegalReference

				  order by uniqueid
				  ) row_num


From [Portfolio Project]..NashvilleHousing
--order by ParcelID
)
Select *--/Delete                             ---- Changed Select to Delete
from RowNumCTE
Where row_num > 1
--order by PropertyAddress


--Delete Unused Columns

select *
From [Portfolio Project]..NashvilleHousing

Alter Table [Portfolio Project]..NashvilleHousing

Drop Column OwnerAddress, TaxDistrict, PropertyAddress                              ---We have Deleted Columns we have used at our top queiries  

Alter Table [Portfolio Project]..NashvilleHousing

Drop Column SaleDate