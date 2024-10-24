#!/bin/bash
#SBATCH --job-name=ctapipe
#SBATCH --output=/scratch/snx3000/lburmist/ctapipe_data/job_outlog/ctapipe.%j.out
#SBATCH --error=/scratch/snx3000/lburmist/ctapipe_data/job_error/ctapipe.%j.err
#SBATCH --account=cta03
#SBATCH --time=24:00:00
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --partition=normal
#SBATCH --constraint=mc
#SBATCH --mem=120GB

#module load singularity
#module load daint-mc
#module load gcc/9.3.0
#module load GSL/2.7-CrayGNU-21.0
#module load cray-python/3.9.12.1

function printHelp {
    echo " --> ERROR in input arguments "
    echo " [0] -d         : default"
    echo " [1]            : particle type (g,gd,e,p,gst,gdst,est,pst)"
    echo " [2]            : fileID (1-...)"
    echo " [0] -h         : print help"
}

siffile="/scratch/snx3000/lburmist/singularity/21.10.2024/ctapipe.sif"

if [ $# -eq 0 ]; then
    printHelp
else
    if [ "$1" = "-d" ]; then
        if [ $# -eq 3 ]; then
            if [ "$2" = "g" ]; then
		particleName="gamma"
		particletype="gamma"
	    elif [ "$2" = "gd" ]; then
		particleName="gamma_diffuse"
		particletype="gamma_diffuse"
            elif [ "$2" = "e" ]; then
		particleName="electron"
		particletype="electron"
            elif [ "$2" = "p" ]; then
		particleName="proton"
		particletype="proton"
            elif [ "$2" = "gst" ]; then
		particleName="gamma"
		particletype="gamma_st"
	    elif [ "$2" = "gdst" ]; then
		particleName="gamma_diffuse"
		particletype="gamma_diffuse_st"
            elif [ "$2" = "est" ]; then
		particleName="electron"
		particletype="electron_st"
            elif [ "$2" = "pst" ]; then
		particleName="proton"
		particletype="proton_st"
            fi
	    #
	    fileID=$3
	    #
	    input="/scratch/snx3000/lburmist/simtel_data/$particletype/data/corsika_run$fileID.simtel.gz"
	    output="/scratch/snx3000/lburmist/ctapipe_data/$particletype/data/"$particleName"_run$fileID.dl1.h5"
	    config="/ctapipe_dbscan_sim_process/configs/ctapipe_standard_sipm_config.json"
	    echo "$input"
	    echo "$output"
	    #--max-events=10
	    #--DataWriter.write_r1_waveforms=True
	    #--DataWriter.transform_waveform=True
	    if [ -f "$input" ]; then
		output_dir=$(dirname $output)		  
		mkdir -p $output_dir
		cmd="singularity run -B /scratch/snx3000/lburmist/:/scratch/snx3000/lburmist/ $siffile ctapipe-process --overwrite --input=$input --output=$output --config=$config --write-images --write-parameters --no-write-showers --DataWriter.write_index_tables=True"
		#echo "$cmd"
		$cmd
	    fi
	else
	    printHelp   
	fi      	    
    elif [ "$1" = "-h" ]; then
        printHelp
    else
        printHelp
    fi
fi
