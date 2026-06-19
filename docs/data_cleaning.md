# Data Cleaning

This document summarizes the main data cleaning steps performed before building the analytical model.

## 1. Standardizing Column Names

Column names were cleaned and standardized to improve readability and make SQL querying easier.

Examples of standardization included:

* converting inconsistent naming styles to `snake_case`
* correcting spelling issues where identified
* making column names easier to interpret in analytical views

This step helped make the database easier to work with and reduced confusion during later modeling.

---

## 2. Player Height Standardization

The original player reference data stored height as text in feet and inches.

Additional player records imported from the NHL API stored height in inches.

To make the player dimension consistent, all player heights were converted into a single numeric format:

```text
height_in
```

This allows height to be used in analysis, filtering, and Power BI visuals without additional transformation.

---

## 3. Missing Player Records

During referential integrity checks, several player IDs from the shot event table were missing from the player reference table.

These missing records were supplemented using the NHL API.

Supplemented records included fields such as:

* player ID
* name
* birth date
* nationality
* height
* weight
* shooting/catching hand
* position
* jersey number

This improved the completeness of the player dimension and allowed shot events to correctly link to player metadata.

---

## 4. Missing Goalie Records

A separate validation check identified missing goalie IDs in the shot event table.

These missing goalie records were also retrieved from the NHL API and added to the player reference table.

After supplementation, both shooter and goalie references were successfully validated.

---

## 5. Team Abbreviation Standardization

Some team abbreviations appeared in inconsistent formats in the source data.

Examples:

```text
L.A → LAK
N.J → NJD
S.J → SJS
T.B → TBL
```

These values were standardized to consistent NHL three-letter team codes to support joins with the team dimension and improve reporting consistency.

---

## 6. Team and Franchise Naming

Historical team names and relocations were considered when creating the team dimension.

Examples include:

* Atlanta Thrashers / Winnipeg Jets
* Phoenix Coyotes / Arizona Coyotes / Utah Hockey Club

The model keeps team identities aligned with the team codes used in the source data while documenting historical naming complexity.

---

## 7. Data Type Normalization

Several columns were imported with data types that did not match their analytical meaning.

For example, some ID columns were imported as decimal or real values, even though IDs should always be whole numbers.

In the analytical model, relevant columns are cast to appropriate types, such as:

* `INTEGER` for IDs, seasons, periods, and count-based fields
* `REAL` for continuous measures such as expected goals, shot distance, and shot angle
* `BOOLEAN`-like fields where values represent true/false indicators

Raw source tables were preserved where possible, while analytical views apply cleaner and more appropriate data types.

---

## 8. Natural Key Identification

The shot event table did not have a single globally unique event ID.

The column `shot_id` was not unique by itself.

After validation, the natural key for shot events was identified as:

```text
season + game_id + shot_id
```

This key uniquely identifies one shot event in the dataset.

---

## 9. Source Table Evaluation

Some source tables contained aggregated data that could be reproduced from more detailed tables.

For example, `season_goalies` was evaluated against `games_goalies_2008_2025`.

The game-level goalie table was selected as the preferred source for modeling because it provides finer granularity and can be aggregated to season level if needed.

---

## 10. Known Source Data Issues

Some placeholder-like shot records remain in the source data.

These records include cases where:

* `shooter_player_id = 0`
* shooter name is missing
* some values appear to use placeholder values such as `0` or `999`

These records were documented rather than silently removed.

This preserves transparency and makes the data quality limitations clear.
