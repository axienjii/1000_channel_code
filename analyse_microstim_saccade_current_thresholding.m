function analyse_microstim_saccade_current_thresholding(date,allInstanceInd)
%23/5/18
%Written by Xing, modified from analyse_microstim_saccade14_letter.m, extracts eye data during a
%saccade task during microstimulation of individual electrodes for current
%thresholding task. Calculates the time at which the eye movement was
%initiated, relative to microstimulation onset. Based on x-component of eye data.

%array       analog input channel
% 8            1
% 9            6
% 10            7
% 11            8
% 12            9
% 13            10
% 14            11
% 15            12
% 16            13
syncPulseChs=[8 1;9 6;10 7;11 8;12 9;13 10;14 11;15 12;16 13];

localDisk=0;
if localDisk==1
    rootdir='D:\data\';
    copyfile(['X:\best\',date(1:6),'_data'],[rootdir,date,'\',date(1:6),'_data']);
elseif localDisk==0
    rootdir='X:\best\';
end
dataDir=[rootdir,date,'\',date(1:6),'_data'];
dataDir=[rootdir,date,'\',date,'_data'];
matFile=[dataDir,'\microstim_saccade_',date,'.mat'];
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
eyeMovementOnset=nan(length(performance),1);%store time at which eye movement was made, relative to microstimulation onset
startMicrostimS=nan(length(performance),1);%store time of onset of microstimulation, relative to acquisition of fixation
endMicrostimS=nan(length(performance),1);%store time of offset of microstimulation, relative to acquisition of fixation

preStimDur=300/1000;
sampFreq=30000;
analyseVisualOnly=1;
switch date(1:6)
    case '041017'
        currentThresholdChs=2;
    case '051017'
        currentThresholdChs=3;
end

arrays=8:16;

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
        instanceNS6FileName=[rootdir,date,'\',instanceName,'.ns6']; 
        eyeDataMat=[rootdir,date,'\',instanceName,'_NSch_eye_channels.mat'];
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
                    if strcmp(class(NSchOriginal.Data),'cell')
                        NSchOriginal.Data=NSchOriginal.Data{end};
                    end
                    NSch{channelInd}=NSchOriginal.Data;
                end
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
                trialNo=trialNo+1;
            end
        end
                
        if exist('allVisualTrial','var')%session(s) in which visual and microstim trials are interleaved
            if analyseVisualOnly==0
                microstimTrialsInd1=find(allCurrentLevel>0);
                microstimTrialsInd2=find(allVisualTrial==0);
                microstimTrialsInd=intersect(microstimTrialsInd1,microstimTrialsInd2);
                correctTrialsInd=find(performance==1);
                correctMicrostimTrialsInd=intersect(microstimTrialsInd,correctTrialsInd);%trialNo for microstim trials with a correct saccade
                fixTimes=allFixT(correctMicrostimTrialsInd)/1000;%durations of fixation period before target onset
            elseif analyseVisualOnly==1%note that in this code, trials with visually presented stimuli are read into the variable 'microstimTrialsInd'
                microstimTrialsInd1=find(cell2mat(allElectrodeNum)>0);
                microstimTrialsInd2=find(allVisualTrial==1);
                microstimTrialsInd=intersect(microstimTrialsInd1,microstimTrialsInd2);
                correctTrialsInd=find(performance==1);
                correctMicrostimTrialsInd=intersect(microstimTrialsInd,correctTrialsInd);%trialNo for microstim trials with a correct saccade
                fixTimes=allFixT(correctMicrostimTrialsInd)/1000;%durations of fixation period before target onset
            end
        else
            microstimTrialsInd=find(allCurrentLevel>0);
            correctTrialsInd=find(performance==1);
            correctMicrostimTrialsInd=intersect(microstimTrialsInd,correctTrialsInd);%trialNo for microstim trials with a correct saccade
            fixTimes=allFixT(correctMicrostimTrialsInd)/1000;%durations of fixation period before target onset
        end
        if ~exist('goodArrays8to16','var')
            load([dataDir,'\currentThresholdChs',num2str(currentThresholdChs),'.mat']);
        end
        allArrayNumNoNan=cell2mat(allArrayNum);
        allArrayNumNoNan(isnan(allArrayNumNoNan))=[];
        allElectrodeNumNoNan=cell2mat(allElectrodeNum);
        allElectrodeNumNoNan(isnan(allElectrodeNumNoNan))=[];
        electrodeArrayNums=[allArrayNumNoNan' allElectrodeNumNoNan'];
        uniqueElectrodeArrayNums = unique(electrodeArrayNums, 'rows');
        for uniqueElectrode=1:size(uniqueElectrodeArrayNums,1)%15%16:30%1:15%
            array=uniqueElectrodeArrayNums(uniqueElectrode,1);
            %load sync pulse data:
            tempIndCh=find(syncPulseChs(:,1)==array);
            syncPulseCh=syncPulseChs(tempIndCh,2);%analog input channel on which sync pulse from that particular CereStim was sent
            instanceNS6FileName=[rootdir,date,'\',instanceName,'.ns6'];
            syncPulseDataMat=[rootdir,date,'\',instanceName,'_NSch_syncPulse',num2str(syncPulseCh),'.mat'];
            if exist(syncPulseDataMat,'file')
                load(syncPulseDataMat,'NSchSync');
            else
                if recordedRaw==0
                    for channelInd=128+syncPulseCh
                        NSchSync{channelInd}=NSchOriginal.Data(channelInd,:);
                    end
                elseif recordedRaw==1
                    for channelInd=1:128+syncPulseCh
                        readChannel=['c:',num2str(128+syncPulseCh),':',num2str(128+syncPulseCh)];
                        NSchOriginalSync=openNSx(instanceNS6FileName,readChannel);
                        if strcmp(class(NSchOriginalSync.Data),'cell')
                            NSchOriginalSync.Data=NSchOriginalSync.Data{end};
                        end
                        NSchSync=NSchOriginalSync.Data;
                    end
                end
                save(syncPulseDataMat,'NSchSync');
            end
            arrayColInd=find(arrays==array);
            electrode=uniqueElectrodeArrayNums(uniqueElectrode,2);
            electrodeIndTemp1=find(goodArrays8to16(:,8)==electrode);
            electrodeIndTemp2=find(goodArrays8to16(:,7)==array);
            electrodeInd=intersect(electrodeIndTemp1,electrodeIndTemp2);
            impedance=goodArrays8to16(electrodeInd,6);
            RFx=goodArrays8to16(electrodeInd,1);
            RFy=goodArrays8to16(electrodeInd,2);
            
            electrodeNumsAll=load('D:\data\channel_area_mapping.mat','channelNums');
            electrodeNumsAll=electrodeNumsAll.channelNums;
            arrayNumsAll=load('D:\data\channel_area_mapping.mat','arrayNums');
            arrayNumsAll=arrayNumsAll.arrayNums;
            electrodeIndTemp1=find(electrodeNumsAll(:)==electrode);
            electrodeIndTemp2=find(arrayNumsAll(:)==array);
            electrodeInd=intersect(electrodeIndTemp1,electrodeIndTemp2);
            instance=ceil(electrodeInd/128);
            chInd128=mod(electrodeInd,128);
            if chInd128==0
                chInd128=128;
            end
            load(['D:\data\best_260617-280617\RFs_instance',num2str(instance),'.mat'])
%             RFx=RFs{chInd128}.centrex
%             RFy=RFs{chInd128}.centrey
            
%             if RFx2~=RFx||RFy2~=RFy
%                pauseHere=1; 
%             end
            
            if RFy<-500
                RFy=NaN;
            end
            
            electrodeInd=find(cell2mat(allElectrodeNum)==electrode);
            arrayInd=find(cell2mat(allArrayNum)==array);
            matchTrials=intersect(electrodeInd,arrayInd);%identify trials where stimulation was delivered on a particular array and electrode
            matchTrials=intersect(matchTrials,correctMicrostimTrialsInd);%identify subset of trials where performance was correct
        
            trialNoTrials=[];
            trialDataX=[];
            trialDataY=[];
            trialDataXSmooth={};
            trialDataYSmooth={};
            trialDataXSmoothFix={};
            trialDataYSmoothFix={};
            for trialCounter=1:length(matchTrials)%for each correct microstim trial
                trialNo=matchTrials(trialCounter);%trial number, out of all trials from that session  
                trialNoTrials(trialCounter)=trialNo;
                %identify time of reward delivery:
                temp=find(NEV.Data.SerialDigitalIO.UnparsedData(1:encodeInd(trialNo))==2^4);
                timeTrialStartInd=temp(end);%index in NEV file that appears in trial- though not necessarily the start (I think)
                timeTrialStart=NEV.Data.SerialDigitalIO.TimeStamp(timeTrialStartInd);%timestamp in NEV file corresponding to something
                corrBit=7;
                temp=find(NEV.Data.SerialDigitalIO.UnparsedData(1:encodeInd(trialNo))==2^corrBit);
                if ~isempty(temp)
                    timeRewardInd=temp(end);%index in NEV file corresponding to reward delivery
                    timeReward=NEV.Data.SerialDigitalIO.TimeStamp(timeRewardInd);%timestamp in NEV file corresponding to reward delivery
                    codeMicrostimOn=2;%sent at the end of microstimulation train
                    temp=find(NEV.Data.SerialDigitalIO.UnparsedData(1:timeRewardInd)==2^codeMicrostimOn);%(two encodes before reward encode)
                    timeMicrostimInd=temp(end);%index in NEV file corresponding to end of microstim train
                    timeMicrostim=NEV.Data.SerialDigitalIO.TimeStamp(timeMicrostimInd);%timestamp in NEV file corresponding to reward delivery
                    timeMicrostimToReward=timeMicrostim:timeReward;%timestamps from 150 ms before end of microstimulation to reward delivery (because eyeanalysis_baseline_correct requires at least 150 ms of eye fixation time)
                    trialDataX{trialCounter}=NSch{1}(timeMicrostimToReward);
                    trialDataY{trialCounter}=NSch{2}(timeMicrostimToReward);
                    timeSmooth=timeMicrostim-preStimDur*sampFreq:timeReward;%timestamps from 150 ms before end of microstimulation to reward delivery (because eyeanalysis_baseline_correct requires at least 150 ms of eye fixation time)
                    trialDataXSmooth{trialCounter}=double(NSch{1}(timeSmooth));
                    trialDataYSmooth{trialCounter}=double(NSch{2}(timeSmooth));
                    timeSmoothFix=timeMicrostim-(166.7+allFixT(trialNo))*sampFreq/1000:timeReward;%timestamps from acquisition of fixation to reward delivery
                    trialDataXSmoothFix{trialCounter}=double(NSch{1}(timeSmoothFix));
                    trialDataYSmoothFix{trialCounter}=double(NSch{2}(timeSmoothFix));
                    figure;
                    plot(NSchSync(timeSmoothFix));%plot sync pulse from acquisition of fixation to reward delivery
                    syncTraceTrial=NSchSync(timeSmoothFix);
                    baselineS=mean(syncTraceTrial(1:200));
                    stdBaselineS=std(double(syncTraceTrial(1:200)));
                    microstimPeriodSyncPulse=find(syncTraceTrial>baselineS+15*stdBaselineS);%identify the period during which microstimulation was delivered, based on the sync pulse
                    startMicrostimS(trialNo)=microstimPeriodSyncPulse(1);
                    differenceSyncHigh=diff(microstimPeriodSyncPulse);%identify the return of the sync pulse to baseline, during the period during which sync signal goes to high, and no further case 
                    indSyncHighEnd=find(differenceSyncHigh>1);
                    if ~isempty(indSyncHighEnd)
                        if indSyncHighEnd(1)==1
                            differenceIndSyncHighEnd=diff(indSyncHighEnd);
                            firstDiffVals=find(differenceIndSyncHighEnd~=1);
                            if isempty(firstDiffVals)
                                indSyncHighEnd(indSyncHighEnd)=[];
                            else
                                indSyncHighEnd(indSyncHighEnd(1:firstDiffVals-1))=[];
                            end
                        end
                    end
                    if isempty(indSyncHighEnd)
                        endMicrostimS(trialNo)=microstimPeriodSyncPulse(end);
                    else
                        endMicrostimS(trialNo)=microstimPeriodSyncPulse(indSyncHighEnd(1)-1);
                    end
                    hold on
                    plot(trialDataXSmoothFix{trialCounter});
                    yLims=get(gca,'ylim');
                    plot([startMicrostimS(trialNo) startMicrostimS(trialNo)],[yLims(1) yLims(2)],'k:');
                    plot([endMicrostimS(trialNo) endMicrostimS(trialNo)],[yLims(1) yLims(2)],'k:');
                    %                 trialDataArtefactFix{trialCounter}=double(NSch{1}(timeSmoothFix));
                    %                 plot(trialDataArtefactFix{trialCounter}+mean(trialDataXSmoothFix{trialCounter}));
                    eyeTraceTrial=trialDataXSmoothFix{trialCounter};
                    baselineE=mean(eyeTraceTrial(1:startMicrostimS(trialNo)-10));
                    stdBaselineE=std(double(eyeTraceTrial(1:startMicrostimS(trialNo)-10)));
                    movement=find(eyeTraceTrial<baselineE-5*stdBaselineE);%identify the period during which microstimulation was delivered, based on the sync pulse
                    movementOnset=[];
                    if ~isempty(movement)
                        movementOnset(trialNo)=movement(1);
                    else
                        movement=find(eyeTraceTrial>baselineE+5*stdBaselineE);%identify the period during which microstimulation was delivered, based on the sync pulse
                        if ~isempty(movement)
                            movementOnset(trialNo)=movement(1);
                        end
                    end
%                     figure;
%                     plot(movement);
                    plot([movementOnset(trialNo) movementOnset(trialNo)],[yLims(1) yLims(2)],'g:');
                    plot([startMicrostimS(trialNo)+allTargetArrivalTime(trialNo)*30000/1000 startMicrostimS(trialNo)+allTargetArrivalTime(trialNo)*30000/1000],[yLims(1) yLims(2)],'r:');%time at which target was acquired, relative to microstimulation, as noted in Tracker
                    if ~exist([rootdir,date,'\eyeData'],'dir')
                        mkdir([rootdir,date,'\eyeData'])
                    end
                    pathname=[rootdir,date,'\eyeData\sync_pulse_eyeX_trial',num2str(trialNo)];
                    print(pathname,'-dtiff');
                    if movementOnset(trialNo)>startMicrostimS(trialNo)
                        eyeMovementOnset(trialNo)=movementOnset(trialNo)-startMicrostimS(trialNo);
                    end
                end
            end            
        end
        save([rootdir,date,'\saccade_time_from_stim_onset.mat'],'eyeMovementOnset','startMicrostimS','endMicrostimS');
    end
end
close all
pause=1;