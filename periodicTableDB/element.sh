#! /bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

function getElementByNum() {
  ATOMIC_NUM=$1
  TARGET_ELEMENT=$($PSQL "
    SELECT * FROM elements 
    INNER JOIN properties USING(atomic_number) 
    INNER JOIN types USING(type_id)
    WHERE atomic_number='$ATOMIC_NUM';
  ")
  
  if [[ -z $TARGET_ELEMENT ]]
  then
    echo "I could not find that element in the database."
  else
    IFS='|' read TYPEID ANUM SYMBOL NAME MASS MELT BOIL TYPE<<< $TARGET_ELEMENT
    echo "The element with atomic number $ANUM is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
  fi
}

function getElementByString() {
  TARGET_STRING=$1
  # Search by full name first
  TARGET_ELEMENT=$($PSQL "
    SELECT * FROM elements 
    INNER JOIN properties USING(atomic_number) 
    INNER JOIN types USING(type_id)
    WHERE name='$TARGET_STRING';
  ")

  if [[ -z $TARGET_ELEMENT ]]
  then
    # try searching with symbol
    TARGET_ELEMENT=$($PSQL "
      SELECT * FROM elements 
      INNER JOIN properties USING(atomic_number) 
      INNER JOIN types USING(type_id)
      WHERE symbol='$TARGET_STRING';
    ")
  fi
  
  if [[ -z $TARGET_ELEMENT ]]
  then
    echo "I could not find that element in the database."
  else
    IFS='|' read TYPEID ANUM SYMBOL NAME MASS MELT BOIL TYPE<<< $TARGET_ELEMENT
    echo "The element with atomic number $ANUM is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
  fi
}

#### Main execution flow  ###
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  if [[ $1 =~ [0-9]+ ]]
  then
    # number provided
    getElementByNum $1
  else
    # string provided
    getElementByString $1
  fi
fi
