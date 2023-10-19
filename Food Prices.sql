SELECT * FROM food_prices.prices;

-- Q1. Count of records
SELECT COUNT(date)
FROM food_prices.prices;

-- Q2. Find out from how many states data are taken 

SELECT count(DISTINCT admin1) as state
FROM food_prices.prices
WHERE admin1 is not null;

-- Q3. How to find out the states which have had the highest prices of Rice under cereals and tubers category - Retail purchases

SELECT admin1 as state,market,category,commodity,pricetype,max(price) as maxprice
FROM food_prices.prices
WHERE category = "cereals and tubers" AND pricetype = "Retail" AND commodity ="Rice"
GROUP BY state, market
ORDER BY maxprice desc;

-- Q4. Find out the states and market which have had the highest prices of Rice under cereals and tubers category- Wholesale purchases

SELECT admin1 as state,market,category,commodity,pricetype,max(price) as maxprice
FROM food_prices.prices
WHERE category = "cereals and tubers" AND pricetype = "Wholesale" AND commodity ="Rice"
GROUP BY state, market
ORDER BY maxprice desc;

-- Q5.Find out the states and market which have had the highest prices of Milk under milk and dairy category- Retail purchases only

SELECT admin1 as state,market,category,commodity,pricetype,max(price) as maxprice
FROM food_prices.prices
WHERE category = "milk and dairy" AND pricetype = "Retail" AND commodity ="Milk"
GROUP BY state, market
ORDER BY maxprice desc;

-- Q6.Find out the states and market which have had the highest prices of Milk (pasteurized) under milk and dairy category- Retail purchases only

SELECT admin1 as state,market,category,commodity,pricetype,max(price) as maxprice
FROM food_prices.prices
WHERE category ="milk and dairy" AND pricetype = "Retail" AND commodity ="Milk (pasteurized)"
GROUP BY state, market
ORDER BY maxprice desc;

-- Q7. Find out the states and market which have had the highest prices of Ghee (vanaspati) under oil and fats- Retail purchases only

SELECT admin1 as state,market,category,commodity,pricetype,max(price) as maxprice
FROM food_prices.prices
WHERE admin1 is not null AND category ="oil and fats" AND commodity ="Ghee (vanaspati)"
GROUP BY state, market
ORDER BY maxprice desc;

-- Q8. Finding out the avegarge price for each type of oil under oil and fats

SELECT commodity, avg(price) as Average_price
FROM food_prices.prices
WHERE category ="oil and fats" 
GROUP BY commodity;

-- Q9. Finding out the avegarge price of oil and fats as whole

SELECT AVG(price) as Averageprice
FROM food_prices.prices
WHERE category ="oil and fats";

-- Q10. Finding out the average prices of lentils

SELECT commodity, avg(price) as Average_price
FROM food_prices.prices
WHERE category ="pulses and nuts"
GROUP BY commodity ;

-- Q11. Finding out the average price of Onions and tomatoes

SELECT commodity, AVG(price) as Averageprice
FROM food_prices.prices
WHERE category ="vegetables and fruits" 
GROUP BY commodity ;

-- Q12 Find out which commodity has the highest price 

SELECT date, admin1 as state,market,category,commodity,pricetype,max(price) as maxprice
FROM food_prices.prices
WHERE pricetype = "Retail"
GROUP BY commodity 
ORDER BY maxprice desc;

-- Q13 Create a table for zones
-- Select city and State from food prices ind table and insert it into zones table

USE food_prices;
-- DROP Table if exists zones;
CREATE TABLE `zones` (
  `City` VARCHAR(255),
  `State` VARCHAR (255),
  `zone` VARCHAR(255),
  PRIMARY KEY(`City`, `State`)
);

Insert into zones
select DISTINCT admin2, admin1, NULL
from food_prices.prices
where admin2 is not NULL;

SET SQL_SAFE_UPDATES = 0;

UPDATE `zones` SET zone ='South'  WHERE State LIKE 'Tamil Nadu';
UPDATE `zones` SET zone ='South'  WHERE State LIKE 'Telangana';
UPDATE `zones` SET zone ='South'  WHERE State LIKE 'Andhra Pradesh';
UPDATE `zones` SET zone ='South'  WHERE State LIKE 'Kerala';
UPDATE `zones` SET zone ='South'  WHERE State LIKE 'Karnataka';

update `zones`set zone = 'North' WHERE State = 'Himachal Pradesh';
update `zones`set zone = 'North' WHERE State = 'Punjab';
update `zones`set zone = 'North' WHERE State = 'Uttarakhand';
update `zones`set zone = 'North' WHERE State = 'Uttar Pradesh';
update `zones`set zone = 'North' WHERE State = 'Haryana';

update `zones`set zone = 'East' WHERE State = 'Bihar';
update `zones`set zone = 'East' WHERE State = 'Orissa';
update `zones`set zone = 'East' WHERE State = 'Jharkhand';
update `zones`set zone = 'East' WHERE State = 'West Bengal';

update `zones`set zone = 'West' WHERE State = 'Rajasthan';
update `zones`set zone = 'West' WHERE State = 'Gujarat';
update `zones`set zone = 'West' WHERE State = 'Goa';
update `zones`set zone = 'West' WHERE State = 'Maharashtra';

update `zones`set zone = 'Central' WHERE State = 'Madhya Pradesh';
update `zones`set zone = 'Central' WHERE State = 'Chhattisgarh';

update `zones`set zone = 'North East' WHERE State = 'Assam';
update `zones`set zone = 'North East' WHERE State = 'Sikkim';
update `zones`set zone = 'North East' WHERE State = 'Manipur';
update `zones`set zone = 'North East' WHERE State = 'Meghalaya';
update `zones`set zone = 'North East' WHERE State = 'Nagaland';
update `zones`set zone = 'North East' WHERE State = 'Mizoram';
update `zones`set zone = 'North East' WHERE State = 'Tripura';
update `zones`set zone = 'North East' WHERE State = 'Arunachal Pradesh';

update `zones`set zone = 'Union Territory' WHERE State = 'Chandigarh';
update `zones`set zone = 'Union Territory' WHERE State = 'Delhi';
update `zones`set zone = 'Union Territory' WHERE State = 'Puducherry';
update `zones`set zone = 'Union Territory' WHERE State = 'Andaman and Nicobar';

-- Q15 JOIN zones table and food_prices_ind AND Create a view

Create view commodity_prices as
Select fo.date,zo.City,zo.State,fo.market,zo.zone,fo.latitude,fo.longitude,fo.category,fo.commodity,fo.unit,fo.priceflag,fo.pricetype,fo.currency,fo.price,fo.usdprice
from zones zo
JOIN food_prices.prices fo
WHERE zo.State = fo.admin1;

select DISTINCT market
from commodity_prices;

-- Q16 Average price of commodities zone wise 

Select date,zone,category,commodity, AVG(price) as Average_price
FROM commodity_prices
WHERE date = "15/07/22"
Group by zone,category,commodity
order by commodity,Average_price DESC;

-- Q17 Find out the price differences between  2022 and 2012 

DROP Table if exists price_differencesB;
Create Table price_differencesB
(State varchar(255),
zone varchar(255),
category varchar(255),
commodity varchar(255),
Average_price_2012 double);

INSERT INTO price_differencesB
SELECT State,zone,category,commodity,round(avg(price)) from commodity_prices
WHERE date = "15/12/12" AND pricetype = "Retail"
group by 1,2,3,4;

DROP Table if exists price_differencesC;
Create Table price_differencesC
(State varchar(255),
zone varchar(255),
category varchar(255),
commodity varchar(255),
Average_price_2022 double);

INSERT INTO price_differencesC
SELECT State,zone,category,commodity,round(avg(price)) from commodity_prices
WHERE date = "15/07/22" and pricetype = "Retail"
group by 1,2,3,4;

SELECT B.State,B.zone,B.category,B.commodity,B.Average_price_2012,C.Average_price_2022,C.Average_price_2022 - B.Average_price_2012 as Diff_bw_price
FROM price_differencesB B
JOIN price_differencesC C
WHERE B.category = C.category AND B.commodity = C.commodity
order by zone;

-- Q18 Find out the average prices of each category food products zone wise

-- South zone has the highest avg price for cereals and tubers(Potatoes,rice,wheat,wheat flour),North zone hasthe lowest average
-- North East zone has the highest avg price for Milk and dairy, South zone has the lowest average
-- North East zone has the highest avg price for Miscellaneous food(Sugar,salt,jaggery,Tea(black)),Union territory has the lowest average
-- Union Territory has the highest avg price for oil and fats(Ghee,Groundnut,Mustard,palm,soybean,sunflower),Central has the lowest average
-- Union Territory,North East has the highest avg price for pulses and nuts(chickpeas and other types of lentils), Central has the lowest average
-- North East zone has the highest avg price for vegetablesand fruits, South has the lowest average

SELECT zone,category, round(avg(price)) as avgprice
from commodity_prices
where pricetype = "Retail" and date = "15/07/22" 
group by 1,2
order by category,avgprice DESC;

-- Q19 Find out the average prices of each commodity zone wise

SELECT zone,commodity, round(avg(price)) as avgprice
from commodity_prices
where pricetype = "Retail" and date = "15/07/22" 
group by 1,2
order by commodity,avgprice DESC;
