#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
  echo $($PSQL "truncate teams, games")
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
tail --line=+2 games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  echo $($PSQL "insert into teams(name) values('$WINNER') on conflict(name) do nothing")
  echo $($PSQL "insert into teams(name) values('$OPPONENT') on conflict(name) do nothing")

  W_ID=$($PSQL "select team_id from teams where name='$WINNER'")
  O_ID=$($PSQL "select team_id from teams where name='$OPPONENT'")
  echo "Got ids: $W_ID - $O_ID"
  echo $($PSQL "insert into games(year,round,winner_goals,opponent_goals, winner_id,opponent_id) values($YEAR,'$ROUND',$WINNER_GOALS,$OPPONENT_GOALS, $W_ID, $O_ID)")
done

