# NHL Analytics Database

Portfolio project focused on NHL shot event analytics using PostgreSQL, Python and Power BI.

## Project Overview

This project demonstrates the design and implementation of an analytical data warehouse using NHL play-by-play and game statistics data.  

The goal is to transform raw hockey data into a clean, validated, and well-structured dimensional model that supports advanced analytics and business intelligence   reporting.  

The project follows a complete BI workflow:  

- Data acquisition
- Data cleaning and validation
- Data enrichment using multiple data sources
- Dimensional modeling
- SQL view creation
- Power BI reporting (in progress)
- Python ETL and data processing

## Objectives

- Design a dimensional data warehouse using PostgreSQL.
- Validate and improve data quality before analysis.
- Enrich incomplete datasets using the NHL API.
- Create reusable SQL views for dimensions and fact tables.
- Build interactive Power BI dashboards based on the analytical model.
- Demonstrate an end-to-end Business Intelligence workflow.

## Technologies

- PostgreSQL
- SQL
- Python
- NHL API
- MoneyPuck dataset
- Power BI
- Git & GitHub

## MoneyPuck

Primary source of NHL play-by-play and game statistics.

Includes:

- Shot events
- Team game statistics
- Goalie game statistics
- Skater game statistics
- Line statistics


## NHL API

Used to enrich missing player information, including:

- Height
- Weight
- Birth date
- Nationality
- Jersey number
- Shooting hand
- Position


## Data Cleaning & Validation

Several data quality issues were identified and resolved during the project.

Examples include:

- Standardized inconsistent NHL team abbreviations.
- Added missing player metadata using the NHL API.
- Added missing goalie records.
- Converted player heights into a consistent integer format (inches).
- Verified logical primary keys.
- Validated duplicate records.
- Standardized data types across tables.

Detailed documentation is available in the /docs folder.

## Dimensional Model

The warehouse currently contains the following dimensions:

- dim_players
- dim_games
- dim_teams

Current fact tables:

- fact_shot_events
- fact_team_game_performance
- fact_goalie_game_performance
- fact_skater_game_performance

Each fact table has a clearly defined grain and validated logical primary key.

## Repository Structure

sql/
│
├── 01_data_cleaning.sql
├── 02_dimensions.sql
├── 03_fact_tables.sql
└── 04_validation.sql

docs/
│
├── data_cleaning.md
├── data_validation_report.md
├── design_decisions.md
└── dimensional_model.md

python/

powerbi/

images/


## Planned Dashboard

The Power BI report will include analyses such as:

- Shot quality and expected goals
- Team performance
- Goalie performance
- Player performance
- Advanced hockey statistics (Corsi, Fenwick, xGoals)

## Future Improvements

- Complete Power BI dashboard.
- Extend dimensional model with line performance analysis.
- Add additional Python ETL automation.
- Create reproducible data refresh pipeline.

## Skills Demonstrated

- SQL
- PostgreSQL
- Data Cleaning
- Data Validation
- Data Modeling
- ETL
- Business Intelligence
- Power BI
- Python
- Git
- Documentation

This project is being developed as part of my Business Intelligence and Data Analytics portfolio.