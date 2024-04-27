
-- second most recent activity for users with many activities
with cte as(
select *,
count(1) over (partition by username) as total_activities
, rank() over (partition by username order by startdate desc) as rn
from UserActivity)
select * from cte where total_activities = 1 or rn = 2

