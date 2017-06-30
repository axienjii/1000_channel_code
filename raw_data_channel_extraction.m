function raw_data_channel_extraction
%Modified by Xing on 20/6/17 from ana_RF_flashgrid.

%Analyses data from runstim_RF_GridMap
%Normally used for mapping V4
%Matt, May 2015
tic
analysedata = 1;        %If data already analysed you can skip straight to the graphs
saveout = 0;            %Save out the data  at the end?
savename = 'FlashMap_20170620';   %Name of data file to save
fileName = 'RF_GridMap_20170619_B1.mat';

datadir = 'D:\data\190617_B1\';
date='190617_B1';
date='280617_B2';

%Directory of stimulus logfile
logdir = 'D:\data\190617_B1\';
% To plot dots on top of data:
%USeful for testing potential positions for stimuli

%Details of mapping: read in from logfile, just read first block
load([logdir,fileName])
gridx = LOG.Grid_x;
gridy = LOG.Grid_y;
pixperdeg = LOG.Par.PixPerDeg;

%dasbit sends a change in the bit (either high or low) on one of the 8 ports
codeStimOn=1;%In runstim code, StimB (stimulus bit) is 1.
codeCorrB=7;%CorrB is 7
codeRew=3;%RewardB is 3
startTrialCode=5;%sent by tracker software early during the trial, not sure exactly what this codes for

stimDur=LOG.BART*nsquares+LOG.INTBAR*(nsquares-1);

for instanceInd=6
    instanceName=['instance',num2str(instanceInd)];
    instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
    NEV=openNEV(instanceNEVFileName,'overwrite');
    oldIndStimOns=find(NEV.Data.SerialDigitalIO.UnparsedData==2^startTrialCode);%starts at 2^0, till 2^7
    oldTimeStimOns=NEV.Data.SerialDigitalIO.TimeStamp(oldIndStimOns);%time stamps corresponding to stimulus onset
    correctTrialCodes=2.^[codeCorrB codeRew];%identify trials where fixation was maintained throughout
    indStimOns=[];
    timeStimOns=[];
    trialStimConds=[];
    for i=1:length(oldIndStimOns)
        if oldIndStimOns(i)+10<length(NEV.Data.SerialDigitalIO.UnparsedData)
            trialCodes(i,:)=NEV.Data.SerialDigitalIO.UnparsedData(oldIndStimOns(i):oldIndStimOns(i)+10);
            if trialCodes(i,10:11)==correctTrialCodes%identify completed trials
                if sum(trialCodes(i,[3 5 7 9])==2)==4
                    indStimOns=[indStimOns oldIndStimOns(i)];
                    timeStimOns=[timeStimOns oldTimeStimOns(i)];
                    trialStimConds(i,:)=NEV.Data.SerialDigitalIO.UnparsedData(oldIndStimOns(i)+[1 3 5 7]);%read out stimulus condition
                end
            end
        end
    end
    preStimDur=300/1000;%length of pre-stimulus-onset period, in s
    postStimDur=300/1000;%length of post-stimulus-offset period, in s
    
    instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
    switch(instanceInd)
        case(1)
            goodChannels=[2 3 6:11 16 19:23 28 29 31:33 36 42:50 56 58 60:65 75:81 89 93:96 98:112 114:128];
            goodChannels=[11 16 19:23 28 29 31:33 36 42:50 56 58 60:65 75:81 89 93:96 98:112 114:128];
        case(2)
            goodChannels=[1:5 18 20:23 34 35 37:42 56:57 59:60 69 72 74:78 90:98 107:110 113:116 125 128];
        case(8)
            goodChannels=[1:1];
        case(5)
            goodChannels=[1:32 97:128];
        case(6)
            goodChannels=33:96;
    end
    
    sampFreq=30000;%hard coded
    downsampleFreq=30;
    
    readRawData=1;
    if readRawData==1
        numMin=1;%duration of each segment to be read in, in minutes
        errorMessages=[];%keep a list of any errors
        for channelCount=1:length(goodChannels)
            channelInd=goodChannels(channelCount);
            readChannel=['c:',num2str(channelInd),':',num2str(channelInd)];
            NSch=openNSx(instanceNS6FileName,'read',readChannel);
            fileName=fullfile('D:\data',date,[instanceName,'_ch',num2str(channelInd),'_rawdata.mat']);
            save(fileName,'NSch');            
%             data=double(NSch.Data);%for MUA extraction, process data for that channel at one shot, across entire session            
        end
    end
end

