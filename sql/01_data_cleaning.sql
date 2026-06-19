-- ============================================================
-- 01_data_cleaning.sql
-- Data cleaning steps for NHL analytics database
-- ============================================================


-- ============================================================
-- 1. Standardize team abbreviations
-- ============================================================

UPDATE team_game_stats
SET player_team = CASE
    WHEN player_team = 'L.A' THEN 'LAK'
    WHEN player_team = 'N.J' THEN 'NJD'
    WHEN player_team = 'S.J' THEN 'SJS'
    WHEN player_team = 'T.B' THEN 'TBL'
    ELSE player_team
END,
opposing_team = CASE
    WHEN opposing_team = 'L.A' THEN 'LAK'
    WHEN opposing_team = 'N.J' THEN 'NJD'
    WHEN opposing_team = 'S.J' THEN 'SJS'
    WHEN opposing_team = 'T.B' THEN 'TBL'
    ELSE opposing_team
END;


-- ============================================================
-- 2. Convert player height from text to inches
-- ============================================================

-- Example for original height format like 6' 1"
-- Adjust column names if your raw column is no longer called height.

UPDATE all_players
SET height_in =
    split_part(height, '''', 1)::int * 12
    +
    regexp_replace(split_part(height, '''', 2), '[^0-9]', '', 'g')::int
WHERE height IS NOT NULL
  AND height_in IS NULL;


-- ============================================================
-- 3. Check missing shooter references before NHL API enrichment
-- ============================================================

SELECT DISTINCT
    s.shooter_player_id,
    s.shooter_name
FROM shots_2007_2025 s
LEFT JOIN all_players p
    ON s.shooter_player_id::int = p.player_id
WHERE p.player_id IS NULL
  AND s.shooter_player_id <> 0
ORDER BY s.shooter_name;


-- ============================================================
-- 4. Check missing goalie references before NHL API enrichment
-- ============================================================

SELECT DISTINCT
    s.goalie_id_for_shot,
    s.goalie_name_for_shot
FROM shots_2007_2025 s
LEFT JOIN all_players p
    ON s.goalie_id_for_shot::int = p.player_id
WHERE p.player_id IS NULL
  AND s.goalie_id_for_shot <> 0
ORDER BY s.goalie_name_for_shot;


-- ============================================================
-- 5. Validate shooter references after enrichment
-- Expected result: 0
-- ============================================================

SELECT COUNT(*) AS missing_shooter_references
FROM shots_2007_2025 s
LEFT JOIN all_players p
    ON s.shooter_player_id::int = p.player_id
WHERE p.player_id IS NULL
  AND s.shooter_player_id <> 0;


-- ============================================================
-- 6. Validate goalie references after enrichment
-- Expected result: 0
-- ============================================================

SELECT COUNT(*) AS missing_goalie_references
FROM shots_2007_2025 s
LEFT JOIN all_players p
    ON s.goalie_id_for_shot::int = p.player_id
WHERE p.player_id IS NULL
  AND s.goalie_id_for_shot <> 0;


-- ============================================================
-- 7. Validate shot event natural key
-- Expected result: 0 rows
-- ============================================================

SELECT
    season,
    game_id,
    shot_id,
    COUNT(*) AS row_count
FROM shots_2007_2025
GROUP BY season, game_id, shot_id
HAVING COUNT(*) > 1;


-- ============================================================
-- 8. Identify placeholder shot records
-- ============================================================

SELECT *
FROM shots_2007_2025
WHERE shooter_player_id = 0
  AND shooter_name IS NULL;