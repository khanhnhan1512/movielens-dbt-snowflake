WITH raw_links AS (
    SELECT * FROM {{ source('raw', 'raw_links') }}
)

SELECT 
    movieID AS movie_id,
    imdbID AS imdb_id,
    tmdbID AS tmdb_id
FROM raw_links