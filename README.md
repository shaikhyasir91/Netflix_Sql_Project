# Netflix Content Analysis Project

This project is an analysis of Netflix content using SQL. It provides insights into various aspects of the Netflix dataset, such as content type distribution, common ratings, genre analysis, and trends in content releases. The queries help answer key questions about Netflix's content library and uncover patterns based on country, genre, and other attributes.

## Dataset

The dataset used in this project includes details about Netflix shows and movies such as:
- Title
- Type (Movie/TV Show)
- Release Year
- Duration
- Genre (Listed In)
- Country
- Date Added
- Director and Casts
- Description
- Ratings

## Key Analyses

1. **Movies vs. TV Shows**  
   - Counted the total number of movies and TV shows on Netflix.

2. **Most Common Ratings**  
   - Identified the most frequent content rating for both movies and TV shows.

3. **Top Countries with the Most Content**  
   - Listed the top 5 countries producing the highest amount of content on Netflix.

4. **Longest Movie on Netflix**  
   - Found the longest movie in terms of duration.

5. **Content Released in the Last 5 Years**  
   - Analyzed the content added to Netflix over the last 5 years.

6. **Content Directed by Rajiv Chilaka**  
   - Filtered the dataset to show all movies or TV shows directed by Rajiv Chilaka.

7. **TV Shows with More Than 5 Seasons**  
   - Listed all TV shows that have more than 5 seasons.

8. **Top Genres on Netflix**  
   - Counted the number of content items in each genre and ranked them.

9. **Average Yearly Content Release by India**  
   - Evaluated the average number of content items released by India per year and listed the top 5 years with the highest average.

10. **Content Categorization by Themes of Violence**  
    - Categorized the content into "Good" or "Bad" based on the presence of keywords like "kill" or "violence" in the description.

## SQL Queries

The project includes a series of SQL queries for each analysis. Below are some key queries.

1. **Count the number of Movies vs TV Shows:**
    ```sql
    SELECT type, COUNT(type) AS Total_Content
    FROM netflix
    GROUP BY type;
    ```

2. **Find the most common rating for Movies and TV Shows:**
    ```sql
    SELECT type, rating
    FROM (
        SELECT type, rating, COUNT(rating),
        RANK() OVER (PARTITION BY type ORDER BY COUNT(rating) DESC) AS rnk
        FROM netflix
        GROUP BY type, rating
    ) a
    WHERE rnk = 1;
    ```

3. **List all movies released in a specific year (e.g., 2020):**
    ```sql
   SELECT *
   FROM netflix
   WHERE type='Movie' and release_year=2020;
    ```

4. **Find the top 5 countries with the most content on Netflix:**
    ```sql
   SELECT 
	   unnest(string_to_array(Country, ',')) AS Country,
	   count(*)
   FROM netflix
   GROUP BY 1
   ORDER BY 2 DESC
   LIMIT 5
;
    ```

5. **Identify the longest movie:**
    ```sql
    SELECT title, CAST(SUBSTRING(duration, 1, POSITION(' ' IN duration) - 1) AS INT) AS Len
    FROM netflix
    WHERE type = 'Movie' AND duration IS NOT NULL
    ORDER BY Len DESC;
    ```

6. **Find each year and the average number of content releases by India on Netflix:**
    ```sql
    SELECT country, release_year, COUNT(show_id) AS total_release,
           ROUND(COUNT(show_id)::NUMERIC / 
                 (SELECT COUNT(show_id) FROM netflix WHERE country = 'India')::NUMERIC * 100, 2) AS avg_release
    FROM netflix
    WHERE country = 'India'
    GROUP BY country, release_year
    ORDER BY avg_release DESC
    LIMIT 5;
    ```

7. **Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
the description field. Label content containing these keywords as 'Bad' and all other 
content as 'Good'. Count how many items fall into each category.**
    ```sql
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
```

