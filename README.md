## Logic
Uses SQL recursion to find both paths from node to root.
Query checks for common elements in path. Closest match is LCA, last match is root.
Uses recursion to find depth of LCA

Includes sanity check for loops in nodes.
A minor graphical demo is included to visualize data.


## Running
```shell
cd foghorn
rails server
```

## Demo using D3
* http://localhost:3000/nodes/demo
 
## Samples
* http://localhost:3000/nodes/2100480/common_ancestors/2100492
* http://localhost:3000/nodes/2100483/common_ancestors/2100492

## Testing
```shell
rails test
```


## Seeds
Using direct file to postgres to speed up loading of node data

## SQL Sample
Finding LCA and root
```sql
 WITH RECURSIVE
        path_1 AS (
        select id, parent_id from nodes where id = '2100480'
        union all
        select  e.id, e.parent_id from nodes e join path_1 on e.id = path_1.parent_id
        ) cycle id  set is_cycle using cycle_path
      ,
        path_2 AS (
        select id, parent_id from nodes where id = '2100490'
        union all
        select  e.id, e.parent_id from nodes e join path_2 on e.id = path_2.parent_id
        ) cycle id  set is_cycle using cycle_path

        select id, is_cycle from path_1 where id in (select id from path_2)
```
Finding Depth of root
```sql
 WITH RECURSIVE
      path_1 AS (
                  select 1 as depth,id, parent_id from nodes where id = 2100480
      union all
      select depth + 1, e.id, e.parent_id from nodes e join path_1 on e.id = path_1.parent_id
      ) cycle id  set is_cycle using cycle_path

      select max(depth) as depth_lca from path_1

```