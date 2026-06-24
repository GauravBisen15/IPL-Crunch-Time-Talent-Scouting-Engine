USE ipl_scouting_db;

SET SQL_SAFE_UPDATES = 0;

ALTER TABLE matches_new 
    MODIFY COLUMN batter VARCHAR(150),
    MODIFY COLUMN bowler VARCHAR(150);

CREATE OR REPLACE VIEW v_production_finishing_metrics AS
WITH HighPressureBattingStats AS (
    SELECT 
        batter AS player_identity,
        SUM(runs_batter) AS aggregate_death_runs,
        COUNT(*) AS total_balls_encountered,
        ROUND((SUM(runs_batter) / COUNT(*)) * 100, 2) AS calculated_strike_rate
    FROM matches_new
    WHERE FLOOR(overs) >= 15 
    GROUP BY batter
    HAVING total_balls_encountered >= 100
)
SELECT 
    player_identity, 
    aggregate_death_runs, 
    total_balls_encountered, 
    calculated_strike_rate
FROM HighPressureBattingStats;

CREATE OR REPLACE VIEW v_production_bowling_metrics AS
WITH HighPressureBowlingStats AS (
    SELECT 
        bowler AS player_identity,
        COUNT(*) AS total_balls_delivered,
        SUM(runs_bowler) AS aggregate_runs_conceded,
        ROUND((SUM(runs_bowler) / (COUNT(*) / 6.0)), 2) AS calculated_economy_rate,
        SUM(CASE WHEN bowler_wicket = 1 THEN 1 ELSE 0 END) AS total_wickets_secured
    FROM matches_new
    WHERE FLOOR(overs) >= 15
    GROUP BY bowler
    HAVING total_balls_delivered >= 100
)
SELECT 
    player_identity, 
    total_balls_delivered, 
    aggregate_runs_conceded, 
    calculated_economy_rate, 
    total_wickets_secured
FROM HighPressureBowlingStats;

SELECT 
    bat.player_identity AS target_marquee_asset,
    bat.calculated_strike_rate AS batting_impact_factor,
    bowl.calculated_economy_rate AS bowling_control_factor,
    bat.aggregate_death_runs AS total_runs_scored,
    bowl.total_wickets_secured AS total_wickets_taken
FROM v_production_finishing_metrics bat
INNER JOIN v_production_bowling_metrics bowl 
    ON bat.player_identity = bowl.player_identity
WHERE bat.calculated_strike_rate > 140.0 
  AND bowl.calculated_economy_rate < 8.5
ORDER BY bat.calculated_strike_rate DESC;