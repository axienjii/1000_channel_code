function crop_resting_state_SNR_mat_files
%Written by Xing 22/1/19. Loads processed MUA data from each checkSNR session
%that was recorded on the same day as resting state data, and crops the
%matrices to the first 128 channels.
date='250717_B2';
% date='260717_B3';%exclude this dataset- data recording abnormal on instance 6
date='090817_B8';
date='100817_B2';
for instanceInd=1:8
    load(['X:\best\',date,'\mean_MUA_instance',num2str(instanceInd),'.mat'])
    channelSNR=channelSNR(1:128);
    meanChannelMUA=meanChannelMUA(1:128,:);
    save(['X:\best\',date,'\mean_MUA_instance',num2str(instanceInd),'.mat'],'channelSNR','meanChannelMUA')
    pause(5)
    load(['X:\best\',date,'\MUA_instance',num2str(instanceInd),'.mat'])
    channelDataMUA=channelDataMUA(1:128);
    save(['X:\best\',date,'\MUA_instance',num2str(instanceInd),'.mat'],'channelDataMUA')
    pause(5)
end