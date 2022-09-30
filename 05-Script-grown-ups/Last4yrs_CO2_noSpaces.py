#!/usr/bin/python

# import csv
import csv
  
DATAFILE="API_EN.ATM.CO2E.PC_DS2_en_csv_v2_4570861.csv"
NEWDATAFILE="NEW_API_EN.ATM.CO2E.PC_DS2_en_csv_v2_4570861.csv"

# open API CSV file as input - file sourced from worldbank data of CO2 emissions per country
# open NEW_API CSV file as output
with open(DATAFILE, "r") as input:
    inputreader = csv.reader(input,delimiter=',')
    
    #Open output filee for writing with all values enclosed in double quotes to match bash version from 04 of this
    with open(NEWDATAFILE, "w") as output:
        outputwriter = csv.writer(output,delimiter=',',doublequote=True, quoting=csv.QUOTE_ALL)
        linenum=0
        for row in inputreader:
            linenum += 1
            pos=len(row)-5   # set position to 5th column from last
            # Use CSV Index [0] - first column, and 5th from the last as per position - to write to the output NEW CSV
            # skip first 4 lines before writing to outpu file
            if linenum > 4: 
            #     # debug check
            #     print (row[0].replace(" ","_"))
            #     print (row[pos:])
                  outputwriter.writerow((row[0].replace(" ","_"), row[1], row[pos], row[pos+1], row[pos+2], row[pos+3], row[pos+4]))
            