# Dimensional Model

## Model Overview

This project uses a dimensional model with shared dimensions and multiple fact views at different grains.

Core dimensions:

- `dim_players`
- `dim_games`
- `dim_teams`

Core fact views:

- `fact_shot_events`
- `fact_team_game_performance`
- `fact_goalie_game_performance`
- `fact_skater_game_performance`

---

## Dimensions

### dim_players

**Grain:** one row per player

**Logical key:**

```player_id```

Purpose: stores descriptive player attributes such as name, birth date, nationality, height, weight, position, and shooting/catching hand.

### dim_games

**Grain**: one row per game per season

**Logical key:**

`season + game_id`

**Purpose:** stores game-level context such as season, game ID, game date, and playoff flag.

### dim_teams

**Grain:** one row per team identity

**Logical key:**

`team_code`

**Purpose:** stores standardized NHL team codes and readable team names for reporting.

## Fact Views
### fact_shot_events

**Grain:** one row per shot event

**Logical key:**

`season + game_id + shot_id`

Foreign keys:

`season + game_id → dim_games`
`shooter_player_id → dim_players`
`goalie_id_for_shot → dim_players`
`team_code → dim_teams`

**Purpose:** supports analysis of shot quality, shot type, expected goals, goal outcomes, goalie performance, and shot location.

### fact_team_game_performance

**Grain:** one team in one game in one situation

**Logical key:**

`season + game_id + team_code + situation`

**Foreign keys:**

`season + game_id → dim_games`
`team_code → dim_teams`
`opposing_team_code → dim_teams`

**Purpose:** supports team-level analysis such as xGoals, Corsi, Fenwick, shots for/against, danger-level chances, and performance by game situation.

### fact_goalie_game_performance

**Grain:** one goalie in one game in one situation

**Logical key:**

`season + game_id + goalie_id + situation`

**Foreign keys:**

`season + game_id → dim_games`
`goalie_id → dim_players`
`team_code → dim_teams`
`opposing_team_code → dim_teams`

**Purpose:** supports goalie performance analysis, including goals against, expected goals against, rebound control, shot danger, and play continuation outcomes.

### fact_skater_game_performance

**Grain:** one skater in one game in one situation

**Logical key:**

`season + game_id + player_id + situation`

**Foreign keys:**

`season + game_id → dim_games`
`player_id → dim_players`
`team_code → dim_teams`
`opposing_team_code → dim_teams`

**Purpose:** supports skater-level analysis, including individual offensive production, on-ice impact, penalties, faceoffs, shot attempts, and advanced xG metrics.

## Notes on Keys

Because the analytical model currently uses SQL views, primary and foreign keys are logical rather than physically enforced.

The key combinations above were validated using SQL duplicate checks.