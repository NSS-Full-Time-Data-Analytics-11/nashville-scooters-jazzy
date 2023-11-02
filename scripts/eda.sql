SELECT DISTINCT scooters.companyname,
	   COUNT (DISTINCT trips.sumdid)
FROM scooters
	INNER JOIN trips USING (sumdid)
GROUP BY scooters.companyname


SELECT DISTINCT companyname
FROM trips;