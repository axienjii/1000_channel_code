function combine_SNR_mat_files
%Written by Xing 4/2/19
%Combines SNR values across NSPs.
date='090817_B8';
date='100817_B2';
date='250717_B2';
allChsSNR=[];
for instance=1:8
   load(['X:\best\resting_state_data\monkey_L\checkSNR_task\',date,'\mean_MUA_NSP',num2str(instance),'.mat']) 
   allChsSNR=[allChsSNR channelSNR'];
end
save(['X:\best\resting_state_data\monkey_L\checkSNR_task\',date,'\allSNR.mat'],'allChsSNR');