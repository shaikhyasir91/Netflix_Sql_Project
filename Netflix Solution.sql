-- 1. Count the number of Movies vs TV Shows
SELECT 	
	type,
	count(type) as Total_Content
FROM netflix
GROUP BY 1;


-- 2. Find the most common rating for movies and TV shows
SELECT
	type,
	rating
From
(
	SELECT 
		type,
		rating,
		count(rating),
		RANK() OVER(partition by type order by count(rating) desc) as rnk
	FROM
		netflix
	GROUP BY 1,2
) a
WHERE 
	rnk=1;


-- 3. List all movies released in a specific year (e.g., 2020)
SELECT
	*
FROM netflix
WHERE type='Movie' and release_year=2020;


-- 4. Find the top 5 countries with the most content on Netflix

SELECT 
	unnest(string_to_array(Country, ',')) AS Country,
	count(*)
FROM netflix
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5
;


-- 5. Identify the longest movie
SELECT 
	title,
	cast(substring(duration,1,position(' ' in duration)-1) as int) as Len
FROM netflix
WHERE 
	type = 'Movie' and duration is not null
ORDER BY 2 desc;


-- 6. Find content added in the last 5 years
SELECT
	*
FROM netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';


-- 7. Find all the movies/TV shows by director 'Rajiv Chilaka'!
SELECT 
	type,
	title,
	director
FROM netflix
WHERE director like '%Rajiv Chilaka%';


-- 8. List all TV shows with more than 5 seasons
SELECT 
	*
FROM netflix
Where type='TV Show' and split_part(duration,' ',1)::int > 5;


-- 9. Count the number of content items in each genre

SELECT 
	unnest(string_to_array(listed_in, ',')) AS Genre,
	count(*)
FROM netflix
GROUP BY 1
ORDER BY 2 DESC;


-- 10. Find each year and the average numbers of content release by India on netflix. 
-- return top 5 year with highest avg content release !


SELECT 
	country,
	release_year,
	COUNT(show_id) as total_release,
	ROUND(
		COUNT(show_id)::numeric/
								(SELECT COUNT(show_id) FROM netflix WHERE country = 'India')::numeric * 100 
		,2
		)
		as avg_release
FROM netflix
WHERE country = 'India' 
GROUP BY country, 2
ORDER BY avg_release DESC 
LIMIT 5;



-- 11. List all movies that are documentaries
SELECT * FROM netflix
WHERE listed_in LIKE '%Documentaries';



-- 12. Find all content without a director
SELECT * FROM netflix
WHERE director IS NULL;



-- 13. Find how many movies actor 'Salman Khan' appeared in last 20 years!

SELECT * FROM netflix
WHERE 
	casts LIKE '%Salman Khan%'
	AND 
	release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 20;



-- 14. Find the top 10 actors who have appeared in the highest number of movies produced in India.

SELECT 
	UNNEST(STRING_TO_ARRAY(casts, ',')) as actor,
	COUNT(*)
FROM netflix
WHERE country = 'India'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;




/*
Question 15:
Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
the description field. Label content containing these keywords as 'Bad' and all other 
content as 'Good'. Count how many items fall into each category.
*/


SELECT 
    category,
	TYPE,
    COUNT(*) AS content_count
FROM (
    SELECT 
		*,
        CASE 
            WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad'
            ELSE 'Good'
        END AS category
    FROM netflix
) AS categorized_content
GROUP BY 1,2
ORDER BY 2;


	