#!/bin/bash
usage="Usage: bet.sh [input nifti] [output bias] [output bet] [output mask] [radius INT] [fractional DOUBLE]";

doublereg='^[0-9]+([.][0-9]+)?$'
integerreg='^[0-9]+$'
if [ "$#" -ne 6 ]; then
  echo "Not enough arguments.
  $usage" >&2;  exit 1
fi
if ! [[ $5 =~ $integerreg ]] ; then
   echo "Radius is not an integer.
   $usage" >&2; exit 1
fi
if ! [[ $6 =~ $doublereg ]] ; then
   echo "Fractional is not an double.
   $usage" >&2; exit 1
fi


file=$1; bias=$2; bet=$3; mask=$4; radius=$5; fractional=$6; 
echo "Filename $file, 
Bias: $bias, 
Bet: $bet,
Mask: $mask, 
Radius: $radius, 
Fractional: $fractional";

nice n3 --fwhm 0.75 --shrink-factor 4 4 4 -i $file -o $bias

nice dividespacing -i $bias -d 1 -m 2

nice bet $bias $bet -r $radius -f $fractional -R

nice dividespacing -i $bias -d 1 -m 0.5
nice dividespacing -i $bet -d 1 -m 0.5

nice fslmaths $bet -bin $mask

