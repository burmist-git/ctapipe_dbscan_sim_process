#!/bin/sh

function printHelp {
    echo " --> ERROR in input arguments "
    echo " [0] -d : default"
    echo " [0] -c : clean"
    echo " [0] -h : print help"
}

if [ $# -eq 0 ] 
then    
    printHelp
else
    if [ "$1" = "-d" ]; then
        printHelp
    elif [ "$1" = "-c" ]; then
	rm *~
	rm slurm-*.out
	rm ctapipe-process.provenance.log
	rm core
    elif [ "$1" = "-h" ]; then
        printHelp
    else
        printHelp
    fi
fi
