function analyse_microstim_motion_across_sessions_5phosphenes(date)
%30/11/17
%Written by Xing, calculates behavioural performance during a
%microstimulation/visual direction-of-motion task.
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
allSetsPerfMicroBin=[];
allSetsPerfVisualBin=[];
analyseConds=0;
for calculateVisual=[0 1]
    for setNo=[1 2 5 10 11 13]%before corrected RFs:[1:23]%26
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
                    date='061217_B11';
                    setElectrodes=[63 48 26 40 35;35 40 26 48 63];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[15 13 13 10 10;10 10 13 13 15];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3 4 5;1 2 3 4 5];
                    currentThresholdChs=48;
                    visualOnly=0;
                case 2
                    date='061217_B13';
                    setElectrodes=[32 55 46 51 57;57 51 46 55 32];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[13 13 10 10 10;10 10 10 13 13];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3 4 5;1 2 3 4 5];
                    currentThresholdChs=48;
                    visualOnly=0;
                case 3
                    date='061217_B15';
                    setElectrodes=[38 55 48 58 59;59 58 48 55 38];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[13 10 10 10 10;10 10 10 10 13];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3 4 5;1 2 3 4 5];
                    currentThresholdChs=48;
                    visualOnly=0;
                case 4
                    date='061217_B17';
                    setElectrodes=[39 17 34 44 19;19 44 34 17 39];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[16 9 12 9 9;9 9 12 9 16];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3 4 5;1 2 3 4 5];
                    currentThresholdChs=49;
                    visualOnly=0;
                case 5
                    date='061217_B19';
                    setElectrodes=[40 21 13 20 61;61 20 13 21 40];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[8 16 14 12 12;12 12 14 16 8];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3 4 5;1 2 3 4 5];
                    currentThresholdChs=49;
                    visualOnly=0;
                case 6
                    date='061217_B21';
                    setElectrodes=[55 35 28 36 50;50 36 28 35 55];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[11 13 12 12 12;12 12 12 13 11];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3 4 5;1 2 3 4 5];
                    currentThresholdChs=49;
                    visualOnly=0;
                case 7
                    date='061217_B23';
                    setElectrodes=[24 53 61 47 10;10 47 61 53 24];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[11 13 13 13 12;12 13 13 13 11];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3 4 5;1 2 3 4 5];
                    currentThresholdChs=49;
                    visualOnly=0;
                case 8
                    date='061217_B25';
                    setElectrodes=[18 20 21 62 37;37 62 21 20 18];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[11 10 10 10 10;10 10 10 10 11];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3 4 5;1 2 3 4 5];
                    currentThresholdChs=49;
                    visualOnly=0;
                case 9
                    date='061217_B27';
                    setElectrodes=[56 29 30 20 4;41 20 30 29 56];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[13 12 12 12 12;12 12 12 12 13];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3 4 5;1 2 3 4 5];
                    currentThresholdChs=49;
                    visualOnly=0;
                case 10
                    date='071217_B22';
                    setElectrodes=[38 47 39 35 27;27 35 39 47 38];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[16 16 14 12 9;9 12 14 16 16];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3 4 5;1 2 3 4 5];
                    currentThresholdChs=50;
                    visualOnly=0;
                case 11
                    date='071217_B24';
                    setElectrodes=[40 50 12 44 26;26 44 12 50 40];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[16 16 12 9 9;9 9 12 16 16];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3 4 5;1 2 3 4 5];
                    currentThresholdChs=50;
                    visualOnly=0;
                case 12
                    date='071217_B26';
                    setElectrodes=[7 64 61 58 2;2 58 61 64 7];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[16 16 16 14 12;12 14 16 16 16];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3 4 5;1 2 3 4 5];
                    currentThresholdChs=50;
                    visualOnly=0;
                case 13
                    date='071217_B28';
                    setElectrodes=[15 12 13 29 57;57 29 13 12 15];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[16 16 14 14 12;12 14 14 16 16];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3 4 5;1 2 3 4 5];
                    currentThresholdChs=50;
                    visualOnly=0;
                case 14
                    date='071217_B30';
                    setElectrodes=[55 48 43 7 40;40 7 43 48 55];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[15 15 8 16 16;16 16 8 15 15];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3 4 5;1 2 3 4 5];
                    currentThresholdChs=50;
                    visualOnly=0;
                case 15
                    date='071217_B32';
                    setElectrodes=[46 19 15 64 47;47 64 15 19 46];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[15 8 16 16 16;16 16 16 8 15];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3 4 5;1 2 3 4 5];
                    currentThresholdChs=50;
                    visualOnly=0;
                case 16
                    date='071217_B34';
                    setElectrodes=[53 61 47 57 2;2 57 47 61 53];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[13 13 13 12 12;12 12 13 13 13];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3 4 5;1 2 3 4 5];
                    currentThresholdChs=50;
                    visualOnly=0;
                case 17
                    date='071217_B36';
                    setElectrodes=[29 30 22 12 41;41 12 22 30 29];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[12 12 12 12 12;12 12 12 12 12];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3 4 5;1 2 3 4 5];
                    currentThresholdChs=50;
                    visualOnly=0;
                case 18
                    date='081217_B20';
                    setElectrodes=[45 30 16 23 37;37 23 16 30 45];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[8 16 14 12 12;12 12 14 16 8];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3 4 5;1 2 3 4 5];
                    currentThresholdChs=51;
                    visualOnly=0;
                case 19
                    date='081217_B17';
                    setElectrodes=[55 35 34 28 52;52 28 34 35 55];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[13 13 12 12 12;12 12 13 13 13];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3 4 5;1 2 3 4 5];
                    currentThresholdChs=51;
                    visualOnly=0;
                case 20
                    date='121217_B5';
                    setElectrodes=[35 39 33 64 9;9 64 33 39 35];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[16 12 12 9 9;9 9 12 12 16];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3 4 5;1 2 3 4 5];
                    currentThresholdChs=52;
                    visualOnly=0;
                case 21
                    date='121217_B7';
                    setElectrodes=[22 27 13 21 61;61 21 13 27 22];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[16 16 14 12 12;12 12 14 16 16];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3 4 5;1 2 3 4 5];
                    currentThresholdChs=52;
                    visualOnly=0;
                case 22
                    date='121217_B9';
                    setElectrodes=[7 15 50 44 45;45 44 50 15 7];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[15 15 8 8 8;8 8 8 15 15];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3 4 5;1 2 3 4 5];
                    currentThresholdChs=52;
                    visualOnly=0;
                case 23
                    date='121217_B11';
                    setElectrodes=[22 55 51 49 41;41 49 51 55 22];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[11 11 13 13 13;13 13 13 11 11];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3 4 5;1 2 3 4 5];
                    currentThresholdChs=52;
                    visualOnly=0;
            end
        elseif calculateVisual==1
            localDisk=0;
            switch(setNo)
                %visual task only:
                case 1
                    date='061217_B10';
                    setElectrodes=[63 48 26 40 35;35 40 26 48 63];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[15 13 13 10 10;10 10 13 13 15];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3 4 5;1 2 3 4 5];
                    currentThresholdChs=49;
                    visualOnly=1;
                case 2
                    date='061217_B12';
                    setElectrodes=[32 55 46 51 57;57 51 46 55 32];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[13 13 10 10 10;10 10 10 13 13];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3 4 5;1 2 3 4 5];
                    currentThresholdChs=48;
                    visualOnly=1;
                case 3
                    date='061217_B14';
                    setElectrodes=[38 55 48 58 59;59 58 48 55 38];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[13 10 10 10 10;10 10 10 10 13];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3 4 5;1 2 3 4 5];
                    currentThresholdChs=48;
                    visualOnly=1;
                case 4
                    date='061217_B16';
                    setElectrodes=[39 17 34 44 19;19 44 34 17 39];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[16 9 12 9 9;9 9 12 9 16];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3 4 5;1 2 3 4 5];
                    currentThresholdChs=49;
                    visualOnly=1;
                case 5
                    date='061217_B18';
                    setElectrodes=[40 21 13 20 61;61 20 13 21 40];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[8 16 14 12 12;12 12 14 16 8];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3 4 5;1 2 3 4 5];
                    currentThresholdChs=49;
                    visualOnly=1;
                case 6
                    date='061217_B20';
                    setElectrodes=[55 35 28 36 50;50 36 28 35 55];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[11 13 12 12 12;12 12 12 13 11];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3 4 5;1 2 3 4 5];
                    currentThresholdChs=49;
                    visualOnly=1;
                case 7
                    date='061217_B22';
                    setElectrodes=[24 53 61 47 10;10 47 61 53 24];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[11 13 13 13 12;12 13 13 13 11];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3 4 5;1 2 3 4 5];
                    currentThresholdChs=49;
                    visualOnly=1;
                case 8
                    date='061217_B24';
                    setElectrodes=[18 20 21 62 37;37 62 21 20 18];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[11 10 10 10 10;10 10 10 10 11];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3 4 5;1 2 3 4 5];
                    currentThresholdChs=49;
                    visualOnly=1;
                case 9
                    date='061217_B26';
                    setElectrodes=[56 29 30 20 4;41 20 30 29 56];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[13 12 12 12 12;12 12 12 12 13];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3 4 5;1 2 3 4 5];
                    currentThresholdChs=49;
                    visualOnly=1;
                case 10
                    date='071217_B21';
                    setElectrodes=[38 47 39 35 27;27 35 39 47 38];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[16 16 14 12 9;9 12 14 16 16];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3 4 5;1 2 3 4 5];
                    currentThresholdChs=50;
                    visualOnly=1;
                case 11
                    date='071217_B23';
                    setElectrodes=[40 50 12 44 26;26 44 12 50 40];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[16 16 12 9 9;9 9 12 16 16];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3 4 5;1 2 3 4 5];
                    currentThresholdChs=50;
                    visualOnly=1;
                case 12
                    date='071217_B25';
                    setElectrodes=[7 64 61 58 2;2 58 61 64 7];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[16 16 16 14 12;12 14 16 16 16];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3 4 5;1 2 3 4 5];
                    currentThresholdChs=50;
                    visualOnly=1;
                case 13
                    date='071217_B27';
                    setElectrodes=[15 12 13 29 57;57 29 13 12 15];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[16 16 14 14 12;12 14 14 16 16];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3 4 5;1 2 3 4 5];
                    currentThresholdChs=50;
                    visualOnly=1;
                case 14
                    date='071217_B29';
                    setElectrodes=[55 48 43 7 40;40 7 43 48 55];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[15 15 8 16 16;16 16 8 15 15];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3 4 5;1 2 3 4 5];
                    currentThresholdChs=50;
                    visualOnly=1;
                case 15
                    date='071217_B31';
                    setElectrodes=[46 19 15 64 47;47 64 15 19 46];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[15 8 16 16 16;16 16 16 8 15];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3 4 5;1 2 3 4 5];
                    currentThresholdChs=50;
                    visualOnly=1;
                case 16
                    date='071217_B33';
                    setElectrodes=[53 61 47 57 2;2 57 47 61 53];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[13 13 13 12 12;12 12 13 13 13];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3 4 5;1 2 3 4 5];
                    currentThresholdChs=50;
                    visualOnly=1;
                case 17
                    date='071217_B35';
                    setElectrodes=[29 30 22 12 41;41 12 22 30 29];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[12 12 12 12 12;12 12 12 12 12];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3 4 5;1 2 3 4 5];
                    currentThresholdChs=50;
                    visualOnly=1;
                case 18
                    date='081217_B10';
                    setElectrodes=[45 30 16 23 37;37 23 16 30 45];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[8 16 14 12 12;12 12 14 16 8];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3 4 5;1 2 3 4 5];
                    currentThresholdChs=51;
                    visualOnly=1;
                case 19
                    date='081217_B16';
                    setElectrodes=[55 35 34 28 52;52 28 34 35 55];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[13 13 12 12 12;12 12 13 13 13];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3 4 5;1 2 3 4 5];
                    currentThresholdChs=51;
                    visualOnly=1;
                case 20
                    date='121217_B4';
                    setElectrodes=[35 39 33 64 9;9 64 33 39 35];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[16 12 12 9 9;9 9 12 12 16];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3 4 5;1 2 3 4 5];
                    currentThresholdChs=52;
                    visualOnly=1;
                case 21
                    date='121217_B6';
                    setElectrodes=[22 27 13 21 61;61 21 13 27 22];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[16 16 14 12 12;12 12 14 16 16];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3 4 5;1 2 3 4 5];
                    currentThresholdChs=52;
                    visualOnly=1;
                case 22
                    date='121217_B8';
                    setElectrodes=[7 15 50 44 45;45 44 50 15 7];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[15 15 8 8 8;8 8 8 15 15];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3 4 5;1 2 3 4 5];
                    currentThresholdChs=52;
                    visualOnly=1;
                case 23
                    date='121217_B10';
                    setElectrodes=[22 55 51 49 41;41 49 51 55 22];%first row: set 1, LRTB; second row: set 2, LRTB
                    setArrays=[11 11 13 13 13;13 13 13 11 11];
                    setInd=1;
                    numTargets=2;
                    electrodePairs=[1 2 3 4 5;1 2 3 4 5];
                    currentThresholdChs=52;
                    visualOnly=1;
            end
        end
        
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
                    eyeChannels=[129 130];
                end
                minFixDur=300/1000;%fixates for at least 300 ms, up to 800 ms
                
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
                        if visualOnly==0
                            if ~isempty(find(trialEncodes==2^CorrectB))&&~isempty(find(trialEncodes==2^MicroB))&&~isempty(find(trialEncodes==2^TargetB))
                                perfNEV(trialNo)=1;
                            elseif ~isempty(find(trialEncodes==2^ErrorB))&&~isempty(find(trialEncodes==2^MicroB))&&~isempty(find(trialEncodes==2^TargetB))
                                perfNEV(trialNo)=-1;
                            end
                            if length(find(trialEncodes==2^MicroB))>=1
                                microstimTrialNEV(trialNo)=1;
                            end
                        elseif visualOnly==1
                            if ~isempty(find(trialEncodes==2^CorrectB))&&~isempty(find(trialEncodes==2^StimB))&&~isempty(find(trialEncodes==2^TargetB))
                                perfNEV(trialNo)=1;
                            elseif ~isempty(find(trialEncodes==2^ErrorB))&&~isempty(find(trialEncodes==2^StimB))&&~isempty(find(trialEncodes==2^TargetB))
                                perfNEV(trialNo)=-1;
                            end
                            microstimTrialNEV(trialNo)=0;
                        end
%                         if find(trialEncodes==2^CorrectB)
%                             perfNEV(trialNo)=1;
%                         elseif find(trialEncodes==2^ErrorB)
%                             perfNEV(trialNo)=-1;
%                         end
%                         for trialCurrentLevelInd=1:length(allCurrentLevel)
%                             if sum(allCurrentLevel{trialCurrentLevelInd})>0
%                                 microstimTrialNEV(trialCurrentLevelInd)=1;
%                             else
%                                 microstimTrialNEV(trialCurrentLevelInd)=0;
%                             end
%                         end
                        %analyse individual conditions:
%                         if analyseConds==1&&length(allElectrodeNum)>=trialNo
%                             electrode=allElectrodeNum(trialNo);
%                             array=allArrayNum(trialNo);
%                             electrode2=allElectrodeNum2(trialNo);
%                             array2=allArrayNum2(trialNo);
%                             electrodeMatch=find(setElectrodes(setInd,:)==electrode);
%                             arrayMatch=find(setArrays(setInd,:)==array);
%                             matchingCh=intersect(electrodeMatch,arrayMatch);%one electrode of a pair
%                             electrodeMatch2=find(setElectrodes(setInd,:)==electrode2);
%                             arrayMatch2=find(setArrays(setInd,:)==array2);
%                             matchingCh2=intersect(electrodeMatch2,arrayMatch2);%the other electrode of a pair
%                             if isequal(sort([matchingCh matchingCh2]),[1 2])
%                                 LRorTB=2;
%                                 targetLocation=1;
%                             elseif isequal(sort([matchingCh matchingCh2]),[3 4])
%                                 LRorTB=2;
%                                 targetLocation=2;
%                             elseif isequal(sort([matchingCh matchingCh2]),[1 4])
%                                 LRorTB=1;
%                                 targetLocation=1;
%                             elseif isequal(sort([matchingCh matchingCh2]),[2 4])
%                                 LRorTB=1;
%                                 targetLocation=2;
%                             end
%                             allLRorTB(trialNo)=LRorTB;
%                             allTargetLocation(trialNo)=targetLocation;
%                         end
                        trialNo=trialNo+1;
                    end
                end
                
                tallyCorrect=length(find(perfNEV==1));
                tallyIncorrect=length(find(perfNEV==-1));
                meanPerf=tallyCorrect/(tallyCorrect+tallyIncorrect);
                visualTrialsInd=find(microstimTrialNEV==0);%not entirely correct- includes microstim trials where fix breaks happen before dasbit sent MicroB
                microstimTrialsInd=find(microstimTrialNEV==1);
                correctTrialsInd=find(perfNEV==1);
                incorrectTrialsInd=find(perfNEV==-1);
                correctVisualTrialsInd=intersect(visualTrialsInd,correctTrialsInd);%trialNo for microstim trials with a correct saccade
                incorrectVisualTrialsInd=intersect(visualTrialsInd,incorrectTrialsInd);%trialNo for microstim trials with a correct saccade
                correctMicrostimTrialsInd=intersect(microstimTrialsInd,correctTrialsInd);%trialNo for microstim trials with a correct saccade
                incorrectMicrostimTrialsInd=intersect(microstimTrialsInd,incorrectTrialsInd);%trialNo for microstim trials with a correct saccade
                meanPerfVisual=length(correctVisualTrialsInd)/(length(correctVisualTrialsInd)+length(incorrectVisualTrialsInd))
                meanPerfMicrostim=length(correctMicrostimTrialsInd)/(length(correctMicrostimTrialsInd)+length(incorrectMicrostimTrialsInd))
                totalRespTrials=length(correctTrialsInd)+length(incorrectTrialsInd);%number of trials where a response was made
                indRespTrials=sort([correctTrialsInd incorrectTrialsInd]);%indices of trials where response was made
                micro=[];
                for trialRespInd=1:totalRespTrials
                    trialNo=indRespTrials(trialRespInd);
                    corr(trialRespInd)=~isempty(find(correctTrialsInd==trialNo));
                    incorr(trialRespInd)=~isempty(find(incorrectTrialsInd==trialNo));
                    if exist('microstimTrialNEV','var')
                        if length(microstimTrialNEV)>=trialNo
                            micro(trialRespInd)=microstimTrialNEV(trialNo);
                        end
                    end
                end
                visualInd=find(micro~=1);
                corrInd=find(corr==1);
                corrVisualInd=intersect(visualInd,corrInd);
                if exist('microstimTrialNEV','var')
                    microInd=find(micro==1);
                    corrMicroInd=intersect(microInd,corrInd);
                end
                perfMicroBin=[];
                perfVisualBin=[];
                perfMicroTrialNo=[];
                perfVisualTrialNo=[];
                numTrialsPerBin=1;
                for trialRespInd=1:length(micro)
                    if micro(trialRespInd)==1
                        firstMicroTrialInBin=find(microInd==trialRespInd);
                        if firstMicroTrialInBin<=length(microInd)-numTrialsPerBin+1
                            binMicroTrials=microInd(firstMicroTrialInBin:firstMicroTrialInBin+numTrialsPerBin-1);
                            corrMicroInBin=intersect(binMicroTrials,corrMicroInd);
                            perfMicroBin=[perfMicroBin length(corrMicroInBin)/numTrialsPerBin];
                            perfMicroTrialNo=[perfMicroTrialNo trialRespInd];
                        end
                    elseif micro(trialRespInd)==0
                        firstVisualTrialInBin=find(visualInd==trialRespInd);
                        if firstVisualTrialInBin<=length(visualInd)-numTrialsPerBin+1
                            binVisualTrials=visualInd(firstVisualTrialInBin:firstVisualTrialInBin+numTrialsPerBin-1);
                            corrVisualInBin=intersect(binVisualTrials,corrVisualInd);
                            perfVisualBin=[perfVisualBin length(corrVisualInBin)/numTrialsPerBin];
                            perfVisualTrialNo=[perfVisualTrialNo trialRespInd];
                        end
                    end
                end
                initialPerfTrials=19;%10%11;%first set of trials are the most important
                if calculateVisual==0
                    perfMicroBin=perfMicroBin(1:initialPerfTrials);
                    if ~isempty(perfMicroBin)
                        allSetsPerfMicroBin=[allSetsPerfMicroBin;perfMicroBin];
%                         save(['D:\microPerf_',date,'.mat'],'perfMicroBin');
                    end
                elseif calculateVisual==1
                    perfVisualBin=perfVisualBin(1:initialPerfTrials);
                    %perfVisualBin=perfVisualBin(end-initialPerfTrials+1:end);
                    if ~isempty(perfVisualBin)
                        allSetsPerfVisualBin=[allSetsPerfVisualBin;perfVisualBin];
%                         save(['D:\visualPerf_',date,'.mat'],'perfVisualBin');
                    end
                end
                
                if analyseConds==1
                    LRTBInd1=find(allLRorTB==1);
                    LRTBInd2=find(allLRorTB==2);
                    targetInd1=find(allTargetLocation==1);
                    targetInd2=find(allTargetLocation==2);
                    
                    condInds=intersect(LRTBInd1,targetInd1);
                    corrIndsM=intersect(condInds,correctMicrostimTrialsInd);
                    incorrIndsM=intersect(condInds,incorrectMicrostimTrialsInd);
                    leftPerfM=length(corrIndsM)/(length(corrIndsM)+length(incorrIndsM));
                    corrIndsV=intersect(condInds,correctVisualTrialsInd);
                    incorrIndsV=intersect(condInds,incorrectVisualTrialsInd);
                    leftPerfV=length(corrIndsV)/(length(corrIndsV)+length(incorrIndsV));
                    
                    condInds=intersect(LRTBInd1,targetInd2);
                    corrIndsM=intersect(condInds,correctMicrostimTrialsInd);
                    incorrIndsM=intersect(condInds,incorrectMicrostimTrialsInd);
                    rightPerfM=length(corrIndsM)/(length(corrIndsM)+length(incorrIndsM));
                    corrIndsV=intersect(condInds,correctVisualTrialsInd);
                    incorrIndsV=intersect(condInds,incorrectVisualTrialsInd);
                    rightPerfV=length(corrIndsV)/(length(corrIndsV)+length(incorrIndsV));
                    
                    condInds=intersect(LRTBInd2,targetInd1);
                    corrIndsM=intersect(condInds,correctMicrostimTrialsInd);
                    incorrIndsM=intersect(condInds,incorrectMicrostimTrialsInd);
                    topPerfM=length(corrIndsM)/(length(corrIndsM)+length(incorrIndsM));
                    corrIndsV=intersect(condInds,correctVisualTrialsInd);
                    incorrIndsV=intersect(condInds,incorrectVisualTrialsInd);
                    topPerfV=length(corrIndsV)/(length(corrIndsV)+length(incorrIndsV));
                    
                    condInds=intersect(LRTBInd2,targetInd2);
                    corrIndsM=intersect(condInds,correctMicrostimTrialsInd);
                    incorrIndsM=intersect(condInds,incorrectMicrostimTrialsInd);
                    bottomPerfM=length(corrIndsM)/(length(corrIndsM)+length(incorrIndsM));
                    corrIndsV=intersect(condInds,correctVisualTrialsInd);
                    incorrIndsV=intersect(condInds,incorrectVisualTrialsInd);
                    bottomPerfV=length(corrIndsV)/(length(corrIndsV)+length(incorrIndsV));
                    
                    figure;
                    subplot(2,4,1:2);
                    for electrodeCount=1:4
                        electrode=setElectrodes(setInd,electrodeCount);
                        array=setArrays(setInd,electrodeCount);
                        load([dataDir,'\array',num2str(array),'.mat']);
                        electrodeIndtemp1=find(goodArrays8to16(:,8)==electrode);%matching channel number
                        electrodeIndtemp2=find(goodArrays8to16(:,7)==array);%matching array number
                        electrodeInd=intersect(electrodeIndtemp1,electrodeIndtemp2);%channel number
                        RFx=goodArrays8to16(electrodeInd,1);
                        RFy=goodArrays8to16(electrodeInd,2);
                        plot(RFx,RFy,'o','Color',cols(array-7,:),'MarkerFaceColor',cols(array-7,:));hold on
                        currentThreshold=goodCurrentThresholds(electrodeInd);
                        if electrodeCount==1
                            text(RFx-28,RFy,[num2str(electrode),'(',num2str(array),')'],'FontSize',10,'Color','k');
                            text(RFx-28,RFy-7,[num2str(currentThreshold),' uA'],'FontSize',10,'Color','k');
                        else
                            text(RFx+4,RFy,[num2str(electrode),'(',num2str(array),')'],'FontSize',10,'Color','k');
                            text(RFx+4,RFy-7,[num2str(currentThreshold),' uA'],'FontSize',10,'Color','k');
                        end
                    end
                    for electrodePairInd=1:size(electrodePairs,1)
                        electrode1=setElectrodes(setInd,electrodePairs(electrodePairInd,1));
                        array1=setArrays(setInd,electrodePairs(electrodePairInd,1));
                        electrode2=setElectrodes(setInd,electrodePairs(electrodePairInd,2));
                        array2=setArrays(setInd,electrodePairs(electrodePairInd,2));
                        electrodeIndtemp1=find(goodArrays8to16(:,8)==electrode1);%matching channel number
                        electrodeIndtemp2=find(goodArrays8to16(:,7)==array1);%matching array number
                        electrodeInd1=intersect(electrodeIndtemp1,electrodeIndtemp2);%channel number
                        electrodeIndtemp1=find(goodArrays8to16(:,8)==electrode2);%matching channel number
                        electrodeIndtemp2=find(goodArrays8to16(:,7)==array2);%matching array number
                        electrodeInd2=intersect(electrodeIndtemp1,electrodeIndtemp2);%channel number
                        RFx1=goodArrays8to16(electrodeInd1,1);
                        RFy1=goodArrays8to16(electrodeInd1,2);
                        RFx2=goodArrays8to16(electrodeInd2,1);
                        RFy2=goodArrays8to16(electrodeInd2,2);
                        plot([RFx1 RFx2],[RFy1 RFy2],'k--');
                    end
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
                    ylim([-160 20]);
                    title(['RF locations for 2-phosphene task, ',date], 'Interpreter', 'none');
                    for arrayInd=1:length(arrays)
                        text(175,0-10*arrayInd,['array',num2str(arrays(arrayInd))],'FontSize',14,'Color',cols(arrayInd,:));
                    end
                    ax=gca;
                    ax.XTick=[0 Par.PixPerDeg*2 Par.PixPerDeg*4 Par.PixPerDeg*6 Par.PixPerDeg*8];
                    ax.XTickLabel={'0','2','4','6','8'};
                    ax.YTick=[-Par.PixPerDeg*8 -Par.PixPerDeg*6 -Par.PixPerDeg*4 -Par.PixPerDeg*2 0];
                    ax.YTickLabel={'-8','-6','-4','-2','0'};
                    xlabel('x-coordinates (dva)')
                    ylabel('y-coordinates (dva)')
                    
                    %            if numTargets==4
                    subplot(2,4,3:4);
                    %            else
                    %                subplot(2,4,3);
                    %            end
                    b=bar([leftPerfV leftPerfM;rightPerfV rightPerfM;topPerfV topPerfM;bottomPerfV bottomPerfM],'FaceColor','flat');
                    b(1).FaceColor = 'flat';
                    b(2).FaceColor = 'flat';
                    b(1).FaceColor = [0 0.4470 0.7410];
                    b(2).FaceColor = [1 0 0];
                    set(gca, 'XTick',1:4)
                    set(gca, 'XTickLabel', {'slant left' 'slant right' 'vertical' 'horizontal'})
                    xLimits=get(gca,'xlim');
                    if ~isnan(leftPerfV)
                        txt=sprintf('%.2f',leftPerfV);
                        text(0.7,0.95,txt,'Color','b')
                    end
                    if ~isnan(leftPerfM)
                        txt=sprintf('%.2f',leftPerfM);
                        text(1,0.95,txt,'Color','r')
                    end
                    if ~isnan(rightPerfV)
                        txt=sprintf('%.2f',rightPerfV);
                        text(1.7,0.95,txt,'Color','b')
                    end
                    if ~isnan(rightPerfM)
                        txt=sprintf('%.2f',rightPerfM);
                        text(2,0.95,txt,'Color','r')
                    end
                    if ~isnan(topPerfV)
                        txt=sprintf('%.2f',topPerfV);
                        text(2.7,0.95,txt,'Color','b')
                    end
                    if ~isnan(topPerfM)
                        txt=sprintf('%.2f',topPerfM);
                        text(3,0.95,txt,'Color','r')
                    end
                    if ~isnan(bottomPerfV)
                        txt=sprintf('%.2f',bottomPerfV);
                        text(3.7,0.95,txt,'Color','b')
                    end
                    if ~isnan(bottomPerfM)
                        txt=sprintf('%.2f',bottomPerfM);
                        text(4,0.95,txt,'Color','r')
                    end
                    ylim([0 1])
                    hold on
                    plot([xLimits(1) xLimits(2)],[1/numTargets 1/numTargets],'k:');
                    xlim([0 5])
                    title('mean performance, visual (blue) & microstim (red) trials');
                    xlabel('target condition');
                    ylabel('average performance across session');
                    %            pathname=fullfile('D:\data',date,['behavioural_performance_per_condition_',date]);
                    %            set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
                    %            print(pathname,'-dtiff');
                end
                
                %         if ~isempty(perfMicroTrialNo)
                %             firstTrialsM=perfMicroTrialNo(initialPerfTrials-numTrialsPerBin+1);
                %             plot([firstTrialsM firstTrialsM],[0 1],'r:');
                %             [pM hM statsM]=ranksum(perfMicroBin(1:50),0.5)
                %             [hM pM ciM statsM]=ttest(perfMicroBin(1:50),0.5)
                %             formattedpM=num2str(pM);
                %             formattedpM=formattedpM(2:end);
                %             text(xLimits(2)/11,0.14,'p','Color','r','FontAngle','italic');
                %             text(xLimits(2)/10,0.14,['= ',formattedpM],'Color','r');
                %         end
                %         if ~isempty(perfVisualTrialNo)
                %             firstTrialsV=perfVisualTrialNo(initialPerfTrials-numTrialsPerBin+1);
                %             plot([firstTrialsV firstTrialsV],[0 1],'b:');
                %             [pV hV statsV]=ranksum(perfVisualBin(1:50),0.5)
                %             [hV pV ciV statsV]=ttest(perfVisualBin(1:50),0.5)
                %             formattedpV=num2str(pV);
                %             formattedpV=formattedpV(2:end);
                %             text(xLimits(2)/11,0.2,'p','Color','b','FontAngle','italic');
                %             text(xLimits(2)/10,0.2,['= ',formattedpV],'Color','b');
                %         end
            end
        end
    end
    if calculateVisual==0
        figure;
        meanAllSetsPerfMicroBin=mean(allSetsPerfMicroBin,1);
        mean(meanAllSetsPerfMicroBin)%0.80 (after RF correction)
        subplot(2,1,1);
        hold on
        plot(meanAllSetsPerfMicroBin,'r');
        ylim([0 1]);
        xLimits=get(gca,'xlim');
        plot([0 xLimits(2)],[0.5 0.5],'k:');
%         plot([10 10],[0 1],'k:');
        xlabel('trial number');
        ylabel('mean performance');
    end
    if calculateVisual==1
        subplot(2,1,2);
        hold on
        meanAllSetsPerfVisualBin=mean(allSetsPerfVisualBin,1);
        mean(meanAllSetsPerfVisualBin)%0.80 (after RF correction), coincidentally the same value as the microstim version
        plot(meanAllSetsPerfVisualBin,'b');
        ylim([0 1]);
        xLimits=get(gca,'xlim');
        plot([0 xLimits(2)],[0.5 0.5],'k:');
%         plot([10 10],[0 1],'k:');
        xlabel('trial number');
%         xlabel('trial number (from end of session)');
        ylabel('mean performance');
    end
end
% title(['performance across the session, on visual (blue) & microstim (red) trials']);
% pathname=fullfile('D:\data\behavioural_performance_all_sets_121217_',num2str(initialPerfTrials),'trials');
% set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
% print(pathname,'-dtiff');
pathname=fullfile(['D:\data\behavioural_performance_all_sets_corrected_RFs_121217_',num2str(initialPerfTrials),'trials']);
set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
print(pathname,'-dtiff');

% perfMat=['D:\data\behavioural_performance_all_sets_121217_',num2str(initialPerfTrials),'trials.mat'];
% save(perfMat,'meanAllSetsPerfVisualBin','meanAllSetsPerfMicroBin');
perfMat=['D:\data\behavioural_performance_all_sets_corrected_sets_121217_',num2str(initialPerfTrials),'trials.mat'];
save(perfMat,'meanAllSetsPerfVisualBin','meanAllSetsPerfMicroBin');
pause=1;

significantByThisTrialMicro=0;
for trialInd=1:length(meanAllSetsPerfMicroBin)
    x=sum(meanAllSetsPerfMicroBin(1:trialInd))*size(allSetsPerfMicroBin,1);
    %         (0.8+0.5+0.6+0.85)*25
    Y = binopdf(x,size(allSetsPerfMicroBin,1)*trialInd,0.5)
    if Y<0.05
        significantByThisTrialMicro(trialInd)=1;
    end
end
significantByThisTrialMicro%1st trial

significantByThisTrialVisual=0;
for trialInd=1:length(meanAllSetsPerfVisualBin)
    x=sum(meanAllSetsPerfVisualBin(1:trialInd))*size(allSetsPerfVisualBin,1);
    %         (0.8+0.5+0.6+0.85)*25
    Y = binopdf(x,size(allSetsPerfVisualBin,1)*trialInd,0.5)
    if Y<0.05
        significantByThisTrialVisual(trialInd)=1;
    end
end
significantByThisTrialVisual%1st trial
