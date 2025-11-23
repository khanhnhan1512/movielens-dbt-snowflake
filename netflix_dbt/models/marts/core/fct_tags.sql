WITH tags AS (
    SELECT * FROM {{ ref('stg_tags') }}
),
movies AS (
    SELECT * FROM {{ ref('dim_movies') }}
),
users AS (
    SELECT * FROM {{ ref('dim_users') }}
)

SELECT
    {{ dbt_utils.generate_surrogate_key(['t.user_id', 't.movie_id', 't.tag']) }} AS row_key,
    t.user_id,
    t.movie_id,
    t.tag,
    t.tag_timestamp
FROM tags t
INNER JOIN movies m ON t.movie_id = m.movie_id
INNER JOIN users u ON t.user_id = u.user_id