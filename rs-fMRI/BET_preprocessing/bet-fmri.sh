#!/bin/bash
usage="Usage: bet.sh [input nifti] [output bet] [output mask] [radius INT] [fractional DOUBLE]";

doublereg='^[0-9]+([.][0-9]+)?$'
integerreg='^[0-9]+$'
if [ "$#" -ne 5 ]; then
  echo "Not enough arguments.
  $usage" >&2;  exit 1
fi
if ! [[ $4 =~ $integerreg ]] ; then
   echo "Radius is not an integer.
   $usage" >&2; exit 1
fi
if ! [[ $5 =~ $doublereg ]] ; then
   echo "Fractional is not an double.
   $usage" >&2; exit 1
fi


file=$1; bet=$2; mask=$3; radius=$4; fractional=$5; 
echo "Filename: $file, 
Bet: $bet,
Mask: $mask, 
Radius: $radius, 
Fractional: $fractional";

nice dividespacing -i $file -d 1 -m 2

nice bet $file $bet -r $radius -f $fractional -R

nice dividespacing -i $bet -d 1 -m 0.5
nice dividespacing -i $file -d 1 -m 0.5

nice fslmaths $bet -bin $mask

