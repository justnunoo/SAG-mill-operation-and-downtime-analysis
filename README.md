SAG Mill Operation & Downtime Analysis

SQL + PostgreSQL + Power BI

📌 Project Overview

This project analyses SAG mill operations and plant downtime using a structured relational database and an interactive Power BI dashboard.

The main objective is to demonstrate how operational data from a mineral processing plant can be transformed into actionable insights for production, maintenance and shutdown decision-making.

⚠️ Important note
All data used in this project is synthetic.
However, the structure, relationships and operational behaviour are intentionally designed to closely mimic real-life mine operations, shutdown activities and mill relining scenarios.

The project is also informed by my practical exposure to mine shutdown and mill relining activities.

🎯 Objectives

Analyse SAG mill and associated equipment performance

Understand the impact of downtime on production output

Distinguish between planned shutdowns (including relining) and unplanned failures

Identify dominant downtime categories and responsible teams

Build a decision-ready operational dashboard for stakeholders

🧱 Data Model & Structure

The database is implemented in PostgreSQL and consists of four main tables:

1. shift

Stores operational shift information.

shift_date

shift_type (DAY / NIGHT)

supervisor_name

2. equipment

Stores plant equipment details.

equipment_code

equipment_name

area

3. production_log

Stores shift-based production performance.

operating_hours

planned_hours

tonnage_processed

availability_percent

Each record represents production for one equipment item in a specific shift.

4. downtime_event

Stores downtime events for each shift and equipment.

start_time

end_time

downtime_category

downtime_reason

is_shutdown

is_relining_activity

responsible_team

contractor_name

Each record represents a single downtime incident.

🔗 Relationship Between Production and Downtime

The relationship between production and downtime is created through:

shift_id

equipment_id

Both the production_log and downtime_event tables reference the same shift and equipment records.

This allows:

aggregation of downtime per shift and per equipment

correlation between downtime duration and tonnage processed

clear separation of planned shutdowns, relining activities and unplanned events

The dataset was deliberately structured so that:

long shutdown or relining periods result in reduced operating hours and lower tonnage

unplanned failures create visible production losses

partial stops still allow reduced but realistic production figures

🧪 Data Characteristics

The synthetic dataset includes:

SAG mill, ball mill, crusher, conveyors and reclaim feeders

Planned shutdowns (including liner replacement and inspections)

Relining activities flagged separately

Mechanical, electrical, process and safety-related stoppages

Contractor, maintenance and operations responsibilities

Shift-based operational performance

The data reflects realistic mill operation patterns such as:

reduced production during shutdown windows

post-reline start-up disturbances

night shift availability challenges

constraint behaviour around the SAG mill

🛠️ Tools & Technologies

PostgreSQL – data storage and analysis

SQL – data cleaning, transformation and KPI calculations

Power BI – dashboard development and visualisation

🧮 SQL Analysis & Pre-processing

SQL was used to:

join production and downtime tables

calculate total downtime per shift and per equipment

classify downtime into planned, unplanned and relining categories

calculate operational KPIs such as:

total downtime

shutdown hours

relining downtime

average availability

total tonnage processed

aggregate performance by:

equipment

shift

downtime category

responsible team

The SQL layer served as the main preprocessing and modelling stage before reporting.

📊 Power BI Dashboard

The dashboard was created by connecting Power BI directly to the PostgreSQL server.

The dashboard includes:

Overall production and availability KPIs

Total downtime and relining downtime

Downtime by category and responsible team

Equipment performance comparison

Shift and date trends

Interactive slicers for:

equipment

shift type

date

The dashboard is designed to support:

shutdown planning

maintenance prioritisation

operational performance reviews

🔍 Key Insights

From the analysis:

The SAG mill acts as the main production constraint asset

Relining activities contribute a significant share of planned downtime

Mechanical and electrical issues dominate unplanned stoppages

Night shifts generally show lower availability and throughput

There is a strong and visible relationship between downtime duration and tonnage processed

📁 Repository Contents

SQL scripts for:

table creation

data population

analysis queries

Power BI theme file

Dashboard screenshots / demo video

Project documentation

🚀 How to Run the Project

Create a PostgreSQL database

Run the SQL schema and data scripts

Open Power BI

Connect to the PostgreSQL database

Load the required tables or views

Build visuals using the prepared dataset

👤 Author

Justice Samuel Nunoo
BSc Physics (Computing)
Data & Operations Analytics | Mining & Process Operations

This project reflects my interest in combining mining operations knowledge with data analytics and business intelligence to support plant performance and shutdown optimisation.

📄 Disclaimer

This project uses synthetic data created strictly for learning, demonstration and portfolio purposes.
No real production data from any mine site is used.
