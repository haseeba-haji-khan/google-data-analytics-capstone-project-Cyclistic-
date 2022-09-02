---data cleaning and data processing
select ride_id, rideable_type, started_at,ended_at, start_station_name, start_station_id, end_station_name,end_station_id,start_lat, start_lng, end_lat, end_lng, member_casual
into a.dbo.divvy_trip
from
(
select *
from
a.dbo.[202004-divvy-tripdata]
union
select *
from
a.dbo.[202005-divvy-tripdata] 
union
select *
from
a.dbo.[202006-divvy-tripdata]
union
select *
from
a.dbo.[202007-divvy-tripdata]
union
select *
from
a.dbo.[202008-divvy-tripdata]
union
select *
from
a.dbo.[202009-divvy-tripdata]
union
select *
from
a.dbo.[202010-divvy-tripdata]
union
select *
from
a.dbo.[202011-divvy-tripdata]
union
select *
from
a.dbo.[202012-divvy-tripdata]
union
select *
from
a.dbo.[202101-divvy-tripdata]
union
select *
from
a.dbo.[202102-divvy-tripdata]
union
select *
from
a.dbo.[202103-divvy-tripdata]
union
select *
from
a.dbo.[202104-divvy-tripdata]
) as a
---

---
select * 
from
a.dbo.divvy_trip
order by started_at
---
select distinct rideable_type
from
a.dbo.divvy_trip
-----checking start station name

select distinct start_station_name
from
a.dbo.divvy_trip
-----
select *
from
a.dbo.divvy_trip
where start_station_name is null or start_station_id is null
---
delete 
from
a.dbo.divvy_trip
where start_station_name is null
or start_station_id is null
------
select distinct end_station_name
from
a.dbo.divvy_trip
---
select *
from
a.dbo.divvy_trip
where end_station_name is null or end_station_id is null
---
delete 
from
a.dbo.divvy_trip
where end_station_name is null
or end_station_id is null
-----finding duplicates
select ride_id, count(ride_id)
from
a.dbo.divvy_trip
group by ride_id
having count(ride_id) > 1

---
with cte as (
select
ride_id, ROW_NUMBER() over (
partition by
ride_id order by
ride_id) row_num
from
a.dbo.divvy_trip
)
delete from cte
where
row_num > 1
----)


----creating new column 
alter table a.dbo.divvy_trip
add 
ride_length int,
[year] int,
[date] date,
day_of_the_week nchar(15),
[month] nchar(15)
----
select * 
from
a.dbo.divvy_trip
order by started_at
---
update
a.dbo.divvy_trip
set
ride_length = DATEDIFF(minute, started_at, ended_at),
[year] = datepart(year, started_at),
[month] = datename(month, started_at),
[date] = cast(started_at as date),
day_of_the_week = datename(weekday, started_at)
---
select * 
from
a.dbo.divvy_trip
order by started_at
---
select *
from
a.dbo.divvy_trip
where
ride_length is null or ride_length <= 0
---
delete
from
a.dbo.divvy_trip
where
ride_length is null or ride_length <= 0
---


----descriptive analysis
----calculate maximum minimum and average of ride length
SELECT max(ride_length) AS max_ride_length, min(ride_length) AS min_ride_length, avg(ride_length) AS average_ride_length
FROM a.dbo.divvy_trip
-----checking top day of weak where number of ride is maximum
select top 1 day_of_the_week 
from 
a.dbo.divvy_trip
group by day_of_the_week
order by count(*) desc
---checking top month where number of ride is maximum
select top 1 month
from 
a.dbo.divvy_trip
group by month
order by count(*) desc
--- average ride length for member and casual rider
SELECT  avg(ride_length) AS average_ride_length , member_casual
FROM a.dbo.divvy_trip
group by member_casual
order by COUNT(*)
 ---  average ride length for member and casual by day of week
SELECT  avg(ride_length) AS average_ride_length , day_of_the_week, member_casual
FROM a.dbo.divvy_trip
group by member_casual, day_of_the_week
order by member_casual desc, average_ride_length desc

---calculate average ride length for member and casual by month
SELECT  avg(ride_length) AS average_ride_length , month, member_casual
FROM a.dbo.divvy_trip
group by member_casual, [month]
order by member_casual desc, average_ride_length desc
---- average ride length, total number of rides for member and casual by month 
SELECT  avg(ride_length) AS average_ride_length , month, count(distinct(ride_id)) as number_of_ride, member_casual
FROM a.dbo.divvy_trip
group by member_casual, month
order by average_ride_length desc, number_of_ride desc  
------ average ride length, total numer of rides of member and casual by day of the week
SELECT  avg(ride_length) AS average_ride_length , day_of_the_week, count(distinct(ride_id)) as number_of_ride, member_casual
FROM a.dbo.divvy_trip
group by member_casual, day_of_the_week
order by average_ride_length desc, number_of_ride desc 
------checking average ride length,rideable type and total number of rides for member and casual 

SELECT  avg(ride_length) AS average_ride_length , rideable_type, count(distinct(ride_id)) as number_of_ride, member_casual
FROM a.dbo.divvy_trip
group by member_casual, rideable_type
order by average_ride_length desc, number_of_ride desc 
----checking number of rides for member and casual by start station name
select start_station_name, start_station_id, count(ride_id) as number_of_ride, member_casual
from
a.dbo.divvy_trip
group by start_station_name, start_station_id, member_casual
ORDER BY number_of_ride desc
----checking number of rides for member and casual by end station name
select end_station_name, end_station_id, count(ride_id) as number_of_id, member_casual
from
a.dbo.divvy_trip
group by end_station_name, end_station_id, member_casual
ORDER BY number_of_id desc
----


