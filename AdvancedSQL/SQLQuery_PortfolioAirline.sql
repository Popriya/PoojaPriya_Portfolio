--Advanced sql: Demonstrating Windows Function with airline dataset

--Selecting features to be analysed in airline dataset
Select Id, Gender, Age, Departure_Delay_In_Minutes, Arrival_Delay_In_Minutes, Inflight_wifi_service, Satisfaction
From Airline
Where Id is not NULL

--Adding Row_number to all records
Select Id, Gender, Age, Departure_Delay_In_Minutes, Arrival_Delay_In_Minutes, Inflight_wifi_service, Satisfaction, 
ROW_NUMBER() OVER (PARTITION by satisfaction order by satisfaction) as row_num
From airline
Where Gender is not NULL

--Giving rank based on inflight wifi service ratings starting from 0 to 5
Select Id, Gender, Age, Departure_Delay_In_Minutes, Arrival_Delay_In_Minutes, Inflight_wifi_service, Satisfaction, 
ROW_NUMBER() OVER (PARTITION by satisfaction order by satisfaction) as row_num,
RANK() OVER (PARTITION by satisfaction order by Inflight_wifi_service asc) as rnk
From airline
Where Gender is not NULL

-- Using Dense rank
Select Id, Gender, Age, Departure_Delay_In_Minutes, Arrival_Delay_In_Minutes, Inflight_wifi_service, Satisfaction, 
ROW_NUMBER() OVER (PARTITION by satisfaction order by satisfaction) as row_num,
DENSE_RANK() OVER (PARTITION by satisfaction order by Inflight_wifi_service asc) as rnk
From airline
Where Gender is not NULL

--Selecting rows with ranking less than 3 based on inflight wifi service ratings starting from 0 to 5 with their respective row numbers
-- for top 100 records
Select TOP 100 *
from(
    Select Id, Gender, Age, Departure_Delay_In_Minutes, Arrival_Delay_In_Minutes, Inflight_wifi_service, Satisfaction,
    ROW_NUMBER() OVER (PARTITION by satisfaction order by satisfaction) as row_num,
    RANK() OVER (PARTITION by satisfaction order by Inflight_wifi_service) as rnk
    from airline
    where gender is not NULL) x
where x.rnk <3
ORDER BY Id;

--Calculating maximum delay in arrival time based on airline satisfaction 
Select Id, Gender, Age, Departure_Delay_In_Minutes, Arrival_Delay_In_Minutes, Inflight_wifi_service, Satisfaction, 
max(arrival_delay_in_minutes) OVER(PARTITION by satisfaction) as [Max_Delay_In_Arrival]
From Airline
Where Id is not NULL
Group By Id, Gender, Age, Departure_Delay_In_Minutes, Arrival_Delay_In_Minutes, Inflight_wifi_service, Satisfaction
 
--To demonstrate lag, lead in Food_and_drink column 
Select Id, Gender, Age, Food_and_drink,
lag(Food_and_drink) OVER (Partition By Satisfaction order by Id) as prev_fnd_rating,
lead(Food_and_drink) OVER (Partition By Satisfaction order by Id) as next_fnd_rating
From Airline a
Where Id is not NULL

--To find a query to display if the Food_and_drink rating is higher , lower or equal to previous passengers 
--ratings
Select Id, Gender, Age, Food_and_drink,
lag(Food_and_drink) OVER (Partition By Satisfaction order by Id) as prev_fnd_rating,
Case when a.Food_and_drink > lag(Food_and_drink) OVER (Partition By Satisfaction order by Id) THEN 'Higher than previous rating by a passenger'
     when a.Food_and_drink < lag(Food_and_drink) OVER (Partition By Satisfaction order by Id) THEN 'Lower than previous rating by a passenger'
     when a.Food_and_drink = lag(Food_and_drink) OVER (Partition By Satisfaction order by Id) THEN 'Equal to previous rating by a passenger'
     END FND_rating
From Airline a
Where Id is not Null
