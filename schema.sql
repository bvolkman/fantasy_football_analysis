-- In this SQL file, write (and comment!) the schema of your database, including the CREATE TABLE, CREATE INDEX, CREATE VIEW, etc. statements that compose it
-- I used the import function on the database page to enter the data into each of these tables
-- A simple table to list team ids, names, and the name of the manager
CREATE TABLE teams (
    id INTEGER,
    name TEXT NOT NULL,
    manager TEXT NOT NULL,
    PRIMARY KEY (id)
);

-- A full list of over 700 players in the NFL during last year (2024 season), eligible for fantasy scoring
CREATE TABLE players (
    id INTEGER,
    name TEXT NOT NULL,
    position TEXT NOT NULL,
    nfl_team TEXT NOT NULL,
    week_1 INTEGER,
    week_2 INTEGER,
    week_3 INTEGER,
    week_4 INTEGER,
    week_5 INTEGER,
    week_6 INTEGER,
    week_7 INTEGER,
    week_8 INTEGER,
    week_9 INTEGER,
    week_10 INTEGER,
    PRIMARY KEY (id)
);

-- The list of players on each team for each week.
-- Each team consists of 1 quarterback (QB), 2 wide receivers (WR), 2 running backs (RB), 1 tight end (TE), 1 kicker (K), 1 defense/special teams (DST), and 1 flex spot (can be a WR, RB, or TE)
-- This table also shows the action for each player: drafted at the beginning of the season, dropped from a roster, or picked up from free agents
CREATE TABLE transactions (
    id INTEGER,
    player_id INTEGER NOT NULL,
    action_week_id INTEGER NOT NULL,
    team_id INTEGER NOT NULL,
    action TEXT NOT NULL CHECK(action IN ('Drafted', 'Dropped', 'Picked Up')),
    week_1 INTEGER,
    week_2 INTEGER,
    week_3 INTEGER,
    week_4 INTEGER,
    week_5 INTEGER,
    week_6 INTEGER,
    week_7 INTEGER,
    week_8 INTEGER,
    week_9 INTEGER,
    week_10 INTEGER,
    PRIMARY KEY (id),
    FOREIGN KEY (player_id) REFERENCES players(id),
    FOREIGN KEY (action_week_id) REFERENCES "weeks"(id)
);

-- I included this in case I needed to reference the column names for each week with an id
CREATE TABLE weeks (
    id INTEGER,
    week_name TEXT NOT NULL UNIQUE,
    PRIMARY KEY (id)
);

-- This table shows the matchups between fantasy teams each week, I will update this as I run the weekly points and will then be able to determine each teams record and ultimately how each team finished at the end of the season
CREATE TABLE matchups (
    id INTEGER,
    week_id INTEGER NOT NULL,
    home_team INTEGER NOT NULL,
    away_team INTEGER NOT NULL,
    home_points INTEGER,
    away_points INTEGER,
    win INTEGER,
    loss INTEGER,
    PRIMARY KEY (id),
    FOREIGN KEY (week_id) REFERENCES weeks(id)
);

--To create a view to show the points of each player each week on their corresponding fantasy teams, factoring in players who have been dropped or picked up throughout the season
CREATE VIEW rosters AS
SELECT
    t.team_id,
    t.player_id,
    p.name,
    p.position,
    t.action,
    t.action_week_id,
    CASE WHEN t.week_1 = t.team_id THEN p.week_1 END AS week_1_pts,
    CASE WHEN t.week_2 = t.team_id THEN p.week_2 END AS week_2_pts,
    CASE WHEN t.week_3 = t.team_id THEN p.week_3 END AS week_3_pts,
    CASE WHEN t.week_4 = t.team_id THEN p.week_4 END AS week_4_pts,
    CASE WHEN t.week_5 = t.team_id THEN p.week_5 END AS week_5_pts,
    CASE WHEN t.week_6 = t.team_id THEN p.week_6 END AS week_6_pts,
    CASE WHEN t.week_7 = t.team_id THEN p.week_7 END AS week_7_pts,
    CASE WHEN t.week_8 = t.team_id THEN p.week_8 END AS week_8_pts,
    CASE WHEN t.week_9 = t.team_id THEN p.week_9 END AS week_9_pts,
    CASE WHEN t.week_10 = t.team_id THEN p.week_10 END AS week_10_pts
FROM transactions t
JOIN players p ON p.id = t.player_id
ORDER BY t.team_id;

--To calculate the total points scored by each team for that week's current roster, this view uses the previously created rosters view
CREATE VIEW weekly_team_points AS
SELECT
    team_id,
    SUM(week_1_pts) AS week_1_total,
    SUM(week_2_pts) AS week_2_total,
    SUM(week_3_pts) AS week_3_total,
    SUM(week_4_pts) AS week_4_total,
    SUM(week_5_pts) AS week_5_total,
    SUM(week_6_pts) AS week_6_total,
    SUM(week_7_pts) AS week_7_total,
    SUM(week_8_pts) AS week_8_total,
    SUM(week_9_pts) AS week_9_total,
    SUM(week_10_pts) AS week_10_total,
    SUM(week_1_pts) + SUM(week_2_pts) + SUM(week_3_pts) + SUM(week_4_pts) + SUM(week_5_pts) + SUM(week_6_pts) + SUM(week_7_pts) + SUM(week_8_pts) + SUM(week_9_pts) + SUM(week_10_pts) AS season_total
FROM rosters
GROUP BY team_id;

--To create a view similar to the rosters view, but as a long table instead of wide table where points are in just 1 column
CREATE VIEW roster_columns AS
SELECT
    r.team_id,
    r.player_id,
    r.name,
    r.position,
    w.id AS week_number,
    CASE w.id
        WHEN 1 THEN r.week_1_pts
        WHEN 2 THEN r.week_2_pts
        WHEN 3 THEN r.week_3_pts
        WHEN 4 THEN r.week_4_pts
        WHEN 5 THEN r.week_5_pts
        WHEN 6 THEN r.week_6_pts
        WHEN 7 THEN r.week_7_pts
        WHEN 8 THEN r.week_8_pts
        WHEN 9 THEN r.week_9_pts
        WHEN 10 THEN r.week_10_pts
    END AS points
FROM rosters r
CROSS JOIN weeks w
ORDER BY r.player_id, w.id;

--To create an index for the list of over 700 players
CREATE INDEX player_index ON players (id, name);
