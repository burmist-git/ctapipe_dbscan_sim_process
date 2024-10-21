#!/usr/local/bin/bash

ctapipe-process --overwrite \
		--input=/scratch/snx3000/lburmist/simtel_data/NSB268MHz/data/corsika_run1.simtel.gz \
		--output=./NSB268MHz_run1.r0.dl1.h5 \
		--config=/users/lburmist/ctapipe_dev/ctapipe_dbscan_sim_process/configs/ctapipe_standard_sipm_config.json \
		--write-images \
		--write-parameters \
		--no-write-showers \
		--DataWriter.write_r0_waveforms=True
