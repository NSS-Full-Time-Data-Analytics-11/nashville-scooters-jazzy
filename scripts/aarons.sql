WITH cte1 AS (SELECT pubtimestamp::date,
    		companyname,
    		sumdid, 
			startdate+starttime AS trip_start,
			enddate+endtime AS trip_end
			FROM TRIPS),
	cte2 as 
	 	(SELECT pubdatetime::date AS pubtimestamp, 
		 		sumdid, 
		 		costpermin,
		 		companyname
			FROM (SELECT pubdatetime, 
				  		 sumdid, 
				  		 costpermin,
				  	CASE WHEN companyname = 'Bolt' THEN 'Bolt Mobility'
		 				 WHEN companyname = 'Jump' THEN 'JUMP' 
				  		 WHEN companyname = 'Spin' THEN 'SPIN' ELSE companyname END AS companyname 
				  --this subbquery is so we can join on company name bellow
		  			FROM scooters) AS scooters2 
			GROUP BY sumdid, companyname, pubtimestamp, costpermin)
SELECT 
    pubtimestamp::date AS date,
    companyname,
	costpermin,
    sumdid, 
	tripduration,
	trip_start,
	trip_end,
	SUM(ROUND(EXTRACT(EPOCH FROM (trip_end::timestamp - trip_start::timestamp)) / 60.0, 2)) AS total_min_per_day_used,
	ROUND((SUM(ROUND(EXTRACT(EPOCH FROM (trip_end - trip_start)) / 60.0, 2)) / 1440.0 * 100)::numeric, 3) || '%' AS trip_use_per_day_percent

FROM trips
FULL JOIN cte1 USING(pubtimestamp, companyname, sumdid)
FULL JOIN cte2 USING(pubtimestamp, sumdid, companyname)
GROUP BY sumdid, companyname, date, costpermin, tripduration, trip_start, trip_end
ORDER BY total_min_per_day_used DESC NULLS LAST;