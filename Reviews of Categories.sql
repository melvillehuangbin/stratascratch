-- select * from yelp_business;
--we want to find top business categories based on total number of reviews
-- output: category, total_reviews, order by reviews desc

-- input: we have a table of business base on business, neighborhood, city, state, review count level
-- we assume each businesses are uniquely identified using the business_id column
-- categories are in the format cat1;cat2;cat3...
-- need to split 

-- approach
-- 1. unnest the categories using unnest, string_to_array
-- 2. sum the reviews (group by categories)
-- 3. rank the reviews (we use dense rank or rank is fine)


with unnest_categories as (
    select
        unnest(string_to_array(categories, ';')) as categories_unnest,
        review_count
    from yelp_business
),

sum_reviews as (
    select
        categories_unnest,
        dense_rank() over(order by sum(review_count) desc) as rank_reviews,
        sum(review_count) as review_cnt
    from unnest_categories
    group by 1
)

select
    categories_unnest as categories,
    review_cnt
from sum_reviews

/***** easy solution ******/

-- select
--     unnest(string_to_array(categories, ';')) as categories,
--     sum(review_count) as review_cnt
-- from yelp_business
-- group by 1
-- order by 2 desc

