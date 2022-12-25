-- select * from fb_friend_requests;
-- overall friend acceptance rate
-- rate of acceptances by date request was sent, order by earliest date to latest
-- each friend request user sending to friend, action = 'sent'
-- if request accepted, action ='accepted'
-- not accepted, no record of action ='accepted' log

-- an acceptance is only counted when the user_id and receiver_id pair is sent and accepted
-- we validate this using a join and assume the sender, receiver id pair uniquely identifies the friend request
-- 1. define rate of acceptance: sum(action='accepted')/sum(action='sent') * 100, group by date
-- 2. get the ending action of the request with a'accepted' (left join) on user_id, receiver_id
-- 3. order by earliest to latest date (order by)

with cte as (
 select
    t1.user_id_sender,
    t1.user_id_receiver,
    t1.date,
    t1.action as action_sent,
    t2.action as action_accepted
from
    (select * from fb_friend_requests where action = 'sent') t1
    left join (select * from fb_friend_requests where action = 'accepted') t2
    on t1.user_id_sender = t2.user_id_sender and t1.user_id_receiver = t2.user_id_receiver
)

select
    date,
    sum(case when action_accepted = 'accepted' then 1 else 0 end) / sum(case when action_sent = 'sent' then 1 else 0 end) as percentage_acceptance
from cte
group by 1
order by 1




