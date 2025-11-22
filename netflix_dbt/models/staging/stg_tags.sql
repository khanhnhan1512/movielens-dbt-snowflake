-- WITH raw_tags AS (
--     SELECT * FROM MOVIELENS.RAW.RAW_TAGS
-- )
WITH raw_tags AS (
    SELECT * FROM {{ source('raw', 'raw_tags') }}
)

SELECT 
    userID AS user_id,
    movieID AS movie_id,
    tag,
    TO_TIMESTAMP_LTZ(timestamp) AS tag_timestamp
FROM raw_tags