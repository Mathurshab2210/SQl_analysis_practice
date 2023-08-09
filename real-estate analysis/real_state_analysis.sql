-- Data Exploration Project: Real Estate License Analysis
SELECT * FROM real_estate_analysis.realstate;
show Columns from realstate;
-- 1. Retrieve basic information about the dataset
SELECT COUNT(*) AS TotalRecords, COUNT(DISTINCT BusinessName) AS UniqueBusinesses,
       COUNT(DISTINCT LicenseHolderName) AS UniqueLicenseHolders,count(distinct licensetype)
FROM realstate;
-- 2. Get an overview of license types and their counts:
SELECT LicenseType, COUNT(*) AS LicenseCount
FROM realstate
GROUP BY LicenseType
ORDER BY LicenseCount DESC;

-- Step 2: License Holder Analysis
-- Identify the top license holders by license count:
select licenseholdername as lhm,count(*) as cnt from 
realstate
group by lhm
order by cnt desc
limit 10;

-- Step 3: Geographic Analysis
--  Explore the distribution of businesses across states:
select BusinessState,count(BusinessName) as cnt
from realstate
group by businessstate;

-- Determine the top cities with the most licenses:
select BusinesCity,count(BusinessName) as cnt
from realstate
group by BusinesCity
order by cnt desc
limit 10 ;

-- Step 4: License Expiration Analysis:
select curdate();
SET SQL_SAFE_UPDATES = 0;
UPDATE `real_estate_analysis`.`realstate`
SET `LicenseExpirationDate` = STR_TO_DATE(`LicenseExpirationDate`, '%m/%d/%Y')
WHERE `LicenseExpirationDate` IS NOT NULL AND `LicenseExpirationDate` <> '';

-- Analyze licenses expiring in the next 60 days:
SELECT BusinessName, COUNT(*) AS ExpiringLicenseCount
FROM realstate
WHERE LicenseExpirationDate BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 60 day)
GROUP BY BusinessName
ORDER BY ExpiringLicenseCount;

-- Step 5: Detailed License Holder Analysis
-- Examine licenses held by a specific license holder:
select businessname,licensetype,count(businessname) as cnt
from realstate
where LicenseType in ('CORPORATE BROKER','CORPORATE BROKER')
group by businessname ,LicenseType
order by  cnt desc;
select distinct LicenseType  from realstate;

-- Compare license counts for multiple license holders:
select businessname,licenseholdername,count(*) as cnt 
from realstate
where licenseholdername in ('AUER JANET','Ajamian Margaret A')
group by businessname,licenseholdername
order by businessname,licenseholdername;

select distinct licenseholdername from realstate;


-- Step 6: Additional Insights
-- dentify license holders with licenses across multiple businesses:
SELECT LicenseHolderName, COUNT(DISTINCT BusinessName) AS BusinessCount
FROM realstate
GROUP BY LicenseHolderName
HAVING BusinessCount > 1
ORDER BY BusinessCount DESC;

--  Ranking of License Holders by License Expiration Date:
-- Show the rank of license holders based on their license expiration dates within each business.
SELECT
    BusinessName,
    LicenseHolderName,
    LicenseExpirationDate,
    RANK() OVER(PARTITION BY BusinessName ORDER BY LicenseExpirationDate) AS Expiration_Rank
FROM realstate;

--  Get businesses with the maximum number of license holders.
WITH BusinessLicenseCounts AS (
    SELECT BusinessName, COUNT(*) AS License_Count
    FROM REALSTATE
    GROUP BY BusinessName
)
SELECT BusinessName, License_Count
FROM BusinessLicenseCounts
WHERE License_Count = (SELECT MAX(License_Count) FROM BusinessLicenseCounts);
--  Rank businesses based on the number of licenses they hold.
SELECT businessname,count(*) as cnt,
dense_rank() over(partition by businessname order by count(*) desc) as rnk
from realstate
group by businessname
order by cnt desc;
-- Calculate the running total of licenses issued for each business
SELECT BusinessName, LicenseExpirationDate, LicenseHolderName,
       SUM(1) OVER (PARTITION BY BusinessName ORDER BY LicenseExpirationDate) AS Running_Total
FROM realstate
ORDER BY BusinessName, LicenseExpirationDate;
