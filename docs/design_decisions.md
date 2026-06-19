# Design Decisions

This document explains the main modeling and processing decisions made during the NHL analytics warehouse project.

---

## 1. Use a Layered Analytical Model

The project separates source data, cleaning logic, dimensional modeling, and analysis.

General flow:

```text
raw/source tables
→ cleaned tables/views
→ dimension and fact views
→ analysis queries
→ Power BI

## 2. Preserve Source Data Where Possible

Raw imported data is kept as close to the original source as practical.

Cleaning and modeling logic is applied in SQL scripts and analytical views.

This makes the process more transparent and allows data quality decisions to be documented.

## 3. Use NHL API to Supplement Missing Player Metadata

MoneyPuck provided detailed event data, but some player metadata was incomplete.

Missing shooter and goalie references were identified through referential integrity checks and supplemented using the NHL API.

This improved the completeness of the player dimension while keeping the cleaning process reproducible and documented.

## 4. Store Player Height as Inches

Player height appeared in different formats across sources.

The original reference data stored height as text, while NHL API records provided height as inches.

All player heights were standardized into ```text height_in```.

This makes the field easier to query, compare, and use in Power BI.


## 5. Use Views for the Analytical Model

The main dimensions and facts are currently implemented as SQL views.

This allows the model to remain flexible while the project is still evolving.

Views also make it possible to adjust cleaning logic without duplicating physical tables.

Current analytical views include:

- dim_players
- dim_games
- dim_teams
- fact_shot_events
- fact_team_game_performance
- fact_goalie_game_performance
- fact_skater_game_performance

## 6. Define Fact Tables by Grain

Fact tables were designed based on their grain, not simply by source table.

Examples:

|Fact View|	Grain|
| :--------------- | :----- |
|fact_shot_events|	One shot event|
|fact_team_game_performance	|One team in one game in one situation|
|fact_goalie_game_performance	|One goalie in one game in one situation|
|fact_skater_game_performance	|One skater in one game in one situation|

This helps prevent mixing metrics from different levels of detail.

## 7. Use Logical Keys for Views

Because the analytical model currently uses views, primary and foreign keys are logical rather than physically enforced.

Examples:

|View	|Logical Key|
| :--------------- | :----- |
|fact_shot_events	|season + game_id + shot_id
|fact_team_game_performance	|season + game_id + team_code + situation
|dim_players	|player_id
|dim_games	|season + game_id

These keys were validated using SQL duplicate checks.

## 8. Standardize Team Abbreviations

Some team abbreviations appeared inconsistently in the source data.

Examples:
```text
L.A → LAK
N.J → NJD
S.J → SJS
T.B → TBL
```
These values were standardized to support reliable joins with the team dimension.

## 9. Keep Historical Team Identities Understandable

The team dimension accounts for historical naming complexity such as:

- Atlanta Thrashers / Winnipeg Jets
- Phoenix Coyotes / Arizona Coyotes / Utah Hockey Club

For this project, team identities are modeled according to the team codes used in the dataset, with historical notes documented where relevant.

This keeps the model practical while still acknowledging franchise history.

## 10. Exclude Line-Level Fact Table From the First Version

The dataset contains line-level statistics, but this table was excluded from the first version of the analytical model.

Reason:

- player, goalie, team, and shot-level analysis already provide strong analytical coverage
- line analysis can be added later as an advanced extension
- excluding it keeps the first model focused and easier to explain

Potential future table:

```text fact_line_game_performance ```

## 11. Prefer Detailed Game-Level Tables Over Season Aggregates

Some season-level tables were reviewed and found to contain metrics that can be reproduced from more detailed game-level tables.

For example, ```text season_goalies ``` was not selected as a primary modeling table because the game-level goalie dataset provides finer granularity and can be aggregated to season level when needed.

## 12. Keep the Model Focused but Extendable

The first version of the model focuses on:

- shot event analysis
- team game performance
- goalie game performance
- skater game performance

Additional analysis areas, such as line combinations or more advanced franchise history modeling, can be added later without redesigning the core warehouse.