#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi
echo $($PSQL "TRUNCATE teams,games")
# Do not change code above this line. Use the PSQL variable above to query your database.
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
 TEAM1=$($PSQL "select name from teams where name='$WINNER'")
 if [[ $WINNER != 'winner' ]]
 then
  if [[ -z $TEAM1 ]]
  then
  INSERT_TEAM=$($PSQL "insert into teams(name) values('$WINNER')")
  if [[ INSERT_TEAM == "INSERT 0 1" ]]
  then 
  echo Inserted into team , $WINNER
  fi
  fi
 fi

 TEAM2=$($PSQL "select name from teams where name='$OPPONENT'")
 if [[ $OPPONENT != 'opponent' ]]
 then
  if [[ -z $TEAM2 ]]
  then
  INSERT_TEAM2=$($PSQL "insert into teams(name) values('$OPPONENT')")
  if [[ INSERT_TEAM2 == "INSERT 0 1" ]]
  then 
  echo Inserted into team , $OPPONENT
  fi
  fi
 fi


TEAM_ID_W=$($PSQL "select team_id from teams where name = '$WINNER'")
TEAM_ID_O=$($PSQL "select team_id from teams where name = '$OPPONENT'")

if [[ -n $TEAM_ID_W || -n $TEAM_ID_O ]]
then 
 if [[ $YEAR != 'year' ]]
 then
  INSERT_GAMES=$($PSQL "INSERT into games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) values($YEAR , '$ROUND' ,$TEAM_ID_W,$TEAM_ID_O,$WINNER_GOALS,$OPPONENT_GOALS)")
  if [[ INSERT_GAMES == "INSERT 0 1" ]]
  then 
  echo Inserted into team , $YEAR
  fi
 fi
fi
 done
