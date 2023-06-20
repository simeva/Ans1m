#!/bin/bash

# Script to prompt user for directory and using aspell it produces a file of all incorrectly spelled words from that location
# Coded to use en_GB dictionary but this can be altered
# Simon Evans 20.06.23


read -p "What directory would you like to spell check? " var
echo "Ok i will search this directory $var"
var2=$(ls -a $var)
read -p "Where would you like the results saved to? " save
echo $var2 | aspell --lang=en_GB list > /$save/spellresults.txt
echo "Spell check complete, check your results here $save/spellresults.txt"
