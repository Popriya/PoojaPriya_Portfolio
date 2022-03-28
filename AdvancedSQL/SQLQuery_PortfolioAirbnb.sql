---Dataset in airbnb host/property details
Select * from property_details a
WHERE (a.bedrooms & a.beds ) is not NULL

Select * from host_details h
WHERE (h.host_id & h.id) is not NULL

--Using INNER JOIN to display host id who are superhosts with the number of reviews, 
--maximum reviews for each record 
Select h.host_id as [Host_ID], host_name as [Host_Name], number_of_reviews as [No of reviews],
max(number_of_reviews) over () as [Max_Reviews]
From host_details h inner join dbo.property_details p
On h.host_id = p.host_id
WHERE h.host_is_superhost = 't' 
Order by number_of_reviews DESC

--List the maximum monthly price partitioned by all the property_type 
-- having availability for more than 5 days and host is a superhost

Select host_id as [Host_Id],property_type as [Property Type], availability_30 as [Available for more than 5 days],
max(monthly_price) OVER (PARTITION by property_type Order by availability_30) as [Max monthly price]
From property_details
Where HOST_ID in (Select host_id from host_details where host_is_superhost ='t') and (availability_30 >5)
Order by availability_30 asc

--List all hosts property with the average monthly price greater than $1000 and segregated by property type 

Select host_id, property_type,
avg(monthly_price) over(PARTITION by property_type order by monthly_price asc) as [AvgMonthlyPrice] 
From property_details
WHERE monthly_price is not NULL and monthly_price >1000

--List of hosts present in property details table who has reviews greater than 10 are super host in the current year
Select h.host_id as [Host Id], h.host_name as [Host Name], count(number_of_reviews) as [No Of Reviews]
From property_details p Join host_details h
on p.host_id=h.host_id
where h.host_is_superhost ='t'
Group By h.host_id,h.host_name
Having count(number_of_reviews)>10
Order by h.host_name
