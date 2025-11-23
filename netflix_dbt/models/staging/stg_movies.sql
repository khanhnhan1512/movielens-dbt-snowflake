-- WITH raw_movies AS (
--     SELECT * FROM MOVIELENS.RAW.RAW_MOVIES
-- )
WITH raw_movies AS (
    SELECT * FROM {{ source('raw', 'raw_movies') }}
),
clean AS (
    SELECT 
        movieID AS movie_id,
        TRIM(REGEXP_REPLACE(title, '\\s*\\(\\d{4}\\)$', '')) AS title,
        CASE 
            WHEN title LIKE '%(%)'
            THEN TRY_TO_NUMBER(RIGHT(LEFT(title, LENGTH(title)-1), 4))
        END AS release_year,
        SPLIT(genres, '|') AS genres_array,
        title AS original_title
    FROM raw_movies
)

SELECT * FROM clean