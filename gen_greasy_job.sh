#!/bin/bash -l

function printHelp {
    echo " --> ERROR in input arguments "
    echo " [0] -d         : default"
    echo " [1]            : particle type (g,gd,e,p,nsb268,nsb386)"
    echo " [2]            : Nnodes (1-...)"
    echo " [0] -c         : clean"
    echo " [0] -h         : print help"
}

nCPU_per_node=72
nCPU_idle=71
nJOB_per_node=$(echo "$nCPU_per_node - $nCPU_idle" | bc -l)
greasyJobDir="./greasy_job/"
outGreasySbatch_sh="./run_greasy_sbatch.sh"

if [ $# -eq 0 ]; then
    printHelp
else
    if [ "$1" = "-d" ]; then
        if [ $# -eq 3 ]; then
            if [ "$2" = "g" ]; then
		particletype="gamma"
	    elif [ "$2" = "gd" ]; then
		particletype="gamma_diffuse"
            elif [ "$2" = "e" ]; then
		particletype="electron"
            elif [ "$2" = "p" ]; then
		particletype="proton"
            elif [ "$2" = "nsb386" ]; then
		particletype="NSB386MHz"
            elif [ "$2" = "nsb268" ]; then
		particletype="NSB268MHz"
	    fi
	    #
	    Nnodes=$3
	    echo "Nnodes        $Nnodes"
	    echo "nCPU_per_node $nCPU_per_node"
	    echo "nCPU_idle     $nCPU_idle"
	    echo "nJOB_per_node $nJOB_per_node"
	    #
	    fileID=1
	    #
	    rm -rf $outGreasySbatch_sh
	    #
	    for nodesID in $(seq 1 $Nnodes)
	    do
		#
		echo "nodesID = $nodesID"
		echo "#!/bin/sh" >> $outGreasySbatch_sh
		#
		outJOBfile="$greasyJobDir/node_$nodesID.job"
		outJOBfileList="$greasyJobDir/node_$nodesID.joblist"
		#
		echo "sbatch $outJOBfile" >> $outGreasySbatch_sh
		#
		rm -rf $outJOBfile
		rm -rf $outJOBfileList
		echo "#!/bin/bash -l" >> $outJOBfile
		echo "#SBATCH --job-name=simtel" >> $outJOBfile
		echo "#SBATCH --output=/scratch/snx3000/lburmist/ctapipe_data/job_outlog/simtel.%j.out" >> $outJOBfile
		echo "#SBATCH --error=/scratch/snx3000/lburmist/ctapipe_data/job_error/simtel.%j.err" >> $outJOBfile
		echo "#SBATCH --account=cta03" >> $outJOBfile
		echo "#SBATCH --time=24:00:00" >> $outJOBfile
		echo "#SBATCH --nodes=1" >> $outJOBfile
		echo "#SBATCH --cpus-per-task=1" >> $outJOBfile
		echo "#SBATCH --partition=normal" >> $outJOBfile
		echo "#SBATCH --constraint=mc" >> $outJOBfile
		echo " " >> $outJOBfile
		echo "module load daint-mc" >> $outJOBfile
		#echo "module load gcc/9.3.0" >> $outJOBfile
		#echo "module load GSL/2.7-CrayGNU-21.09" >> $outJOBfile
		#echo "module load cray-python/3.9.12.1" >> $outJOBfile
		echo "module load GREASY" >> $outJOBfile
		echo " " >> $outJOBfile
		echo "greasy $outJOBfileList" >> $outJOBfile
		#
		out_r0_dl1_h5_file_dir="/scratch/snx3000/lburmist/ctapipe_data/$particletype"
		mkdir -p $out_r0_dl1_h5_file_dir
		#
		for jobIT in $(seq 1 $nJOB_per_node)
		do
		    #
		    config_file="/users/lburmist/ctapipe_dev/ctapipe_dbscan_sim_process/configs/ctapipe_standard_sipm_config.json"
		    in_simtel_file="/scratch/snx3000/lburmist/simtel_data/$particletype/data/corsika_run$fileID.simtel.gz"
		    #
		    echo "         fileID         = $fileID"
		    echo "         in_simtel_file = $in_simtel_file"
		    #
		    if [ -f "$in_simtel_file" ]; then
			out_r0_dl1_h5_file="$out_r0_dl1_h5_file_dir/"$particletype"_run$fileID.r0.dl1.h5"
			#
			#cmd="ctapipe-process --overwrite --input=$in_simtel_file --output=$out_r0_dl1_h5_file --config=$config_file --write-images --write-parameters --no-write-showers --DataWriter.write_raw_waveforms=True"
			cmd="ctapipe-process --overwrite --input=$in_simtel_file --output=$out_r0_dl1_h5_file --config=$config_file --write-images --write-parameters --no-write-showers --DataWriter.write_r0_waveforms=True"
			echo "$cmd" >> $outJOBfileList
		    fi
		    ((fileID=fileID+1))
		done
	    done
	else
	    printHelp   
	fi      
    elif [ "$1" = "-c" ]; then
	rm -rf $greasyJobDir/*
	rm -rf $outGreasySbatch_sh
    elif [ "$1" = "-h" ]; then
        printHelp
    else
        printHelp
    fi
fi
