#!/bin/bash

# $1 input file location (e.g. input/bd175f42-81ba-4131-8ec8-0a2dc41dbee2.mrc)
# $2 output file location (e.g. output/bd175f42-81ba-4131-8ec8-0a2dc41dbee2.pdb)
# $3 $4 -c contour ()
# $5 $6 -sstep sstep ()
# $7 $8 -vw vw ()
# $9 norm ()
# $10 solved file location (e.g. solved/bd175f42-81ba-4131-8ec8-0a2dc41dbee2.pdb)
# $11 verification file location (e.g. verification/bd175f42-81ba-4131-8ec8-0a2dc41dbee2.pdb)

ONE=$1
TWO=$2
THREE=$3
FOUR=$4
FIVE=$5
SIX=$6
SEVEN=$7
EIGHT=$8
NINE=$9
TEN=${10}
ELEVEN=${11}

export ONE
export TWO
export THREE
export FOUR
export FIVE
export SIX
export SEVEN
export EIGHT
export NINE
export TEN
export ELEVEN

printenv

input_filename=$(basename -- "$1")
ID=$(echo $input_filename | cut -f 1 -d '.')

# solved file uploaded

# sbatch --output ${PWD}/log/$ID --parsable -A dkihara --export ONE={ONE},TWO={TWO},THREE={THREE},FOUR={FOUR},FIVE={FIVE},SIX={SIX},SEVEN={SEVEN},EIGHT={EIGHT},NINE={NINE},TEN={TEN},ELEVEN={ELEVEN} \
#     --chdir ${PWD} \
#     --job-name $ID \
#     --time 24:00:00 \
#     --exclusive \
#     -N 1-1 -n 24 \
#     job.sh

# sbatch --parsable -A dkihara --export ONE={ONE},TWO={TWO},THREE={THREE},FOUR={FOUR},FIVE={FIVE},SIX={SIX},SEVEN={SEVEN},EIGHT={EIGHT},NINE={NINE},TEN={TEN},ELEVEN={ELEVEN} \
# --chdir ${PWD} \
# --job-name $ID \
# --time 24:00:00 \
# --exclusive \
# -N 1-1 -n 24 \
# job.sh

# sbatch --parsable -A dkihara --export=ALL \
# --chdir ${PWD} \
# --job-name $ID \
# --time 24:00:00 \
# --exclusive \
# -N 1-1 -n 24 \
# job.sh

sbatch --output ${PWD}/log/$ID --parsable -A dkihara --export=ALL \
--chdir ${PWD} \
--job-name $ID \
--time 24:00:00 \
--exclusive \
-N 1-1 -n 24 \
job.sh

# no solved file in the arguement

# ./run.sh input/$ID.mrc output/$ID.pdb -c 0 -sstep 2 -vw 5 -gnorm

# solved file provided in the arguement, but not uploaded tp scratch

# ./run.sh input/$ID.mrc output/$ID.pdb -c 0 -sstep 2 -vw 5 -gnorm solved/$ID.pdb $ID.pdb

until [ -f /scratch/brown/lu677/emsuite/emap2sec/output/$ID.pdb ]
do
     sleep 5
done
echo "File found"
