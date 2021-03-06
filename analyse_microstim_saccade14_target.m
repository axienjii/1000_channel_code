function analyse_microstim_saccade14_target(date,allInstanceInd)
%14/6/19
%Written by Xing, modified from analyse_microstim_saccade14_letter.m, extracts eye data during a
%2-phosphene task and checks locations of saccade end points when saccading
%to targets. Used for eye calibration of other sessions.
%Finds saccade end point using function calculateSaccadeEndpoint3,
%which calculates velocity of eye movements in dva per s, and identifies
%time points corresponding to peak velocities.

localDisk=0;
if localDisk==1
    rootdir='D:\data\';
    copyfile(['X:\best\',date(1:6),'_data'],[rootdir,date,'\',date(1:6),'_data']);
elseif localDisk==0
    rootdir='X:\best\';
end
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
minCrossingTime=0;
analyseVisualOnly=1;
switch date
    case '280917_B4'
        minCrossingTime=preStimDur-0.166;
        currentThresholdChs=2;
        degPerVoltXFinal=0.0036;%as calculated on this date
        degPerVoltYFinal=[];
        visualOnly=1;
        electrodeNums=[50 55 37 51];
        arrayNums=[13 11 13 10];
        targetLocs='TB';
    case '280917_B8'
        minCrossingTime=preStimDur-0.166;
        currentThresholdChs=2;
        degPerVoltXFinal=[];%as calculated on this date
        degPerVoltYFinal=0.0038;
        visualOnly=1;
        electrodeNums=[50 55 37 51];
        arrayNums=[13 11 13 10];
        targetLocs='LR';
end

cols=[1 0 0;0 1 1;165/255 42/255 42/255;0 1 0;0 0 1;0 0 0;1 0 1;0.9 0.9 0;128/255 0 128/255];
arrays=8:16;

currentAmplitudeAllTrials=[];
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
            if visualOnly==0
                microstimTrialsInd=find(allCurrentLevel>0);
                correctTrialsInd=find(performance==1);
                correctMicrostimTrialsInd=intersect(microstimTrialsInd,correctTrialsInd);%trialNo for microstim trials with a correct saccade
                fixTimes=allFixT(correctMicrostimTrialsInd)/1000;%durations of fixation period before target onset
            elseif visualOnly==1%note that in this code, trials with visually presented stimuli are read into the variable 'microstimTrialsInd'
                microstimTrialsInd=find(allElectrodeNum>0);
                correctTrialsInd=find(performance==1);
                correctMicrostimTrialsInd=intersect(microstimTrialsInd,correctTrialsInd);%trialNo for microstim trials with a correct saccade
                fixTimes=allFixT(correctMicrostimTrialsInd)/1000;%durations of fixation period before target onset
            end
            
        end
        figInd1=figure;hold on
        figInd2=figure;hold on
        figInd3=figure;hold on
        figInd4=figure;hold on
        figInd5=figure;hold on
        figInd6=figure;hold on
        figInd8=figure;hold on
        figInd10=figure;hold on
        saccadeEndAllTrials=[]; 
        saccadeEndAllTrialsVolt=[];
        electrodeAllTrials=[];
        timePeakVelocityXYsAllTrials=[];
        timePeakVelocityXYSecsAllTrials=[];
        arrayAllTrials=[];
        if ~exist('goodArrays8to16','var')
            load([dataDir,'\currentThresholdChs',num2str(currentThresholdChs),'.mat']);
        end
        for uniqueElectrode=1:length(electrodeNums)%15%16:30%1:15%
            figInd9(uniqueElectrode)=figure;hold on
            array=arrayNums(uniqueElectrode);
            arrayColInd=find(arrays==array);
            electrode=electrodeNums(uniqueElectrode);
            electrodeIndTemp1=find(goodArrays8to16(:,8)==electrode);
            electrodeIndTemp2=find(goodArrays8to16(:,7)==array);
            electrodeInd=intersect(electrodeIndTemp1,electrodeIndTemp2);
            impedance=goodArrays8to16(electrodeInd,6);
%             RFx=goodArrays8to16(electrodeInd,1);
%             RFy=goodArrays8to16(electrodeInd,2);
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
            
            electrodeInd=find(allElectrodeNum==electrode);
            arrayInd=find(allArrayNum==array);
            matchTrials=intersect(electrodeInd,arrayInd);%identify trials where stimulation was delivered on a particular array and electrode
            matchTrials=intersect(matchTrials,correctMicrostimTrialsInd);%identify subset of trials where performance was correct
            currentAmplitudeAllTrials=[currentAmplitudeAllTrials allCurrentLevel(matchTrials)];
        
            trialDataXY={};
%             degPerVoltXFinal=0.0024;
%             degPerVoltYFinal=0.0022;
            flankingSamples=(30000/50)/2;%50-ms period before reward delivery
            saccadeEndTrials=[];
            saccadeEndTrialsVolt=[];
            electrodeTrials=[];
            timePeakVelocityXYs=[];
            timePeakVelocityXYSecs=[];
            trialNoTrials=[];
            trialDataX=[];
            trialDataY=[];
            trialDataXSmooth={};
            trialDataYSmooth={};
            trialDataXSmoothFix={};
            trialDataYSmoothFix={};
            startMicrostim=[];
            endMicrostim=[];
            posIndXTrials=[];
            posIndYTrials=[];
            posIndXTrialsVolt=[];
            posIndYTrialsVolt=[];
            baselineXChs=[];
            baselineYChs=[];
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
                    startMicrostim(trialCounter)=allFixT(trialNo)*sampFreq/1000;
                    endMicrostim(trialCounter)=(166.7+allFixT(trialNo))*sampFreq/1000;
                    %                 figure;
                    %                 plot(trialDataXSmoothFix{trialCounter});
                    %                 hold on
                    %                 yLims=get(gca,'ylim');
                    %                 plot([startMicrostim(trialCounter) startMicrostim(trialCounter)],[yLims(1) yLims(2)],'k:');
                    %                 plot([endMicrostim(trialCounter) endMicrostim(trialCounter)],[yLims(1) yLims(2)],'k:');
                    % %                 trialDataArtefactFix{trialCounter}=double(NSch{1}(timeSmoothFix));
                    % %                 plot(trialDataArtefactFix{trialCounter}+mean(trialDataXSmoothFix{trialCounter}));
                    numDataPointsAfterStim=timeReward-timeMicrostim;
                    eyepx=-0.15*sampFreq:double(numDataPointsAfterStim);
                    eyepx=eyepx/sampFreq;
                    %                 [EYExs,EYEys] = eyeanalysis_baseline_correct(double(trialDataXSmooth{trialCounter}),double(trialDataYSmooth{trialCounter}),eyepx,sampFreq,1:size(trialDataX{1},1));
                    %                 figure(figInd1)
                    %                 subplot(2,1,1)
                    %                 plot(trialDataX{trialCounter});hold on
                    %                 subplot(2,1,2)
                    %                 plot(trialDataY{trialCounter});hold on
                    figure(figInd2)
                    subplot(2,1,1)
                    plot(trialDataXSmooth{trialCounter},'Color',cols(arrayColInd,:));hold on
                    subplot(2,1,2)
                    plot(trialDataYSmooth{trialCounter},'Color',cols(arrayColInd,:));hold on
                    baselineX=mean(trialDataXSmooth{trialCounter}(1:5000));
                    baselineY=mean(trialDataYSmooth{trialCounter}(1:5000));
                    baselineXTrials(trialCounter)=baselineX;
                    baselineYTrials(trialCounter)=baselineY;
                    %quick-and-dirty estimate of saccade end position:
                    if length(trialDataXSmooth{trialCounter})>=10460
                        roughPosIndX=(trialDataXSmooth{trialCounter}(10460)-baselineX)*degPerVoltXFinal*Par.PixPerDeg;%position during saccade, very rough calculation
                        roughPosIndY=(trialDataYSmooth{trialCounter}(10460)-baselineY)*degPerVoltYFinal*Par.PixPerDeg;
                    end
                    %scatter(-roughPosIndX,-roughPosIndY,[],cols(arrayColInd,:),'MarkerFaceColor',cols(arrayColInd,:));
                    %accurate calculation of saccade end position:
                    numHistBins=50;
                    posIndX=NaN;
                    posIndY=NaN;
                    posIndXs=[];
                    posIndYs=[];
                    posIndXSec=NaN;
                    posIndYSec=NaN;
                    timePeakVelocityXY=NaN;
                    timePeakVelocityXYSec=NaN;
                    %                 if min(trialDataXSmooth{trialCounter})>5500&&max(trialDataYSmooth{trialCounter})<1500%exclude extreme outliers
                    %                     try
                    figInd7=figure;
                    saccadeTimeAfterPeakVel=50/1000;%time interval following occurrence of peak velocity of eye movement, before saccade end point is calculated
                    saccadeCalcWin=50/1000;%duration of window, for calculation of saccade end point
                    trialDataXYSmooth{trialCounter}=sqrt((trialDataXSmooth{trialCounter}*degPerVoltXFinal).^2+(trialDataYSmooth{trialCounter}*degPerVoltYFinal).^2);%calculate displacement
                    timePeakVelocityXY=calculateSaccadeEndpoint3([1:length(trialDataXYSmooth{trialCounter})]',trialDataXYSmooth{trialCounter}',Par.PixPerDeg);%return the midpoints of the peaks of the bimodal distribution, relative to histogram bins
                    timePeakVelocityXY=timePeakVelocityXY(find(timePeakVelocityXY>minCrossingTime*sampFreq));%exclude spurious peaks that occur before stimulation
                    for peakVelInd=1:length(timePeakVelocityXY)
                        startWin=timePeakVelocityXY(peakVelInd);%+saccadeTimeAfterPeakVel*sampFreq;
                        endWin=length(trialDataXYSmooth{trialCounter});
%                         startWin=timePeakVelocityXY(peakVelInd)+saccadeTimeAfterPeakVel*sampFreq;
%                         endWin=timePeakVelocityXY(peakVelInd)+(saccadeTimeAfterPeakVel+saccadeCalcWin)*sampFreq;
                        ax=gca;
                        yLims=get(gca,'ylim');
                        plot([startWin startWin],[yLims(1) yLims(2)],'k:');
                        plot([endWin endWin],[yLims(1) yLims(2)],'k:');
                        if length(trialDataXYSmooth{trialCounter})>=endWin
                            saccadeEndX(peakVelInd)=mean(trialDataXSmooth{trialCounter}(startWin:endWin));
                            ax=gca;
                            xLims=get(gca,'xlim');
                            plot([xLims(1) xLims(2)],[saccadeEndX(peakVelInd) saccadeEndX(peakVelInd)],'r:');
                            posIndXs(peakVelInd)=-(saccadeEndX(peakVelInd)-baselineX)*degPerVoltXFinal*Par.PixPerDeg;
                            posIndX=posIndXs(1);
                            posIndXsVolt(peakVelInd)=-(saccadeEndX(peakVelInd)-baselineX);%in units of voltage
                            posIndXVolt=posIndXsVolt(1);
                            saccadeEndY(peakVelInd)=mean(trialDataYSmooth{trialCounter}(startWin:endWin));
                            ax=gca;
                            xLims=get(gca,'xlim');
                            plot([xLims(1) xLims(2)],[saccadeEndY(peakVelInd) saccadeEndY(peakVelInd)],'r:');
                            posIndYs(peakVelInd)=(saccadeEndY(peakVelInd)-baselineY)*degPerVoltYFinal*Par.PixPerDeg;
                            posIndY=posIndYs(1);
                            posIndYsVolt(peakVelInd)=(saccadeEndY(peakVelInd)-baselineY);%in units of voltage
                            posIndYVolt=posIndYsVolt(1);
                        end
                    end
                    subplot(2,1,1);
                    plot(trialDataXSmooth{trialCounter});hold on
                    if ~isempty(posIndXs)
                        if length(posIndXs)>1&&abs(posIndXs(2))>abs(posIndXs(1))
                            posIndXSec=posIndXs(2);%second saccade
                            timePeakVelocityXYSec=timePeakVelocityXY(2);
                        end
                    end
                    subplot(2,1,2);
                    plot(trialDataYSmooth{trialCounter});hold on
                    if ~isempty(posIndYs)
                        if length(posIndYs)>1&&abs(posIndYs(2))>abs(posIndYs(1))
                            posIndYSec=posIndYs(2);%second saccade
                        end
                    end
                    close(figInd7);
                    %                     catch ME
                    %                     end
                    %                 end
                    cleanUp=0;%remove datapoints that are too close to fixation?
                    if cleanUp==1
                        if posIndX<5||posIndY<5
                            manualCheck=1;
                            posIndX=NaN;
                            posIndY=NaN;
                        end
                    end
                    cleanUp2=0;%remove datapoints that are too far away?
                    if cleanUp2==1
                        if posIndX>200||posIndY>200
                            manualCheck=1;
                            posIndX=NaN;
                            posIndY=NaN;
                        end
                    end
                    posIndXTrials(trialCounter)=posIndX;
                    posIndYTrials(trialCounter)=posIndY;
                    saccadeEndTrials(trialCounter,:)=[posIndX posIndY];
                    posIndXTrialsVolt(trialCounter)=posIndXVolt;
                    posIndYTrialsVolt(trialCounter)=posIndYVolt;
                    saccadeEndTrialsVolt(trialCounter,:)=[posIndXVolt posIndYVolt];
                    electrodeTrials(trialCounter)=electrode;
                    freqMicrostim=300;%microstimulation frequency in Hz
                    pulseDuration=1000/freqMicrostim;%duration of each pulse in ms
                    numPulsesTrain=50;%number of pulses delivered in a train on every trial
                    if ~isempty(timePeakVelocityXY)
                        if strcmp(date,'110917_B3')%for monopolar stimulation, dasbit for target occurred at the end of stimulation
                            timePeakVelocityXYs(trialCounter)=(timePeakVelocityXY(1)/sampFreq-preStimDur+0.166)*1000;%+pulseDuration*numPulsesTrain/1000;%time of peak velocity relative to end of microstimulation delivery, in ms
                            timePeakVelocityXYSecs(trialCounter)=(timePeakVelocityXYSec/sampFreq-preStimDur+0.166)*1000;%+pulseDuration*numPulsesTrain/1000;%time of peak velocity for 2nd saccade, relative to end of microstimulation delivery, in ms
                        else %strcmp(date,'110917_B1')||strcmp(date,'110917_B2')%for bipolar stimulation, dasbit for target occurred at the beginning of stimulation
                            timePeakVelocityXYs(trialCounter)=(timePeakVelocityXY(1)/sampFreq-preStimDur)*1000;%+pulseDuration*numPulsesTrain/1000;%time of peak velocity relative to end of microstimulation delivery, in ms
                            timePeakVelocityXYSecs(trialCounter)=(timePeakVelocityXYSec/sampFreq-preStimDur)*1000;%+pulseDuration*numPulsesTrain/1000;%time of peak velocity for 2nd saccade, relative to end of microstimulation delivery, in ms
                        end
                    else
                        timePeakVelocityXYs(trialCounter)=NaN;
                        timePeakVelocityXYSecs(trialCounter)=NaN;
                    end
                    figure(figInd3)
                    scatter(posIndX,-posIndY,[],cols(arrayColInd,:),'MarkerFaceColor',cols(arrayColInd,:));
                    
                    figure(figInd4)
                    plot(posIndX,-posIndY,'MarkerEdgeColor',cols(arrayColInd,:),'Marker','o','MarkerSize',10);
                    impCol=impedance*0.9/150+0.05;
                    text(posIndX-0.05,-posIndY,num2str(electrode),'FontSize',6,'Color',[impCol impCol 1]);
                    
                    figure(figInd9(uniqueElectrode))%plot the saccade end points for an individual electrode, with the mean
                    %                 subplot(11,10,uniqueElectrode);
                    hold on
                    plot(posIndX,-posIndY,'MarkerEdgeColor',cols(arrayColInd,:),'Marker','o','MarkerSize',10);
                    impCol=impedance*0.9/150+0.05;
                    text(posIndX-0.05,-posIndY,num2str(electrode),'FontSize',6,'Color',[impCol impCol 1]);
                    
                    %                 close(figHistogram);
                    figure(figInd8)
                    plot(RFx,RFy,'MarkerEdgeColor',cols(arrayColInd,:),'Marker','o','MarkerSize',6);
                    text(RFx+0.2,RFy,num2str(electrode),'FontSize',8,'Color',[0 0 0]);
                    if ~isnan(posIndXSec)&&~isnan(posIndYSec)
                        plot(posIndX,-posIndY,'MarkerEdgeColor',cols(arrayColInd,:),'Marker','o','MarkerSize',10);
                        plot(posIndXSec,-posIndYSec,'x:','Color',cols(arrayColInd,:));
                        plot([posIndX posIndXSec],[-posIndY -posIndYSec],':','Color',cols(arrayColInd,:));
                        text(posIndXSec+0.2,-posIndYSec,['(',num2str(electrode),')'],'FontSize',6,'Color',[0 0 0]);
                    end
                end
            end
            saccadeEndAllTrials=[saccadeEndAllTrials;saccadeEndTrials];
            saccadeEndAllTrialsVolt=[saccadeEndAllTrialsVolt;saccadeEndTrialsVolt];
            electrodeAllTrials=[electrodeAllTrials;electrodeTrials'];
            arrayTrials=repmat(array,1,length(electrodeTrials));
            arrayAllTrials=[arrayAllTrials;arrayTrials'];
            timePeakVelocityXYsAllTrials=[timePeakVelocityXYsAllTrials;timePeakVelocityXYs'];
            timePeakVelocityXYSecsAllTrials=[timePeakVelocityXYSecsAllTrials;timePeakVelocityXYSecs'];
            if ~isempty(matchTrials)
                figure(figInd4)
                trialsIndElectrode=find(electrodeTrials==electrode);%identify trials where stimulation was delivered on a given electrode
                trialsXYElectrode=saccadeEndTrials(trialsIndElectrode,:);
                meanSaccadeXY=nanmean(trialsXYElectrode,1);%calculate mean of saccade end points
                stdSaccadeXY=nanstd(trialsXYElectrode,0,1);%calculate std of saccade end points
                allStdSaccadeXY(uniqueElectrode,:)=stdSaccadeXY;
                for trialElectrodeInd=1:length(trialsIndElectrode)
                    plot([meanSaccadeXY(1) trialsXYElectrode(trialElectrodeInd,1)],[-meanSaccadeXY(2) -trialsXYElectrode(trialElectrodeInd,2)],'-','Color',[impCol impCol 1]);
                end
                plot(meanSaccadeXY(1),-meanSaccadeXY(2),'MarkerFaceColor',cols(arrayColInd,:),'MarkerEdgeColor',cols(arrayColInd,:),'Marker','o','MarkerSize',10);
                %             ellipse(stdSaccadeXY(1),stdSaccadeXY(2),meanSaccadeXY(1),-meanSaccadeXY(2),cols(arrayColInd,:));
                %             plot(meanSaccadeXY(1),-meanSaccadeXY(2),'MarkerEdgeColor',cols(arrayColInd,:),'Marker','o','MarkerSize',mean(stdSaccadeXY));
                text(meanSaccadeXY(1)-0.05,-meanSaccadeXY(2),num2str(electrode),'FontSize',8,'Color',[0 0 0]);
                
                figure(figInd9(uniqueElectrode))%plot the saccade end points for an individual electrode, with the mean
                for trialElectrodeInd=1:length(trialsIndElectrode)
                    plot([meanSaccadeXY(1) trialsXYElectrode(trialElectrodeInd,1)],[-meanSaccadeXY(2) -trialsXYElectrode(trialElectrodeInd,2)],'-','Color',[impCol impCol 1]);
                end
                plot(meanSaccadeXY(1),-meanSaccadeXY(2),'MarkerFaceColor',cols(arrayColInd,:),'MarkerEdgeColor',cols(arrayColInd,:),'Marker','o','MarkerSize',10);
                %             ellipse(stdSaccadeXY(1),stdSaccadeXY(2),meanSaccadeXY(1),-meanSaccadeXY(2),cols(arrayColInd,:));
                %             plot(meanSaccadeXY(1),-meanSaccadeXY(2),'MarkerEdgeColor',cols(arrayColInd,:),'Marker','o','MarkerSize',mean(stdSaccadeXY));
                text(meanSaccadeXY(1)-0.05,-meanSaccadeXY(2),num2str(electrode),'FontSize',8,'Color',[0 0 0]);

                figure(figInd10)%plot only the RF centres
                greenCol=[0 1 0;0 0.7 0;0 0.5 0;0 0.4 0];
                numGoodTrials=sum(~isnan(trialsXYElectrode(:,1)));
                if numGoodTrials>4
                    numGoodTrials=4;
                end
                stdCutoff=25;
                if numGoodTrials>0&&stdSaccadeXY(1)<stdCutoff&&stdSaccadeXY(2)<stdCutoff
                    plot(RFx,RFy,'MarkerEdgeColor',cols(arrayColInd,:),'Marker','o','MarkerSize',4,'MarkerFaceColor',greenCol(numGoodTrials,:));
                    text(RFx+0.15,RFy,num2str(electrode),'FontSize',7,'Color',[0 0 0]);
                    ellipse(stdSaccadeXY(1),stdSaccadeXY(2),RFx,RFy,cols(arrayColInd,:));
                end
                
                figure(figInd5)
                plot(meanSaccadeXY(1),-meanSaccadeXY(2),'MarkerFaceColor',cols(arrayColInd,:),'MarkerEdgeColor',cols(arrayColInd,:),'Marker','o','MarkerSize',10);
                ellipse(stdSaccadeXY(1),stdSaccadeXY(2),meanSaccadeXY(1),-meanSaccadeXY(2),cols(arrayColInd,:));
                plot(RFx,RFy,'MarkerEdgeColor',cols(arrayColInd,:),'Marker','o','MarkerSize',6);
                text(meanSaccadeXY(1)-0.07,-meanSaccadeXY(2),num2str(electrode),'FontSize',8,'Color',[0 0 0]);
                text(RFx-0.07,RFy,num2str(electrode),'FontSize',8,'Color',[0 0 0]);
                plot([meanSaccadeXY(1) RFx],[-meanSaccadeXY(2) RFy],'-','Color',cols(arrayColInd,:));
                
                figure(figInd6)
                plot(meanSaccadeXY(1),-meanSaccadeXY(2),'MarkerFaceColor',cols(arrayColInd,:),'MarkerEdgeColor',cols(arrayColInd,:),'Marker','o','MarkerSize',6);
                plot(RFx,RFy,'MarkerEdgeColor',cols(arrayColInd,:),'Marker','o','MarkerSize',6);
                text(meanSaccadeXY(1)+0.2,-meanSaccadeXY(2),num2str(electrode),'FontSize',8,'Color',[0 0 0]);
                text(RFx+0.2,RFy,num2str(electrode),'FontSize',8,'Color',[0 0 0]);
                plot([meanSaccadeXY(1) RFx],[-meanSaccadeXY(2) RFy],'-','Color',cols(arrayColInd,:));
                
                figure(figInd8)
                plot(meanSaccadeXY(1),-meanSaccadeXY(2),'MarkerFaceColor',cols(arrayColInd,:),'MarkerEdgeColor',cols(arrayColInd,:),'Marker','o','MarkerSize',6);
                text(meanSaccadeXY(1)+0.2,-meanSaccadeXY(2),num2str(electrode),'FontSize',8,'Color',[0 0 0]);
                plot([meanSaccadeXY(1) RFx],[-meanSaccadeXY(2) RFy],'-','Color',cols(arrayColInd,:));
            
                figure(figInd9(uniqueElectrode))
                scatter(0,0,'r','o','filled');%fix spot
                %draw dotted lines indicating [0,0]
                plot([0 0],[-250 200],'k:');
                plot([-200 300],[0 0],'k:');
                plot([-200 300],[200 -300],'k:');
                ellipse(50,50,0,0,[0.1 0.1 0.1]);
                ellipse(100,100,0,0,[0.1 0.1 0.1]);
                ellipse(150,150,0,0,[0.1 0.1 0.1]);
                ellipse(200,200,0,0,[0.1 0.1 0.1]);
                text(sqrt(1000),-sqrt(1000),'2','FontSize',14,'Color',[0.7 0.7 0.7]);
                text(sqrt(4000),-sqrt(4000),'4','FontSize',14,'Color',[0.7 0.7 0.7]);
                text(sqrt(10000),-sqrt(10000),'6','FontSize',14,'Color',[0.7 0.7 0.7]);
                text(sqrt(18000),-sqrt(18000),'8','FontSize',14,'Color',[0.7 0.7 0.7]);
                axis equal
                xlim([-20 220]);
                ylim([-200 15]);
                title('saccade endpoints');
                for arrayInd=1:length(arrays)
                    text(180,0-4*arrayInd,['array',num2str(arrays(arrayInd))],'FontSize',14,'Color',cols(arrayInd,:));
                end
                ax=gca;
                ax.XTick=[0 Par.PixPerDeg*2 Par.PixPerDeg*4 Par.PixPerDeg*6 Par.PixPerDeg*8];
                ax.XTickLabel={'0','2','4','6','8'};
                ax.YTick=[-Par.PixPerDeg*8 -Par.PixPerDeg*6 -Par.PixPerDeg*4 -Par.PixPerDeg*2 0];
                ax.YTickLabel={'-8','-6','-4','-2','0'};
                xlabel('x-coordinates (dva)')
                ylabel('y-coordinates (dva)')
                set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
                pathname=fullfile(rootdir,date,['saccade_endpoints_dva_array_',num2str(array),'_electrode_',num2str(electrode),'_',date]);
                print(pathname,'-dtiff');
                close(figInd9(uniqueElectrode))
                baselineXChs{uniqueElectrode}=baselineXTrials;
                baselineYChs{uniqueElectrode}=baselineYTrials;
                trialDataXSmoothChs{uniqueElectrode}=trialDataXSmooth;
                trialDataYSmoothChs{uniqueElectrode}=trialDataYSmooth;
                trialNoChs{uniqueElectrode}=trialNoTrials;
                posIndXChs{uniqueElectrode}=posIndXTrials;
                posIndYChs{uniqueElectrode}=posIndYTrials;
                trialDataXSmoothFixChs{uniqueElectrode}=trialDataXSmoothFix;
                trialDataYSmoothFixChs{uniqueElectrode}=trialDataYSmoothFix;
                startMicrostimChs{uniqueElectrode}=startMicrostim;
                endMicrostimChs{uniqueElectrode}=endMicrostim;
            end
        end
        save([rootdir,date,'\saccade_data_',date,'_fix_to_rew.mat'],'baselineXChs','baselineYChs','trialDataXSmoothFixChs','trialDataYSmoothFixChs','trialNoChs','posIndXChs','posIndYChs','startMicrostimChs','endMicrostimChs','currentAmplitudeAllTrials');
        (200/26)/mean(saccadeEndAllTrialsVolt(:,1))
        (200/26)/mean(saccadeEndAllTrialsVolt(:,2))
        %calculate distance between targets, in volts:
        uniqueElectrodes=unique(electrodeAllTrials);
        for electrodeInd=1:length(uniqueElectrodes)
            trialInd=find(electrodeAllTrials==uniqueElectrodes(electrodeInd));
            switch targetLocs
                case 'TB'
                    meanSaccadeEndVolt(electrodeInd)=mean(saccadeEndAllTrialsVolt(trialInd,2));%y-location, for session with TB targets
                    distance400=abs(meanSaccadeEndVolt(1)-meanSaccadeEndVolt(2));%voltage corresponding to 400 pixels
                    degPerVoltYFinal=(400/26)/distance400%0.0038 on 280917_B4
                case 'LR'
                    meanSaccadeEndVolt(electrodeInd)=mean(saccadeEndAllTrialsVolt(trialInd,1));%x-location, for session with LR targets
                    distance400=abs(meanSaccadeEndVolt(1)-meanSaccadeEndVolt(2));%voltage corresponding to 400 pixels
                    degPerVoltXFinal=(400/26)/distance400%0.0036 on 280917_B8
            end
        end
        save([rootdir,date,'\saccade_endpoints_',date,'.mat'],'saccadeEndAllTrials','electrodeAllTrials','arrayAllTrials','timePeakVelocityXYsAllTrials','timePeakVelocityXYSecsAllTrials','saccadeEndAllTrialsVolt','distance400','degPerVoltXFinal','degPerVoltYFinal');
    end
end
pause=1;