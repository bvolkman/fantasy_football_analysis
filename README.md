# fantasy_football_analysis
Harvard CS50 Final Project - Created a fantasy football league and tracked points, players, rosters, and win/loss records

# Design Document

By Ben Volkman

Video overview: <https://youtu.be/Kypv9zA89E8>

## Scope

The purpose of this database is to track, update, and analyze a fantasy football league's 2024 season from week-to-week and the season as a whole. Included in the scope:

* Teams and managers participating in the league with basic identifying information
* Players, which includes basic identifying information as well as their fantasy points scored for each week of the season
* Transactions, which includes the team completing the transaction, the player involved, the week it took place, and the type of transaction
* Matchups, which includes the teams playing each other for each week, later to be updated with the scores and results for each matchup
* Weeks, including the 10 weeks of the season that can be matched to the column headers in the players and transactions tables

Outside of the scope, which could be things found in actual fantasy leagues, are having bench spots for back up players to substitute in, bye weeks during the season where a player has the week off, and trading players between fantasy teams.

## Functional Requirements

* A user should be able to update the results of the matchups table
* Once the matchups are updated, they should be able to analyze the rosters, players, and points throughout the season
* Determine the ranking of the fantasy teams throughout the season

Beyond the scope would be factoring in injuries and having a playoff after the end of the regular season

## Representation

Entities are captured in SQLite tables with the following schema.

### Entities

The database includes the following entities:

#### Teams

The `teams` table includes:

* `id`, which specifies the unique ID for the team as an `INTEGER`. This column thus has the `PRIMARY KEY` constraint applied.
* `name`, which specifies the team's name as `TEXT`, given `TEXT` is appropriate for name fields.
* `manager`, which specifies the name of the person that is managing that fantasy team. `TEXT` is appropriate for name fields.

All columns are required and hence have the `NOT NULL` constraint applied where a `PRIMARY KEY` or `FOREIGN KEY` constraint is not. No other constraints are necessary.

The `players` table includes:

* `id`, which specifies the unique ID for the team as an `INTEGER`. This column thus has the `PRIMARY KEY` constraint applied.
* `name`, which specifies the team's name as `TEXT`, given `TEXT` is appropriate for name fields.
* `position`, which specifies the player's position they play and the roster spot they are able to fill.
* `nfl_team`, which specifies the player's NFL team as `TEXT`, the actual real life NFL team the player is rostered on.
* `week_1` through `week_10` columns, which specify the player's weekly points for each corresponding week of the season as `INTEGER`.

The columns `name`, `position`, and `nfl_team` are all required and have the `NOT NULL` constraint applied with the `id` as a `PRIMARY KEY`. The remaining columns for weekly points (`week_1` through `week_10`) are allowed to be `NULL` since there may be weeks where a player is injured or didn't record any scoring stats.

The `transactions` table includes:

* `id`, which specifies the unique ID for the transaction as an `INTEGER`. This column thus has the `PRIMARY KEY` constraint applied.
* `player_id`, which specifies the player's id involved in the transaction as `INTEGER`. This column thus has the `FOREIGN KEY` constraint applied, referencing the `id` column in the `players` table to ensure data integrity.
* `action_week_id`, which specifies the week the transaction takes effect and changes a teams roster during the season as `INTEGER`. This column thus has the `FOREIGN KEY` constraint applied, referencing the `id` column in the `weeks` table to ensure data integrity.
* `action`, which specifies the type of transaction taking place as `TEXT`. There is a `CHECK` in place to ensure that the actions can only be listed as 'Drafted' (only in week 1), 'Dropped, or 'Picked Up'.
* `team_id`, which specifies the fantasy team making the transaction as `INTEGER`. This column thus has the `FOREIGN KEY` constraint applied, referencing the `id` column in the `teams` table to ensure data integrity.
* `week_1` through `week_10` columns, which specify the player's weekly points for each corresponding week of the season as `INTEGER`.

The columns `player_id`, `action_week_id`, `team_id`, and `action` are all required and have the `NOT NULL` constraint applied with the `id` as a `PRIMARY KEY`. The remaining columns (`week_1` through `week_10`) are allowed to be `NULL` since a player may be dropped from a team or added later in the season and should not record points for that fantasy team when not rostered.

The `mathcups` table includes:

* `id`, which specifies the unique ID for the matchup as an `INTEGER`. This column thus has the `PRIMARY KEY` constraint applied.
* `week_id`, which specifies the week the matchup took place during the season as`INTEGER`. This column thus has the `FOREIGN KEY` constraint applied, referencing the `id` column in the `weeks` table to ensure data integrity.
* `home_team`, which specifies the first team in that matchup as `INTEGER`. The schedule was set up so that each team plays all the other teams twice. Once as the home team and once as the away team.
* `away_team`, which specifies the second team in that matchup as `INTEGER`. The schedule was set up so that each team plays all the other teams twice. Once as the home team and once as the away team.
* `home_points`, which specifies the points scored by the home team in that week as `INTEGER`. This column was previously blank until an update was executed to show the results for the season.
* `away_points`, which specifies the points scored by the away team in that week as `INTEGER`. This column was also previously blank until an update was executed to show the results for the season.
* `win`, which specifies which team won the matchup as `INTEGER`. This column was previously blank until an update was executed to show the results for the season. The winning team's id populates this column.
* `loss`, which specifies which team lost the matchup as `INTEGER`. This column was previously blank until an update was executed to show the results for the season. The losing team's id populates this column.

The columns `week_id`, `home_team`, and `away_team` are all required and have the `NOT NULL` constraint applied with the `id` as a `PRIMARY KEY`. The remaining columns of `home_points`, `away_points`, `win`, and `loss` are allowed to be `NULL` since they started out blank at the beginning of the season and were later filled in with the update query.

The 'weeks' table includes:

* `id`, which specifies the unique ID for the week as an `INTEGER`. This column thus has the `PRIMARY KEY` constraint applied.
* `week_name`, which specifies the name of the week as it correlates to the column headers in the players table and transactions table as `TEXT`. This also has the `UNIQUE` constraint to ensure that no weeks have the same name.

The column `week_name` is required and has the `NOT NULL` constraint applied with the `id` as a `PRIMARY KEY`.

### Relationships

The below entity relationship diagram describes the relationships among the entities in the database.

![ER Diagram](fantasy_footballER.png)

As detailed by the diagram:

* One team can make 0 to many transactions throughout the season. They may be happy with the team they drafted in week 1, or they might have multiple injuries or under performing players that they want to replace. Each transaction is made by only one team. Even though multiple teams can have a transaction in the same week, or a player can be rostered on different teams throughout the season, both cannot be true. Thus the same transaction cannot be performed by multiple teams (ie: the same player cannot be picked up by 2 teams in week 4).
* Transactions contain only 1 player at a time (reminder: trades cannot be performed in this league as outlined in the scope). A player can be part of only one transaction at a time.
* Transactions can occur on a weekly basis and can have 0 to many each week.
* Transactions establish a weekly roster which scores a weekly matchup. There is only one roster for each team (home and away) each week. Each matchup always contains 2 rosters.

## Optimizations

* It is common for users to search across all NFL players in the players table, so I created an index to speed up searching for `id` and `name` in the players table.

* I also wanted to make it easier for users to analyze what players were on what teams for any given week. I created the `rosters` view to make it easier to be able to see the history of the scoring and players across all weeks and teams.
* Once the `rosters` view was created, I wanted users to be able to easily see the scoring by team for each week of the season. I created the `weekly_team_totals` view to summarize fantasy team performance over the season. This view was also necessary to perform the update query that would populate the empty columns `home_points` and `away_points` in the matchups table to show the results for the season and also populate the `win` and `loss` columns based on the points.
* Finally, I realized that for users to more easily run queries and analyze the data, I would need to transform my `rosters` view from a wide table to a long table. I created the `roster_columns` view.

## Limitations

* Some limitations of my design are that I decided to only have a 10 week season instead of the full 17 week NFL season. I also went with 6 teams instead of other leagues that are typically 10 - 12 teams and involve far more players and rosters that include bench spots for back ups and injured reserve slots for hurt players. Another limitation that I realized, but was later able to correct, was how the data was formatted. The data I found online for player stats had a scoring column for each week creating a "wide" table. That's why the `roster_columns` view was so important to create, because trying to write queries and including a `GROUP BY` statement for the wide table was complicated and tedious.
* My database does not represent manager performance very well. A typical fantasy season would involve a lot more transactions every week. While my database can be useful for identifying fantasy player performances and roster trends, it does not represent real life manager strategies and roster moves very well. Most managers would be more proactive throughout the season and there would be more turnover of players on the rosters. It also does not factor in whether a player had a low weekly score due to injury or simply a poor stat line for that week.
