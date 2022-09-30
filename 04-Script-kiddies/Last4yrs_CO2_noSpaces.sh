#!/bin/bash

# Show only last 4 years of CO2 emissions by country
# skip first 4 lines, replace spaces by underscores
# file sourced from worldbank data of CO2 emissions per country

DATAFILE="API_EN.ATM.CO2E.PC_DS2_en_csv_v2_4570861.csv"
NEWDATAFILE="NEW_API_EN.ATM.CO2E.PC_DS2_en_csv_v2_4570861.csv"

# file sparator is comma, print fields 1,2 and last 4 plus double quotes
tail -n +5 $DATAFILE | awk 'BEGIN { FS = "," } ; {print $1","$2","$(NF-4)","$(NF-3)","$(NF-2)","$(NF-1)",""\"\"" }' | sed 's/ /_/g' > $NEWDATAFILE  

# debug check
#head $NEWDATAFILE