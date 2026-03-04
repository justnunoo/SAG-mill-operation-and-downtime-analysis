

-- log.production_id, 
-- log.shift_id, 
-- log.equipment_id, 
-- d.downtime_id,

select 
shift.shift_date, 
shift.shift_type, 
shift.supervisor_name,
e.equipment_code,
e.equipment_name,
log.operating_hours,
log.planned_hours,
log.tonnage_processed,
availability_percent,
d.start_time,
d.end_time,
d.downtime_category,
d.downtime_reason,
d.is_shutdown,
d.is_relining_activity,
d.responsible_team,
d.contractor_name
from production_log as log
join shift on shift.shift_id = log.shift_id
join equipment as e on e.equipment_id = log.equipment_id
join downtime_event as d on d.shift_id = log.shift_id;


-- Checking for duplicate rows in the dataset
select 
shift.shift_date, 
shift.shift_type, 
shift.supervisor_name,
e.equipment_code,
e.equipment_name,
log.operating_hours,
log.planned_hours,
log.tonnage_processed,
availability_percent,
d.start_time,
d.end_time,
d.downtime_category,
d.downtime_reason,
d.is_shutdown,
d.is_relining_activity,
d.responsible_team,
d.contractor_name,
count(*) as row_count_
from production_log as log
join shift on shift.shift_id = log.shift_id
join equipment as e on e.equipment_id = log.equipment_id
join downtime_event as d on d.shift_id = log.shift_id
group by shift.shift_date, 
shift.shift_type, 
shift.supervisor_name,
e.equipment_code,
e.equipment_name,
log.operating_hours,
log.planned_hours,
log.tonnage_processed,
availability_percent,
d.start_time,
d.end_time,
d.downtime_category,
d.downtime_reason,
d.is_shutdown,
d.is_relining_activity,
d.responsible_team,
d.contractor_name
having count(*) > 1;

-- Here extract and epoch is used to convert the time data to a format for subtraction
select
start_time,
end_time,
extract(epoch from (end_time - start_time))/3600 as downtime_hours
from downtime_event;


-- Overall availability
select
round(avg(availability_percent), 2) as Overall_availabilty
from production_log;

-- Total tonnage processed
select
sum(tonnage_processed) as total_tonnage_processed
from production_log;

-- Total downtime
select 
round(sum(extract(epoch from (end_time - start_time))/3600), 2) as downtime_hours
from downtime_event;

-- Unplanned downtime hours
select
sum(planned_hours - operating_hours) as unplanned_downtime_hours
from production_log;

-- Relining downtime hours
select
round(sum(extract(epoch from (end_time - start_time) / 3600)), 2) as relining_downtime_hours
from downtime_event
where is_relining_activity = true;

-- % of downtime caused by relining
select
round((
select
round(sum(extract(epoch from (end_time - start_time) / 3600)), 2) as relining_downtime_hours
from downtime_event
where is_relining_activity = true
)/ round(sum(extract(epoch from (end_time - start_time) / 3600)), 2) * 100, 2) as relining_downtime_percentage
from downtime_event;

-- Total downtime hours by equipment
select 
e.equipment_name,
round(sum(extract(epoch from (d.end_time - d.start_time))/3600), 2) as downtime_hours
from downtime_event as d
join equipment as e on e.equipment_id = d.equipment_id
group by e.equipment_name
order by downtime_hours desc;

-- Total downtime hours (relining vs non-relining ativities)
select 
is_relining_activity,
round(sum(extract(epoch from (end_time - start_time))/3600), 2) as downtime_hours
from downtime_event
group by is_relining_activity
order by downtime_hours desc;

-- Contractor vs in-house downtime
select
case 
	when contractor_name is not null then 'contractor'
	else 'in-house'
	end is_contractor,
round(sum(extract(epoch from (end_time - start_time))/3600), 2) as downtime_hours
from downtime_event
group by is_contractor
order by downtime_hours desc;

-- Shutdown vs non-shutdown downtime
select
is_shutdown,
round(sum(extract(epoch from (end_time - start_time))/3600), 2) as downtime_hours
from downtime_event
group by is_shutdown
order by downtime_hours desc;

--Total downtime hours by category
select
downtime_category,
round(sum(extract(epoch from (end_time - start_time))/3600), 2) as downtime_hours
from downtime_event
group by downtime_category
order by downtime_hours desc;

-- Total downtime between relining and non-relining ativities.
select
is_relining_activity,
round(sum(extract(epoch from (end_time - start_time))/3600), 2) as downtime_hours,
round(sum(extract(epoch from (end_time - start_time))/3600) / (
select 
sum(extract(epoch from (end_time - start_time))/3600) as downtime_hours
from downtime_event
) * 100, 2) as downtime_hours_percentage
from downtime_event
group by is_relining_activity
order by downtime_hours desc;


-- Availability by equipment
select 
e.equipment_name,
sum(log.operating_hours) as total_operating_hours,
sum(log.planned_hours) as total_planned_hours
from equipment as e
join production_log as log on log.equipment_id = e.equipment_id
group by e.equipment_name
order by total_operating_hours desc;


-- Top 10 downtime reasons
select 
downtime_reason,
count(*)
from downtime_event event
join shift on shift.shift_id = event.shift_id
join production_log log on log.shift_id = event.shift_id
group by downtime_reason
limit 10;


select *
from equipment as e
join production_log as log on log.equipment_id = e.equipment_id;

select
*
from downtime_event;

select 
log.tonnage_processed,
round(extract(epoch from event.end_time - event.start_time) / 3600, 2) as downtime_duration
from production_log as log
join shift on shift.shift_id = log.shift_id
join downtime_event as event on event.shift_id = shift.shift_id
order by downtime_duration desc;

select
avg(tonnage_processed) avg_tonnage,
avg(availability_percent) avg_availabilty
from production_log as log
join shift on shift.shift_id = log.shift_id
group by shift.shift_type;