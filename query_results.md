# Query Results

Query 1: To calculate the final win/loss record for each team and the final standings at the end of the year, including a tie breaker using the point differential calculation
| id | manager | team_name        | avg_win | avg_loss |
| -- | ------- | ---------------- | ------- | -------- |
| 1  | Dan     | Wrecking Crew    | 7.5     | \-25.4   |
| 2  | Matt    | Gridiron Gang    | 45.3    | \-17.8   |
| 3  | Mike    | Holy Cowboys     | 29.7    | \-16     |
| 4  | Steve   | Sunday Warriors  | 8.5     | \-15.8   |
| 5  | Adam    | Touchdown Titans | 19.7    | \-12.3   |
| 6  | Eric    | Hail Marys       | 18.8    | \-20.8   |
#
Query 2: To show the entire schedule and results of each matchup for a specific manager
| 1  | Mike | Holy Cowboys | 87.6  | 138.5 | Adam  |
| -- | ---- | ------------ | ----- | ----- | ----- |
| 2  | Mike | Holy Cowboys | 158.4 | 99.4  | Dan   |
| 3  | Mike | Holy Cowboys | 145   | 135.5 | Matt  |
| 4  | Mike | Holy Cowboys | 104.1 | 118.2 | Eric  |
| 5  | Mike | Holy Cowboys | 124.1 | 136.2 | Steve |
| 6  | Mike | Holy Cowboys | 163.2 | 164.3 | Adam  |
| 7  | Mike | Holy Cowboys | 152.2 | 144.6 | Dan   |
| 8  | Mike | Holy Cowboys | 169   | 128.9 | Matt  |
| 9  | Mike | Holy Cowboys | 127.4 | 95.1  | Eric  |
| 10 | Mike | Holy Cowboys | 123.8 | 125.7 | Steve |
#
Query 3: Show the top 10 point totals of the season
| week_id | manager | team_name        | points_for | points_against | opponent |
| ------- | ------- | ---------------- | ---------- | -------------- | -------- |
| 8       | Mike    | Holy Cowboys     | 169        | 128.9          | Matt     |
| 6       | Adam    | Touchdown Titans | 164.3      | 163.2          | Mike     |
| 6       | Mike    | Holy Cowboys     | 163.2      | 164.3          | Adam     |
| 6       | Steve   | Sunday Warriors  | 159.6      | 149.2          | Eric     |
| 2       | Mike    | Holy Cowboys     | 158.4      | 99.4           | Dan      |
| 7       | Eric    | Hail Marys       | 153.8      | 132            | Matt     |
| 7       | Mike    | Holy Cowboys     | 152.2      | 144.6          | Dan      |
| 6       | Eric    | Hail Marys       | 149.2      | 159.6          | Steve    |
| 5       | Dan     | Wrecking Crew    | 149        | 129.8          | Eric     |
| 3       | Mike    | Holy Cowboys     | 145        | 135.5          | Matt     |
#
Query 4: Shows which weeks had a rostered player score no points. These players either sat out due to injury, suffered an injury early in the game before scoring, or simply had a bad game and didn't record any stats
| team_id | player_id | name               | position | week_number |
| ------- | --------- | ------------------ | -------- | ----------- |
| 1       | 66        | A.J. Brown         | WR       | 2           |
| 6       | 54        | George Kittle      | TE       | 3           |
| 4       | 53        | Davante Adams      | WR       | 4           |
| 3       | 56        | Trey McBride       | TE       | 4           |
| 5       | 48        | Mike Evans         | WR       | 5           |
| 1       | 43        | CeeDee Lamb        | WR       | 8           |
| 2       | 7         | Saquon Barkley     | RB       | 9           |
| 3       | 16        | Patrick Mahomes II | QB       | 9           |
| 4       | 26        | Kyren Williams     | RB       | 9           |
| 4       | 34        | James Conner       | RB       | 9           |
| 5       | 35        | Chase Brown        | RB       | 9           |
| 1       | 43        | CeeDee Lamb        | WR       | 9           |
| 1       | 66        | A.J. Brown         | WR       | 9           |
| 4       | 110       | Travis Kelce       | TE       | 9           |
#
QUERY 5: Shows any players that were rostered on more than 1 team
| player_id | name      | total_teams |
| --------- | --------- | ----------- |
| 38        | Joe Mixon | 2           |
#
Query 6: Shows on average over the entire seaosn if running backs or wide receivers score more points on a weekly basis. Answer: Running backs
| position | avg_points |
| -------- | ---------- |
| RB       | 16.1       |
| WR       | 14.1       |
#
Query 7: Shows which team had the most consistent weekly score (smallest range).
| name             | max   | min  | point_range |
| ---------------- | ----- | ---- | ----------- |
| Gridiron Gang    | 138.6 | 89.1 | 49.5        |
| Wrecking Crew    | 149   | 99.4 | 49.6        |
| Hail Marys       | 153.8 | 95.1 | 58.7        |
| Holy Cowboys     | 169   | 87.6 | 81.4        |
| Touchdown Titans | 164.3 | 80.6 | 83.7        |
| Sunday Warriors  | 159.6 | 71   | 88.6        |
#
Query 8: Shows the highest scoring player that was never rostered during the season.
| id | name           | position | nfl_team | total_points |
| -- | -------------- | -------- | -------- | ------------ |
| 4  | Baker Mayfield | QB       | TB       | 244.2        |
#
Query 9: Shows which manager/team had the most defensive/special team (DST) point total for the seaosn.
| manager | id | name       | position | dst_points |
| ------- | -- | ---------- | -------- | ---------- |
| Eric    | 6  | Hail Marys | DST      | 105.5      |
#
Query 10: Shows which NFL team had the most players drafted.
| nfl_team | player_count |
| -------- | ------------ |
| BUF      | 4            |
| BAL      | 4            |
| PHI      | 3            |
| MIN      | 3            |
| LAR      | 3            |
| DET      | 3            |
| CIN      | 3            |
| WAS      | 2            |
| TB       | 2            |
| NYJ      | 2            |
| MIA      | 2            |
| KC       | 2            |
| GB       | 2            |
| DEN      | 2            |
| DAL      | 2            |
| ATL      | 2            |
| ARI      | 2            |
| SF       | 1            |
| PIT      | 1            |
| NYG      | 1            |
| NO       | 1            |
| LV       | 1            |
| LAC      | 1            |
| JAC      | 1            |
| IND      | 1            |
| HOU      | 1            |
| CHI      | 1            |
| CAR      | 1            |
#
Query 11: To show the highest possible scoring roster in week 1: QB, WR, WR, RB, RB, TE, K, DST, FLEX (FLEX can be a WR, RB, or TE)
| id  | name           | position | nfl_team | week_1 |
| --- | -------------- | -------- | -------- | ------ |
| 148 | Chicago Bears  | DST      | CHI      | 24     |
| 60  | Chris Boswell  | K        | PIT      | 26     |
| 2   | Josh Allen     | QB       | BUF      | 31.2   |
| 7   | Saquon Barkley | RB       | PHI      | 32.2   |
| 38  | Joe Mixon      | RB       | HOU      | 25.3   |
| 197 | Isaiah Likely  | TE       | BAL      | 21.6   |
| 84  | Jayden Reed    | WR       | GB       | 31.1   |
| 122 | Cooper Kupp    | WR       | SEA      | 25     |
| 184 | Allen Lazard   | WR       | NYJ      | 23.9   |
#
Query 12: Shows the average win and loss margin for each manager for the entire season
| id | manager | team_name        | avg_win | avg_loss |
| -- | ------- | ---------------- | ------- | -------- |
| 1  | Dan     | Wrecking Crew    | 7.5     | \-25.4   |
| 2  | Matt    | Gridiron Gang    | 45.3    | \-17.8   |
| 3  | Mike    | Holy Cowboys     | 29.7    | \-16     |
| 4  | Steve   | Sunday Warriors  | 8.5     | \-15.8   |
| 5  | Adam    | Touchdown Titans | 19.7    | \-12.3   |
| 6  | Eric    | Hail Marys       | 18.8    | \-20.8   |
