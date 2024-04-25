#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo "$($PSQL "TRUNCATE TABLE games, teams;")"

cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WIN_GOALS OPP_GOALS
do
  if [[ $YEAR != 'year' ]]
  then
    FIND_TEAM1_RESULT="$($PSQL "select name from teams where name = '$WINNER';")"
    FIND_TEAM2_RESULT="$($PSQL "select name from teams where name = '$OPPONENT';")"
    
    if [[ -z $FIND_TEAM1_RESULT ]]
    then
      INSERT_TEAM_RESULT="$($PSQL "insert into teams (name) values ('$WINNER');")"
      if [[ $INSERT_TEAM_RESULT = "INSERT 0 1" ]]
      then
        echo "Inserted into teams table, $WINNER"
      fi
    fi

    if [[ -z $FIND_TEAM2_RESULT ]]
    then
      INSERT_TEAM_RESULT="$($PSQL "insert into teams (name) values ('$OPPONENT');")"
      if [[ $INSERT_TEAM_RESULT = "INSERT 0 1" ]]
      then
        echo "Inserted into teams table, $OPPONENT"
      fi
    fi
  fi
done

echo -e "\n\n"

cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WIN_GOALS OPP_GOALS
do
  if [[ $YEAR != 'year' ]]
  then
    WINNER_ID="$($PSQL "select team_id from teams where name = '$WINNER';")"
    OPPONENT_ID="$($PSQL "select team_id from teams where name = '$OPPONENT';")"

    if [[ -n $WINNER_ID && -n $OPPONENT_ID ]]
    then
      INSERT_GAME_RESULT="$($PSQL "insert into games (year, round, winner_id, opponent_id, winner_goals, opponent_goals) values ($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WIN_GOALS, $OPP_GOALS);")"
      if [[ $INSERT_GAME_RESULT = "INSERT 0 1" ]]
      then
        echo Inserted into games table, $YEAR $ROUND
      fi
    fi
  fi
done
