#!/bin/bash -   
#title          :printers_counter.sh
#description    :this script it was created to collect the page counter of the BROTHER and HP printers via snmp
#author         :Luis Mauricio Kihara
#date           :20191002
#version        :1.1.0      
#usage          :./printers_counter.sh
#notes          :       
#bash_version   :5.0.7(1)-release
#============================================================================

# Init the variables
FILE='path'
PRINTER=$(awk '{print $2}' $FILE)
GROUP='name_of_group'
VERSION='version_of_snmp'
MIB='1.3.6.1.2.1.43.10.2.1.4.1.1'

# the script grab the printers IP of the file and create a loop, checking all the page counters and print in the screen the information
for printers in $PRINTER; do
	COUNTER=$(snmpwalk -v $VERSION -c $GROUP $printers $MIB | awk '{print $4}')
	PRINTER_NAME=$(grep $printers $FILE | awk '{print $1}')
	echo "Impressora: "$PRINTER_NAME " - Contador: "$COUNTER
done

