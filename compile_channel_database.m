function compile_channel_database
%Written by Xing on 12/8/20.
%Creates a .mat file containing RF data, channel impedance and current
%thresholds, for sample data from Lick. Purpose is for Sebas (at
%Eduardo's lab at the Universidad Miguel Hernandez) to create a simple GUI.

%RFs:
allChannelRFs=[];
for instanceInd=1:8
    load(['D:\data\best_260617-280617\RFs_instance',num2str(instanceInd),'.mat'])
    allChannelRFs=[allChannelRFs;channelRFs];
end

%Impedance values on 20/7/17
load('C:\Users\User\Documents\impedance_values\200717\impedanceAllChannels.mat')
allImpedances=impedanceAllChannels(:,1);

%Current threshold values on 28/2/18
allThresholds=NaN(1024,1);
load('X:\best\currentThresholds_previous\currentThresholdChs84.mat')
load('X:\best\channel_area_mapping.mat')
for chInd=1:length(goodCurrentThresholdsNew)
    array=goodArrays8to16New(chInd,7);
    electrode=goodArrays8to16New(chInd,8);
    ind1=find(arrayNums(:)==array);
    ind2=find(channelNums(:)==electrode);
    finalInd=intersect(ind1,ind2);
    if goodCurrentThresholdsNew(chInd)>0&&goodCurrentThresholdsNew(chInd)<210
        allThresholds(finalInd)=goodCurrentThresholdsNew(chInd);
    end
end

%channel and array indexing
arrayIndexing=arrayNums(:);
channelIndexing=channelNums(:);
areaIndexing=areas(:);

MonkeyLData.RFx=allChannelRFs(:,1)/25.8601;
MonkeyLData.RFy=allChannelRFs(:,2)/25.8601;
MonkeyLData.impedances=allImpedances;
MonkeyLData.thresholds=allThresholds;
MonkeyLData.arrayInds=arrayIndexing;
MonkeyLData.channelInds=channelIndexing;
MonkeyLData.areaInds=areaIndexing;
fileName=fullfile('D:\data\sample_monkeyL_RFs_imp200717_curthresh84');
save(fileName,'MonkeyLData');