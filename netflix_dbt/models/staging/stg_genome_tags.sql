-- WITH raw_genome_tags AS (
--     SELECT * FROM MOVIELENS.RAW.RAW_GENOME_TAGS
-- )
WITH raw_genome_tags AS (
    SELECT * FROM {{ source('raw', 'raw_genome_tags') }}
)

SELECT 
    tagID AS tag_id,
    tag
FROM raw_genome_tags