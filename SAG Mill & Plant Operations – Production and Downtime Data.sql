-- create the shift table

DROP TABLE IF EXISTS shift CASCADE
CREATE TABLE shift (
    shift_id SERIAL PRIMARY KEY,
    shift_date DATE NOT NULL,
    shift_type VARCHAR(10) CHECK (shift_type IN ('DAY','NIGHT')),
    supervisor_name TEXT
);

-- create the equipment table

CREATE TABLE equipment (
    equipment_id SERIAL PRIMARY KEY,
    equipment_code VARCHAR(20) UNIQUE,
    equipment_name TEXT,
    area TEXT
);

-- create production log table

CREATE TABLE production_log (
    production_id SERIAL PRIMARY KEY,
    shift_id INT REFERENCES shift(shift_id),
    equipment_id INT REFERENCES equipment(equipment_id),
    operating_hours NUMERIC(4,2),
    planned_hours NUMERIC(4,2),
    tonnage_processed NUMERIC(10,2),
    availability_percent NUMERIC(5,2)
);

-- create downtime event table

CREATE TABLE downtime_event (
    downtime_id SERIAL PRIMARY KEY,
    shift_id INT REFERENCES shift(shift_id),
    equipment_id INT REFERENCES equipment(equipment_id),

    start_time TIMESTAMP,
    end_time TIMESTAMP,

    downtime_category TEXT,     -- Mechanical, Electrical, Process, Planned, Safety
    downtime_reason TEXT,

    is_shutdown BOOLEAN,
    is_relining_activity BOOLEAN,

    responsible_team TEXT,      -- Contractor / Maintenance / Operations
    contractor_name TEXT
);

INSERT INTO equipment (equipment_code, equipment_name, area) VALUES
('SAG01','SAG Mill','Milling'),
('BM01','Ball Mill','Milling'),
('CR01','Primary Crusher','Crushing'),
('CV01','Transfer Conveyor','Materials Handling'),
('RF01','Reclaim Feeder','Materials Handling');

INSERT INTO shift (shift_date, shift_type, supervisor_name) VALUES
('2026-01-10','DAY','A. Kamara'),
('2026-01-10','NIGHT','M. Conteh'),
('2026-01-11','DAY','A. Kamara'),
('2026-01-11','NIGHT','M. Conteh'),
('2026-01-12','DAY','S. Koroma'),
('2026-01-12','NIGHT','M. Conteh'),
('2026-01-13','DAY','A. Kamara'),
('2026-01-13','NIGHT','S. Koroma'),
('2026-01-14','DAY','A. Kamara'),
('2026-01-14','NIGHT','M. Conteh');



INSERT INTO production_log
(shift_id, equipment_id, operating_hours, planned_hours, tonnage_processed, availability_percent)
VALUES
(1,1,8.50,12.00,3250.00,70.83),
(1,2,9.10,12.00,3100.00,75.83),
(1,3,10.20,12.00,5400.00,85.00),
(2,1,6.00,12.00,2100.00,50.00),
(2,2,7.40,12.00,2600.00,61.67),
(2,3,9.80,12.00,5100.00,81.67),
(3,1,11.20,12.00,3950.00,93.33),
(3,2,10.80,12.00,3720.00,90.00),
(4,1,7.10,12.00,2500.00,59.17),
-- 2026-01-12 DAY
(5,1,10.60,12.00,3820,88.33),
(5,2,10.20,12.00,3600,85.00),
(5,3,11.40,12.00,5650,95.00),
(5,4,11.70,12.00,0,97.50),
(5,5,11.80,12.00,0,98.33),
-- 2026-01-12 NIGHT
(6,1,9.20,12.00,3320,76.67),
(6,2,9.00,12.00,3180,75.00),
(6,3,10.80,12.00,5300,90.00),
-- 2026-01-13 DAY
(7,1,11.50,12.00,4100,95.83),
(7,2,11.20,12.00,3950,93.33),
(7,3,11.80,12.00,5800,98.33),
-- 2026-01-13 NIGHT
(8,1,8.40,12.00,3000,70.00),
(8,2,8.10,12.00,2950,67.50),
(8,3,9.20,12.00,4700,76.67),
-- 2026-01-14 DAY
(9,1,11.10,12.00,4020,92.50),
(9,2,10.70,12.00,3780,89.17),
(9,3,11.60,12.00,5750,96.67),
-- 2026-01-14 NIGHT
(10,1,6.80,12.00,2400,56.67),
(10,2,7.10,12.00,2600,59.17),
(10,3,8.30,12.00,4300,69.17);





INSERT INTO downtime_event
(shift_id, equipment_id, start_time, end_time,
 downtime_category, downtime_reason,
 is_shutdown, is_relining_activity,
 responsible_team, contractor_name)
VALUES
-- Planned shutdown – liner change
(2,1,'2026-01-10 22:00','2026-01-11 04:30',
 'Planned','SAG mill liner replacement',
 TRUE, TRUE,
 'Contractor','African Relining Services'),
-- Liner handler system issue during relining
(2,1,'2026-01-11 01:15','2026-01-11 02:00',
 'Mechanical','Liner handler hydraulic fault',
 TRUE, TRUE,
 'Contractor','African Relining Services'),
-- Unplanned mechanical failure after restart
(3,1,'2026-01-11 09:20','2026-01-11 10:05',
 'Mechanical','Trunnion bearing high temperature alarm',
 FALSE, FALSE,
 'Maintenance',NULL),
-- Conveyor belt trip
(1,4,'2026-01-10 10:30','2026-01-10 11:00',
 'Process','Conveyor belt mistrack trip',
 FALSE, FALSE,
 'Operations',NULL),
-- Crusher choke
(1,3,'2026-01-10 14:10','2026-01-10 14:45',
 'Process','Crusher choke due to wet ore',
 FALSE, FALSE,
 'Operations',NULL),
 -- SAG relining continuation
(6,1,'2026-01-12 01:10','2026-01-12 03:40',
 'Planned','SAG liner installation – shell liners',
 TRUE, TRUE,'Contractor','African Relining Services'),
(6,1,'2026-01-12 03:45','2026-01-12 04:30',
 'Safety','Re-entry delay after gas test',
 TRUE, TRUE,'Contractor','African Relining Services'),
-- Ball mill planned inspection during shutdown window
(6,2,'2026-01-12 00:30','2026-01-12 02:00',
 'Planned','Ball mill gearbox inspection',
 TRUE,FALSE,'Maintenance',NULL),
-- SAG mill post-reline startup issue
(7,1,'2026-01-13 07:10','2026-01-13 07:55',
 'Electrical','Mill motor soft starter trip',
 FALSE,FALSE,'Maintenance',NULL),
-- Ball mill lubrication fault
(7,2,'2026-01-13 10:25','2026-01-13 11:05',
 'Mechanical','Lube system low pressure alarm',
 FALSE,FALSE,'Maintenance',NULL),
-- Crusher unplanned
(8,3,'2026-01-13 22:40','2026-01-13 23:30',
 'Process','Oversize rock jam at crusher feed',
 FALSE,FALSE,'Operations',NULL),
-- Conveyor belt damage
(8,4,'2026-01-13 21:10','2026-01-13 22:20',
 'Mechanical','Conveyor belt tear repair',
 FALSE,FALSE,'Maintenance',NULL),
-- Reclaim feeder blockage
(9,5,'2026-01-14 08:50','2026-01-14 09:20',
 'Process','Wet ore blockage at reclaim feeder',
 FALSE,FALSE,'Operations',NULL),
-- SAG mill liner bolt retorque (short planned stop)
(9,1,'2026-01-14 11:40','2026-01-14 12:15',
 'Planned','Post-reline liner bolt re-torque',
 FALSE,TRUE,'Contractor','African Relining Services'),
-- SAG mill bearing alarm night shift
(10,1,'2026-01-14 21:30','2026-01-14 22:25',
 'Mechanical','High pinion bearing temperature',
 FALSE,FALSE,'Maintenance',NULL),
-- Ball mill trip
(10,2,'2026-01-14 23:10','2026-01-15 00:05',
 'Electrical','VSD trip on ball mill drive',
 FALSE,FALSE,'Maintenance',NULL);


 INSERT INTO shift (shift_date, shift_type, supervisor_name) VALUES
('2026-01-15', 'DAY',   'S. Koroma'),
('2026-01-15', 'NIGHT', 'A. Kamara'),
('2026-01-16', 'DAY',   'M. Conteh'),
('2026-01-16', 'NIGHT', 'S. Koroma'),
('2026-01-17', 'DAY',   'A. Kamara'),
('2026-01-17', 'NIGHT', 'M. Conteh'),
('2026-01-18', 'DAY',   'S. Koroma'),
('2026-01-18', 'NIGHT', 'A. Kamara'),
('2026-01-19', 'DAY',   'M. Conteh'),
('2026-01-19', 'NIGHT', 'S. Koroma'),
('2026-01-20', 'DAY',   'A. Kamara'),
('2026-01-20', 'NIGHT', 'M. Conteh');


-- shift_id starts from 11 (following your last shift_id = 10)
INSERT INTO production_log
(shift_id, equipment_id, operating_hours, planned_hours, tonnage_processed, availability_percent)
VALUES
-- 2026-01-15 DAY (shift 11)
(11,1, 10.80,12.00, 3850.00, 90.00),
(11,2, 10.50,12.00, 3680.00, 87.50),
(11,3, 11.30,12.00, 5580.00, 94.17),
-- 2026-01-15 NIGHT (shift 12)
(12,1,  7.90,12.00, 2780.00, 65.83),
(12,2,  8.20,12.00, 2900.00, 68.33),
(12,3,  9.50,12.00, 4950.00, 79.17),
-- 2026-01-16 DAY (shift 13) – good day
(13,1, 11.60,12.00, 4180.00, 96.67),
(13,2, 11.40,12.00, 4050.00, 95.00),
(13,3, 11.70,12.00, 5820.00, 97.50),
-- 2026-01-16 NIGHT (shift 14) – major reline stop
(14,1,  4.50,12.00, 1580.00, 37.50),
(14,2,  9.80,12.00, 3450.00, 81.67),
(14,3, 10.10,12.00, 5250.00, 84.17),
-- 2026-01-17 DAY (shift 15)
(15,1, 10.90,12.00, 3900.00, 90.83),
(15,2, 10.60,12.00, 3750.00, 88.33),
(15,3, 11.20,12.00, 5520.00, 93.33),
-- 2026-01-17 NIGHT (shift 16)
(16,1,  8.70,12.00, 3050.00, 72.50),
(16,2,  8.40,12.00, 2950.00, 70.00),
(16,3,  9.90,12.00, 5150.00, 82.50),
-- 2026-01-18 DAY (shift 17) – strong performance
(17,1, 11.40,12.00, 4100.00, 95.00),
(17,2, 11.10,12.00, 3980.00, 92.50),
(17,3, 11.60,12.00, 5750.00, 96.67),
-- 2026-01-18 NIGHT (shift 18)
(18,1,  6.50,12.00, 2280.00, 54.17),
(18,2,  7.00,12.00, 2450.00, 58.33),
(18,3,  8.80,12.00, 4600.00, 73.33),
-- 2026-01-19 DAY (shift 19)
(19,1, 10.70,12.00, 3750.00, 89.17),
(19,2, 10.30,12.00, 3620.00, 85.83),
(19,3, 11.00,12.00, 5450.00, 91.67),
-- 2026-01-19 NIGHT (shift 20)
(20,1,  9.30,12.00, 3250.00, 77.50),
(20,2,  9.00,12.00, 3150.00, 75.00),
(20,3, 10.40,12.00, 5350.00, 86.67),
-- 2026-01-20 DAY (shift 21)
(21,1, 11.00,12.00, 3950.00, 91.67),
(21,2, 10.80,12.00, 3850.00, 90.00),
(21,3, 11.50,12.00, 5700.00, 95.83),
-- 2026-01-20 NIGHT (shift 22)
(22,1,  7.80,12.00, 2730.00, 65.00),
(22,2,  8.10,12.00, 2850.00, 67.50),
(22,3,  9.70,12.00, 5050.00, 80.83);



INSERT INTO downtime_event
(shift_id, equipment_id, start_time, end_time,
 downtime_category, downtime_reason,
 is_shutdown, is_relining_activity,
 responsible_team, contractor_name)
VALUES
-- 2026-01-15 DAY – short electrical delay
(11,1, '2026-01-15 08:40','2026-01-15 09:15',
 'Electrical','Mill drive VFD fault reset', FALSE, FALSE,
 'Maintenance', NULL),
-- 2026-01-15 NIGHT – major SAG reline (multi-hour shutdown)
(12,1, '2026-01-15 21:00','2026-01-16 05:45',
 'Planned','SAG mill shell & discharge liner replacement', TRUE, TRUE,
 'Contractor','African Relining Services'),
-- Delay during reline (safety)
(12,1, '2026-01-16 02:10','2026-01-16 03:00',
 'Safety','Confined space gas monitoring delay', TRUE, TRUE,
 'Contractor','African Relining Services'),
-- 2026-01-16 DAY – post-reline vibration trip
(13,1, '2026-01-16 10:25','2026-01-16 11:10',
 'Mechanical','High vibration on pinion bearing', FALSE, FALSE,
 'Maintenance', NULL),
-- 2026-01-16 NIGHT – crusher liner wear stop
(14,3, '2026-01-16 23:50','2026-01-17 00:40',
 'Planned','Primary crusher mantle & concave replacement', TRUE, FALSE,
 'Contractor','Metso Outotec'),
-- 2026-01-17 NIGHT – conveyor splice repair
(16,4, '2026-01-17 22:15','2026-01-17 23:50',
 'Mechanical','Belt splice failure repair', FALSE, FALSE,
 'Maintenance', NULL),
-- 2026-01-18 DAY – ball mill media reload (planned)
(17,2, '2026-01-18 06:30','2026-01-18 08:00',
 'Planned','Ball mill media addition & inspection', TRUE, FALSE,
 'Maintenance', NULL),
-- 2026-01-19 NIGHT – SAG motor cooling fan issue
(20,1, '2026-01-19 23:20','2026-01-20 00:45',
 'Electrical','Mill motor cooling fan bearing seized', FALSE, FALSE,
 'Maintenance', NULL),
-- 2026-01-20 DAY – feeder calibration stop
(21,5, '2026-01-20 09:10','2026-01-20 09:50',
 'Process','Reclaim feeder weigh scale calibration', FALSE, FALSE,
 'Operations', NULL);


 ---------------------------------------------------------
-- 1. Equipment nominal throughput (realistic design rates)
---------------------------------------------------------

DROP TABLE IF EXISTS equipment_capacity;

CREATE TABLE equipment_capacity (
    equipment_id INT PRIMARY KEY,
    nominal_tph NUMERIC(10,2)
);

INSERT INTO equipment_capacity (equipment_id, nominal_tph) VALUES
(1, 450.00),  -- SAG Mill
(2, 420.00),  -- Ball Mill
(3, 650.00),  -- Primary Crusher
(4, 1200.00), -- Transfer Conveyor
(5, 800.00);  -- Reclaim Feeder



---------------------------------------------------------
-- 2. Downtime hours per shift and equipment
---------------------------------------------------------

DROP VIEW IF EXISTS v_downtime_hours;

CREATE VIEW v_downtime_hours AS
SELECT
    shift_id,
    equipment_id,
    SUM(
        EXTRACT(EPOCH FROM (end_time - start_time)) / 3600.0
    ) AS downtime_hours
FROM downtime_event
WHERE start_time IS NOT NULL
  AND end_time   IS NOT NULL
GROUP BY
    shift_id,
    equipment_id;



---------------------------------------------------------
-- 3. Recalculate operating hours
--    operating = planned - downtime
---------------------------------------------------------

UPDATE production_log p
SET operating_hours =
    ROUND(
        GREATEST(
            p.planned_hours - COALESCE(d.downtime_hours, 0),
            0
        ),
        2
    )
FROM v_downtime_hours d
WHERE p.shift_id     = d.shift_id
  AND p.equipment_id = d.equipment_id;



---------------------------------------------------------
-- 4. Recalculate availability
---------------------------------------------------------

UPDATE production_log
SET availability_percent =
    ROUND((operating_hours / planned_hours) * 100, 2)
WHERE planned_hours > 0;



---------------------------------------------------------
-- 5. Recalculate tonnage from operating hours
--    tonnage = operating_hours × nominal throughput
---------------------------------------------------------

UPDATE production_log p
SET tonnage_processed =
    ROUND(
        p.operating_hours * c.nominal_tph,
        2
    )
FROM equipment_capacity c
WHERE p.equipment_id = c.equipment_id;



---------------------------------------------------------
-- 6. Handling equipment should not report tonnage
--    (conveyors and feeders)
---------------------------------------------------------

UPDATE production_log p
SET tonnage_processed = 0
FROM equipment e
WHERE p.equipment_id = e.equipment_id
  AND e.equipment_name IN ('Transfer Conveyor', 'Reclaim Feeder');



---------------------------------------------------------
-- 7. Final consistency clean-up (safety guard)
---------------------------------------------------------

UPDATE production_log
SET operating_hours = planned_hours
WHERE operating_hours > planned_hours;

UPDATE production_log
SET availability_percent =
    ROUND((operating_hours / planned_hours) * 100, 2)
WHERE planned_hours > 0;
