#!/bin/bash

in_def_file="ctapipe.def"
out_sif_file="ctapipe.sif"
out_log_file="ctapipe.log"

function printHelp {
    echo " --> ERROR in input arguments "
    echo " [0] -d                  : build apptainer (singularity) no modules need to be loaded"
    echo " [0] -t                  : test sif file"
    echo " [0] --t_ctapipe_process : test ctapipe process"
    echo " [0] --t_dbscan          : test dbscan trg"
    echo " [0] -h                  : print help"
}

if [ $# -eq 0 ] 
then    
    printHelp
else
    if [ "$1" = "-d" ]; then
	#
	echo " "
	echo " "
	echo " "
	date
	#
	singularity --version
	#
	rm -rf $out_sif_file
	rm -rf $out_log_file
	time singularity build --build-arg SSH_AUTH_SOCK_USER=$SSH_AUTH_SOCK $out_sif_file $in_def_file | tee -a $out_log_file
	#
	du -hs $out_sif_file
	#
	date
	#
    elif [ "$1" = "-t" ]; then
	singularity run $out_sif_file ls
	singularity run $out_sif_file ls /ctapipe_dbscan_sim_process/
	singularity run $out_sif_file pwd
	singularity run $out_sif_file ctapipe-process --help
	singularity run $out_sif_file ctapipe-info
	singularity run $out_sif_file ctapipe-info --datamodel
	singularity run $out_sif_file ctapipe-info --version
	echo "singularity run $out_sif_file ctapipe-process --help-all"
	#
	singularity run $out_sif_file ls /DBscan_on_simtel_data/
    elif [ "$1" = "--t_ctapipe_process" ]; then
	scratchDir="/srv/beegfs/scratch/users/b/burmistr/"
        dataOIdir_sim_telarray_Preff=$scratchDir"/sim_telarray/prod5/NSB_2MHz/proton/data/"
	dataOIdir_ctapipe_Preff=$scratchDir"/ctapipe/prod5/NSB_2MHz/proton/data/"
	ctapipe_config="/ctapipe_dbscan_sim_process/configs/ctapipe_standard_sipm_config.json"
	#
	mkdir -p $dataOIdir_ctapipe_Preff
        #
        simtelIn=$dataOIdir_sim_telarray_Preff"/corsika_run1.simtel.gz"
        dl1Out=$dataOIdir_ctapipe_Preff"/corsika_run1.r1.dl1.h5"
	#
	echo "scratchDir                   = $scratchDir"
	echo "dataOIdir_sim_telarray_Preff = $dataOIdir_sim_telarray_Preff"
	echo "dataOIdir_ctapipe_Preff      = $dataOIdir_ctapipe_Preff"
	echo "ctapipe_config               = $ctapipe_config"
	echo "simtelIn                     = $simtelIn"
	echo "dl1Out                       = $dl1Out"
	#
	singularity run -B $scratchDir:$scratchDir $out_sif_file ctapipe-process --overwrite --input=$simtelIn --output=$dl1Out --config=$ctapipe_config --max-events=10 --write-images --write-parameters --no-write-showers --DataWriter.write_r1_waveforms=True
    elif [ "$1" = "--t_dbscan" ]; then
	#
	singularity run $out_sif_file ls /DBscan_on_simtel_data/
	singularity run $out_sif_file python3 /DBscan_on_simtel_data/DBscan_on_simtel_data_stereo.py
        #
	scratchDir="/srv/beegfs/scratch/users/b/burmistr/"
        dataOIdir_sim_telarray_Preff=$scratchDir"/sim_telarray/prod5/NSB_2MHz/proton/"
	dataOIdir_sim_telarray_data=$dataOIdir_sim_telarray_Preff"/data/"
	dataOIdir_sim_telarray_dbscan_npe=$dataOIdir_sim_telarray_Preff"/npe/"
	dataOIdir_ctapipe_Preff=$scratchDir"/ctapipe/prod5/NSB_2MHz/proton/data/"
	#
	mkdir -p $dataOIdir_sim_telarray_dbscan_npe
	#
        simtelIn=$dataOIdir_sim_telarray_data"/corsika_run1.simtel.gz"
        dl1In=$dataOIdir_ctapipe_Preff"/corsika_run1.r1.dl1.h5"
        outpkl=$dataOIdir_sim_telarray_dbscan_npe"/corsika_run1.npe.pkl"
        outcsv=$dataOIdir_sim_telarray_dbscan_npe"/corsika_run1.npe.csv"
        outh5=$dataOIdir_sim_telarray_dbscan_npe"/corsika_run1.npe.h5"
        #
        pixel_mapping_csv="/DBscan_on_simtel_data/pixel_mapping.csv"
        isolated_flower_seed_super_flower_csv="/DBscan_on_simtel_data/isolated_flower_seed_super_flower.list"
        isolated_flower_seed_flower_csv="/DBscan_on_simtel_data/isolated_flower_seed_flower.list"
        all_seed_flower_csv="/DBscan_on_simtel_data/all_seed_flower.list"
	#
	echo "simtelIn                              $simtelIn"
	echo "dl1In                                 $dl1In"
	echo "outpkl                                $outpkl"
	echo "outcsv                                $outcsv"
	echo "outh5                                 $outh5"
	echo "pixel_mapping_csv                     $pixel_mapping_csv"
	echo "isolated_flower_seed_super_flower_csv $isolated_flower_seed_super_flower_csv"
	echo "isolated_flower_seed_flower_csv       $isolated_flower_seed_flower_csv"
	echo "all_seed_flower_csv                   $all_seed_flower_csv"
	#
	singularity run -B $scratchDir:$scratchDir $out_sif_file python3 /DBscan_on_simtel_data/DBscan_on_simtel_data_stereo.py --trg $simtelIn $dl1In $outpkl $outcsv $outh5 $pixel_mapping_csv $isolated_flower_seed_super_flower_csv $isolated_flower_seed_flower_csv $all_seed_flower_csv
	#singularity run -B $scratchDir:$scratchDir $out_sif_file python3 /DBscan_on_simtel_data/DBscan_on_simtel_data_stereo.py --astropytable $simtelIn
	#singularity run -B $scratchDir:$scratchDir $out_sif_file python3 /DBscan_on_simtel_data/DBscan_on_simtel_data_stereo.py --astropytable_read /DBscan_on_simtel_data/testtable.h5
    elif [ "$1" = "-h" ]; then
        printHelp
    else
        printHelp
    fi
fi
