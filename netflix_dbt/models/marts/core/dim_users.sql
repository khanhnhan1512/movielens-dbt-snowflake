WITH ratings AS (
    SELECT * FROM {{ ref('stg_ratings') }}
)

SELECT
    user_id,
    MIN(rating_timestamp) AS first_rating_timestamp,
    MAX(rating_timestamp) AS last_rating_timestamp,
    COUNT(movie_id) AS total_ratings,
    avg(rating) AS average_rating_score
FROM ratings
GROUP BY user_id