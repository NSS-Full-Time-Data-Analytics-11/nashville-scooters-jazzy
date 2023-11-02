## Metro Scooters Analysis
In May of 2018, Bird dropped hundreds of scooters on the streets of Nashville with no permission. In response, Metro sued, which caused Bird to remove and wait for permits. Metro began developing regulations for scooters and other shared urban mobility devices (SUMDs). In 2019, the Metro Council passed legislation enacting a one-year pilot program for scooters. For this project, you have been provided with the data for 3 months of this pilot program with the goal of reporting on usage trends and generating recommendations for quantity and distribution of scooters in Nashville.

Metro would like to know what the ideal density of available scooters is, which balances the objectives of
enabling scooters to serve transportation goals,
discouraging scooters from piling up on sidewalks,
keeping it economically viable for companies to operate equitably in the city.

This data for this project can be downloaded as a Postgres backup from https://drive.google.com/file/d/1BXAfByFvHCwX0G1BvTCQ373qKm7wE4Y-/view?usp=share_link.

Some notes about the data:
* When not in use, each scooter will report its location every five minutes. This data is contained in the scooters table.
* WARNING: Both tables contain a large number of records, so think carefully about what data you need to pull in a given query. If you try and pull in all rows from the scooters table, there is a very good chance that you will crash your notebook!

As you know, it's important to gain an understanding of new datasets before diving headlong into analysis. Here are some suggestions for guiding the process of getting to know the data contained in these tables:
- Are there any null values in any columns in either table?
- What date range is represented in each of the date columns? Investigate any values that seem odd.
- Is time represented with am/pm or using 24 hour values in each of the columns that include time?
- What values are there in the sumdgroup column? Are there any that are not of interest for this project?
- What are the minimum and maximum values for all the latitude and longitude columns? Do these ranges make sense, or is there anything surprising?
-What is the range of values for trip duration and trip distance? Do these values make sense? Explore values that might seem questionable.
- Check out how the values for the company name column in the scooters table compare to those of the trips table. What do you notice?
