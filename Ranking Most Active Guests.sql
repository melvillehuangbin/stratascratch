-- select * from airbnb_contacts;
-- output: rank, guest_id, number of total messages sent, order by highest number of total_messages first

-- assumptions: we assume here each guest can take up multiple rows in the table, since the table records different levels of datetimes the messages are sent/received, aggregation required to find n_messages
-- important point to note: always ask questions regarding the level of granularity of the table before tackling the question
-- 1. get sum of messages by each guest (sum, group by)
-- 2. get rank of guest base on messages (rank)

select
    dense_rank() over(order by sum(n_messages) desc) as ranking,
    id_guest,
    sum(n_messages) as sum_n_messages
from airbnb_contacts
group by 2
    
    


    

