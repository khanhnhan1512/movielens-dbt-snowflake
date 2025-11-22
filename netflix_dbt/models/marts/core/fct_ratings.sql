{{
    config(
        materialized='incremental',
        on_schema_change='fail'
    )
}}

WITH src_ratings AS (
    SELECT * FROM {{ ref('stg_ratings') }}
)

SELECT
    user_id,
    movie_id,
    rating,
    rating_timestamp
FROM src_ratings
WHERE rating IS NOT NULL
{% if is_incremental() %}
    AND rating_timestamp > (SELECT MAX(rating_timestamp) FROM {{ this }})
{% endif %}


-- Cách hoạt động:
-- Lần chạy đầu tiên (is_incremental() = False):
-- - Tải toàn bộ dữ liệu từ src_ratings.
-- Các lần chạy sau (is_incremental() = True):
-- - Chỉ tải dữ liệu mới có rating_timestamp lớn hơn timestamp lớn nhất hiện có trong bảng đích.

-- Lợi ích:
-- Nếu có record mới được thêm vào stg_ratings, chỉ những record nào có timestamp mới hơn mới được tải vào fct_ratings,
-- tránh việc rebuild toàn bộ bảng, tiết kiệm thời gian và tài nguyên.