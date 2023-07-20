
--DATA CLEANING PROJECT

Select *
From PortfolioProjects..NashvilleHousingg


--Standardizing the Date format

Select SaleDateConverted, CONVERT(Date, SaleDate) as DateOnly
From PortfolioProjects..NashvilleHousingg


Update PortfolioProjects..NashvilleHousingg
Set SaleDate = CONVERT(Date, SaleDate) 


ALTER TABLE PortfolioProjects..NashvilleHousingg
Add SaleDateConverted Date;

Update PortfolioProjects..NashvilleHousingg
Set SaleDateConverted = CONVERT(Date, SaleDate) 



--Property Address

Select *
From PortfolioProjects..NashvilleHousingg
--where PropertyAddress is null
order by ParcelID



Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProjects..NashvilleHousingg a
Join PortfolioProjects..NashvilleHousingg b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]

where a.PropertyAddress is null

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProjects..NashvilleHousingg a
Join PortfolioProjects..NashvilleHousingg b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]




--Breaking out Address into Individual Columns (Address, City, State)

Select PropertyAddress
From PortfolioProjects..NashvilleHousingg


Select SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address, 
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as SecondAddress
From PortfolioProjects..NashvilleHousingg


ALTER TABLE PortfolioProjects..NashvilleHousingg
Add PropertySplitAddress nvarchar(255);

Update PortfolioProjects..NashvilleHousingg
Set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE PortfolioProjects..NashvilleHousingg
Add PropertySplitCity nvarchar(255);

Update PortfolioProjects..NashvilleHousingg
Set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) 


Select *
From PortfolioProjects..NashvilleHousingg


Select OwnerAddress
From PortfolioProjects..NashvilleHousingg


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
From PortfolioProjects..NashvilleHousingg



ALTER TABLE PortfolioProjects..NashvilleHousingg
Add OwnerSplitAddress nvarchar(255);

Update PortfolioProjects..NashvilleHousingg
Set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

ALTER TABLE PortfolioProjects..NashvilleHousingg
Add OwnerSplitCity nvarchar(255);

Update PortfolioProjects..NashvilleHousingg
Set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2) 


ALTER TABLE PortfolioProjects..NashvilleHousingg
Add OwnerSplitState nvarchar(255);

Update PortfolioProjects..NashvilleHousingg
Set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)



--Replacing all the Y and N with Yes and No

Select Distinct(SoldAsVacant), COUNT(SoldAsVacant)
From PortfolioProjects..NashvilleHousingg
group by SoldAsVacant
order by 2


Select SoldAsVacant,
CASE
	When SoldAsVacant = 'Y' Then 'Yes'
	When SoldAsVacant = 'N' Then 'No'

	Else SoldAsVacant
END
From PortfolioProjects..NashvilleHousingg

Update PortfolioProjects..NashvilleHousingg
SET SoldAsVacant = CASE
	When SoldAsVacant = 'Y' Then 'Yes'
	When SoldAsVacant = 'N' Then 'No'

	Else SoldAsVacant
END


--Removing Duplicates

With RowNumCTE As(
Select *,
ROW_NUMBER() Over (Partition by ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference 
ORDER by UniqueID) row_num
From PortfolioProjects..NashvilleHousingg
--order by ParcelID
)
select *
from RowNumCTE
Where row_num > 1
order by PropertyAddress




--Deleting Unused Columns

Select *
From PortfolioProjects..NashvilleHousingg

Alter Table PortfolioProjects..NashvilleHousingg
Drop Column OwnerAddress, TaxDistrict, PropertyAddress

Alter Table PortfolioProjects..NashvilleHousingg
Drop Column SaleDate