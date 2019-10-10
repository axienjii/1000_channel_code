function list_2phosphene5(date)
%22/8/19
%Written by Xing, makes list of data folders corresponding to a
%microstimulation/visual 2-phosphene task.
%Calculates mean performance across sets of electrodes, for the first 50
%trials.
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
allDatesV=[];
allDatesM=[];
for calculateVisual=[0 1]
    for setNo=[1:17 19:25]%26
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
            allDatesM=[allDatesM;{date}];
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
            allDatesV=[allDatesV;{date}];
        end
    end
end
save('D:\data\list_2phosphene_datesM','allDatesM');
save('D:\data\list_2phosphene_datesV','allDatesV');