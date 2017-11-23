#!/bin/bash
if [ "x$1" == "x" ]
then
  echo "Datei angeben!"
  exit
fi

FILE=$1
MATCH_LINE=$(grep -n -m 1 '\[EEPLuaData\]' "$FILE" | cut -f1 -d:)
END_LINE=$(expr $MATCH_LINE - 2)
sed -i "1,$END_LINE s/$/$(echo \\\r)/g" $FILE

