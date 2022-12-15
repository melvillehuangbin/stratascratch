-- total number of downloads for paying/non-paying users by date
-- records where non-paying customer have more downloads than paying customers
-- sort by earliest date
-- output: date, non-paying downlaods, paying downloads

select *
from (
    select
        d.date,
        sum(case when a.paying_customer ='no' then d.downloads else 0 end) as non_paying,
        sum(case when a.paying_customer = 'yes' then d.downloads else 0 end) as paying
    from 
        ms_download_facts d
        left join ms_user_dimension u on d.user_id = u.user_id
        left join ms_acc_dimension a on u.acc_id = a.acc_id
    group by 1
    order by 1 asc
) t
where t.non_paying > t.paying

