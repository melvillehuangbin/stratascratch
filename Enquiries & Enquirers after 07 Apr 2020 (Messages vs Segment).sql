----- MESSAGE -----
with m_enquiries_sanitized as (
  select
    m.id as message_id,
    case
        when user_id = '7vd8r2H3A6kcvBXhUMjN2o' and original_sender_id is not null then original_sender_id
        else user_id
    end as user_id,
    listing_id,
    created_at_ts as created_date,
    case
      when enquiry_type = 'call' then 'call_enquiry'
      when enquiry_type = 'show_phone' then 'phone_reveal'
      when enquiry_type is null then 'single_enquiry'
      else enquiry_type
    end as enquiry_type,
    case
      when user_id is null then 'active'
      else u.status end as status
  from `co-169315.bi_views.all_enquiries_from_messages_view` m
  left join `co-169315.sg_prod.users` u on m.user_id = u.id
  left join sg_prod.listings l on m.listing_id = l.id
  where
    created_at_ts >= '2020-04-07'
    and user_id <> 'fonwwHKcDPM76vznQibybQ'
    and [[l.listing_type in ({{ listing_type }})]]
    and [[u.agent.agent_number is {{ agent_or_consumer|noquote }}]]
),
m_enquiries_summary as (
  select
    date_trunc(created_date, {{period|noquote}}) as period,
    count(distinct message_id) as total_enquiries,
    count(distinct user_id) as unique_enquirer,
    round(cast(count(distinct(message_id)) as float64) / cast(count(distinct user_id) as float64), 2) as enquiries_per_enquirer
  from m_enquiries_sanitized
  where [[created_date >= {{ start_date }}]]
    and [[status = {{ enquirer_status }}]]
    and [[enquiry_type not in ({{ exclude }})]]
  group by 1
  order by 1 desc
),

m_cumulative_enquirer as (
  select
  	date_trunc(first_enquiry, {{period|noquote}}) as period,
  	count(user_id) as count
  from (
    select
  	    user_id,
        min(cast(created_date as date)) as first_enquiry
    from m_enquiries_sanitized
    left join `co-169315.sg_prod.users` u on m_enquiries_sanitized.user_id = u.id
    where [[created_date >= {{ start_date }}]]
     and [[created_date <= {{ end_date }}]]
     and [[u.status = {{ enquirer_status }}]]
    group by 1
  )
  group by 1
  order by 1 asc
),

m_cumulative_summ as (
  select
  	e1.period,
  	e1.count as count,
  	SUM(e2.count) as cum_sum
  from m_cumulative_enquirer e1
  inner join m_cumulative_enquirer e2 on e1.period >= e2.period
  group by 1,2
  order by 1 asc
),

m_enquiries_final as (
  select
    m_enquiries_summary.period,
    total_enquiries,
    unique_enquirer as unique_enquirer_by_period,
    enquiries_per_enquirer as enquiries_per_enquirer_by_period,
    cum_sum as cumulative_unique_enquirer
  from m_enquiries_summary
  join m_cumulative_summ on m_enquiries_summary.period = m_cumulative_summ.period
  order by 1 asc
),

----- SEGMENT -----
s_enquiries_sanitized as (
select
  datetime_period,
  user_id,
  listing_id,
  anonymous_id,
  enquiry_type,
  case
  when u.status is null then 'active'
  else u.status end as status
from `co-169315.bi_views.all_enquiries_view` e
left join `co-169315.sg_prod.users` u on e.user_id = u.id
left join sg_prod.listings l on e.listing_id = l.id
where [[l.listing_type in ({{ listing_type }})]]
and [[u.agent.agent_number is {{ agent_or_consumer|noquote }}]]
),
s_enquiries_summary as (
  select
    date_trunc(datetime_period, {{period|noquote}}) as period,
    count(anonymous_id) as total_enquiries,
    count(distinct anonymous_id) as unique_enquirer,
    round(cast(count(*) as float64) / cast(count(distinct anonymous_id) as float64), 2) as enquiries_per_enquirer,
  from s_enquiries_sanitized
  where [[datetime_period >= {{ start_date }}]]
    and [[status = {{ enquirer_status }}]]
    and enquiry_type != '3' -- to remove ios old enquiry type on version 5.20.0
    and [[enquiry_type not in ({{ exclude }})]]
  group by 1
  order by 1 desc
),

s_cumulative_enquirer as (
  select
  	date_trunc(first_enquiry, {{period|noquote}}) as period,
  	count(anonymous_id) as count
  from (
    select * from
    (select
  	    anonymous_id,
        min(cast(datetime_period as date)) as first_enquiry,
        case
          when status is null then 'active'
          else status end as status
    from `co-169315.bi_views.all_enquiries_view` e
    left join `co-169315.sg_prod.users` u on  e.user_id = u.id
    where [[datetime_period >= {{ start_date }}]]
    group by 1,3
    )
    where [[status = {{ enquirer_status }}]]
  )
  group by 1
  order by 1 asc
),

s_cumulative_summ as (
  select
  	e1.period,
  	e1.count as count,
  	SUM(e2.count) as cum_sum
  from s_cumulative_enquirer e1
  inner join s_cumulative_enquirer e2 on e1.period >= e2.period
  group by 1,2
  order by 1 asc
),

s_enquiries_final as (
  select
    s_enquiries_summary.period,
    total_enquiries,
    unique_enquirer as unique_enquirer_by_period,
    enquiries_per_enquirer as enquiries_per_enquirer_by_period,
    cum_sum as cumulative_unique_enquirer
  from s_enquiries_summary
  join s_cumulative_summ on s_enquiries_summary.period = s_cumulative_summ.period
  order by 1 asc
)

----- COMBINED ON PERIOD -----

  select
    s.period,
    m.total_enquiries as total_m_enquiries,
    m.unique_enquirer_by_period as unique_m_enquirer_by_period,
    m.enquiries_per_enquirer_by_period as m_e_per_e_by_period,
    m.cumulative_unique_enquirer as m_cumulative_unique_enquirer,
    s.total_enquiries as total_segment_enquiries,
    s.unique_enquirer_by_period as unique_segment_enquirer_by_period,
    s.enquiries_per_enquirer_by_period as segment_e_per_e_by_period,
    s.cumulative_unique_enquirer as segment_cumulative_unique_enquirer,
    ABS(cast(m.total_enquiries as float64) / cast(s.total_enquiries as float64) - 1) as enquiries_diff_percentage,
    ABS(cast(m.unique_enquirer_by_period as float64) / cast(s.unique_enquirer_by_period as float64) - 1) as enquirers_diff_percentage
  from s_enquiries_final s
  left join m_enquiries_final m on m.period = s.period
  order by 1 asc