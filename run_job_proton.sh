#!/bin/bash -l
#SBATCH --job-name simtel%j
#SBATCH --error /srv/beegfs/scratch/users/b/burmistr/ctapipe/prod5/NSB_268MHz/proton/job_error/crgen_%j.error
#SBATCH --output /srv/beegfs/scratch/users/b/burmistr/ctapipe/prod5/NSB_268MHz/proton/job_output/output_%j.output
#SBATCH --ntasks 1
#SBATCH --cpus-per-task 1
#SBATCH --partition public-cpu
#SBATCH --time 24:00:00

function printHelp {
    echo " --> ERROR in input arguments "
    echo " [0] -d         : default"
    echo " [1]            : particletype (gamma, gamma_diffuse, electron, proton)"
    echo " [2]            : jobID (1-5000)"
    echo " [0] -h         : print help"
}

if [ $# -eq 0 ]; then
    printHelp
else
    if [ "$1" = "-d" ]; then
        if [ $# -eq 3 ]; then
	    #
	    particletype=$2
	    jobID=$3
	    #
	    sif_file="./ctapipe.sif"
            scratchDir="/srv/beegfs/scratch/users/b/burmistr/"
            dataOIdir_sim_telarray_Preff=$scratchDir"/sim_telarray/prod5/NSB_268MHz/$particletype/data/"
            dataOIdir_ctapipe_Preff=$scratchDir"/ctapipe/prod5/NSB_268MHz/$particletype/data/"
            ctapipe_config="/ctapipe_dbscan_sim_process/configs/ctapipe_standard_sipm_config.json"
            #
            mkdir -p $dataOIdir_ctapipe_Preff
            #
            simtelIn=$dataOIdir_sim_telarray_Preff"/corsika_run"$jobID".simtel.gz"
            dl1Out=$dataOIdir_ctapipe_Preff"/corsika_run"$jobID".r1.dl1.h5"
            #
            echo "sif_file                     = $sif_file"
            echo "scratchDir                   = $scratchDir"
            echo "dataOIdir_sim_telarray_Preff = $dataOIdir_sim_telarray_Preff"
            echo "dataOIdir_ctapipe_Preff      = $dataOIdir_ctapipe_Preff"
            echo "ctapipe_config               = $ctapipe_config"
            echo "simtelIn                     = $simtelIn"
            echo "dl1Out                       = $dl1Out"
            #
            srun singularity run -B $scratchDir:$scratchDir $sif_file ctapipe-process --overwrite --input=$simtelIn --output=$dl1Out --config=$ctapipe_config --write-images --write-parameters --no-write-showers --DataWriter.write_r1_waveforms=True
        else
            printHelp       
        fi      
    elif [ "$1" = "-h" ]; then
        printHelp
    else
        printHelp
    fi
fi
