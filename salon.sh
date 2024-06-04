#! /bin/bash
PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"

MAIN() {
  echo -e $1

  SERVICES=$($PSQL "select service_id, name from services order by service_id")
  
  echo "$SERVICES" | while read ID BAR NAME
  do
    echo "$ID) $NAME"
  done

  read SERVICE_ID_SELECTED
  FOUND=$($PSQL "select name from services where service_id = $SERVICE_ID_SELECTED")

  if [[ -z $FOUND ]]
  then
    MAIN "\nI could not find that service. What would you like today?"
  fi

  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE
  CUSTOMER_NAME=$($PSQL "select name from customers where phone = '$CUSTOMER_PHONE'")
  if [[ -z $CUSTOMER_NAME ]]
  then
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME

    INSERT_CUSTOMER_RESULT=$($PSQL "insert into customers(name,phone) values('$CUSTOMER_NAME','$CUSTOMER_PHONE')")
  fi

  CUSTOMER_ID=$($PSQL "select customer_id from customers where phone = '$CUSTOMER_PHONE'")

  echo -e "\nWhat time would you like your cut, $CUSTOMER_NAME?"
  read SERVICE_TIME
  
  INSERT_APP_RESULT=$($PSQL "insert into appointments(customer_id,service_id,time) values($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
  echo -e "\nI have put you down for a$FOUND at $SERVICE_TIME, $CUSTOMER_NAME."

  EXIT
}

EXIT() {
  exit
}

MAIN "Welcome to My Salon, how can I help you?"
