#!/bin/bash

# ${ONE} input file location (e.g. input/bd175f42-81ba-4131-8ec8-0a2dc41dbee2.mrc)
# ${TWO} output file location (e.g. output/bd175f42-81ba-4131-8ec8-0a2dc41dbee2.pdb)
# ${THREE} ${FOUR} -c contour ()
# ${FIVE} ${SIX} -sstep sstep ()
# ${SEVEN} ${EIGHT} -vw vw ()
# ${NINE} norm ()
# $TEN solved file location (e.g. solved/bd175f42-81ba-4131-8ec8-0a2dc41dbee2.pdb)
# $ELEVEN verification file location (e.g. verification/bd175f42-81ba-4131-8ec8-0a2dc41dbee2.pdb)

cd $SLURM_SUBMIT_DIR
source /home/lu677/emsuite/prereq/eman2-sphire-sparx/etc/profile.d/conda.sh
conda activate /home/lu677/emsuite/prereq/eman2-sphire-sparx


SD="/scratch/brown/lu677/emsuite/emap2sec"

input_filename=$(basename -- "${ONE}")


output_filename=$(basename -- "${TWO}")
ID=$(echo $input_filename | cut -f 1 -d '.')
stride_file_location=""
trim_file_location=trim/$input_filename

echo "generating trim file"

data_generate/map2train $SD/${ONE} ${THREE} ${FOUR} ${FIVE} ${SIX} ${SEVEN} ${EIGHT} ${NINE} > $SD/$trim_file_location
dataset_file_location=dataset/$ID.dataset
if [ -s "$SD/${TEN}" ]
then

    echo "provided with solved structure"

    solved_filename=$(basename -- "${TEN}")
    verification_filename=$(basename -- "${ELEVEN}")
    stride_file_location=stride/$ID.stride

    echo "generating stride file"

    ../prereq/stride/stride -f$SD/$stride_file_location $SD/solved/$solved_filename

    echo "generating dataset"

    python data_generate/dataset.py $SD/$trim_file_location $SD/$stride_file_location $SD/$dataset_file_location
else

    echo "generating dataset"

    python data_generate/dataset.py $SD/$trim_file_location $SD/$dataset_file_location
fi

echo "generating actual data"

echo "$SD/$dataset_file_location" > dataset_file_location
python emap2sec/Emap2sec.py dataset_file_location

echo "visualizing data"

visual/Visual.pl $SD/$trim_file_location outputP2_0 -p > $SD/output/$ID.pdb
mv outputP2_0 results
mv outputP1_0 results

