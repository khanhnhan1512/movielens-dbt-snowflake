{% snapshot snap_tags %}

{{
    config(
        target_schema='snapshots',
        unique_key=['user_id', 'movie_id', 'tag'],
        strategy='timestamp',
        updated_at='tag_timestamp',
        invalidate_hard_deletes=True
    )
}}
-- The invalidate_hard_deletes=True is a crucial setting that handles deleted records. When a record no longer exists in the source table, dbt will mark it as deleted in the snapshot by setting the dbt_valid_to timestamp to the current snapshot time, rather than just leaving it as "valid forever".
SELECT 
    {{ dbt_utils.generate_surrogate_key(['user_id', 'movie_id', 'tag']) }} AS row_key,
    user_id,
    movie_id,
    tag,
    CAST(tag_timestamp AS TIMESTAMP_NTZ) AS tag_timestamp -- snapshot requires TIMESTAMP_NTZ for proper time zone handling
FROM {{ ref('stg_tags') }}
LIMIT 100

{% endsnapshot %}