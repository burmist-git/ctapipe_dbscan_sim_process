#!/usr/bin/env python

import argparse
import logging
import glob
import os
import re
import uuid
import time
import subprocess as sp
import numpy as np

def main():

    parser = argparse.ArgumentParser(
        description=("Script to run ctapipe-merge tool with DL1 hdf5 files"))
    parser.add_argument('--input_dir', '-i',
                        help='input directory',
                        default="./")
    parser.add_argument('--pattern', '-p',
                        help='pattern to mask unwanted files',
                        default="*.h5")
    parser.add_argument('--type',
                        help='particle type',
                        default="gamma")
    parser.add_argument('--num_outputfiles', '-n',
                        help='number of output files',
                        default=10,
                        type=int)
    parser.add_argument('--output_dir', '-o',
                        help='output directory',
                        default="./")

    args = parser.parse_args()

    analysis_id = uuid.uuid1()

    # Input handling
    abs_file_dir = os.path.abspath(args.input_dir)
    input = np.sort(glob.glob(os.path.join(abs_file_dir, args.pattern)))

    run_numbers = []
    for file in input:
        print(file)
        print(re.findall(r'\d+', file.split("/")[-1])[-4])
        run_numbers.append([int(s) for s in re.findall(r'\d+', file.split("/")[-1])][-4])
        #run_numbers.append([int(s) for s in re.findall(r'\d+', file.split("/")[-1])][0])
    run_numbers = np.sort(run_numbers)

    print(len(run_numbers))

    print(run_numbers)
    n_runs = 0

    skip_broken_files = True
    for runs in np.array_split(run_numbers, args.num_outputfiles):
        #output_file = f"{args.output_dir}/proton_runs{runs[0]}-{runs[-1]}.r0.r1.dl1.h5"
        output_file = f"{args.output_dir}/{args.type}_theta_16.087_az_108.090_runs{1250+runs[0]}-{1250+runs[-1]}.r1.dl1.h5"
        cmd = [
             "sbatch",
             "-A",
             "aswg",
             #"--partition=long",
             "--partition=short",
             "--mem-per-cpu=32G",
             f"--job-name=testing_{str(analysis_id)}",
             f"ctapipe-merge",
             "--overwrite",
             #"--no-dl1-images",
             #"--no-true-images",
             #"--no-true-parameters",
             "--MergeTool.skip_broken_files=True",
             f"--output={output_file}",
            ]
        for run in runs:
            cmd.append(f"{abs_file_dir}/{args.type}_theta_16.087_az_108.09_run{run}.r1.dl1.h5")
        print(f"Submitting merger tool to create: '{output_file}'")
        sp.run(cmd)
        n_runs += 1

    print("All jobs submitted!")
    time.sleep(10)
    n_completedruns = int(sp.check_output(f"sacct --format='JobID,JobName%50,State,Account' | grep 'testing_{str(analysis_id)}' | grep 'COMPLETED' --only-matching | wc -l", shell=True).decode('utf-8').replace("\n",""))
    n_failedruns = 0
    while((n_runs - n_failedruns) != n_completedruns):
        print(f"({n_completedruns}/{n_runs}) runs completed")
        n_failedruns = 0
        for state in ["BOOT_FAIL", "CANCELLED", "CONFIGURING", "DEADLINE", "FAILED", "NODE_FAIL", "OUT_OF_MEMORY", "PENDING", "PREEMPTED", "RUNNING", "RESV_DEL_HOLD", "REQUEUE_FED", "REQUEUE_HOLD", "REQUEUED", "RESIZING", "REVOKED", "SIGNALING", "SPECIAL_EXIT", "STAGE_OUT", "STOPPED", "SUSPENDED", "TIMEOUT"]:
            n_stateruns = int(sp.check_output(f"sacct --format='JobID,JobName%50,State,Account%30' | grep 'testing_{str(analysis_id)}' | grep '{state}' --only-matching | wc -l", shell=True).decode('utf-8').replace("\n",""))
            if n_stateruns > 0:
                print(f"    ({n_stateruns}/{n_runs}) in '{state}' state")
            if n_stateruns > 0 and state in ["BOOT_FAIL", "CANCELLED", "DEADLINE", "FAILED", "NODE_FAIL", "OUT_OF_MEMORY", "SPECIAL_EXIT", "STAGE_OUT", "STOPPED", "SUSPENDED", "TIMEOUT"]:
                if skip_broken_files:
                    n_failedruns += n_stateruns
                    continue
                else:
                    exit()
        n_completedruns = int(sp.check_output(f"sacct --format='JobID,JobName%50,State,Account' | grep 'testing_{str(analysis_id)}' | grep 'COMPLETED' --only-matching | wc -l", shell=True).decode('utf-8').replace("\n",""))
        time.sleep(60)

    print(n_completedruns)
    return

if __name__ == "__main__":
    main()

