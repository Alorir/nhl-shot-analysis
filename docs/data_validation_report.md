# Data Validation Report

This document summarizes the validation checks performed before building the analytical model.

## 1. Player Dimension Validation

### Duplicate player IDs

Expected result: `0 rows`

```sql
SELECT
    player_id,
    COUNT(*) AS row_count
FROM all_players
GROUP BY player_id
HAVING COUNT(*) > 1;
```
### Missing player IDs

Expected result: 0
```sql 
SELECT COUNT(*) AS missing_player_ids
FROM all_players
WHERE player_id IS NULL;
```
Result: 0

## 2. Shot Event Referential Integrity
### Missing shooter references

Expected result: 0
```sql
SELECT COUNT(*) AS missing_shooter_references
FROM shots_2007_2025 s
LEFT JOIN all_players p
    ON s.shooter_player_id::int = p.player_id
WHERE p.player_id IS NULL
  AND s.shooter_player_id <> 0;
```
Result: 0

### Missing goalie references

Expected result: 0
```sql
SELECT COUNT(*) AS missing_goalie_references
FROM shots_2007_2025 s
LEFT JOIN all_players p
    ON s.goalie_id_for_shot::int = p.player_id
WHERE p.player_id IS NULL
  AND s.goalie_id_for_shot <> 0;
```
Result: 0

## 3. Supplemental NHL API Records

The player dimension was supplemented using the NHL API after missing references were identified.

Supplemental records added:´

```text
Record type	Count
Missing shooter/player records	124
Missing goalie records	12
```text

After enrichment, shooter and goalie references both validated successfully.

## 4. Shot Event Key Validation

The column shot_id is not globally unique by itself.

The validated natural key for shot events is:
```text
season + game_id + shot_id
```
Expected result: 0 rows
```sql
SELECT
    season,
    game_id,
    shot_id,
    COUNT(*) AS row_count
FROM shots_2007_2025
GROUP BY season, game_id, shot_id
HAVING COUNT(*) > 1;
```
Result: 0 rows

## 5. Team Game Performance Key Validation

The validated grain for team game performance is:
```text
one team + one game + one situation
```
Logical key:
```text
season + game_id + team_code + situation
```
Expected result: 0 rows
```sql
SELECT
    season,
    game_id,
    player_team,
    situation,
    COUNT(*) AS row_count
FROM team_game_stats
GROUP BY season, game_id, player_team, situation
HAVING COUNT(*) > 1;
```
Result: 0 rows

## 6. Known Source Data Issues

A small number of placeholder-like shot records remain in the dataset.

These records include:

- shooter_player_id = 0
- missing shooter name
- laceholder-like values such as 0 or 999

These records were retained and documented rather than silently removed.

## 7. Validation Summary
```text
Validation check	Result
Duplicate player IDs	Passed
Missing player IDs	Passed
Missing shooter references	Passed
Missing goalie references	Passed
Shot event natural key	Passed
Team game performance key	Passed
Placeholder shot records	Documented
```