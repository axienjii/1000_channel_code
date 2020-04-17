function analyse_microstim_2phosphene5_moviedata(date)
%1/4/20
%Written by Xing, extracts eye movement data during a
%microstimulation/visual 2-phosphene task.

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
for calculateVisual=s0
    for setNo=14
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
                    date='091017_B13';
                    setElectrodes=[49 8 37 51;29 38 63 40];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[13 10 13 10;12 13 15 10];
                    setInd=2;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=5;
                    visualOnly=0;
                case 2
                    date='101017_B40';
                    setElectrodes=[49 8 37 51;46 46 40 61];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[13 10 13 10;16 15 8 12];
                    setInd=2;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=5;
                    visualOnly=0;
                case 3
                    date='111017_B11';
                    setElectrodes=[49 8 37 51;50 27 63 44];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[13 10 13 10;16 8 14 12];
                    setInd=2;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=8;
                    visualOnly=0;
                case 4
                    date='131017_B9';
                    setElectrodes=[49 8 37 51;45 32 50 33];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[13 10 13 10;14 14 8 13];
                    setInd=2;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=10;
                    visualOnly=0;
                    localDisk=1;
                case 5
                    date='181017_B21';
                    setElectrodes=[37 20 32 51];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[10 10 13 10];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=11;
                    visualOnly=0;
                case 6
                    date='181017_B28';
                    setElectrodes=[46 21 49 57];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[10 11 15 10];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=12;
                    visualOnly=0;
                case 7
                    date='191017_B33';
                    setElectrodes=[30 18 12 29];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[10 11 13 10];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=13;
                    visualOnly=0;
                case 8
                    date='191017_B35';
                    setElectrodes=[42 55 13 45];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[13 11 13 10];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=14;
                    visualOnly=0;
                case 9
                    date='191017_B37';
                    setElectrodes=[42 55 13 45];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[13 11 13 10];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=15;
                    visualOnly=0;
                case 10
                    date='191017_B39';
                    setElectrodes=[3 22 34 42];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[13 11 13 10];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=16;
                    visualOnly=0;
                case 11
                    date='191017_B41';
                    setElectrodes=[45 18 56 29];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[10 11 13 10];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=17;
                    visualOnly=0;
                case 12
                    date='201017_B28';
                    setElectrodes=[26 60 48 35];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[12 13 13 10];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=19;
                    visualOnly=0;
                    localDisk=1;
                case 13
                    date='201017_B30';
                    setElectrodes=[27 51 11 43];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[12 13 13 10];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=20;
                    visualOnly=0;
                    localDisk=1;
                case 14
                    date='231017_B11';
                    setElectrodes=[25 35 45 37];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[12 13 8 12];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=21;
                    visualOnly=0;
                    localDisk=1;
                case 15
                    date='231017_B39';
                    setElectrodes=[52 52 48 47];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[12 13 15 13];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=22;
                    visualOnly=0;
                    localDisk=1;
                case 16
                    date='231017_B43';
                    setElectrodes=[18 47 43 44];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[12 13 8 13];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=24;
                    visualOnly=0;
                    localDisk=1;
                case 17
                    date='231017_B42';
                    setElectrodes=[12 23 45 50];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[12 12 16 12];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=22;
                    visualOnly=0;
                    localDisk=1;
                case 18
                    date='231017_B45';
                    setElectrodes=[10 55 19 30];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[12 13 8 12];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=25;
                    visualOnly=0;
                    localDisk=1;
                case 19
                    date='231017_B49';
                    setElectrodes=[35 22 40 41];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[12 13 15 13];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=26;
                    visualOnly=0;
                    localDisk=1;
                case 20
                    date='241017_B17';
                    setElectrodes=[46 19 44 18];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[16 8 16 12];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=28;
                    visualOnly=0;
                    localDisk=1;
                case 21
                    date='241017_B46';
                    setElectrodes=[28 53 62 49];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[12 13 15 13];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=29;
                    visualOnly=0;
                    localDisk=1;
                case 22
                    date='241017_B49';
                    setElectrodes=[43 55 55 50];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[13 13 15 13];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=30;
                    visualOnly=0;
                    localDisk=1;
                case 23
                    date='241017_B51';
                    setElectrodes=[27 50 15 58];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[12 13 15 13];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=31;
                    visualOnly=0;
                    localDisk=1;
                case 24
                    date='241017_B54';
                    setElectrodes=[38 55 44 27];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[16 15 8 12];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=32;
                    visualOnly=0;
                    localDisk=1;
                case 25
                    date='241017_B56';
                    setElectrodes=[41 23 38 35];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[12 12 16 12];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=33;
                    visualOnly=0;
                    localDisk=1;
                case 26
                    date='241017_B58';
                    setElectrodes=[39 62 40 13];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[16 15 16 12];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=34;
                    visualOnly=0;
                    localDisk=1;
            end
        elseif calculateVisual==1  
            localDisk=0;
            switch(setNo)
                %visual task only:
                case 1
                    date='091017_B7';
                    setElectrodes=[49 8 37 51;29 38 63 40];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[13 10 13 10;12 13 15 10];
                    setInd=2;
                    numTargets=4;
                    electrodePairs=[1 4;2 4;1 2;3 4];
                    currentThresholdChs=5;
                    visualOnly=1;
                case 2
                    date='101017_B39';
                    setElectrodes=[49 8 37 51;46 46 40 61];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[13 10 13 10;16 15 8 12];
                    setInd=2;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=5;
                    visualOnly=1;
                case 3
                    date='111017_B1';
                    setElectrodes=[49 8 37 51;50 27 63 44];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[13 10 13 10;16 8 14 12];
                    setInd=2;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=7;
                    visualOnly=1;
                case 4
                    date='131017_B1';
                    setElectrodes=[49 8 37 51;45 32 50 33];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[13 10 13 10;14 14 8 13];
                    setInd=2;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=10;
                    visualOnly=1;
                    localDisk=1;
                case 5
                    date='181017_B18';
                    setElectrodes=[37 20 32 51];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[10 10 13 10];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=11;
                    visualOnly=1;
                case 6
                    date='181017_B27';
                    setElectrodes=[46 21 49 57];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[10 11 15 10];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=12;
                    visualOnly=1;
                case 7
                    date='191017_B29';
                    setElectrodes=[30 18 12 29];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[10 11 13 10];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=13;
                    visualOnly=1;
                case 8
                    date='191017_B34';
                    setElectrodes=[42 55 13 45];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[13 11 13 10];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=14;
                    visualOnly=1;
                case 9
                    date='191017_B36';
                    setElectrodes=[42 55 13 45];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[13 11 13 10];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=15;
                    visualOnly=1;
                case 10
                    date='191017_B38';
                    setElectrodes=[3 22 34 42];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[13 11 13 10];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=16;
                    visualOnly=1;
                case 11
                    date='191017_B40';
                    setElectrodes=[45 18 56 29];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[10 11 13 10];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=17;
                    visualOnly=1;
                case 12
                    date='201017_B27';
                    setElectrodes=[26 60 48 35];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[12 13 13 10];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=19;
                    visualOnly=1;
                    localDisk=1;
                case 13
                    date='201017_B29';
                    setElectrodes=[27 51 11 43];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[12 13 13 10];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=20;
                    visualOnly=1;
                    localDisk=1;
                case 14
                    date='231017_B10';
                    setElectrodes=[25 35 45 37];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[12 13 8 12];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=21;
                    visualOnly=1;
                    localDisk=1;
                case 15
                    date='231017_B38';
                    setElectrodes=[52 52 48 47];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[12 13 15 13];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=22;
                    visualOnly=1;
                    localDisk=1;
                case 16
                    date='231017_B40';
                    setElectrodes=[18 47 43 44];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[12 13 8 13];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=23;
                    visualOnly=1;
                    localDisk=1;
                case 17
                    date='231017_B41';
                    setElectrodes=[12 23 45 50];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[12 12 16 12];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=24;
                    visualOnly=1;
                    localDisk=1;
                case 18
                    date='231017_B44';
                    setElectrodes=[10 55 19 30];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[12 13 8 12];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=25;
                    visualOnly=1;
                    localDisk=1;
                case 19
                    date='231017_B48';
                    setElectrodes=[35 22 40 41];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[12 13 15 13];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=26;
                    visualOnly=1;
                    localDisk=1;
                case 20
                    date='241017_B15';
                    setElectrodes=[46 19 44 18];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[16 8 16 12];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=28;
                    visualOnly=1;
                    localDisk=1;
                case 21
                    date='241017_B44';
                    setElectrodes=[28 53 62 49];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[12 13 15 13];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=29;
                    visualOnly=1;
                    localDisk=1;
                case 22
                    date='241017_B48';
                    setElectrodes=[43 55 55 50];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[13 13 15 13];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=30;
                    visualOnly=1;
                    localDisk=1;
                case 23
                    date='241017_B50';
                    setElectrodes=[27 50 15 58];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[12 13 15 13];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=31;
                    visualOnly=1;
                    localDisk=1;
                case 24
                    date='241017_B53';
                    setElectrodes=[38 55 44 27];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[16 15 8 12];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=32;
                    visualOnly=1;
                    localDisk=1;
                case 25
                    date='241017_B55';
                    setElectrodes=[41 23 38 35];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[12 12 16 12];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=33;
                    visualOnly=1;
                    localDisk=1;
                case 26
                    date='241017_B57';
                    setElectrodes=[39 62 40 13];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[16 15 16 12];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2;3 4];
                    currentThresholdChs=34;
                    visualOnly=1;
                    localDisk=1;
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
                            eyeDataXFinal{trialNo}=NSch{1}(microstimTime-0.3*sampFreq:microstimTime+1.167*sampFreq);%eye data from 300 ms before stim onset to 1.3 s after stim onset
                            length(eyeDataXFinal{trialNo})
                            eyeDataYFinal{trialNo}=NSch{2}(microstimTime-0.3*sampFreq:microstimTime+1.167*sampFreq);
                            allArrayNumFinal{trialNo}=[allArrayNum(trialNo) allArrayNum2(trialNo)];
                            allElectrodeNumFinal{trialNo}=[allElectrodeNum(trialNo) allElectrodeNum2(trialNo)];   
                        end
                    
                        if strcmp(date,'231017_B45')
                            if length(find(trialEncodes==2^MicroB))==3
                                microstimTrialNEV(trialNo)=1;
                            end
                            if length(find(trialEncodes==2^MicroB))==2
                                microstimTrialNEV(trialNo)=1;
                            else
                                microstimTrialNEV(trialNo)=0;
                            end
                        else
                            microstimTrialNEV=allCurrentLevel>0;
                        end
                        trialNo=trialNo+1;
                    end
                end
                perfNEV=performance;
            end
            eyeDataTrialMat=['D:\data\',date,'\eye_data_',date,'.mat'];
            save(eyeDataTrialMat,'eyeDataXFinal','eyeDataYFinal','allElectrodeNumFinal','allArrayNumFinal');
        end
    end
end