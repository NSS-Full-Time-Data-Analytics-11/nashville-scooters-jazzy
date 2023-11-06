WITH trip_min AS (
	SELECT companyname, startdate, starttime, enddate, endtime, tripduration,
	       CASE WHEN companyname = 'Bolt Mobility' THEN ROUND(tripduration/60,2)
	   		    ELSE tripduration END AS trip_in_min
	FROM trips
	ORDER BY tripduration DESC),

calc_diff AS (
	SELECT companyname, startdate, starttime, enddate, endtime, trip_in_min, 
		   (trip_in_min - trip_in_min%1)::INT AS rounded_tripduration,
		   (1440 * (enddate - startdate)) AS day_diff, 
		   EXTRACT(epoch FROM (endtime - starttime))/60 AS min,
		   (EXTRACT(epoch FROM (endtime - starttime))/60)%1 AS round_off,
		   ((1440 * (enddate - startdate)) + (EXTRACT(epoch FROM (endtime - starttime))/60) - (EXTRACT(epoch FROM (endtime - starttime))/60)%1)::INT AS calc_diff
	FROM trip_min
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
