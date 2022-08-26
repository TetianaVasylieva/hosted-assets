#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"
if [[ $1 ]]
then
  # check if argument is a number or not
  if [[ $1 =~ ^[0-9]+$ ]]
  then
  SEARCH_RESULT=$($PSQL "SELECT elements.atomic_number, symbol, name, types.type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE atomic_number = $1;")
  else
  SEARCH_RESULT=$($PSQL "SELECT elements.atomic_number, symbol, name, types.type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE symbol = '$1' OR name = '$1';")
  fi

  if [[ -z $SEARCH_RESULT ]]
  then
    echo I could not find that element in the database.
  else
    echo $SEARCH_RESULT | while read ATOMIC_NUMBER BAR SYMBOL BAR NAME BAR TYPE BAR ATOMIC_MASS BAR MPC BAR BPC 
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MPC celsius and a boiling point of $BPC celsius."
    done
  fi  
else
  echo Please provide an element as an argument.
fi
