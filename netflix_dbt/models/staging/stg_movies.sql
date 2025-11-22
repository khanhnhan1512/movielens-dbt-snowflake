-- WITH raw_movies AS (
--     SELECT * FROM MOVIELENS.RAW.RAW_MOVIES
-- )
WITH raw_movies AS (
    SELECT * FROM {{ source('raw', 'raw_movies') }}
)

SELECT 
    movieID AS movie_id,
    title,
    genres
FROM raw_movies