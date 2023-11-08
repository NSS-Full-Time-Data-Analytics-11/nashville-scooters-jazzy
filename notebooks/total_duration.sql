WITH trip_min AS (
	SELECT sumdid, companyname, startdate, starttime, enddate, endtime, tripduration,
	       CASE WHEN companyname = 'Bolt Mobility' THEN ROUND(tripduration/60,2)
	   		    ELSE tripduration END AS trip_in_min
	FROM trips
	WHERE triproute != '[]'
	ORDER BY tripduration DESC),

calc_time AS (
	SELECT sumdid, companyname, startdate, starttime, enddate, endtime, tripduration, trip_in_min, 
		   (trip_in_min - trip_in_min%1)::INT AS rounded_tripduration,
		   (1440 * (enddate - startdate)) AS day_diff, 
		   EXTRACT(epoch FROM (endtime - starttime))/60 AS min,
		   (EXTRACT(epoch FROM (endtime - starttime))/60)%1 AS round_off,
		   ((1440 * (enddate - startdate)) + (EXTRACT(epoch FROM (endtime - starttime))/60) - (EXTRACT(epoch FROM (endtime - starttime))/60)%1)::INT AS calc_time
	FROM trip_min)

SELECT companyname, sumdid, SUM(tripduration) AS tot_duration,
	   SUM(trip_in_min) AS tot_min,
	   SUM(calc_time) AS tot_calc
FROM calc_time
GROUP BY companyname, sumdid
ORDER BY tot_min;


