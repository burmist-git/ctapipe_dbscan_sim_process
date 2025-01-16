#!/bin/bash

function printHelp {
    echo " --> ERROR in input arguments "
    echo " [0] -d : default"
    echo " [0] -h : print help"
}

function run_ctapipe_process_NSB {
    #
    particle_type=$1
    process_file_prefix=$2
    NSBDIR=$3
    #
    input="../../scratch/simtel_data/NSB/$NSBDIR/$particle_type/data/$process_file_prefix.simtel.gz"
    output="../../scratch/ctapipe_data/NSB/$NSBDIR/$particle_type/data/$process_file_prefix.dl1.h5"
    config="./configs/ctapipe_standard_sipm_config.json"
    #
    echo "$input"
    echo "$output"
    echo "$config"
    #
    output_dir=$(dirname $output)		  
    mkdir -p $output_dir
    ctapipe-process --overwrite --input=$input --output=$output --config=$config --write-images --write-parameters --no-write-showers --DataWriter.write_index_tables=True
    #echo "$cmd"
    #--max-events=10
    #--DataWriter.write_r1_waveforms=True
    #--DataWriter.transform_waveform=True
}

if [ $# -eq 0 ]; then
    printHelp
else
    if [ "$1" = "-d" ]; then
	#
	# NSB150MHz NSB200MHz NSB250MHz NSB268MHz NSB300MHz NSB350MHz NSB386MHz NSB400MHz
	#
	particle_type="proton"
	process_file_prefix="corsika_run307"
	NSBDIR="NSB150MHz"
	run_ctapipe_process_NSB $particle_type $process_file_prefix $NSBDIR
	NSBDIR="NSB200MHz"
	run_ctapipe_process_NSB $particle_type $process_file_prefix $NSBDIR
	NSBDIR="NSB250MHz"
	run_ctapipe_process_NSB $particle_type $process_file_prefix $NSBDIR
	NSBDIR="NSB268MHz"
	run_ctapipe_process_NSB $particle_type $process_file_prefix $NSBDIR
	NSBDIR="NSB300MHz"
	run_ctapipe_process_NSB $particle_type $process_file_prefix $NSBDIR
	NSBDIR="NSB350MHz"
	run_ctapipe_process_NSB $particle_type $process_file_prefix $NSBDIR
	NSBDIR="NSB386MHz"
	run_ctapipe_process_NSB $particle_type $process_file_prefix $NSBDIR
	NSBDIR="NSB400MHz"
	run_ctapipe_process_NSB $particle_type $process_file_prefix $NSBDIR
    elif [ "$1" = "-h" ]; then
	printHelp
    else
        printHelp
    fi
fi
