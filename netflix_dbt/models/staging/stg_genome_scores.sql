-- WITH raw_genome_scores AS (
--     SELECT * FROM MOVIELENS.RAW.RAW_GENOME_SCORES
-- )
WITH raw_genome_scores AS (
    SELECT * FROM {{ source('raw', 'raw_genome_scores') }}
)

SELECT 
    movieID AS movie_id,
    tagID AS tag_id,
    relevance
FROM raw_genome_scores