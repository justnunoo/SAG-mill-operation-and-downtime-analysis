select
shift.shift_type,
avg(log.availability_percent) as avg_availability_precent,
sum(tonnage_processed) as total_tonnage
from production_log as log
join shift on shift.shift_id = log.shift_id
group by shift.shift_type;

select
down.downtime_category,
-- down.downtime_reason,
-- down.is_relining_activity,
round(sum(extract(epoch from down.end_time - down.start_time) / 3600), 2) as total_down_duration
from downtime_event as down
join shift on shift.shift_id = down.shift_id
join production_log as log on log.shift_id = shift.shift_id
group by down.downtime_category
order by total_down_duration desc;

-- downtime sequence
select
down.downtime_reason,
shift.shift_date,
round(sum(extract(epoch from down.end_time - down.start_time) / 3600), 2) as total_down_duration
from downtime_event as down
join shift on shift.shift_id = down.shift_id
join production_log as log on log.shift_id = shift.shift_id
group by down.downtime_reason,shift.shift_date
order by shift.shift_date;

select
down.downtime_reason,
down.start_time,
down.end_time
from downtime_event as down
join shift on shift.shift_id = down.shift_id
join production_log as log on log.shift_id = shift.shift_id
group by down.downtime_reason,
down.start_time,
down.end_time
order by down.start_time;


select
*
from downtime_event as down
join shift on shift.shift_id = down.shift_id
join production_log as log on log.shift_id = shift.shift_id;

