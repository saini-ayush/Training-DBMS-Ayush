WITH QualityRankTable AS (
    SELECT 
        a.username,
        i.type,
        ai.quality,
        i.name,
        RANK() OVER (
            PARTITION BY a.username, i.type 
            ORDER BY 
                CASE ai.quality 
                    WHEN 'epic' THEN 1
                    WHEN 'rare' THEN 2
                    WHEN 'common' THEN 3
                END
        ) as quality_rank
    FROM accounts a
    JOIN account_items ai ON a.id = ai.account_id
    JOIN items i ON ai.item_id = i.id
),
BestItems AS (
    SELECT 
        username,
        type,
        quality as advised_quality,
        GROUP_CONCAT(DISTINCT name ORDER BY name SEPARATOR ', ') as advised_name
    FROM QualityRankTable
    WHERE quality_rank = 1
    GROUP BY username, type, quality
)
SELECT 
    username,
    type,
    advised_quality,
    advised_name
FROM BestItems
ORDER BY username ASC, type ASC;


