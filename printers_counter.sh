#!/bin/bash -   
#title          :printers_counter.sh
#description    :this script it was created to collect the page counter of the printers via snmp
#author         :Luis Mauricio Kihara
#date           :20191002
#version        :1.0.0      
#usage          :./printers_counter.sh
#notes          :       
#bash_version   :5.0.7(1)-release
#============================================================================

# Init the variables
PRINTER=$(awk '{print $2}' path)
GROUP='snmp_group'
VERSION='version'
MIB='1.3.6.1.2.1.43.10.2.1.4.1.1'

# the script grab the printers IP of the file and create a loop, checking all the page counters and print in the screen the information
for printers in $PRINTER; do
	COUNTER=$(snmpwalk -v $VERSION -c $GROUP $printers $MIB | awk '{print $4}')
	PRINTER_NAME=$(grep $printers path | awk '{print $1}')
	echo "Impressora: "$PRINTER_NAME " - Contador: "$COUNTER
done

