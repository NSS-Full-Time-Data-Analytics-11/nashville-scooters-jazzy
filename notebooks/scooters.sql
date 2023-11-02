SELECT *
FROM scooters
LIMIT 10;


SELECT AVG(latitude)  AS avg_lat,  AVG(longitude) AS avg_long, 
	   MIN(latitude)  AS min_lat,  MAX(latitude)  AS max_lat,
	   MIN(longitude) AS min_long, MAX(longitude) AS max_long
FROM scooters
LIMIT 10;

SELECT COUNT(latitude)
FROM scooters;



SELECT *
FROM trips
LIMIT 10;

SELECT startdate, enddate, starttime, endtime
FROM trips
WHERE enddate - startdate > 1
ORDER BY startdate, starttime
LIMIT 10000;


SELECT *
FROM scooters
WHERE chargelevel IS NULL;

SELECT companyname, COUNT(sumdid)
FROM scooters
WHERE chargelevel = 0
GROUP BY companyname;

-- Same query but with distinct
SELECT companyname, COUNT(DISTINCT sumdid)
FROM scooters
WHERE chargelevel = 0
GROUP BY companyname;
-- RESULTS (since it took 90 seconds to complete)
-- Bolt: 118, Gotcha: 193, Jump: 931, Lime: 357, Spin: 538


SELECT sumdid, startdate, starttime,
	   enddate, endtime,
	   startlatitude, startlongitude,
	   endlatitude, endlongitude
FROM trips
ORDER BY sumdid, startdate, starttime
LIMIT 10000;



SELECT pubtimestamp
FROM trips
WHERE CAST(pubtimestamp AS varchar) NOT LIKE '2019-05-27%'
LIMIT 1000;




