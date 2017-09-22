function analyse_microstim_artefact2(date,allInstanceInd,allGoodChannels)
%15/9/17
%Written by Xing. Plots profile of stimulation artefact across V4 channels,
%while microstimulation delivered on V1 channels.
%Uses serial port encodes to identify trials.

matFile=['D:\data\',date,'\',date,'_data\microstim_saccade_',date,'.mat'];
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

downSampling=1;
downsampleFreq=30;

sampFreq=30000;
switch date
    case '070917_B13'
        minCrossingTime=300/1000;
    case '110917_B1'
        minCrossingTime=300/1000;
    case '110917_B2'
        minCrossingTime=300/1000;
    case '110917_B3'
        minCrossingTime=preStimDur-0.166;
end

cols=[1 0 0;0 1 1;165/255 42/255 42/255;0 1 0;0 0 1;0 0 0;1 0 1;0.9 0.9 0;128/255 0 128/255];
arrays=8:16;

processRaw=1;
if processRaw==1
    for instanceCount=1%:length(allInstanceInd)
        instanceInd=allInstanceInd(instanceCount);
        instanceName=['instance',num2str(instanceInd)];
        instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
        NEV=openNEV(instanceNEVFileName);        
        
        %read in V4 neuronal data:
        recordedRaw=1;
        if instanceInd==1
            neuronalChannels=33:96;%V4 array on instance 1
        elseif instanceInd==2
            neuronalChannels=[1:32 97:128];%V4 array on instance 2
        end
        minFixDur=300/1000;%fixates for at least 300 ms, up to 800 ms
        instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6']; 
        neuronalDataMat=['D:\data\',date,'\',instanceName,'_NSch_channels.mat'];
        if exist(neuronalDataMat,'file')
            load(neuronalDataMat,'NSch');
        else
            if recordedRaw==0
                NSchOriginal=openNSx(instanceNS6FileName);
                for channelInd=1:length(neuronalChannels)
                    NSch{channelInd}=NSchOriginal.Data(channelInd,:);
                end
            elseif recordedRaw==1
                for channelInd=1%:length(neuronalChannels)
                    readChannel=['c:',num2str(neuronalChannels(channelInd)),':',num2str(neuronalChannels(channelInd))];
                    NSchOriginal=openNSx(instanceNS6FileName,readChannel);
                    NSch{channelInd}=NSchOriginal.Data;
                end
            end
            save(neuronalDataMat,'NSch');
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
                
        microstimTrialsInd=find(allCurrentLevel>0);
        correctTrialsInd=find(performance==1);
        correctMicrostimTrialsInd=intersect(microstimTrialsInd,correctTrialsInd);%trialNo for microstim trials with a correct saccade
        fixTimes=allFixT(correctMicrostimTrialsInd)/1000;%durations of fixation period before target onset

        figInd1=figure;hold on
        figInd2=figure;hold on
        figInd3=figure;hold on
        figInd4=figure;hold on
        figInd5=figure;hold on
        figInd6=figure;hold on
        figInd8=figure;hold on
        saccadeEndAllTrials=[]; 
        electrodeAllTrials=[];
        timePeakVelocityXYsAllTrials=[];
        timePeakVelocityXYSecsAllTrials=[];
        arrayAllTrials=[];
        for uniqueElectrode=1:size(goodArrays8to16,1)
            array=goodArrays8to16(uniqueElectrode,7);
            arrayColInd=find(arrays==array);
            electrode=goodArrays8to16(uniqueElectrode,8);
            impedance=goodArrays8to16(uniqueElectrode,6);
            RFx=goodArrays8to16(uniqueElectrode,1);
            RFy=goodArrays8to16(uniqueElectrode,2);
            if RFy<-500
                RFy=NaN;
            end
            
            electrodeInd=find(cell2mat(allElectrodeNum)==electrode);
            arrayInd=find(cell2mat(allArrayNum)==array);
            matchTrials=intersect(electrodeInd,arrayInd);%identify trials where stimulation was delivered on a particular array and electrode
            matchTrials=intersect(matchTrials,correctMicrostimTrialsInd);%identify subset of trials where performance was correct
        
            trialDataXY={};
            degPerVoltXFinal=0.0024;
            degPerVoltYFinal=0.0022;
            flankingSamples=(30000/50)/2;%50-ms period before reward delivery
            saccadeEndTrials=[];
            electrodeTrials=[];
            timePeakVelocityXYs=[];
            timePeakVelocityXYSecs=[];
            for trialCounter=1:length(matchTrials)%for each correct microstim trial
                trialNo=matchTrials(trialCounter);%trial number, out of all trials from that session  
                corrBit=7;
                temp=find(NEV.Data.SerialDigitalIO.UnparsedData(1:encodeInd(trialNo))==2^corrBit);
                timeRewardInd=temp(end);%index in NEV file corresponding to reward delivery
                timeReward=NEV.Data.SerialDigitalIO.TimeStamp(timeRewardInd);%timestamp in NEV file corresponding to reward delivery
                codeMicrostimOn=2;%sent at the end of microstimulation train, for monopolar, and at start, for bipolar
                temp=find(NEV.Data.SerialDigitalIO.UnparsedData(1:timeRewardInd)==2^codeMicrostimOn);%(two encodes before reward encode)
                timeMicrostimInd=temp(end);%index in NEV file corresponding to end of microstim train
                timeMicrostim=NEV.Data.SerialDigitalIO.TimeStamp(timeMicrostimInd);%timestamp in NEV file corresponding to reward delivery
                preStimDur=100;
                postStimDur=100;
                stimDur=167;
                if strcmp(date,'110917_B2')
                    timeMicrostimToReward=timeMicrostim-preStimDur/1000*sampFreq:timeMicrostim+(stimDur*2+postStimDur)/1000*sampFreq;%timestamps from 150 ms before end of microstimulation to reward delivery (because eyeanalysis_baseline_correct requires at least 150 ms of eye fixation time)
                elseif strcmp(date,'110917_B3')
                    timeMicrostimToReward=timeMicrostim-(preStimDur+stimDur)/1000*sampFreq:timeMicrostim+(postStimDur)/1000*sampFreq;%timestamps from 150 ms before end of microstimulation to reward delivery (because eyeanalysis_baseline_correct requires at least 150 ms of eye fixation time)
                end
                trialData{trialCounter}=NSch{1}(timeMicrostimToReward);
                figure;
                plot(trialData{trialCounter})
                xlabel('sample points')
                ylabel('voltage')
                hold on
                yLims=get(gca,'ylim');
                plot([preStimDur/1000*sampFreq preStimDur/1000*sampFreq],[yLims(1) yLims(2)],'k:')
                plot([(preStimDur+166)/1000*sampFreq (preStimDur+166)/1000*sampFreq],[yLims(1) yLims(2)],'k:')
                title(['V4 channel stimulation artefact'])
            end
        end
    end
end

%extract microstim artefact for each channel and trial, average across
%trials, depending on level of current delivered and whether trial was a
%hit or miss:
for instanceCount=1:length(allInstanceInd)
    instanceInd=allInstanceInd(instanceCount);
    instanceName=['instance',num2str(instanceInd)];
    goodChannels=allGoodChannels{instanceCount};
    for channelCount=1:length(goodChannels)
        channelInd=goodChannels(channelCount);
        fileName=fullfile('D:\data',date,['MUA_',instanceName,'_ch',num2str(channelInd),'_downsample.mat']);
        load(fileName);
        trialData=[];
        meanChannelMUA=[];
        timeStimOnsMatch;%edit to analyse data for each condition separately
        for trialInd=1:length(timeStimOnsMatch)
            if downSampling==1
                startPoint=floor(timeStimOnsMatch(trialInd)/downsampleFreq);
                if length(channelDataMUA)>=startPoint+sampFreq/downsampleFreq*artefactDur-1
                    spontanAct(trialInd,:)=channelDataMUA(startPoint-sampFreq/downsampleFreq*(preStimDur+artefactDur):startPoint-1);%raw data in uV, read in data during stimulus presentation
                    microstimAct(trialInd,:)=channelDataMUA(startPoint-sampFreq/downsampleFreq*artefactDur:startPoint+sampFreq/downsampleFreq*postStimDur-1);%raw data in uV, read in data during stimulus presentation
                end
            end
        end
        meanSpontanAct(channelInd,:)=mean(spontanAct(:));%average across trials and spontaneous activity period
        peakMicrostimAct(channelInd,:)=max(microstimAct,[],2);%find peak activity level for each trial during microstimulation period
        meanMicrostimAct=mean(peakMicrostimAct(:));%find mean peak across trials
        meanChannelMUA(channelInd,:)=mean([spontanAct microstimAct],1);
        
        figInd=ceil(channelInd/36);
        figure(figInd);
        subplotInd=channelInd-((figInd-1)*36);
        subplot(6,6,subplotInd);
        plot(meanChannelMUA(channelInd,:));
        hold on
        ax=gca;
        if downSampling==0
            ax.XTick=[0 sampFreq/downsampleFreq*preStimDur sampFreq/downsampleFreq*(preStimDur+stimDur)];
            ax.XTickLabel={num2str(-preStimDur*1000),'0',num2str(stimDurms)};
        elseif downSampling==1
            ax.XTick=[0 sampFreq/downsampleFreq*preStimDur sampFreq/downsampleFreq*(preStimDur+stimDur)];
            ax.XTickLabel={num2str(-preStimDur*1000),'0',num2str(stimDurms)};
        end
        %     set(gca,'ylim',[0 max(meanChannelMUA(channelInd,:))]);
        title(num2str(channelInd));
        %set axis limits
        maxResponse=max(meanChannelMUA(channelInd,:));
        minResponse=min(meanChannelMUA(channelInd,:));
        diffResponse=maxResponse-minResponse;
        %draw dotted lines indicating stimulus presentation
        if downSampling==0
            plot([sampFreq*preStimDur sampFreq*preStimDur],[minResponse-diffResponse/10 maxResponse+diffResponse/10],'k:')
            plot([sampFreq*(preStimDur+stimDur) sampFreq*(preStimDur+stimDur)],[minResponse-diffResponse/10 maxResponse+diffResponse/10],'k:')
        elseif downSampling==1
            plot([sampFreq/downsampleFreq*preStimDur sampFreq/downsampleFreq*preStimDur],[minResponse-diffResponse/10 maxResponse+diffResponse/10],'k:')
            plot([sampFreq/downsampleFreq*(preStimDur+stimDur) sampFreq/downsampleFreq*(preStimDur+stimDur)],[minResponse-diffResponse/10 maxResponse+diffResponse/10],'k:')
        end
        ylim([minResponse-diffResponse/10 maxResponse+diffResponse/10]);
        xlim([0 length(meanChannelMUA(channelInd,:))]);
    end
end