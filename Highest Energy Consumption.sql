-- select * from fb_eu_energy;
-- find date with highest total energy consumption from Meta/Facebook data ceners
-- output date along with total energy consumption across data centers

-- questions, input given: three tables of date, consumption from different datacenters in different regions
-- we assume that there could be a tie in highest energy consumption
-- date level - so no aggregation required

-- 1. union the 3 tables (use union all to keep duplicate values)
-- 2. sum the enery consumption (sum, group by)
-- 3. rank the energy consumption (rank over(order by energy))
-- 4. output only rank = 1

with all_regions as (
    select * from fb_eu_energy
    union all
    select * from fb_asia_energy
    union all
    select * from fb_na_energy
),

energy_agg as (
    select
        date,
        sum(consumption) as total_energy
    from all_regions
    group by 1
),

rank_energy as (
    select
        date,
        total_energy,
        rank() over(order by total_energy desc) as energy_ranking
    from energy_agg
)

select
    date,
    total_energy
from rank_energy
where energy_ranking = 1