#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c"

MAIN_MENU(){
  echo -e "\nAvailable Services:\n"
  SERVICES_LIST=$($PSQL "SELECT service_id, name FROM services ORDER BY service_id")
  echo "$SERVICES_LIST" | while read SID BAR SERVICE_NAME
  do
    echo "$SID) $SERVICE_NAME"
  done

  SELECT_SERVICE
}

SELECT_SERVICE () {
  # get service id from user
  echo "What service would you like to book?"
  read SERVICE_ID_SELECTED

  # check if service_id_selected is valid
  if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]; then
    # if service_id_selected is not a number, then show list again
    echo "I could not find that service. What would you like today?"
    MAIN_MENU
  else  
    SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id='$SERVICE_ID_SELECTED'" | sed -E 's/^ //g')

    if [[ -z $SERVICE_NAME ]]; then
      echo "I could not find that service. What would you like today?"
      MAIN_MENU 
    else :
      SERVE $SERVICE_ID_SELECTED $SERVICE_NAME
    fi
  fi
}

# Handle service selection
SERVE(){
  SERVICE_ID_SELECTED=$1
  SERVICE_NAME_SELECTED=$2
  echo "You have selected $SERVICE_NAME_SELECTED"

  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  if [[ -z $CUSTOMER_ID ]]
  then
    echo -e "\nWhat's your name"
    read CUSTOMER_NAME
    NEW_CUS_RESULT=$($PSQL "INSERT INTO customers(phone, name) VALUES ('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  else
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
    echo "Welcome back $CUSTOMER_NAME!"
  fi
  echo -e "\nWhen do you want to book service $SERVICE_NAME_SELECTED"
  read SERVICE_TIME
  if [[ $SERVICE_TIME =~ ^[0-9]{2}:[0-9]{2}$ ]]
  then
    NEW_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id,service_id,time) VALUES ($CUSTOMER_ID,$SERVICE_ID_SELECTED,'$SERVICE_TIME')")
    echo "I have put you down for a $SERVICE_NAME_SELECTED at $SERVICE_TIME, $CUSTOMER_NAME."
  else
    echo "Appointment time must follow the form hh:mm"
    SERVE $SERVICE_ID_SELECTED $SERVICE_NAME_SELECTED
  fi
}

# Run program
MAIN_MENU
