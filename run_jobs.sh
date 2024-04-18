



#for((i=501; i<=625; i++))
#do
#    python run_reduction.py -i /fefs/aswg/data/mc/DL0/LSTProd2/TrainingDataset/Protons/dec_2276/sim_telarray/node_theta_16.087_az_108.090_/output_v1.4/ -o /fefs/aswg/workspace/tjark.miener/LST1_trigger/train/proton/single_new/ --type proton -p "simtel_corsika_theta_16.087_az_108.090_run$i*.simtel.gz"
#done

#for((i=1; i<=100; i++))
#do
#    python run_reduction.py -i /fefs/aswg/data/mc/DL0/LSTProd2/TestDataset/Protons/sim_telarray/node_corsika_theta_10.0_az_102.199_/output_v1.4/ -o /fefs/aswg/workspace/tjark.miener/LST1_trigger/test/proton/single/ --type proton -p "simtel_corsika_theta_10.0_az_102.199_run$i.simtel.*z"
#    python run_reduction.py -i /fefs/aswg/mc/LST_Advanced_Camera_Prod1/electron/zenith_20deg/south_pointing/4LSTs_SiPM/sim_telarray/ -o /fefs/aswg/workspace/tjark.miener/4LSTsSiPMCam_r0r1dl1/electron/ -p "simtel_corsika_run$i.simtel.*z"
#done
# python run_reduction.py -i /home/georgios.voutsinas/ws/AllSky/CTLearn_additional/sim_telarray/node_corsika_theta_10.0_az_102.199_/output_v1.4/ -o /fefs/aswg/workspace/tjark.miener/DeepCrab/R1DL1/LSTProd2/TestDataset/Protons/ --type proton -p "simtel_corsika*"
# python run_reduction.py -i /home/georgios.voutsinas/ws/AllSky/CTLearn_additional/sim_telarray/node_corsika_theta_16.087_az_108.09_/output_v1.4/ -o /fefs/aswg/workspace/tjark.miener/DeepCrab/R1DL1/LSTProd2/TrainingDataset/Protons/dec_2276/ --type proton -p "simtel_corsika*"


