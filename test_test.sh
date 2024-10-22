#!/usr/local/bin/bash -l

#!/bin/bash -l
function printHelp {
    echo " --> ERROR in input arguments "
    echo " [0] --t01    : test01"
    echo " [0] --t02    : test02"
    echo " [0] --t03    : test03 (singularity cscs)"
    echo " [0] -h       : print help"
}

if [ $# -eq 0 ]; then
    printHelp
else
    if [ "$1" = "--t01" ]; then
	input="/scratch/snx3000/lburmist/simtel_data/NSB268MHz/data/corsika_run1.simtel.gz"
	output="./NSB268MHz_run1.r0.dl1.h5"
	config="/users/lburmist/ctapipe_dev/ctapipe_dbscan_sim_process/configs/ctapipe_standard_sipm_config.json"
	ctapipe-process --overwrite \
			--input=$input \
			--output=$output \
			--config=$config \
			--write-images \
			--write-parameters \
			--no-write-showers \
			--DataWriter.write_r0_waveforms=True
    elif [ "$1" = "--t02" ]; then
	input="/home/burmist/home2/work/CTA/scratch/simtel_data/proton_st/data/corsika_run1.simtel.gz"
	output="/home/burmist/home2/work/CTA/scratch/ctapipe_data/proton_st/data/proton_run1.r1.dl1.h5"
	config="./configs/ctapipe_standard_sipm_config.json"
	#--max-events=10 \
	ctapipe-process --overwrite \
			--input=$input \
			--output=$output \
			--config=$config \
			--write-images \
			--write-parameters \
			--no-write-showers \
			--DataWriter.write_r1_waveforms=True
    elif [ "$1" = "--t03" ]; then
	input="/scratch/snx3000/lburmist/simtel_data/gamma_st/data/corsika_run1.simtel.gz"
	output="/scratch/snx3000/lburmist/ctapipe_data/gamma_st/data/gamma_run1.r1.dl1.h5"
	config="./configs/ctapipe_standard_sipm_config.json"
	siffile=/scratch/snx3000/lburmist/singularity/21.10.2024/ctapipe.sif
	singularity run -B /scratch/snx3000/lburmist/:/scratch/snx3000/lburmist/ $siffile \
		    ctapipe-process --overwrite \
		    --input=$input \
		    --output=$output \
		    --config=$config \
		    --max-events=10 \
		    --write-images \
		    --write-parameters \
		    --no-write-showers \
		    --DataWriter.write_r1_waveforms=True \
		    --DataWriter.write_index_tables=True \
	            --DataWriter.transform_waveform=True
    elif [ "$1" = "-h" ]; then
        printHelp
    else
        printHelp
    fi
fi
