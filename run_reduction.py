#!/usr/bin/env python

import argparse
import logging
import glob
import os
import subprocess as sp
import numpy as np

def main():

    parser = argparse.ArgumentParser(
        description=("Script to run reduction from simtel files to DL1 hdf5 files with the ctapipe-process tool"))
    parser.add_argument('--input_dir', '-i',
                        help='input directory',
                        default="./")
    parser.add_argument('--pattern', '-p',
                        help='pattern to mask unwanted files',
                        default="*")
    parser.add_argument('--type',
                        help='particle type',
                        default="gamma")
    parser.add_argument('--config', '-c',
                        help='ctapipe config file',
                        default='./configs/ctapipe_standard_sipm_config.json')
    parser.add_argument('--output_dir', '-o',
                        help='output directory',
                        default="./")

    args = parser.parse_args()

    # Input handling
    abs_file_dir = os.path.abspath(args.input_dir)
    files = np.sort(glob.glob(os.path.join(abs_file_dir, args.pattern)))
    #corsika_run5.simtel.gz
    for file in files:
        print(f"Inputfile: '{file}'")
        output_file = f"{args.output_dir}/{file.split('/')[-1].replace('corsika', f'{args.type}').replace('simtel.gz', 'r0.dl1.h5')}"
        print(f"Outputfile: '{output_file}'")
        cmd = [
             "sbatch",
             "-A",
             "cta04",
             "-C",
             "mc",
             f"ctapipe-process",
             #"-t 1",
             "--overwrite",
             f"--input={file}",
             f"--output={output_file}",
             f"--config={args.config}",
             #"--no-write-images",
             "--write-images",
             "--write-parameters",
             "--no-write-showers",
             f"--DataWriter.write_raw_waveforms=True",
             #f"--DataWriter.write_r1_waveforms=True"
            ]
        print(cmd)
        #sp.run(cmd)
    return

def test():

    parser = argparse.ArgumentParser(
    description=("Script to run reduction from simtel files to DL1 hdf5 files with the ctapipe-process tool"))
    parser.add_argument('--input_dir', '-i',
                        help='input directory',
                        default="./")
    parser.add_argument('--pattern', '-p',
                        help='pattern to mask unwanted files',
                        default="*")
    parser.add_argument('--type',
                        help='particle type',
                        default="gamma")
    parser.add_argument('--config', '-c',
                        help='ctapipe config file',
                        default='./configs/ctapipe_standard_sipm_config.json')
    parser.add_argument('--output_dir', '-o',
                        help='output directory',
                        default="./")

    args = parser.parse_args()

    print(f"--config={args.config}")

    
    
if __name__ == "__main__":
    main()
    #test()
