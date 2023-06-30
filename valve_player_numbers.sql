-- ===== Cleaning data in valve_player_data table =====


-- Drop columns that are not needed

ALTER TABLE portfolio_projects."valve_player_data"
DROP COLUMN "Month_Year", 
DROP COLUMN "URL";



-- Only Valve developed games will be used
-- Drop rows that are not relevant

DELETE FROM portfolio_projects."valve_player_data"
WHERE "Game_Name" NOT IN ('Counter Strike: Global Offensive', 'Dota 2', 'Team Fortress 2')




-- Values in "Percent Gain" column is currently a varchar data type but needs to instead be a float type


-- Remove % and + symbols

UPDATE portfolio_projects."valve_player_data"
SET "Percent_Gain" = REPLACE("Percent_Gain", '%', '')

UPDATE portfolio_projects."valve_player_data"
SET "Percent_Gain" = REPLACE("Percent_Gain", '+', '')

-- Convert column to float type

ALTER TABLE portfolio_projects."valve_player_data"
ALTER COLUMN "Percent_Gain" TYPE float
USING "Percent_Gain"::float




-- Add a "month" column extracted from the date

ALTER TABLE portfolio_projects."valve_player_data"
ADD COLUMN month_column integer

UPDATE portfolio_projects."valve_player_data"
SET month_column = EXTRACT(MONTH FROM "Date")





-- Create views for summary statistics


-- View for max/min of average players, max peak players and average percent change of each game

CREATE VIEW overall_player_stats AS
SELECT "Game_Name",
	   ROUND(AVG(CAST("Avg_players" AS numeric)), 2) AS "Total Average Players",
	   MAX("Avg_players") AS "Maximum Average Players",
	   MIN("Avg_players") AS "Minimum Average Players",
	   MAX("Peak_Players") AS "Maximum Peak Players",
	   ROUND(AVG(CAST("Percent_Gain" AS numeric)), 2) AS "Average Percent Change"
FROM portfolio_projects."valve_player_data"
GROUP BY "Game_Name"
ORDER BY "Total Average Players" DESC


SELECT *
FROM overall_player_stats



-- View for average number of players and average percent change within each month

CREATE VIEW monthly_stats AS 
SELECT "month_column",
	   "Game_Name",
	   ROUND(AVG(CAST("Avg_players" AS numeric)), 2) AS "Total Average Players",
	   ROUND(AVG(CAST("Percent_Gain" AS numeric)), 2) AS "Average Percent Change"
FROM portfolio_projects."valve_player_data"
GROUP BY "month_column", "Game_Name"
ORDER BY "month_column" ASC


SELECT *
FROM monthly_stats
	   
	   
	   
	   