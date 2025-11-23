SELECT
    user_id,
    first_rating_timestamp,
    last_rating_timestamp
FROM {{ ref('dim_users') }}
WHERE first_rating_timestamp > last_rating_timestamp