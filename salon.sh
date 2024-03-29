#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"

ENTER_ROW() {
  # get customer info
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE

  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")

  # if customer doesn't exist
    if [[ -z $CUSTOMER_NAME ]]
    then
    # get new customer name
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME
    # insert new customer
    INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')") 
    fi

  # get customer_id
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")

  # get service time
  echo -e "\nWhat time would you like your $SERVICE_NAME, $CUSTOMER_NAME?"
  read SERVICE_TIME
  
  # insert appintment
  INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
  #echo $INSERT_APPOINTMENT_RESULT
  # print the message
  echo -e "\nI have put you down for a$SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
    
}

MAIN_MENU() {
  if [[ $1 ]]
  then
    echo -e "\n$1\n"
  fi

  SERVICES=$($PSQL "SELECT service_id, name FROM services")
  echo "$SERVICES" | while read SERVICE_ID BAR SERVICE_NAME
  do
    echo "$SERVICE_ID) $SERVICE_NAME"
  done
  #echo -e "\nPlease enter a service number:\n"
  read SERVICE_ID_SELECTED

  # if input is not a number
  if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]
  then
    # send to main menu
    MAIN_MENU "I could not find that service. What would you like today?"
  else
    # check service_id
    SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
    # if not available
    if [[ -z $SERVICE_NAME ]]
    then
    # send to main menu
    MAIN_MENU "I could not find that service. What would you like today?"
    else
    ENTER_ROW
    fi
  fi
}
MAIN_MENU "Welcome to My Salon, how can I help you?"
