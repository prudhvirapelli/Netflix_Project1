---netflix Project
create table netflix
(
show_id	varchar(6),
type varchar(10),	
title varchar(150),
director varchar(208),
casts varchar(1000),
country varchar(150),
date_added varchar(50),
release_year  int ,
rating varchar(10),
duration varchar(15),
listed_in varchar(100),
description varchar(250)

);

select * from netflix;
-- deleting table
drop table if exists netflix;
--- total content
select count(*) as total_content from netflix;
--- 
select coun distinct type from  netflix;
--- 15 questions business questions

--3. List All Movies Released in a Specific Year (e.g., 2020)

select * from netflix
where type = 'Movie'
and release_year = 2020;

--4. Find the Top 5 Countries with the Most Content on Netflix

select 
  unnest(string_to_array(country,  ',')) as new_country,
  count(show_id) as total_content
  from netflix
  group by 1
  order by 2 desc
  limit 5;

---5. Identify the Longest Movie

select * from netflix
where

 type = 'Movie'
 and
 duration = (select max(duration) from netflix)


--6. Find Content Added in the Last 5 Years

select * from netflix
where
to_date(date_added,'Month ,DD,YYY') >= Current_date - interval '5 years'





--7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'

select show_id, title ,director from netflix
where director ilike '%Rajiv Chilaka%';

--8. List All TV Shows with More Than 5 Seasons
select  *,type, title, duration from netflix
where duration >'5 seasons' and type = 'TV Show'

----9. Count the Number of Content Items in Each Genre
select listed_in,count(show_id),
unnest(string_to_array(listed_in, ','))
from netflix
group by 1;

--10.Find each year and the average numbers of content release in India on netflix.
select 
extract(year from to-date(date_added,'Month DD,YYYY')) as year,count(*)
from netflix
 where country = 'India'
 group by 1;

--11. List All Movies that are Documentaries

select * from netflix where
listed_in ilike '%documentaries%'



--12. Find All Content Without a Director

select * from netflix
where director is null;


--13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years
select * from netflix 
where casts ilike '%salman khan%'
and 
release_year > extract(year from current_date)-10

--14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India

select unnest(string_to_array(casts, ',')) AS actors,
count(*) as total_content
from netflix
where country ilike '%india%'
group by 1
order by 2 desc
limit 10


--15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords.label content containing these keywords as 'bad' and all other content as 'good'. count how many fall into each caregory





with new_table as
(

select * ,
 case 
 when 
 description ilike '%kills%'
 or 
 description ilike '%violence%' 
 then 'Bad_Content'

else 'Good_content'
end category
from netflix
)
select 
category, count(*) as total_content
from new_table
group by 1
