#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

echo "Enter your username:"
read USERNAME

USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")

if [[ -z $USER_ID ]]
then
  INSERT_RESULT=$($PSQL "INSERT INTO users(username) VALUES('$USERNAME')")
  USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")
  echo "Welcome, $USERNAME! It looks like this is your first time here."
else
  USERNAME_FROM_DB=$($PSQL "SELECT username FROM users WHERE user_id=$USER_ID")
  GAMES_PLAYED=$($PSQL "SELECT COUNT(*) FROM games WHERE user_id=$USER_ID")
  BEST_GAME=$($PSQL "SELECT MIN(number_of_guesses) FROM games WHERE user_id=$USER_ID")

  echo "Welcome back, $USERNAME_FROM_DB! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi

SECRET_NUMBER=$(( RANDOM % 1000 + 1 ))

echo "Guess the secret number between 1 and 1000:"
read GUESS

NUMBER_OF_GUESSES=1

while true
do
  if [[ ! $GUESS =~ ^[+-]?[0-9]+$ ]]
  then
    echo "That is not an integer, guess again:"
  else
    if [[ $GUESS == -* ]]
    then
      GUESS_IS_NEGATIVE=true
      GUESS_DIGITS=${GUESS#-}
    else
      GUESS_IS_NEGATIVE=false
      GUESS_DIGITS=${GUESS#+}
    fi

    while [[ ${#GUESS_DIGITS} -gt 1 && ${GUESS_DIGITS:0:1} == 0 ]]
    do
      GUESS_DIGITS=${GUESS_DIGITS:1}
    done

    if [[ $GUESS_IS_NEGATIVE == true && $GUESS_DIGITS != 0 ]]
    then
      echo "It's higher than that, guess again:"
    elif [[ $GUESS_IS_NEGATIVE == false && ${#GUESS_DIGITS} -gt 4 ]]
    then
      echo "It's lower than that, guess again:"
    else
      GUESS_NUMBER=$((10#$GUESS_DIGITS))

      if (( GUESS_NUMBER == SECRET_NUMBER ))
      then
        break
      elif (( GUESS_NUMBER > SECRET_NUMBER ))
      then
        echo "It's lower than that, guess again:"
      else
        echo "It's higher than that, guess again:"
      fi
    fi
  fi

  read GUESS
  ((NUMBER_OF_GUESSES++))
done

echo "You guessed it in $NUMBER_OF_GUESSES tries. The secret number was $SECRET_NUMBER. Nice job!"

INSERT_RESULT=$($PSQL "INSERT INTO games(user_id, number_of_guesses) VALUES($USER_ID, $NUMBER_OF_GUESSES)")
