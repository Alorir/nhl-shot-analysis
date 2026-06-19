-- ============================================================
-- 04_validation.sql
-- Data validation checks for NHL analytics database
-- ============================================================


-- 1. Duplicate player IDs
-- Expected result: 0 rows

SELECT
    player_id,
    COUNT(*) AS row_count
FROM all_players
GROUP BY player_id
HAVING COUNT(*) > 1;


-- 2. Missing player IDs
-- Expected result: 0

SELECT COUNT(*) AS missing_player_ids
FROM all_players
WHERE player_id IS NULL;


-- 3. Missing shooter references
-- Expected result: 0

SELECT COUNT(*) AS missing_shooter_references
FROM shots_2007_2025 s
LEFT JOIN all_players p
    ON s.shooter_player_id::int = p.player_id
WHERE p.player_id IS NULL
  AND s.shooter_player_id <> 0;


-- 4. Missing goalie references
-- Expected result: 0

SELECT COUNT(*) AS missing_goalie_references
FROM shots_2007_2025 s
LEFT JOIN all_players p
    ON s.goalie_id_for_shot::int = p.player_id
WHERE p.player_id IS NULL
  AND s.goalie_id_for_shot <> 0;


-- 5. Shot event natural key validation
-- Expected result: 0 rows

SELECT
    season,
    game_id,
    shot_id,
    COUNT(*) AS row_count
FROM shots_2007_2025
GROUP BY season, game_id, shot_id
HAVING COUNT(*) > 1;


-- 6. Team game performance key validation
-- Expected result: 0 rows

SELECT
    season,
    game_id,
    player_team,
    situation,
    COUNT(*) AS row_count
FROM team_game_stats
GROUP BY season, game_id, player_team, situation
HAVING COUNT(*) > 1;


-- 7. Placeholder shot records
-- Documented known issue

SELECT COUNT(*) AS placeholder_shot_records
FROM shots_2007_2025
WHERE shooter_player_id = 0
  AND shooter_name IS NULL;