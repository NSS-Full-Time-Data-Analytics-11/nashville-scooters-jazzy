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
--WHERE chargelevel = 0
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


SELECT startdate AS date, starttime, endtime, tripduration, (tripduration - tripduration%1)::INT AS rounded_tripduration,
	   (EXTRACT(epoch FROM (endtime - starttime)) / 60)::INT AS diff
	   --DATE_PART('minute', (endtime - starttime)) AS calc_diff
FROM trips
WHERE (startdate = enddate) AND (DATE_PART('minute', (endtime - starttime)) <> (tripduration - tripduration%1)::INT)
ORDER BY tripduration DESC;




WITH calc_diff AS (
	SELECT companyname, startdate, starttime, enddate, endtime, tripduration, 
		   (tripduration - tripduration%1)::INT AS rounded_tripduration,
		   (1440 * (enddate - startdate)) AS day_diff, 
		   EXTRACT(epoch FROM (endtime - starttime))/60 AS min,
		   (EXTRACT(epoch FROM (endtime - starttime))/60)%1 AS round_off,
		   ((1440 * (enddate - startdate)) + (EXTRACT(epoch FROM (endtime - starttime))/60) - (EXTRACT(epoch FROM (endtime - starttime))/60)%1)::INT AS calc_diff
	FROM trips
	--WHERE companyname = 'Bolt Mobility'
	--WHERE ((1440 * (enddate - startdate)) + (EXTRACT(epoch FROM (endtime - starttime))/60) - (EXTRACT(epoch FROM (endtime - starttime))/60)%1)::INT <> (tripduration - tripduration%1)::INT
	--ORDER BY tripduration DESC
	),
	
total_trips AS (
	SELECT companyname, COUNT(startdate) AS total
	FROM trips
	GROUP BY companyname
	ORDER BY total DESC),
	
time_error AS (
	SELECT companyname, COALESCE(SUM(CASE WHEN rounded_tripduration NOT IN (calc_diff-1, calc_diff, calc_diff +1) THEN 1 END),0) AS errors
	FROM calc_diff
	GROUP BY companyname
	ORDER BY errors DESC)

SELECT companyname, errors, total,
	   ROUND((errors::decimal / total::decimal) * 100, 2) AS error_pct
FROM total_trips INNER JOIN time_error USING (companyname)
ORDER BY error_pct DESC;




SELECT startdate, enddate, enddate - startdate AS diff
FROM trips
WHERE enddate <> startdate
LIMIT 100;



SELECT *
FROM trips
WHERE starttime::varchar LIKE '__:__:___%';



SELECT *
FROM trips
WHERE enddate < startdate;


