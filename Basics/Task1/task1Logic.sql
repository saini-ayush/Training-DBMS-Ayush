WITH RankedImages as (
	select image_id,
    score,
    ROW_NUMBER() OVER (ORDER BY score DESC) as desc_rank,
    ROW_NUMBER() OVER (ORDER BY score ASC) as asc_rank
    from unlabled_image_predictions
),

PositiveSamples as (
	select image_id,
    1 as weak_label
    from RankedImages
    Where desc_rank % 3 = 1
    order by desc_rank
    LIMIT 10000
),

NegetiveSamples as (
	select image_id,
    0 as weak_label
    from RankedImages
    Where asc_rank % 3 = 1
    order by asc_rank
    LIMIT 10000
)


SELECT image_id , weak_label 
FROM (SELECT * from PositiveSamples UNION ALL SELECT * FROM NegetiveSamples )
AS Combined
ORDER BY image_id;