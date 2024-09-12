#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=<database_name> -t --no-align -c"

#Get username
echo "Enter your username:"
read USERNAME

#Check if user exist
  USER_INFO=$($PSQL "SELECT user_id, games_played, best_games FROM users WHERE username='$USERNAME'")

  if [[ -z USER_INFO ]] 
   then 
   #Add user
   echo -e "\nWelcome, $USERNAME! It looks like this is your first time here.\n"
   INSERT_USER=$($PSQL "INSERT INTO users(username) VALUES('$USERNAME')") 
   USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")
  else
   #If user exists in the database 

    IFS = "|" read USER_ID GAMES_PLAYED BEST_GAMES <<< "USER_INFO"
   echo -e "\nWelcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAMES guesses."

  fi
  # Generate the secrete number
    
  SECRET_NUMBER=$(($RANDOM % 1000 + 1))
  GUESS_COUNT=0

  #Guessing game
  echo "\nGuess the secret number between 1 and 1000:"
  While [[ $GUESS != $SECRET_NUMBER ]]
   do
     read GUESS
     #Check if the number guessed is an integer
      if [[ ! $GUESS =~ ^[0-9]+$ ]]
      then
      echo -e "\nThat is not an integer, guess again:"
      fi


      ((GUESS_COUNT++))

      if [[ $GUESS -lt $SECRET_NUMBER ]]
       then
       ech -e "\nIt's higher than that, guess again:"

       elif [[ $GUESS -gt $SECRET_NUMBER ]]
       ech -e "\nIt's lower than that, guess again:"

       fi
  done

  #If the user guesses right
   You guessed it in $GUESS_COUNT tries. The secret number was $SECRET_NUMBER. Nice job!


   #Update the database
   GAMES_PLAYED=$(( GAMES_PLAYED + 1 ))
   if [[ -z $BEST_GAMES || $GUESS_COUNT -lt $BEST_GAMES ]] 
   then
   BEST_GAMES=GUESS_COUNT

   fi

   #Record the game
   UPDATE_GAMES_PLAYED=$($PSQL "UPDATE users SET games_played = '$GAMES_PLAYED' WHERE username='$USERNAME'")
   UPDATE_BEST_GAMES=$($PSQL "UPDATE users SET best_games = '$BEST_GAMES' WHERE username='$USERNAME'")

   #Insert games information
   INSERT_GAMES_INFO=$($PSQL "INSERT INTO games(user_id,guesses) VALUES('$USER_ID','$GUESS_COUNT'")

