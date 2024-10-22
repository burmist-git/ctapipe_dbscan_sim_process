#!/bin/bash -l

function printHelp {
    echo " --> ERROR in input arguments "
    echo " [0] -d         : default"
    echo " [1]            : particle type (g,gd,e,p,gst,gdst,est,pst)"
    echo " [2]            : Nnodes (1-...)"
    echo " [0] --NSB      : NSB simulation"
    echo " [1]            : Nnodes (1-...)"
    echo " [0] -c         : clean"
    echo " [0] -h         : print help"
}

nCPU_per_node=72
nCPU_idle=1
nJOB_per_node=$(echo "$nCPU_per_node - $nCPU_idle" | bc -l)
greasyJobDir="./greasy_job/"
outGreasySbatch_sh="./run_greasy_sbatch.sh"
siffile="/scratch/snx3000/lburmist/singularity/21.10.2024/ctapipe.sif"
mkdir -p $greasyJobDir

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
		echo "#SBATCH --account=cta04" >> $outJOBfile
		echo "#SBATCH --time=24:00:00" >> $outJOBfile
		echo "#SBATCH --nodes=1" >> $outJOBfile
		echo "#SBATCH --cpus-per-task=1" >> $outJOBfile
		echo "#SBATCH --partition=normal" >> $outJOBfile
		echo "#SBATCH --constraint=mc" >> $outJOBfile
		#echo "#SBATCH --mem=120GB" >> $outJOBfile
		echo " " >> $outJOBfile
		echo "module load singularity" >> $outJOBfile
		echo "module load daint-mc" >> $outJOBfile
		echo "module load gcc/9.3.0" >> $outJOBfile
		echo "module load GSL/2.7-CrayGNU-21.09" >> $outJOBfile
		echo "module load cray-python/3.9.12.1" >> $outJOBfile
		echo "module load GREASY" >> $outJOBfile
		echo " " >> $outJOBfile
		echo "greasy $outJOBfileList" >> $outJOBfile
		#
		for jobIT in $(seq 1 $nJOB_per_node)
		do
		    #input="/scratch/snx3000/lburmist/simtel_data/gamma_st/data/corsika_run1.simtel.gz"
		    #output="/scratch/snx3000/lburmist/ctapipe_data/gamma_st/data/gamma_run1.r1.dl1.h5"
		    #config="./configs/ctapipe_standard_sipm_config.json"
		    #singularity run -B /scratch/snx3000/lburmist/:/scratch/snx3000/lburmist/ $siffile \
			#	    ctapipe-process --overwrite \
			#	    --input=$input \
			#	    --output=$output \
			#	    --config=$config \
			#	    --max-events=10 \
			#	    --write-images \
			#	    --write-parameters \
			#	    --no-write-showers \
			#	    --DataWriter.write_r1_waveforms=True
		    echo "         fileID = $fileID"
		    #
		    input="/scratch/snx3000/lburmist/simtel_data/$particletype/data/corsika_run$fileID.simtel.gz"
		    output="/scratch/snx3000/lburmist/ctapipe_data/$particletype/data/"$particleName"_run$fileID.r1.dl1.h5"
		    config="/ctapipe_dbscan_sim_process/configs/ctapipe_standard_sipm_config.json"
		    echo "$input"
		    echo "$output"
		    #
		    if [ -f "$input" ]; then
			#
			output_dir=$(dirname $output)		  
			mkdir -p $output_dir
			#
			#
			cmd="singularity run -B /tmp/:/tmp2/ -B /scratch/snx3000/lburmist/:/scratch/snx3000/lburmist/ $siffile ctapipe-process --overwrite --input=$input --output=/tmp2/"$particleName"_run$fileID.r1.dl1.h5 --config=$config --max-events=1000 --write-images --write-parameters --no-write-showers --DataWriter.write_r1_waveforms=True --DataWriter.write_index_tables=True --DataWriter.transform_waveform=True"
			echo "$cmd" >> $outJOBfileList
			#cmd="[# 1 #] mv /tmp/"$particleName"_run$fileID.r1.dl1.h5 $output"
			#echo "$cmd" >> $outJOBfileList
			#
			#
			#cmd="singularity run -B /tmp/:/tmp2/ -B /scratch/snx3000/lburmist/:/scratch/snx3000/lburmist/ /scratch/snx3000/lburmist/singularity/21.10.2024/ctapipe.sif hostname 2>&1 > /tmp/tt.log"
			#echo "$cmd" >> $outJOBfileList
			#cmd="[# 1 #] mv /tmp/tt.log /scratch/snx3000/lburmist/."
			#echo "$cmd" >> $outJOBfileList
		    fi
		    #
		    ((fileID=fileID+1))
		done
		###
		###
		###
		fileID=1
		for jobIT in $(seq 1 $nJOB_per_node)
		do
		    #
		    output="/scratch/snx3000/lburmist/ctapipe_data/$particletype/data/"$particleName"_run$fileID.r1.dl1.h5"
		    #
		    if [ -f "$input" ]; then
			#
			cmd="[# $fileID #] mv /tmp/"$particleName"_run$fileID.r1.dl1.h5 $output"
			echo "$cmd" >> $outJOBfileList
		    fi
		    #
		    ((fileID=fileID+1))
		done
		###
		###
		###
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
