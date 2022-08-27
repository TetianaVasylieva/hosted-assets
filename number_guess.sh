#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

CHECK_GUESS_NUMBER_INTEGER() {
read GUESS_NUMBER
if [[ ! $GUESS_NUMBER =~ ^[0-9]+$ ]]
then
  echo That is not an integer, guess again:
  CHECK_GUESS_NUMBER_INTEGER
fi
}

SECRET_NUMBER=$((1 + $RANDOM % 1000))
#echo $SECRET_NUMBER
echo Enter your username:
read USERNAME
USER_ID=$($PSQL "SELECT user_id FROM users WHERE username = '$USERNAME';")
if [[ -z $USER_ID ]]
then
  echo "Welcome, $USERNAME! It looks like this is your first time here."
  INSERT_USER_RESULT=$($PSQL "INSERT INTO users (username) VALUES ('$USERNAME');")
  USER_ID=$($PSQL "SELECT user_id FROM users WHERE username = '$USERNAME';")  
else
  GAMES_PLAYED=$($PSQL "SELECT COUNT(user_id) FROM games WHERE user_id = $USER_ID;")
  BEST_GAME=$($PSQL "SELECT MIN(number_of_guesses) FROM games WHERE user_id = $USER_ID;")
  echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi

# request for input of guess_number
echo "Guess the secret number between 1 and 1000:"
CHECK_GUESS_NUMBER_INTEGER
((GUESS_NUMBER += 0))
NUMBER_OF_GUESSES=1
while [[ $SECRET_NUMBER -ne $GUESS_NUMBER ]]
do
  ((NUMBER_OF_GUESSES += 1))
  if [[ $SECRET_NUMBER -gt $GUESS_NUMBER ]]
  then
    echo "It's higher than that, guess again:"
  else 
    echo "It's lower than that, guess again:"
  fi
  CHECK_GUESS_NUMBER_INTEGER
done
echo You guessed it in $NUMBER_OF_GUESSES tries. The secret number was $SECRET_NUMBER. Nice job!
INSERT_GAME_RESULT=$($PSQL "INSERT INTO games (user_id, number_of_guesses) VALUES ($USER_ID, $NUMBER_OF_GUESSES);")
