USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:


-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

SELECT COUNT(*) AS Count_Total FROM director_mapping;
SELECT COUNT(*) AS Count_Total FROM genre;
SELECT COUNT(*) AS Count_Total FROM movie;
SELECT COUNT(*) AS Count_Total FROM names;
SELECT COUNT(*) AS Count_Total FROM ratings;
SELECT COUNT(*) AS Count_Total FROM role_mapping;

-- Q2. Which columns in the movie table have null values?
-- Type your code below:

SELECT
SUM(CASE WHEN id IS NULL THEN 1 ELSE 0 END) AS Id_Null,
SUM(CASE WHEN title IS NULL THEN 1 ELSE 0 END) AS Title_Null,
SUM(CASE WHEN year IS NULL THEN 1 ELSE 0 END) AS Year_Null,
SUM(CASE WHEN date_published IS NULL THEN 1 ELSE 0 END) AS Date_Published_Null,
SUM(CASE WHEN duration IS NULL THEN 1 ELSE 0 END) AS Duration_Null,
SUM(CASE WHEN country IS NULL THEN 1 ELSE 0 END) AS Country_Null,
SUM(CASE WHEN worlwide_gross_income IS NULL THEN 1 ELSE 0 END) AS WorldWide_Null,
SUM(CASE WHEN languages IS NULL THEN 1 ELSE 0 END) AS Language_Null,
SUM(CASE WHEN production_company IS NULL THEN 1 ELSE 0 END) AS Production_Company_Null
FROM movie;



-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- Number of movies released each Year
SELECT
year, COUNT(id) AS number_of_movies
FROM movie
GROUP BY year;

-- Number of movie released month wise
SELECT
MONTH(date_published) AS month_released, COUNT(id) AS number_of_movies
FROM movie
GROUP BY MONTH(date_published)
ORDER By MONTH(date_published);


/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

SELECT 
		count(id) AS num_of_movies, 
        year
FROM 
		movie
WHERE 
			year = 2019
            AND
            (country like '%India%'
            OR country like '%USA%');

/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT DISTINCT genre 
FROM genre;



/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

SELECT genre AS Genre_with_max_movies
FROM genre
GROUP BY genre
ORDER BY COUNT(movie_id) DESC
LIMIT 1; 

/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

SELECT SUM(num_movies) AS Total_movies_of_one_genre
FROM
	(
	SELECT 
			COUNT(movie_id) AS num_movies
	FROM 
			genre
	GROUP BY 
			movie_id
	HAVING
			COUNT(movie_id) = 1
	) AS count_movies
;


/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT 
	genre, ROUND(AVG(duration),2) AS Avg_duration 
FROM 
	movie m
    INNER JOIN genre g
    ON m.id=g.movie_id
GROUP BY 
	g.genre;
    

/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT * 
FROM 
(
	SELECT 
		genre,
		COUNT(movie_id) AS movie_count,
		RANK() OVER (ORDER BY COUNT(movie_id) DESC) AS genre_rank
	FROM 
		genre
	GROUP BY 
		genre
) AS ranking_genres
WHERE 
	genre like 'Thriller';


/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:


SELECT 
		MIN(avg_rating) AS min_avg_rating,
        MAX(avg_rating) AS max_avg_rating,
        MIN(total_votes) AS min_total_votes,
        MAX(total_votes) AS max_total_votes,
        MIN(median_rating) AS min_median_rating,
        MAX(median_rating) AS max_median_rating
FROM ratings;


/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

SELECT * 
FROM
	(
	SELECT 
			m.title,
			r.avg_rating,
			DENSE_RANK() OVER(ORDER BY r.avg_rating DESC) AS movie_rank
	FROM 
			movie m 
			INNER JOIN ratings r 
			ON m.id = r.movie_id
	) AS rating_rankings
LIMIT 10;


/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

SELECT 
	median_rating, 
    COUNT(movie_id) AS movie_count
FROM 
	ratings
GROUP BY median_rating
ORDER BY median_rating;


/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:


SELECT *
FROM
(
	SELECT
			production_company,
			COUNT(id) AS movie_count,
			DENSE_RANK() OVER (ORDER BY COUNT(id) DESC) AS prod_company_rank
	FROM
			movie m 
			INNER JOIN ratings r
			ON m.id=r.movie_id
	WHERE 
			r.avg_rating > 8
			AND
			m.production_company IS NOT NULL
	GROUP BY 
			production_company
) AS prod_comp_ranking
WHERE
	prod_company_rank = 1
;


-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT 
		genre,
        COUNT(m.id) AS movie_count
FROM
		genre g
        INNER JOIN movie m
		ON g.movie_id=m.id
			INNER JOIN ratings r
			ON m.id=r.movie_id
WHERE 
		MONTH(date_published) = 3
        AND year = 2017
        AND m.country = 'USA'
        AND r.total_votes > 1000
GROUP BY
		genre
ORDER BY 
		movie_count DESC;


-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:



SELECT
		title,
        avg_rating,
        genre
FROM 
		movie m
        INNER JOIN ratings r
        ON m.id=r.movie_id
			INNER JOIN genre g
			ON r.movie_id=g.movie_id
WHERE 
		title like 'The%'
        AND 
        avg_rating > 8;


-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT 
	COUNT(id) AS Num_of_movies
FROM
	movie m
    INNER JOIN ratings r
    ON m.id=r.movie_id
WHERE 
 	date_published BETWEEN '2018-04-01' AND '2019-04-01' 
	AND median_rating = 8
ORDER BY 
		date_published;


-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

SELECT
		country AS movie_country,
        SUM(total_votes) AS Total_votes
FROM
		movie m
        JOIN ratings r 
        ON m.id=r.movie_id
WHERE 
		country like 'Germany'
        OR country like 'Italy'
GROUP BY 
		country;


-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:



SELECT
		SUM(CASE WHEN id IS NULL THEN 1 ELSE 0 END) AS id_nulls,
        SUM(CASE WHEN name IS NULL THEN 1 ELSE 0 END) AS name_nulls,
        SUM(CASE WHEN height IS NULL THEN 1 ELSE 0 END) AS height_nulls,
        SUM(CASE WHEN date_of_birth IS NULL THEN 1 ELSE 0 END) AS date_of_birth_nulls,
        SUM(CASE WHEN known_for_movies IS NULL THEN 1 ELSE 0 END) AS known_for_movies_nulls
FROM 
		names;



/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

WITH top_genres_cte AS
(
	SELECT 	genre
	FROM	genre g
			JOIN ratings r 
			ON g.movie_id=r.movie_id
	WHERE	avg_rating > 8
	GROUP BY genre
	ORDER BY COUNT(g.movie_id) DESC
	LIMIT 3
),
top_directors_cte AS
( 
SELECT 
		n.name AS director_name,
        COUNT(dm.movie_id) AS movie_count,
        DENSE_RANK() OVER (ORDER BY COUNT(dm.movie_id) DESC) AS director_rank
FROM
		names n 
			INNER JOIN director_mapping dm
			ON n.id=dm.name_id
				INNER JOIN genre g
				ON dm.movie_id=g.movie_id
					INNER JOIN ratings r
					ON g.movie_id=r.movie_id,
						top_genres_cte
WHERE 
	r.avg_rating > 8 AND 
    g.genre IN (top_genres_cte.genre)
GROUP BY
		dm.name_id
)
SELECT 
		director_name,
        movie_count
FROM top_directors_cte 
WHERE director_rank <= 3
LIMIT 3;


/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT 
        n.name AS actor_name,
       COUNT(rm.movie_id) AS movie_count
FROM 
	role_mapping rm
		INNER JOIN 	ratings r
		ON rm.movie_id=r.movie_id
			INNER JOIN names n
            ON rm.name_id=n.id
WHERE 
	median_rating>=8 AND rm.category = 'actor'
GROUP BY rm.name_id, rm.category
ORDER BY COUNT(movie_id) DESC
LIMIT 2
;


/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT 
		production_company,
        SUM(total_votes) AS vote_count,
        DENSE_RANK() OVER(ORDER BY SUM(total_votes) DESC) AS prod_comp_rank
FROM
		movie m
			INNER JOIN ratings r
            ON m.id=r.movie_id
GROUP BY 
		production_company
ORDER BY 
		vote_count DESC
LIMIT 3;


/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT 
		n.name AS actor_name,
        SUM(r.total_votes) AS total_votes,
        COUNT(rm.movie_id) AS movie_count,
        ROUND((SUM(r.avg_rating*r.total_votes))/SUM(r.total_votes),2) AS actor_avg_rating,
        DENSE_RANK() OVER (ORDER BY ROUND((SUM(r.avg_rating*r.total_votes))/SUM(r.total_votes),2) DESC, SUM(r.total_votes)) AS actor_rank
FROM
		role_mapping rm
			INNER JOIN names n
            ON rm.name_id=n.id
				INNER JOIN ratings r
				ON rm.movie_id=r.movie_id
					INNER JOIN movie m
                    ON r.movie_id=m.id
WHERE 
		category = 'actor'
        AND country = 'India'
GROUP BY 
		name_id
HAVING
		movie_count >= 5;
        

-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:


SELECT 
		n.name AS actress_name,
        SUM(r.total_votes) AS total_votes,
        COUNT(rm.movie_id) AS movie_count,
        ROUND((SUM(r.avg_rating*r.total_votes))/SUM(r.total_votes),2) AS actress_avg_rating,
        DENSE_RANK() OVER (ORDER BY ROUND((SUM(r.avg_rating*r.total_votes))/SUM(r.total_votes),2) DESC, SUM(r.total_votes)) AS actress_rank
FROM
		role_mapping rm
			INNER JOIN names n
            ON rm.name_id=n.id
				INNER JOIN ratings r
				ON rm.movie_id=r.movie_id
					INNER JOIN movie m
                    ON r.movie_id=m.id
WHERE 
		category = 'actress'
        AND country = 'India'
        AND languages LIKE '%Hindi%'
GROUP BY 
		name_id
HAVING
		movie_count >= 3
LIMIT 5;


/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:


SELECT 
		title AS Movie,
        avg_rating AS Rating,
        CASE WHEN avg_rating > 8 THEN 'Superhit movies'
        WHEN avg_rating > 7 THEN 'Hit movies'
        WHEN avg_rating > 5 THEN 'One-time-watch movies'
        ELSE 'Flop movies' END AS Movie_category
FROM
		movie m
        INNER JOIN ratings r
        ON m.id=r.movie_id
			INNER JOIN genre g
            ON r.movie_id=g.movie_id
WHERE 
		g.genre = 'Thriller'
ORDER BY 
		r.avg_rating DESC;


/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT
		genre,
		ROUND(AVG(m.duration),2) AS avg_duration,
		ROUND(SUM(AVG(m.duration)) OVER(ORDER BY g.genre),2) AS running_total_duration,
		ROUND(AVG(AVG(m.duration)) OVER(ORDER BY g.genre),2) AS moving_avg_duration
FROM 
		movie m
			INNER JOIN genre g
			ON m.id=g.movie_id
GROUP BY 
		genre;

-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies


WITH top_genres_cte AS
(
	SELECT 	genre
	FROM	genre g
			JOIN ratings r 
			ON g.movie_id=r.movie_id
	WHERE	avg_rating > 8
	GROUP BY genre
	ORDER BY COUNT(g.movie_id) DESC
	LIMIT 3
),
-- worldwide gross income of movies of each year from top 3 genre
-- Converting worldwide_gross_income datatype from 'varchar' to decimal
-- Converting values in INR to to dollars after the data-type is corrected using conversion equation, 1 USD = 80 INR
movie_income AS
(	SELECT g.genre, year, title AS movie_name,
		   CASE
			 WHEN worlwide_gross_income LIKE 'INR%' 
				THEN Cast(Replace(worlwide_gross_income, 'INR', '') AS DECIMAL(12)) / 80
			 WHEN worlwide_gross_income LIKE '$%' 
				THEN Cast(Replace(worlwide_gross_income, '$', '') AS DECIMAL(12))
			 ELSE Cast(worlwide_gross_income AS DECIMAL(12))
		   END worldwide_gross_income
	FROM   
			genre g
		   INNER JOIN movie m
				   ON g.movie_id = m.id,
		   top_genres_cte
	WHERE  g.genre IN ( top_genres_cte.genre )
	-- group by for distinct movie titles. To avoid repetitions, since one movie can belong to many genres
	GROUP  BY movie_name
	ORDER  BY year
),
top_movies AS
(	SELECT *,
		   Dense_rank() OVER(partition BY year ORDER BY worldwide_gross_income DESC) AS movie_rank
	FROM   movie_income
)
SELECT *
FROM   top_movies
WHERE  movie_rank <= 5;



-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:



WITH top_prod_comp AS
	(SELECT 
			production_company,
			COUNT(m.id) AS movie_count,
			DENSE_RANK() OVER (ORDER BY COUNT(m.id) DESC) AS prod_comp_rank
	FROM 
			movie m
				INNER JOIN ratings r
				ON m.id=r.movie_id
	WHERE 
			r.median_rating >= 8
			AND m.languages LIKE '%,%'
			AND production_company IS NOT NULL
	GROUP BY 
			m.production_company
)
SELECT * 
FROM top_prod_comp
WHERE prod_comp_rank <=2;


-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:


SELECT 
		n.name AS actress_name,
        SUM(total_votes) AS total_votes,
        COUNT(rm.movie_id) AS movie_count,
        ROUND(SUM(r.avg_rating*r.total_votes)/SUM(r.total_votes),2) AS actress_avg_rating,
        DENSE_RANK() OVER (ORDER BY COUNT(rm.movie_id) DESC) AS actress_rank
FROM
		movie m
			INNER JOIN ratings r
            ON m.id=r.movie_id
				INNER JOIN genre g
				ON r.movie_id=g.movie_id
					INNER JOIN role_mapping rm
					ON g.movie_id=rm.movie_id
						INNER JOIN names n
                        ON rm.name_id=n.id
WHERE 
		g.genre LIKE 'drama'
		AND r.avg_rating > 8
        AND rm.category LIKE 'actress'
GROUP BY 
		rm.name_id
LIMIT 3;


/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:


WITH director_dates AS
(
	SELECT 
			dm.name_id,
            n.name,
            dm.movie_id,
            r.avg_rating,
            r.total_votes,
            m.duration,
            m.date_published,
            LEAD(date_published,1) OVER(PARTITION BY dm.name_id ORDER BY m.date_published, dm.movie_id) AS next_date_published
	FROM
			movie m
				INNER JOIN ratings r
				ON m.id=r.movie_id
					INNER JOIN director_mapping dm
					ON r.movie_id=dm.movie_id
						INNER JOIN names n
                        ON dm.name_id=n.id						
),
date_diff AS
(
	SELECT *, DATEDIFF(next_date_published, date_published) AS inter_period 
    FROM director_dates
)
SELECT
		name_id AS director_id,
        name AS director_name,
        COUNT(movie_id) AS number_of_movies,
        ROUND(AVG(inter_period)) AS avg_inter_movie_days,
        ROUND(SUM(avg_rating*total_votes)/SUM(total_votes),2) AS avg_rating,
        SUM(total_votes) AS total_votes,
        MIN(avg_rating) AS min_rating,
        MAX(avg_rating) AS max_rating,
        SUM(duration) AS total_duration
FROM
		date_diff df
GROUP BY 
		director_id
ORDER BY 
		number_of_movies DESC
LIMIT 9;
		