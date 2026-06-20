-- ============================================================
-- 02_dimensions.sql
-- Creates analytical dimension views for the NHL shot analysis project.
-- ============================================================


-- ============================================================
-- 1. Player dimension
-- Grain: one row per player_id
-- Source: all_players
-- ============================================================

CREATE OR REPLACE VIEW dim_players AS
SELECT DISTINCT
    player_id,
    name,
    birth_date,
    nationality,
    height_in,
    weight AS weight_lb,
    shoots_catches,
    primary_position,
    position,
    primary_number,
    team AS current_team_abbrev
FROM all_players
WHERE player_id IS NOT NULL;


-- Validation check: player_id should be unique in dim_players

SELECT
    player_id,
    COUNT(*) AS row_count
FROM dim_players
GROUP BY player_id
HAVING COUNT(*) > 1;


-- ============================================================
-- 2. Game dimension
-- Grain: one row per season + game_id
-- Source: team_game_stats
-- ============================================================

CREATE OR REPLACE VIEW dim_games AS
SELECT DISTINCT
    season,
    game_id,
    game_date,
    playoff_game AS is_playoff_game
FROM team_game_stats
WHERE game_id IS NOT NULL;

-- Validation check: season + game_id should be unique in dim_games

SELECT
    season,
    game_id,
    COUNT(*)
FROM dim_games
GROUP BY season, game_id
HAVING COUNT(*) > 1;


-- ============================================================
-- 3. Team dimension
-- Grain: one row per team
-- ============================================================ 

CREATE OR REPLACE VIEW dim_teams AS
SELECT *
FROM (
    VALUES
        ('ATL', 'Atlanta Thrashers', 'ATL/WPG', 1999, 2010, false),
        ('WPG', 'Winnipeg Jets', 'ATL/WPG', 2011, NULL, true),
        ('PHX', 'Phoenix Coyotes', 'WPG/PHX/ARI/UTA', 1996, 2013, false),
        ('ARI', 'Arizona Coyotes', 'WPG/PHX/ARI/UTA', 2014, 2023, false),
        ('LAK', 'Los Angeles Kings', 'LAK', 1967, NULL, true),
        ('NJD', 'New Jersey Devils', 'NJD', 1982, NULL, true),
        ('SJS', 'San Jose Sharks', 'SJS', 1991, NULL, true),
        ('TBL', 'Tampa Bay Lightning', 'TBL', 1992, NULL, true),
        ('ANA', 'Anaheim Ducks', 'ANA', 1993, NULL, true), 
		('BOS', 'Boston Bruins', 'BOS', 1924, NULL, true),
		('BUF',	'Buffalo Sabres','BUF', 1970, NULL, true),
		('CGY',	'Calgary Flames','CGY', 1980, NULL, true),
		('CAR',	'Carolina Hurricanes','CAR', 1997, NULL, true),
		('COL',	'Colorado Avalanche','COL', 1995, NULL, true),
		('CBJ',	'Columbus Blue Jackets','CBJ', 2000, NULL, true),
		('DAL',	'Dallas Stars','DAL', 1993, NULL, true),
		('DET',	'Detroit Red Wings', 'DET', 1932, NULL, true),
		('EDM',	'Edmonton Oilers','EDM', 1979, NULL, true),
		('FLA',	'Florida Panthers','FLA', 1993, NULL, true),
		('CHI',	'Chicago Blackhawks','CHI', 1926, NULL, true),
		('MIN',	'Minnesota Wild','MIN', 2000, NULL, true),
		('MTL',	'Montreal Canadiens','MTL', 1917, NULL, true),
		('NSH',	'Nashville Predators','NSH', 1998, NULL, true),
		('NYI',	'New York Islanders','NYI', 1972, NULL, true),
		('NYR',	'New York Rangers','NYR', 1926, NULL, true),
		('OTT',	'Ottawa Senators','OTT', 1992, NULL, true),
		('PHI',	'Philadelphia Flyers','PHI', 1967, NULL, true),
		('PIT',	'Pittsburgh Penguins','PIT', 1967, NULL, true),
		('SEA',	'Seattle Kraken','SEA', 2021, NULL, true),
		('STL',	'St. Louis Blues','STL', 1967, NULL, true),
		('TOR',	'Toronto Maple Leafs','TOR',1917, NULL, true),
		('UTA',	'Utah Hockey Club','UTA',2024, NULL, true),
		('VAN',	'Vancouver Canucks','VAN',1970, NULL, true),
		('VGK',	'Vegas Golden Knights','VGK',2017, NULL, true),
		('WSH',	'Washington Capitals','WSH',1974, NULL, true)
     ) AS t(team_code, team_name, franchise_group, valid_from_season, valid_to_season, is_active);