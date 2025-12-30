-- In this SQL file, write (and comment!) the typical SQL queries users will run on your database

--To fix the wrong player id, team 1 appeared to have 2 kickers before, 151 was the 2nd kicker and should have been 152 for a defense
UPDATE transactions
SET player_id = 152
WHERE id = 49;

-- This is before the rosters view and weekly_team_points view, this is to see the total points for each team in week 1
SELECT
    t.team_id,
    SUM(p.week_1) week_1_total
FROM transactions t
JOIN players p ON p.id = t.player_id
WHERE t.week_1 = t.team_id
GROUP BY t.team_id;

-- This gets the same result as the query above after creating the rosters and weekly_team_points views
SELECT
    team_id,
    week_1_total
FROM weekly_team_points;

--To update the matchups table with the results of the weekly scores to see which team won or lost. I used the cte to connect the weekly_team_points view (a long table) with the weeks table and the matchups table (long tables)
WITH matchup_points AS (
    SELECT
        m.id AS matchup_id,
        m.week_id,
        h.team_id AS home_team_id,
        a.team_id AS away_team_id,
        CASE w.week_name
            WHEN 'week_1' THEN h.week_1_total
            WHEN 'week_2' THEN h.week_2_total
            WHEN 'week_3' THEN h.week_3_total
            WHEN 'week_4' THEN h.week_4_total
            WHEN 'week_5' THEN h.week_5_total
            WHEN 'week_6' THEN h.week_6_total
            WHEN 'week_7' THEN h.week_7_total
            WHEN 'week_8' THEN h.week_8_total
            WHEN 'week_9' THEN h.week_9_total
            WHEN 'week_10' THEN h.week_10_total
        END AS home_points,
        CASE w.week_name
            WHEN 'week_1' THEN a.week_1_total
            WHEN 'week_2' THEN a.week_2_total
            WHEN 'week_3' THEN a.week_3_total
            WHEN 'week_4' THEN a.week_4_total
            WHEN 'week_5' THEN a.week_5_total
            WHEN 'week_6' THEN a.week_6_total
            WHEN 'week_7' THEN a.week_7_total
            WHEN 'week_8' THEN a.week_8_total
            WHEN 'week_9' THEN a.week_9_total
            WHEN 'week_10' THEN a.week_10_total
        END AS away_points
    FROM matchups m
    JOIN weeks w ON w.id = m.week_id
    JOIN weekly_team_points h ON h.team_id = m.home_team
    JOIN weekly_team_points a ON a.team_id = m.away_team
)
UPDATE matchups
SET
    home_points = mp.home_points,
    away_points = mp.away_points,
    win = CASE WHEN mp.home_points > mp.away_points THEN home_team ELSE away_team END,
    loss = CASE WHEN mp.home_points < mp.away_points THEN home_team ELSE away_team END
FROM matchup_points mp
WHERE id = mp.matchup_id;

--To calculate the final win/loss record for each team and the final standings at the end of the year, including a tie breaker using the point differential calculation
WITH team_standings AS (
    SELECT
        t.id,
        t.name,
        t.manager,
        COUNT(CASE WHEN m.win = t.id THEN 1 END) AS wins,
        COUNT(CASE WHEN m.loss = t.id THEN 1 END) AS losses,
        SUM(CASE WHEN t.id = m.home_team THEN m.home_points
            WHEN t.id = m.away_team THEN m.away_points
            END) AS points_for,
        SUM(CASE WHEN t.id = m.home_team THEN m.away_points
            WHEN t.id = m.away_team THEN m.home_points
            END) AS points_against
        FROM teams t
        JOIN matchups m ON t.id IN (m.home_team, m.away_team)
        GROUP BY t.id, t.name
)
SELECT
    RANK() OVER (ORDER BY wins DESC, points_for - points_against DESC) AS rank,
    id AS team_id,
    name AS team_name,
    manager,
    wins,
    losses,
    ROUND(points_for - points_against, 1) AS point_diff,
    points_for,
    points_against
FROM team_standings
ORDER BY rank;

-- To show the entire schedule and results of each matchup for a specific manager
SELECT
    m.week_id,
    t.manager,
    t.name AS team_name,
    CASE WHEN t.id = m.home_team THEN m.home_points
        WHEN t.id = m.away_team THEN m.away_points
        END AS points_for,
    CASE WHEN t.id = m.home_team THEN m.away_points
        WHEN t.id = m.away_team THEN m.home_points
        END AS points_against,
    CASE WHEN t.id = m.home_team THEN opp.manager
        WHEN t.id = m.away_team THEN opp.manager
        END AS opponent
FROM teams t
JOIN matchups m ON t.id IN (m.home_team, m.away_team)
JOIN teams opp ON (t.id = m.home_team AND opp.id = m.away_team) OR (t.id = m.away_team AND opp.id = m.home_team)
WHERE t.manager = 'Mike'
ORDER BY m.id, m.week_id;

--Show the top 10 point totals of the season
SELECT
    m.week_id,
    t.manager,
    t.name AS team_name,
    CASE WHEN t.id = m.home_team THEN m.home_points
        WHEN t.id = m.away_team THEN m.away_points
        END AS points_for,
    CASE WHEN t.id = m.home_team THEN m.away_points
        WHEN t.id = m.away_team THEN m.home_points
        END AS points_against,
    CASE WHEN t.id = m.home_team THEN opp.manager
        WHEN t.id = m.away_team THEN opp.manager
        END AS opponent
FROM teams t
JOIN matchups m ON t.id IN (m.home_team, m.away_team)
JOIN teams opp ON (t.id = m.home_team AND opp.id = m.away_team) OR (t.id = m.away_team AND opp.id = m.home_team)
ORDER BY points_for DESC
LIMIT 10;

--Shows which weeks had a rostered player score no points. These players either sat out due to injury, suffered an injury early in the game before scoring, or simply had a bad game and didn't record any stats
SELECT
    team_id,
    player_id,
    name,
    position,
    week_number
FROM roster_columns
WHERE points = "" OR 0
ORDER BY week_number, player_id;

--Shows any players that were rostered on more than 1 team
WITH team_count AS (
    SELECT
    r.player_id,
    r.name,
    COUNT(DISTINCT team_id) AS total_teams
    FROM rosters r
    GROUP BY r.player_id, r.name
)
SELECT
    player_id,
    name,
    total_teams
FROM team_count
WHERE total_teams > 1;

--Shows on average over the entire seaosn if running backs or wide receivers score more points on a weekly basis. Answer: Running backs
SELECT
    position,
    ROUND(AVG(points), 1) AS avg_points
FROM roster_columns
WHERE position IN ('RB', 'WR')
GROUP BY position;

--Shows which team had the most consistent weekly score (smallest range). Make sure to group by name again in the main query
WITH points_sum AS (
    SELECT
        rc.team_id,
        t.name,
        rc.week_number,
        SUM(rc.points) AS week_points
    FROM roster_columns rc
    JOIN teams t ON t.id = rc.team_id
    GROUP BY rc.week_number, rc.team_id, t.name
)
SELECT
    name,
    MAX(week_points) AS max,
    MIN(week_points) AS min,
    (MAX(week_points) - MIN(week_points)) AS point_range
FROM points_sum
GROUP BY name
ORDER BY point_range ASC;

--Shows the highest scoring player that was never rostered during the season. Make sure to use a LEFT JOIN so you can search for null values as the unrostered players.
SELECT
    p.id,
    p.name,
    p.position,
    p.nfl_team,
    (p.week_1 + p.week_2 + p.week_3 + p.week_4 + p.week_5 + p.week_6 + p.week_7 + p.week_8 + p.week_9 + p.week_10) AS total_points
FROM players p
LEFT JOIN transactions t ON t.player_id = p.id
WHERE t.player_id IS NULL
ORDER BY total_points DESC
LIMIT 1;

--Shows which manager/team had the most defensive/special team (DST) point total for the seaosn.
SELECT
    t.manager,
    t.id,
    t.name,
    rc.position,
    SUM(rc.points) AS dst_points
FROM roster_columns rc
JOIN teams t ON t.id = rc.team_id
WHERE position = 'DST'
GROUP BY t.manager, t.id, t.name, rc.position
ORDER BY dst_points DESC
LIMIT 1;

--Shows which NFL team had the most players drafted.
SELECT
    p.nfl_team,
    COUNT(t.player_id) AS player_count
FROM players p
JOIN transactions t ON t.player_id = p.id
WHERE t.action = 'Drafted'
GROUP BY p.nfl_team
ORDER BY player_count DESC;

-- To show the highest possible scoring roster in week 1: QB, WR, WR, RB, RB, TE, K, DST, FLEX (FLEX can be a WR, RB, or TE)
WITH position_rank AS (
    Select
        id,
        name,
        position,
        nfl_team,
        week_1,
        RANK () OVER (PARTITION BY position ORDER BY week_1 DESC, id) AS points_rank
    FROM players
    WHERE week_1 != ""
),
flex_cte AS (
    SELECT *
    FROM position_rank
    WHERE position IN ('WR', 'RB', 'TE')
)
SELECT
    id,
    name,
    position,
    nfl_team,
    week_1
FROM position_rank
WHERE
    (position IN ('QB', 'TE', 'K', 'DST') AND points_rank = 1)
    OR (position IN ('WR', 'RB') AND points_rank IN (1, 2))
    OR id IN (
        SELECT id
        FROM flex_cte
        WHERE (position = 'RB' AND points_rank = 3)
            OR (position = 'WR' AND points_rank = 3)
            OR (position = 'TE' AND points_rank =2)
        ORDER BY week_1 DESC
        LIMIT 1
    )
ORDER BY position;

--Shows the average win and loss margin for each manager for the entire season
WITH matchup_results AS (
    SELECT
        m.week_id,
        t.id,
        t.manager,
        t.name AS team_name,
        CASE WHEN t.id = m.home_team THEN m.home_points
            WHEN t.id = m.away_team THEN m.away_points
            END AS points_for,
        CASE WHEN t.id = m.home_team THEN m.away_points
            WHEN t.id = m.away_team THEN m.home_points
            END AS points_against,
        CASE WHEN t.id = m.home_team THEN opp.manager
            WHEN t.id = m.away_team THEN opp.manager
            END AS opponent
    FROM teams t
    JOIN matchups m ON t.id IN (m.home_team, m.away_team)
    JOIN teams opp ON (t.id = m.home_team AND opp.id = m.away_team) OR (t.id = m.away_team AND opp.id = m.home_team)
    ORDER BY m.id, m.week_id
),
point_diff_cte AS (
    SELECT
        id,
        manager,
        team_name,
        points_for - points_against AS point_diff,
        CASE WHEN points_for - points_against > 0 THEN 1 ELSE 0 END AS result
    FROM matchup_results
)
SELECT
    id,
    manager,
    team_name,
    ROUND(AVG(CASE WHEN result = 1 THEN point_diff END), 1) AS avg_win,
    ROUND(AVG(CASE WHEN result = 0 THEN point_diff END), 1) AS avg_loss
FROM point_diff_cte
GROUP BY id, manager, team_name
ORDER BY id;
