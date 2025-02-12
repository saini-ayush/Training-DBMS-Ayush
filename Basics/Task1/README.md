
# Task 1: SQL Question 

This README will help to understand my thought process behind the task and the approch I took for the same.

## Question

- Our sampling strategy is to order the images in decreasing order of scores and sample every 3rd image starting with the first from the beginning until we get 10k positive samples. And we would like to do the same in the other direction, starting from the end to get 10k negative samples.

- Task: Write a SQL query that performs this sampling and creates the expected output ordered by image_id with integer columns image_id, weak_label.

## Thought-Process

- Ranking the images 
    - decreasing rank for positive samples
    - ascending rank for negetive samples

```
ROW_NUMBER() OVER (ORDER BY score DESC) as desc_rank,
ROW_NUMBER() OVER (ORDER BY score ASC) as asc_rank
```

- Sampled data taking every 3 record for the positive and negetive samples and limited it to 10000 records.

```
PositiveSamples as (
	select image_id,
    1 as weak_label
    from RankedImages
    Where desc_rank % 3 = 1
    order by desc_rank
    limit 10000
),

NegetiveSamples as (
	select image_id,
    0 as weak_label
    from RankedImages
    Where asc_rank % 3 = 1
    order by asc_rank
    limit 10000
)
```

- Combined the 10k records from positive samples and 10k records from negetive samples using union function.

```
SELECT image_id , weak_label 
FROM (SELECT * from PositiveSamples UNION ALL SELECT * FROM NegetiveSamples )
AS Combined
ORDER BY image_id;
```



## Advanced SQL Queries Used

- Common Table Expressions (CTEs)
- ROW_NUMBER (Window function)
- Union 


## Results

|image_id|weak_label|
|--------|----------|
|47      |0         |
|63      |0         |
|96      |0         |
|115     |1         |
|126     |0         |
|132     |0         |
|219     |0         |
|232     |0         |
|272     |1         |
|306     |0         |
|363     |1         |
|405     |1         |
|417     |1         |

For all data navigate to [task1Results.csv](task1Results.csv)

