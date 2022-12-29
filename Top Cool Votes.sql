-- select * from yelp_reviews;
-- find review text that received highest number of cool votes
-- output: business_name, review_text, highest numebr of coool votes

-- input/assumptions:
-- we have a table of reviews base on user, business and date level
-- we assume that counting cool votes uses the cool column which has an integer value
-- we also assume review text can have the same number of cool votes (can tie)

-- 1. sum the cool votes (group by review_text, business_name)
-- 2. select the max number of votes (where, max)

with cool_votes as (
    select
        review_text,
        business_name,
        sum(cool) as sum_cool_votes
    from yelp_reviews
    group by 1,2
)

select
    business_name,
    review_text
from cool_votes
where sum_cool_votes = (select max(sum_cool_votes) from cool_votes)
    