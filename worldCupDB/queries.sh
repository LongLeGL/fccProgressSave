#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=worldcup --no-align --tuples-only -c"

Do not change code above this line. Use the PSQL variable above to query your database.

echo -e "\nTotal number of goals in all games from winning teams:"
echo "$($PSQL "SELECT SUM(winner_goals) FROM games")"

echo -e "\nTotal number of goals in all games from both teams combined:"
echo "$($PSQL "SELECT SUM(winner_goals+opponent_goals) from games")"

echo -e "\nAverage number of goals in all games from the winning teams:"
echo $($PSQL "select AVG(winner_goals) from games")

echo -e "\nAverage number of goals in all games from the winning teams rounded to two decimal places:"
echo $($PSQL "select ROUND(AVG(winner_goals), 2) from games")

echo -e "\nAverage number of goals in all games from both teams:"
echo $($PSQL "select AVG(winner_goals+opponent_goals) from games")

echo -e "\nMost goals scored in a single game by one team:"
echo $($PSQL "select MAX(winner_goals) from games")

echo -e "\nNumber of games where the winning team scored more than two goals:"
echo $($PSQL "select count(*) from games where winner_goals > 2")

echo -e "\nWinner of the 2018 tournament team name:"
echo $($PSQL "select name from games FULL JOIN teams on winner_id = team_id where year=2018 and round='Final'")

echo -e "\nList of teams who played in the 2014 'Eighth-Final' round:"
echo $($PSQL "SELECT DISTINCT t.name
FROM teams t JOIN games g 
ON t.team_id IN (g.opponent_id, g.winner_id)
WHERE g.year = 2014 AND g.round = 'Eighth-Final'
ORDER BY t.name")

echo -e "\nList of unique winning team names in the whole data set:"
echo $($PSQL "select distinct name from teams join games on team_id=winner_id order by name")

echo -e "\nYear and team name of all the champions:"
echo $($PSQL "select year,name from teams join games on team_id=winner_id where round='Final' order by year")

echo -e "\nList of teams that start with 'Co':"
echo "$($PSQL "select distinct name from teams join games ON team_id IN (winner_id, opponent_id) where name like 'Co%' order by name")"
