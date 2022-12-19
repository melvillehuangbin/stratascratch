select
    bike_number,
    max(end_time) last_used
from dc_bikeshare_q1_2012
group by 1
order by last_used desc