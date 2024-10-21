#!/bin/bash 

ctapipe-process --overwrite --input=/scratch/snx3000/lburmist/simtel_data/NSB386MHz/data/corsika_run1.simtel.gz --output=NSB386MHz_run1.r0.dl1.h5 --config=/users/lburmist/ctapipe_dev/ctapipe_dbscan_sim_process/configs/ctapipe_standard_sipm_config.json --max-events=10 --write-images --write-parameters --no-write-showers --DataWriter.write_raw_waveforms=True
