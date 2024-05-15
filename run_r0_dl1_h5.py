#!/usr/bin/env python

import numpy as np
import tables

#from ctapipe.io import EventSource

def main():
    open_file = tables.open_file("./gamma_tmp/gamma_run1.r0.dl1.h5", mode="r")
    #help(tables)
    #print(open_file.root.dl1.event.subarray.trigger[0])
    #print(len(open_file.root.r0.event.telescope.tel_001))
    #print(np.max(open_file.root.r0.event.telescope.tel_001[2][3][:][0]))
    #print(np.max(open_file.root.r0.event.telescope.tel_001[2][3][:][0]))
    print(open_file.root.r0.event.telescope.tel_001)
    print(type(open_file.root.r0.event.telescope.tel_001))
    print(len(open_file.root.r0.event.telescope.tel_001))
    print(open_file.root.r0.event.telescope.tel_001[0])
    #print(open_file.root.r0.event.telescope.tel_001[len(open_file.root.r0.event.telescope.tel_001)-1])
    #print(open_file.root.r0.event.telescope.tel_001[2][3].shape)
    #print(open_file)
    #print(open_file.root.configuration.simulation.run)
    #print(open_file.root.simulation.event.subarray.shower[1000][2])
    #ES = EventSource("/scratch/snx3000/lburmist/ctapipe_data/gamma/gamma_run1.r0.dl1.h5")
    #for event in ES:
    #    print(event["r0"])
    #    break
    
if __name__ == "__main__":
    main()
