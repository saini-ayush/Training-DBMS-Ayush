# Game Inventory Selection

## Problem Statement

An MMORPG game is under development. For the profile and inventory mechanics, it needs a query that advises the best quality items available in the inventory.

Item quality is represented by three ranks (from lowest to highest): "common", "rare", and "epic".
The result should have the following columns: username / type / advised_quality / advised _name.
- username - account username
- type - item type
- advised_quality - advised item quality ("common", "rare" or "epic")
- advised_name - list of advised items records:
- A record is the name of the item.
- Records are separated by a comma.
- Records are sorted in ascending order by name.
The result should be sorted in ascending order by username, then in ascending order by type.

Note:
- Accounts may not have items of a specific type at all.
- More than one item of the same type may be advised, as long as they are of the same quality.

### Thinking Approch

- Started with created a CTE which will join all 3 tables and rank the item partitioned by username and item type.

```
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
```

This CTE will give output as following:

|username|type  |quality|name               |quality_rank|
|--------|------|-------|-------------------|------------|
|cmunns1 |sword |common |Sword of Loasaceae |1           |
|cmunns1 |sword |common |Sword of Solanaceae|1           |
|cmunns1 |shield|epic   |Shield of Rosaceae |1           |
|cmunns1 |shield|epic   |Shield of Fagaceae |1           |
|cmunns1 |shield|rare   |Shield of Rosaceae |3           |
|cmunns1 |shield|rare   |Shield of Rosaceae |3           |
|cmunns1 |shield|common |Shield of Rosaceae |5           |
|cmunns1 |shield|common |Shield of Fagaceae |5           |
|cmunns1 |shield|common |Shield of Lauraceae|5           |
|cmunns1 |shield|common |Shield of Rosaceae |5           |
|cmunns1 |armor |rare   |Armor of Myrtaceae |1           |
|yworcs0 |sword |common |Sword of Loasaceae |1           |
|yworcs0 |shield|epic   |Shield of Fagaceae |1           |
|yworcs0 |shield|epic   |Shield of Rosaceae |1           |
|yworcs0 |shield|rare   |Shield of Lauraceae|3           |
|yworcs0 |shield|common |Shield of Fagaceae |4           |


- Once tables are joined and items are ranked another CTE will help in taking the top rank item and if there are item with same item type, username and quality but different name will be concated into one.

```
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
```


- selected the desired columns from this CTE and order them in ascending order.


### Results

```
SELECT 
    username,
    type,
    advised_quality,
    advised_name
FROM BestItems
ORDER BY username ASC, type ASC;
```

|username|type  |advised_quality|advised_name                           |
|--------|------|---------------|---------------------------------------|
|cmunns1 |sword |common         |Sword of Loasaceae, Sword of Solanaceae|
|cmunns1 |shield|epic           |Shield of Fagaceae, Shield of Rosaceae |
|cmunns1 |armor |rare           |Armor of Myrtaceae                     |
|yworcs0 |sword |common         |Sword of Loasaceae                     |
|yworcs0 |shield|epic           |Shield of Fagaceae, Shield of Rosaceae |

Results shows each user best item in different type of items.
