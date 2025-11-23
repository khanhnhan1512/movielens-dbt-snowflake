with movies as (
    select * from {{ ref('stg_movies') }}
),
links as (
    select * from {{ ref('stg_links') }}
)

SELECT 
    m.movie_id,
    m.title,
    m.release_year,
    l.imdb_id,
    l.tmdb_id,
    m.genres_array
FROM movies m
LEFT JOIN links l ON m.movie_id = l.movie_id