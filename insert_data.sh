#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE TABLE games, teams;")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  # add winners teams and do not add title
  if [[ $WINNER != winner ]]
  then
    # get first team_id
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER';")
    # if not found
    if [[ -z $WINNER_ID ]]
    then
      # insert winner team
      INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams (name) VALUES ('$WINNER');") 
      if [[ $INSERT_TEAM_RESULT == "INSERT 0 1" ]]
      then 
        echo Inserted into teams, $WINNER
      fi
      # get new winner_id 
      WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER';")  
    fi
  fi
  # add opponents teams and do not add title
  if [[ $OPPONENT != opponent ]]
  then
    # get first team_id
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT';")
    # if not found
    if [[ -z $OPPONENT_ID ]]
    then
      # insert opponent team
      INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams (name) VALUES ('$OPPONENT');") 
      if [[ $INSERT_TEAM_RESULT == "INSERT 0 1" ]]
      then 
        echo Inserted into teams, $OPPONENT
      fi
      # get new winner_id 
      OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT';")  
    fi
  fi
  # add data to games table
  if [[ $YEAR != year ]]
  then
    INSERT_GAME_RESULT=$($PSQL "INSERT INTO games (year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS);")
    if [[ $INSERT_GAME_RESULT == "INSERT 0 1" ]]
    then
      echo Inserted into games, $WINNER, $OPPONENT
    fi
  fi
done
