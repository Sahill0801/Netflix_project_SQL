CREATE TABLE Netflix
(
	show_id	Varchar(5),
	type	Varchar(10),
	title	Varchar(1000),
	director	Varchar(1000),
	casts 	Varchar(1050),
	country	Varchar(250),
	date_added	Varchar(25),
	release_year	Int,
	rating	Varchar(50),
	duration	Varchar(50),
	listed_in	Varchar(500),
	description	Varchar(5000)
);

select * from netflix;

select count(*) from netflix;

select
distinct type
from netflix;


-- Data Cleaning

SELECT * FROM netflix
where 
	show_id	is null or type is null or
	title is null or director is null or
	casts is null or country is null or
	date_added is null or release_year is null or
	rating is null or duration is null or
	listed_in is null or description is null ;

DELETE  FROM netflix
where 
	show_id	is null or type is null or
	title is null or director is null or
	casts is null or country is null or
	date_added is null or release_year is null or
	rating is null or duration is null or
	listed_in is null or description is null ;

SELECT * FROM netflix;

--- Business Problem

-- 1. Count the number of Movies vs TV Shows
select
	type,
	count(*) as total_count
from netflix
group by type

--2. Find the most common rating for movies and TV shows

select
	type,
	Max(rating),
from netflix
group by type


--3. List all movies released in a specific year (e.g., 2020)

select 
 type,
 title,
 release_year
from netflix
where release_year = '2020' And type = 'Movie'

--4. Find the top 5 countries with the most content on Netflix

select
	unnest(string_to_array(country, ',' )) as new_country,
	count(show_id) as total_content
from netflix
group by 1
order by 2 desc
limit 5

--5. Identify the longest movie

select * from netflix
where
	type= 'Movie'
	and
	duration = (select max(duration) from netflix)
	
6. Find content added in the last 5 years

select 
	*,
--	to_date(date_added,'Month DD,YYYY')  convert to date format
from netflix
WHERE 
	to_date(date_added,'Month DD,YYYY')  >= current_date - interval '5 years';


7. Find all the movies/TV shows by director 'Rajiv Chilaka'!

select * 
from netflix
where 
	director Ilike '%Rajiv Chilaka%';

--8. List all TV shows with more than 5 seasons

-- split part is used to sperate duration in before space
-- ::numeric text to numeric

SELECT 
	*
FROM netflix
where
	type = 'TV Show'
	AND
	split_part(duration, ' ',1)::numeric > 5 

--9. Count the number of content items in each genre

select 
	unnest(string_to_array(listed_in, ',')) as genre,
	count(show_id) as total_content
from netflix
group by 1

--10.Find each year and the average numbers of content release in India on netflix. 
return top 5 year with highest avg content release!

select 
	extract(year from to_date(date_added, 'Month DD,YYYY')) as year,
	count(*),
	round(
	count(*)::numeric/(select count(*) from netflix where country = 'India')::numeric *100 
	)as avg_content
from netflix
where country = 'India'
group by  1
order by 2 desc
limit 5


--11. List all movies that are documentaries

select
	type,
	listed_in
from netflix
where 
	type = 'Movie'
	and
	listed_in ILIKE '%documentaries%'

--12. Find all content without a director

select 
	*
from netflix
where
	director is null
	
--13. Find how many movies actor 'Salman Khan' appeared in last 10 years!

select * from netflix
where
	casts ILIKE '%Salman Khan%'
	and
	release_year > extract(year from current_date) - 10

14. Find the top 10 actors who have appeared in the highest number of movies produced in India.

select
unnest(string_to_array(casts,',')) as actors,
count(*) as total_content
from netflix
where
country ILIKE '%India%'
group by 1
order by 2 desc
limit 10


15.
Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
the description field. Label content containing these keywords as 'Bad' and all other 
content as 'Good'. Count how many items fall into each category.


with new_table
as
(
select
* ,
	CASE
	WHEN description ILIKE '%kill%'
	or
	description ILIKE '%violence%'
	THEN
	'Bad_Content'
	Else
	'Good Content'
    END category
from netflix
)
select
	category,
	COUNT(*) as total_content
from new_table
group by 1


