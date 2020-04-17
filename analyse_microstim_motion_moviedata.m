function analyse_microstim_motion_moviedata
%2/4/20
%Written by Xing, extracts eye movement data during a
%microstimulation/visual motion task, with data from 041217_B35.

allInstanceInd=1;

saveFullMUA=1;
smoothResponse=1;

downSampling=1;
downsampleFreq=30;

alignTargOn=1;%1: align eye movement data across trials, relative to target onset (variable from trial to trial, from 300 to 800 ms after fixation). 0: plot the first 300 ms of fixation, followed by the period from target onset to saccade response?
onlyGoodSaccadeTrials=0;%set to 1 to exclude trials where the time taken to reach the target exceeds the allowedSacTime.
allowedSacTime=250/1000;

stimDurms=500;%in ms- min 0, max 500
preStimDur=300/1000;
stimDur=stimDurms/1000;%in seconds
postStimDur=400/1000;%length of post-stimulus-offset period, in s
sampFreq=30000;

cols=[1 0 0;0 1 1;165/255 42/255 42/255;0 1 0;0 0 1;0 0 0;1 0 1;0.9 0.9 0;128/255 0 128/255];
arrays=8:16;

localDisk=0;
analyseConds=0;
allSetsPerfMicroAllTrials=[];
allSetsPerfVisualAllTrials=[];
allPerfV=[];
allPerfM=[];
setNos=[1:5 8 10 12:17 19:24];%before RF correction: [1:17 19:25];
allRFsFigure=figure;
setNoSubplot=1;
eyeDataXFinal={};
eyeDataYFinal={};
for calculateVisual=0
    for setNo=17
        perfNEV=[];
        timeInd=[];
        encodeInd=[];
        microstimTrialNEV=[];
        allLRorTB=[];
        allTargetLocation=[];
        corr=[];
        incorr=[];
        if calculateVisual==0
            switch(setNo)
                case 1
                    date='091117_B4';
                    setElectrodes=[15 34 42;42 34 15];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[15 13 10;10 13 15];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=37;
                    visualOnly=0;
                case 2
                    date='091117_B16';
                    setElectrodes=[63 48 35;35 48 63];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[15 13 10;10 13 15];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=37;
                    visualOnly=0;
                case 3
                    date='271117_B27';
                    setElectrodes=[63 48 35;35 48 63];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[15 13 10;10 13 15];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=38;
                    visualOnly=0;
                case 4
                    date='271117_B29';
                    setElectrodes=[62 49 42;42 49 62];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[15 13 10;10 13 15];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=38;
                    visualOnly=0;
                case 5
                    date='271117_B32';
                    setElectrodes=[26 35 8;8 35 26];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[12 13 10;10 13 12];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=38;
                    visualOnly=0;
                case 6
                    date='291117_B10';
                    setElectrodes=[44 50 22;22 50 44];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[12 13 11;11 13 12];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=39;
                    visualOnly=0;
                case 7
                    date='291117_B12';
                    setElectrodes=[25 42 24];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[12 13 11;11 13 12];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=39;
                    visualOnly=0;
                case 8
                    date='291117_B46';
                    setElectrodes=[37 41 1;1 41 37];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[16 12 9;9 12 16];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=40;
                    visualOnly=0;
                case 9
                    date='291117_B48';
                    setElectrodes=[50 34 9;9 34 50];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[16 12 9;9 12 16];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=40;
                    visualOnly=0;
                case 10
                    date='291117_B50';
                    setElectrodes=[39 33 48;48 33 39];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[16 12 9;9 12 16];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=40;
                    visualOnly=0;
                case 11
                    date='291117_B52';
                    setElectrodes=[40 12 47;47 12 40];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[16 12 9;9 12 16];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=40;
                    visualOnly=0;
                case 12
                    date='291117_B55';
                    setElectrodes=[46 59 63;63 59 46];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[16 14 9;9 14 16];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=40;
                    visualOnly=0;
                case 13
                    date='291117_B57';
                    setElectrodes=[45 14 64;64 14 45];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[16 12 9;9 12 16];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=40;
                    visualOnly=0;
                case 14
                    date='041217_B25';
                    setElectrodes=[64 3 43;43 3 64];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[16 14 12;12 14 16];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=45;
                    visualOnly=0;
                case 15
                    date='041217_B24';
                    setElectrodes=[40 63 52;52 63 40];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[8 14 12;12 14 8];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=45;
                    visualOnly=0;
                case 16
                    date='041217_B33';
                    setElectrodes=[30 21 10;10 21 30];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[8 14 12;12 14 8];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=47;
                    visualOnly=0;
                case 17
                    date='041217_B35';
                    setElectrodes=[22 54 57;57 54 22];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[8 14 12;12 14 8];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=47;
                    visualOnly=0;
            end
        elseif calculateVisual==1  
            localDisk=0;
            switch(setNo)
                %visual task only:
                case 1
                    date='091117_B1';
                    setElectrodes=[15 34 42;42 34 15];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[15 13 10;10 13 15];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=37;
                    visualOnly=1;
                case 2
                    date='091117_B5';
                    setElectrodes=[63 48 35;35 48 63];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[15 13 10;10 13 15];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=37;
                    visualOnly=1;
                case 3
                    date='271117_B26';
                    setElectrodes=[63 48 35;35 48 63];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[15 13 10;10 13 15];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=38;
                    visualOnly=1;
                case 4
                    date='271117_B28';
                    setElectrodes=[62 49 42;42 49 62];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[15 13 10;10 13 15];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=38;
                    visualOnly=1;
                case 5
                    date='271117_B31';
                    setElectrodes=[26 35 8;8 35 26];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[12 13 10;10 13 12];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=38;
                    visualOnly=1;
                case 6
                    date='291117_B9';
                    setElectrodes=[44 50 22;22 50 44];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[12 13 11;11 13 12];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=39;
                    visualOnly=1;
                case 7
                    date='291117_B11';
                    setElectrodes=[25 42 24];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[12 13 11;11 13 12];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=39;
                    visualOnly=1;
                case 8
                    date='291117_B45';
                    setElectrodes=[37 41 1;1 41 37];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[16 12 9;9 12 16];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=40;
                    visualOnly=1;
                case 9
                    date='291117_B47';
                    setElectrodes=[50 34 9;9 34 50];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[16 12 9;9 12 16];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=40;
                    visualOnly=1;
                case 10
                    date='291117_B49';
                    setElectrodes=[39 33 48;48 33 39];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[16 12 9;9 12 16];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=40;
                    visualOnly=1;
                case 11
                    date='291117_B51';
                    setElectrodes=[40 12 47;47 12 40];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[16 12 9;9 12 16];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=40;
                    visualOnly=1;
                case 12
                    date='291117_B54';
                    setElectrodes=[46 59 63;63 59 46];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[16 14 9;9 14 16];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=40;
                    visualOnly=1;
                case 13
                    date='291117_B56';
                    setElectrodes=[45 14 64;64 14 45];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[16 12 9;9 12 16];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=40;
                    visualOnly=1;
                case 14
                    date='041217_B19';
                    setElectrodes=[64 3 43;43 3 64];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[16 14 12;12 14 16];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=45;
                    visualOnly=1;
                case 15
                    date='041217_B23';
                    setElectrodes=[40 63 52;52 63 40];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[8 14 12;12 14 8];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=45;
                    visualOnly=1;
                case 16
                    date='041217_B32';
                    setElectrodes=[30 21 10;10 21 30];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[8 14 12;12 14 8];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=47;
                    visualOnly=1;
                case 17
                    date='041217_B34';
                    setElectrodes=[22 54 57;57 54 22];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[8 14 12;12 14 8];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3;1 2 3];
                    currentThresholdChs=47;
                    visualOnly=1;
            end
        end
        localDisk=0;
        
        if localDisk==1
            rootdir='D:\data\';
        elseif localDisk==0
            rootdir='X:\best\';
        end
        matFile=[rootdir,date,'\',date,'_data\microstim_saccade_',date,'.mat'];
        dataDir=[rootdir,date,'\',date,'_data'];
        %     if ~exist('dataDir','dir')
        %         copyfile(['Y:\Xing\',date(1:6),'_data'],[rootdir,date,'\',date,'_data']);
        %     end
        load(matFile);
        maxNumTrials=size(TRLMAT,1);
        if maxNumTrials<=length(performance)
            performance=performance(1:maxNumTrials);
            allArrayNum=allArrayNum(1:maxNumTrials);
            allBlockNo=allBlockNo(1:maxNumTrials);
            allElectrodeNum=allElectrodeNum(1:maxNumTrials);
            allFixT=allFixT(1:maxNumTrials);
            allHitRT=allHitRT(1:maxNumTrials);
            allHitX=allHitX(1:maxNumTrials);
            allHitY=allHitY(1:maxNumTrials);
            allInstanceNum=allInstanceNum(1:maxNumTrials);
            allSampleX=allSampleX(1:maxNumTrials);
            allSampleY=allSampleY(1:maxNumTrials);
            allStimDur=allStimDur(1:maxNumTrials);
            allTargetArrivalTime=allTargetArrivalTime(1:maxNumTrials);
            allTargetArrivalTime=allTargetArrivalTime(1:maxNumTrials);
        end
        [dummy goodTrials]=find(performance~=0);
        % goodTrialConds=allTrialCond(goodTrials,:);
        goodTrialIDs=TRLMAT(goodTrials,:);
        
        load([dataDir,'\currentThresholdChs',num2str(currentThresholdChs),'.mat']);
        
        processRaw=1;
        if processRaw==1
            for instanceCount=1%:length(allInstanceInd)
                instanceInd=allInstanceInd(instanceCount);
                instanceName=['instance',num2str(instanceInd)];
                instanceNEVFileName=[rootdir,date,'\',instanceName,'.nev'];
                NEV=openNEV(instanceNEVFileName);
                
                %read in eye data:
                recordedRaw=1;
                if recordedRaw==0%7/9/17
                    eyeChannels=[1 2];
                elseif recordedRaw==1%11/9/17
                    if NEV.ElectrodesInfo(130).ConnectorPin==2
                        eyeChannels=[130 131];
                    elseif NEV.ElectrodesInfo(130).ConnectorPin==3
                        eyeChannels=[129 130];
                    end
                end
                minFixDur=300/1000;%fixates for at least 300 ms, up to 800 ms
                instanceNS6FileName=['X:\best\',date,'\',instanceName,'.ns6'];
                eyeDataMat=['D:\data\',date,'\',instanceName,'_NSch_eye_channels.mat'];
                if exist(eyeDataMat,'file')
                    load(eyeDataMat,'NSch');
                else
                    if recordedRaw==0
                        NSchOriginal=openNSx(instanceNS6FileName);
                        for channelInd=1:length(eyeChannels)
                            NSch{channelInd}=NSchOriginal.Data(channelInd,:);
                        end
                    elseif recordedRaw==1
                        for channelInd=1:length(eyeChannels)
                            readChannel=['c:',num2str(eyeChannels(channelInd)),':',num2str(eyeChannels(channelInd))];
                            NSchOriginal=openNSx(instanceNS6FileName,readChannel);
                            NSch{channelInd}=NSchOriginal.Data;
                        end
                    end
                    if iscell(NSchOriginal.Data)
                        for blockInd=1:length(NSchOriginal.Data)
                            NSchtemp{channelInd}=[NSch{blockInd}{1} NSch{blockInd}{2}];
                        end
                        NSch=NSchtemp;
                    end
                    save(eyeDataMat,'NSch');
                end
                
                %identify trials using encodes sent via serial port:
                trialNo=1;
                breakHere=0;
                while breakHere==0
                    encode=double(num2str(trialNo));%serial port encodes. e.g. 0 is encoded as 48, 1 as 49, 10 as [49 48], 12 as [49 50]
                    tempInd=strfind(NEV.Data.SerialDigitalIO.UnparsedData',encode);
                    if isempty(tempInd)
                        breakHere=1;
                    else
                        timeInd(trialNo)=NEV.Data.SerialDigitalIO.TimeStamp(tempInd(1));
                        encodeInd(trialNo)=tempInd(1);
                        if trialNo>1
                            trialEncodes=NEV.Data.SerialDigitalIO.UnparsedData(encodeInd(trialNo-1):encodeInd(trialNo));
                        else
                            trialEncodes=NEV.Data.SerialDigitalIO.UnparsedData(1:encodeInd(trialNo));
                        end
                        ErrorB=Par.ErrorB;
                        CorrectB=Par.CorrectB;
                        MicroB=Par.MicroB;
                        StimB=Par.StimB;
                        TargetB=Par.TargetB;
                        if find(trialEncodes==2^CorrectB)
                            perfNEV(trialNo)=1;
                        elseif find(trialEncodes==2^ErrorB)
                            perfNEV(trialNo)=-1;
                        else
                            perfNEV(trialNo)=0;
                        end
                        if perfNEV(trialNo)~=0
                            stimOnInd=find(trialEncodes==2^StimB)%stimulus onset
                            microstimInd=find(trialEncodes==2^MicroB)%stimulus onset
                            if length(microstimInd)>1
                                microstimInd=microstimInd(end);
                            end
                            if trialNo>1
%                                 stimOnTime=NEV.Data.SerialDigitalIO.TimeStamp(encodeInd(trialNo-1)+stimOnInd-1);
                                microstimTime=NEV.Data.SerialDigitalIO.TimeStamp(encodeInd(trialNo-1)+microstimInd-1);
                            else
%                                 stimOnTime=NEV.Data.SerialDigitalIO.TimeStamp(stimOnInd);
                                microstimTime=NEV.Data.SerialDigitalIO.TimeStamp(microstimInd);
                            end
                            allFixT(trialNo)
%                             eyeDataXFinal{trialNo}=NSch{1}(stimOnTime-0.3*sampFreq:stimOnTime+1.3*sampFreq);%eye data from 300 ms before stim onset to 1.3 s after stim onset
%                             length(eyeDataXFinal{trialNo})
%                             eyeDataYFinal{trialNo}=NSch{2}(stimOnTime-0.3*sampFreq:stimOnTime+1.3*sampFreq);
                            eyeDataXFinal{trialNo}=NSch{1}(microstimTime-0.3*sampFreq:microstimTime+(1+3*0.15)*sampFreq);%eye data from 300 ms before stim onset to 1 s after stim offset
                            length(eyeDataXFinal{trialNo})
                            eyeDataYFinal{trialNo}=NSch{2}(microstimTime-0.3*sampFreq:microstimTime+(1+3*0.15)*sampFreq);
                        end
                        trialNo=trialNo+1;
                    end
                end
                perfNEV=performance;
            end
            allArrayNumFinal=allArrayNum;
            allElectrodeNumFinal=allElectrodeNum;
            eyeDataTrialMat=['D:\data\',date,'\eye_data_',date,'.mat'];
            save(eyeDataTrialMat,'eyeDataXFinal','eyeDataYFinal','allElectrodeNumFinal','allArrayNumFinal');
        end
    end
end