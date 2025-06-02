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
    echo " [1]            : jobID (0-9)"
    echo " [2]            : nsbGHz (0.386, 0.268, 0.500, 0.450, 0.400, 0.350, 0.300, 0.250, 0.200, 0.150)"
    echo " [0] -h         : print help"
}

if [ $# -eq 0 ]; then
    printHelp
else
    if [ "$1" = "-d" ]; then
	if [ $# -eq 3 ]; then
	    #
	    jobID=$2
	    nsbGHz=$3
	    #
	    _min_photoelectrons=0
	    _nightsky_background=$nsbGHz
	    maxtrgev=10000
	    cfg_dir="/run_simtelarray/cfg/"
	    #
	    scratchDir="/srv/beegfs/scratch/users/b/burmistr/"
	    inFilePref="/srv/beegfs/scratch/users/b/burmistr/corsika/forNSB/"
	    outFilePref="/srv/beegfs/scratch/users/b/burmistr/sim_telarray/nsb/"
	    #
	    in_corsika_file="$inFilePref/dummy10000$jobID.corsika.gz"
	    out_simtel_file="$outFilePref/data/corsika_dummy100000_"$nsbGHz"GHz.simtel.gz"
	    out_hist_file="$outFilePref/hdata/corsika_dummy100000_"$nsbGHz"GHz.hdata"
	    out_log_file="$outFilePref/log/corsika_dummy100000_"$nsbGHz"GHz.log"
	    #
            echo "inFilePref      $inFilePref"
            echo "outFilePref     $outFilePref"
	    echo "jobID           $jobID"
	    echo "nsbGHz          $nsbGHz"
	    echo "in_corsika_file $in_corsika_file"
	    echo "out_simtel_file $out_simtel_file"
	    echo "out_hist_file   $out_hist_file"
	    echo "out_log_file    $out_log_file"
	    #
	    mkdir -p "$outFilePref/data/"
	    mkdir -p "$outFilePref/hdata/"
	    mkdir -p "$outFilePref/log/"
	    #
	    rm -rf $out_hist_file
	    rm -rf $out_simtel_file
	    rm -rf $out_log_file
	    #
	    srun singularity run -B ../run_simtelarray:/run_simtelarray -B $scratchDir:$scratchDir ../singularityalma.sif /sim_telarray/bin/sim_telarray -I$cfg_dir -c $cfg_dir/CTA-PROD5-LaPalma-baseline_4LSTs_MAGIC.cfg -C MAXIMUM_TRIGGERED_EVENTS=$maxtrgev -DNUM_TELESCOPES=1 -DNO_STEREO_TRIGGER=1 -C min_photons=0 -C min_photoelectrons=$_min_photoelectrons -C save_photons=3 -C only_triggered_telescopes=1 -C only_triggered_arrays=1 -C random_state=auto -C show=all -C maximum_telescopes=1 -C fadc_sum_bins=75 -C telescope_phi=180 -C telescope_zenith_angle=20 -C asum_threshold=8.25 -C trigger_current_limit=2000.0 -C nightsky_background=all:$_nightsky_background -C nsb_scaling_factor=1 -C dark_events=0 -C pedestal_events=0 -h $out_hist_file -o $out_simtel_file $in_corsika_file 2>&1 > $out_log_file
	    #
        else
            printHelp       
        fi      
    elif [ "$1" = "-h" ]; then
        printHelp
    else
        printHelp
    fi
fi
