function analyse_microstim_letter_moviedata(date)
%3/4/20
%Written by Xing, extracts eye movement data during a
%microstimulation/visual 2-phosphene task, using session 22.

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
setNos=[1:3 5:12];%set 2 data is missing?
allPerfV=[];
allPerfM=[];
allRFsFigure=figure;
setNoSubplot=1;
eyeDataXFinal={};
eyeDataYFinal={};

for calculateVisual=0
    for setNo=28%[22 28]
        perfNEV=[];
        timeInd=[];
        encodeInd=[];
        microstimTrialNEV=[];
        allLRorTB=[];
        allTargetLocation=[];
        corr=[];
        incorr=[];
        localDisk=0;
        if calculateVisual==0
            switch(setNo)
            %microstim task:
                case 1
                    date='170418_B9';%next batch of new electrode combinations
                    setElectrodes=[{[34 14 44 58 34 22 63 20 23 3]} {[39 10 7 16 41 12 42 43 31 23]}];%170418_B & B?
                    setArrays=[{[12 12 14 16 16 16 14 14 12 14]} {[16 16 12 12 12 12 12 12 12 12]}];
                    setInd=44;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=110;
                    visualOnly=0;
                case 2
                    date='170418_B10';
                    setElectrodes=[{[9 46 24 22 62 11 36 40 5 43]} {[37 16 15 1 48 56 57 6 15 7]}];%170418_B & B?
                    setArrays=[{[16 16 16 16 16 8 16 14 12 12]} {[16 16 16 8 14 12 12 12 12 12]}];
                    setInd=44;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=110;
                    visualOnly=0;
                case 3
                    date='180418_B8';
                    setElectrodes=[{[12 6 61 56 55 27 48 30 3 13]} {[40 46 4 44 15 35 6 57 22 30]}];%180418_B & B?
                    setArrays=[{[12 14 16 16 16 16 14 12 14 14]} {[16 16 16 14 12 12 12 12 12 12]}];
                    setInd=45;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=111;
                    visualOnly=0;
                case 4
                    date='180418_B9';
                    setElectrodes=[{[35 16 32 15 30 61 47 58 19 2]} {[39 50 23 22 16 20 24 60 42 14]}];%180418_B & B?
                    setArrays=[{[16 16 16 16 16 16 14 14 12 12]} {[12 16 16 16 14 14 12 12 12 12]}];
                    setInd=45;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=111;
                    visualOnly=0;
                case 5
                    date='200418_B7';
                    setElectrodes=[{[9 45 28 32 48 62 1 16 28 12]} {[6 16 19 45 14 18 11 56 64 29]}];%180418_B & B?
                    setArrays=[{[12 14 16 16 16 16 8 14 12 14]} {[16 16 16 14 12 12 12 12 12 12]}];
                    setInd=46;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=112;
                    visualOnly=0;
                case 6
                    date='200418_B8';
                    setElectrodes=[{[40 6 48 22 43 53 63 13 21 61]} {[16 18 61 23 64 19 22 48 6 10]}];%180418_B & B?
                    setArrays=[{[16 16 16 8 8 16 14 14 12 12]} {[12 12 12 12 14 8 8 16 16 16]}];
                    setInd=46;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=112;
                    visualOnly=0;
                case 7
                    date='230418_B6';
                    setElectrodes=[{[2 5 5 59 45 27 31 29 47 49]} {[38 19 45 14 50 2 44 10 27 28]}];%180418_B & B?
                    setArrays=[{[12 12 14 16 8 8 14 12 13 14]} {[16 16 14 12 12 12 12 12 12 12]}];
                    setInd=47;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=113;
                    visualOnly=0;
                case 8
                    date='230418_B7';
                    setElectrodes=[{[39 38 34 56 52 50 21 54 29 44]} {[17 35 38 60 9 32 64 31 32 13]}];%180418_B & B?
                    setArrays=[{[16 16 16 16 8 8 16 14 14 12]} {[9 16 16 16 8 14 12 12 12 12]}];
                    setInd=47;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=113;
                    visualOnly=0;
                case 9
                    date='250418_B4';
                    setElectrodes=[{[64 13 58 36 15 30 28 64 33 21]} {[35 39 17 33 9 34 1 58 52 26]}];%180418_B & B?
                    setArrays=[{[9 12 14 16 16 16 14 12 13 12]} {[16 12 9 12 12 12 12 12 12 12]}];
                    setInd=48;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=114;
                    visualOnly=0;
                case 10
                    date='250418_B5';
                    setElectrodes=[{[3 44 64 55 9 27 59 12 20 52]} {[59 45 19 7 56 11 31 60 44 19]}];%180418_B & B?
                    setArrays=[{[16 16 16 16 8 8 16 14 12 12]} {[14 14 16 16 16 8 14 12 12 12]}];
                    setInd=48;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=114;
                    visualOnly=0;
                case 11
                    date='300418_B5';
                    setElectrodes=[{[35 40 21 60 22 10 30 63 14 21]} {[23 11 7 6 59 13 19 60 24 63]}];%180418_B & B?
                    setArrays=[{[12 14 16 16 8 8 14 12 13 14]} {[16 16 14 14 14 12 12 12 12 12]}];
                    setInd=49;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=117;
                    visualOnly=0;
                case 12
                    date='300418_B6';
                    setElectrodes=[{[50 4 53 40 57 52 19 64 41 60]} {[48 22 12 13 29 61 25 33 41 34]}];%180418_B & B?
                    setArrays=[{[12 14 16 8 8 8 8 14 13 14]} {[16 16 16 14 14 12 12 13 13 13]}];
                    setInd=50;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=117;
                    visualOnly=0;
                case 13
                    date='010518_B6';
                    setElectrodes=[{[41 16 7 4 44 64 55 61 24 31]} {[7 32 61 28 40 12 20 48 30 64]}];%010518_B & B
                    setArrays=[{[12 12 12 16 16 16 14 14 12 12]} {[16 16 16 16 14 14 14 14 14 14]}];
                    setInd=51;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=118;
                    visualOnly=0;
                case 14
                    date='010518_B7';
                    setElectrodes=[{[4 43 38 53 38 8 14 32 47 56]} {[24 11 51 39 37 29 51 62 21 20]}];%010518_B & B
                    setArrays=[{[10 10 10 13 13 10 10 11 10 10]} {[13 13 13 10 10 10 10 10 10 10]}];
                    setInd=52;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=118;
                    visualOnly=0;
                case 15
                    date='020518_B6';
                    setElectrodes=[{[33 17 7 50 6 63 12 24 54 56]} {[64 36 55 3 5 4 59 37 14 47]}];%010518_B & B
                    setArrays=[{[12 9 14 16 16 16 16 14 14 12]} {[16 16 14 14 12 12 12 12 13 13]}];
                    setInd=53;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=119;
                    visualOnly=0;
                case 16
                    date='020518_B7';
                    setElectrodes=[{[17 30 40 27 46 20 48 51 34 45]} {[32 31 46 20 38 46 64 61 14 23]}];%010518_B & B
                    setArrays=[{[10 10 10 13 13 13 10 10 11 10]} {[13 13 13 13 10 10 10 10 10 10]}];
                    setInd=54;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=119;
                    visualOnly=0;
                case 17
                    date='030518_B9';
                    setElectrodes=[{[48 15 39 43 31 20 15 29 22 27]} {[60 56 21 20 63 54 21 16 31 32]}];%010518_B & B
                    setArrays=[{[9 12 14 16 16 16 14 14 12 12]} {[16 16 16 16 14 14 14 14 14 14]}];
                    setInd=55;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=120;
                    visualOnly=0;
                case 18
                    date='030518_B17';
                    setElectrodes=[{[9 58 4 28 49 32 31 51 6 21]} {[43 10 49 43 31 34 9 42 45 32]}];%010518_B & B
                    setArrays=[{[10 13 15 15 15 13 13 13 11 10]} {[8 8 14 13 10 10 10 10 10 10]}];
                    setInd=56;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=120;
                    visualOnly=0;
                case 19
                    date='070518_B5';
                    setElectrodes=[{[1 31 26 32 48 5 48 18 46 58]} {[22 1 60 20 56 1 60 17 25 34]}];%010518_B & B
                    setArrays=[{[10 10 12 14 15 15 13 13 10 10]} {[8 8 14 12 9 10 10 10 10 11]}];
                    setInd=57;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=122;
                    visualOnly=0;
                case 20
                    date='070518_B6';
                    setElectrodes=[{[56 10 37 9 50 8 29 30 39 29]} {[57 45 62 59 28 21 44 58 27 53]}];%010518_B & B
                    setArrays=[{[9 12 12 8 8 15 15 13 10 10]} {[8 8 16 16 14 12 13 13 13 13]}];
                    setInd=58;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=122;
                    visualOnly=0;
                case 21
                    date='080518_B6';
                    setElectrodes=[{[27 19 20 46 11 44 34 5 42 25]} {[7 28 30 10 40 43 56 15 3 21]}];%010518_B & B
                    setArrays=[{[9 12 12 14 8 8 13 10 10 12]} {[15 15 13 13 10 10 10 10 11 11]}];
                    setInd=59;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=123;
                    visualOnly=0;
                case 22
                    date='080518_B7';
                    setElectrodes=[{[26 5 32 62 43 46 62 26 44 44]} {[41 62 4 48 26 47 6 22 24 61]}];%010518_B & B
                    setArrays=[{[9 9 12 14 8 15 13 13 10 13]} {[15 15 15 13 13 10 11 10 10 11]}];
                    setInd=60;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=123;
                    visualOnly=0;
                case 23
                    date='090518_B5';
                    setElectrodes=[{[60 34 50 37 4 1 16 15 51 52]} {[15 37 29 62 18 5 48 16 18 60]}];%010518_B & B
                    setArrays=[{[10 10 13 15 15 15 11 10 11 13]} {[15 15 15 13 13 10 10 10 11 11]}];
                    setInd=61;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=124;
                    visualOnly=0;
                case 24
                    date='090518_B6';
                    setElectrodes=[{[28 49 62 63 7 8 61 20 35 55]} {[63 5 56 35 36 55 55 48 22 62]}];%010518_B & B
                    setArrays=[{[10 13 15 15 15 11 10 10 13 13]} {[15 15 13 13 13 10 11 11 11 11]}];
                    setInd=62;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=124;
                    visualOnly=0;
                case 25
                    date='290518_B7';%15 electrodes per letter
                    setElectrodes=[{[4 36 27 46 4 31 64 30 26 31 26 1 34 9 42]} {[61 28 40 58 5 2 56 34 9 42 40 10 30 4 28]}];%280518_B & B?
                    setArrays=[{[16 16 8 15 15 14 12 12 12 10 9 10 10 10 10]} {[16 16 14 14 12 12 9 10 10 10 10 13 13 15 15]}];
                    setInd=69;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=127;
                    visualOnly=0;
%                 case 25
%                     date='300518_B1';
%                     setElectrodes=[{[4 36 27 46 4 31 64 30 26 31 26 1 34 9 42]} {[61 28 40 58 5 2 56 34 9 42 40 10 30 4 28]}];%280518_B & B?
%                     setArrays=[{[16 16 8 15 15 14 12 12 12 10 9 10 10 10 10]} {[16 16 14 14 12 12 9 10 10 10 10 13 13 15 15]}];
%                     setInd=69;
%                     numTargets=2;
%                     electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
%                     currentThresholdChs=127;
%                     visualOnly=0;
                case 26
                    date='040618_B10';
                    setElectrodes=[{[56 61 29 13 27 27 29 4 32 20 46 36 17 9 34]} {[1 56 36 4 36 21 30 33 42 4 43 10 30 4 28]}];%280518_B & B?
                    setArrays=[{[9 12 14 14 16 8 15 15 13 13 10 10 10 10 10]} {[10 9 12 14 16 14 12 13 10 10 10 13 13 15 15]}];
                    setInd=69;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=128;
                    visualOnly=0;
%                 case 26
%                     date='140618_B4';
%                     setElectrodes=[{[56 61 29 13 27 27 29 4 32 20 46 36 17 9 34]} {[1 56 36 4 36 21 30 33 42 4 43 10 30 4 28]}];%280518_B & B?
%                     setArrays=[{[9 12 14 14 16 8 15 15 13 13 10 10 10 10 10]} {[10 9 12 14 16 14 12 13 10 10 10 13 13 15 15]}];
%                     setInd=69;
%                     numTargets=2;
%                     electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
%                     currentThresholdChs=129;
%                     visualOnly=0;
                case 27
                    date='140618_B5';
                    setElectrodes=[{[17 46 32 55 11 19 32 63 33 31 27 28 48 33 8]} {[1 48 9 8 17 9 45 44 31 34 9 41 29 32 27]}];%280518_B & B?
                    setArrays=[{[12 16 16 16 8 8 14 12 13 10 9 9 9 12 12]} {[9 9 12 12 12 16 14 12 10 10 10 13 12 14 8]}];
                    setInd=70;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=129;
                    visualOnly=0;
                case 28
                    date='140618_B7';
                    setElectrodes=[{[40 6 56 52 50 48 30 1 28 23 50 3 52 28 47]} {[6 16 19 7 6 15 42 60 52 25 33 47 46 8 48]}];%280518_B & B?
                    setArrays=[{[16 16 16 8 8 15 16 8 14 12 12 12 12 12 13]} {[16 16 16 14 14 12 12 12 12 12 13 13 15 15 15]}];
                    setInd=70;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=129;
                    visualOnly=0;
                case 29%setInd 71
                    date='180618_B7';
                    setElectrodes=[{[48 22 44 15 63 19 30 63 4 61 37 14 41 58 30]} {[48 15 36 53 4 29 20 10 37 28 41 5 37 55 15]}];%280518_B & B?
                    setArrays=[{[16 8 8 15 15 8 14 12 12 12 12 13 13 13 13]} {[16 16 16 14 14 14 12 12 12 12 13 15 15 15 15]}];
                    setInd=71;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=130;
                    visualOnly=0;
            end
        elseif calculateVisual==1
            localDisk=0;
            switch(setNo)
                %visual task only:
                case 1
                    date='170418_B8';%next batch of new electrode combinations
                    setElectrodes=[{[34 14 44 58 34 22 63 20 23 3]} {[39 10 7 16 41 12 42 43 31 23]}];%170418_B & B?
                    setArrays=[{[12 12 14 16 16 16 14 14 12 14]} {[16 16 12 12 12 12 12 12 12 12]}];
                    setInd=44;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=110;
                    visualOnly=1;
                case 2
                    date='170418_B7';
                    setElectrodes=[{[9 46 24 22 62 11 36 40 5 43]} {[37 16 15 1 48 56 57 6 15 7]}];%170418_B & B?
                    setArrays=[{[16 16 16 16 16 8 16 14 12 12]} {[16 16 16 8 14 12 12 12 12 12]}];
                    setInd=44;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=110;
                    visualOnly=1;
                case 3
                    date='180418_B6';
                    setElectrodes=[{[12 6 61 56 55 27 48 30 3 13]} {[40 46 4 44 15 35 6 57 22 30]}];%180418_B & B?
                    setArrays=[{[12 14 16 16 16 16 14 12 14 14]} {[16 16 16 14 12 12 12 12 12 12]}];
                    setInd=45;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=111;
                    visualOnly=1;
                case 4
                    date='180418_B4';
                    setElectrodes=[{[35 16 32 15 30 61 47 58 19 2]} {[39 50 23 22 16 20 24 60 42 14]}];%180418_B & B?
                    setArrays=[{[16 16 16 16 16 16 14 14 12 12]} {[12 16 16 16 14 14 12 12 12 12]}];
                    setInd=45;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=111;
                    visualOnly=1;
                case 5
                    date='200418_B6';
                    setElectrodes=[{[9 45 28 32 48 62 1 16 28 12]} {[6 16 19 45 14 18 11 56 64 29]}];%180418_B & B?
                    setArrays=[{[12 14 16 16 16 16 8 14 12 14]} {[16 16 16 14 12 12 12 12 12 12]}];
                    setInd=46;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=112;
                    visualOnly=1;
                case 6
                    date='200418_B5';
                    setElectrodes=[{[40 6 48 22 43 53 63 13 21 61]} {[16 18 61 23 64 19 22 48 6 10]}];%180418_B & B?
                    setArrays=[{[16 16 16 8 8 16 14 14 12 12]} {[12 12 12 12 14 8 8 16 16 16]}];
                    setInd=46;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=112;
                    visualOnly=1;
                case 7
                    date='230418_B5';
                    setElectrodes=[{[2 5 5 59 45 27 31 29 47 49]} {[38 19 45 14 50 2 44 10 27 28]}];%180418_B & B?
                    setArrays=[{[12 12 14 16 8 8 14 12 13 14]} {[16 16 14 12 12 12 12 12 12 12]}];
                    setInd=47;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=113;
                    visualOnly=1;
                case 8
                    date='230418_B4';
                    setElectrodes=[{[39 38 34 56 52 50 21 54 29 44]} {[17 35 38 60 9 32 64 31 32 13]}];%180418_B & B?
                    setArrays=[{[16 16 16 16 8 8 16 14 14 12]} {[9 16 16 16 8 14 12 12 12 12]}];
                    setInd=47;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=113;
                    visualOnly=1;
                case 9
                    date='240418_B6';
                    setElectrodes=[{[64 13 58 36 15 30 28 64 33 21]} {[35 39 17 33 9 34 1 58 52 26]}];%180418_B & B?
                    setArrays=[{[9 12 14 16 16 16 14 12 13 12]} {[16 12 9 12 12 12 12 12 12 12]}];
                    setInd=48;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=114;
                    visualOnly=1;
                case 10
                    date='240418_B4';
                    setElectrodes=[{[3 44 64 55 9 27 59 12 20 52]} {[59 45 19 7 56 11 31 60 44 19]}];%180418_B & B?
                    setArrays=[{[16 16 16 16 8 8 16 14 12 12]} {[14 14 16 16 16 8 14 12 12 12]}];
                    setInd=48;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=114;
                    visualOnly=1;
                case 11
                    date='250418_B8';
                    setElectrodes=[{[35 40 21 60 22 10 30 63 14 21]} {[23 11 7 6 59 13 19 60 24 63]}];%180418_B & B?
                    setArrays=[{[12 14 16 16 8 8 14 12 13 14]} {[16 16 14 14 14 12 12 12 12 12]}];
                    setInd=49;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=117;
                    visualOnly=1;
                case 12
                    date='260418_B5';
                    setElectrodes=[{[50 4 53 40 57 52 19 64 41 60]} {[48 22 12 13 29 61 25 33 41 34]}];%180418_B & B?
                    setArrays=[{[12 14 16 8 8 8 8 14 13 14]} {[16 16 16 14 14 12 12 13 13 13]}];
                    setInd=50;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=117;
                    visualOnly=1;
                case 13
                    date='010518_B2';
                    setElectrodes=[{[41 16 7 4 44 64 55 61 24 31]} {[7 32 61 28 40 12 20 48 30 64]}];%010518_B & B
                    setArrays=[{[12 12 12 16 16 16 14 14 12 12]} {[16 16 16 16 14 14 14 14 14 14]}];
                    setInd=51;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=118;
                    visualOnly=1;
                case 14
                    date='010518_B4';
                    setElectrodes=[{[4 43 38 53 38 8 14 32 47 56]} {[24 11 51 39 37 29 51 62 21 20]}];%010518_B & B
                    setArrays=[{[10 10 10 13 13 10 10 11 10 10]} {[13 13 13 10 10 10 10 10 10 10]}];
                    setInd=52;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=118;
                    visualOnly=1;
                case 15
                    date='020518_B4';
                    setElectrodes=[{[33 17 7 50 6 63 12 24 54 56]} {[64 36 55 3 5 4 59 37 14 47]}];%010518_B & B
                    setArrays=[{[12 9 14 16 16 16 16 14 14 12]} {[16 16 14 14 12 12 12 12 13 13]}];
                    setInd=53;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=119;
                    visualOnly=1;
                case 16
                    date='020518_B3';
                    setElectrodes=[{[17 30 40 27 46 20 48 51 34 45]} {[32 31 46 20 38 46 64 61 14 23]}];%010518_B & B
                    setArrays=[{[10 10 10 13 13 13 10 10 11 10]} {[13 13 13 13 10 10 10 10 10 10]}];
                    setInd=54;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=119;
                    visualOnly=1;
                case 17
                    date='030518_B8';
                    setElectrodes=[{[48 15 39 43 31 20 15 29 22 27]} {[60 56 21 20 63 54 21 16 31 32]}];%010518_B & B
                    setArrays=[{[9 12 14 16 16 16 14 14 12 12]} {[16 16 16 16 14 14 14 14 14 14]}];
                    setInd=55;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=120;
                    visualOnly=1;
                case 18
                    date='030518_B7';
                    setElectrodes=[{[9 58 4 28 49 32 31 51 6 21]} {[43 10 49 43 31 34 9 42 45 32]}];%010518_B & B
                    setArrays=[{[10 13 15 15 15 13 13 13 11 10]} {[8 8 14 13 10 10 10 10 10 10]}];
                    setInd=56;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=120;
                    visualOnly=1;
                case 19
                    date='040518_B2';
                    setElectrodes=[{[1 31 26 32 48 5 48 18 46 58]} {[22 1 60 20 56 1 60 17 25 34]}];%010518_B & B
                    setArrays=[{[10 10 12 14 15 15 13 13 10 10]} {[8 8 14 12 9 10 10 10 10 11]}];
                    setInd=57;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=122;
                    visualOnly=1;
                case 20
                    date='070518_B2';
                    setElectrodes=[{[56 10 37 9 50 8 29 30 39 29]} {[57 45 62 59 28 21 44 58 27 53]}];%010518_B & B
                    setArrays=[{[9 12 12 8 8 15 15 13 10 10]} {[8 8 16 16 14 12 13 13 13 13]}];
                    setInd=58;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=122;
                    visualOnly=1;
                case 21
                    date='080518_B3';
                    setElectrodes=[{[27 19 20 46 11 44 34 5 42 25]} {[7 28 30 10 40 43 56 15 3 21]}];%010518_B & B
                    setArrays=[{[9 12 12 14 8 8 13 10 10 12]} {[15 15 13 13 10 10 10 10 11 11]}];
                    setInd=59;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=123;
                    visualOnly=1;
                case 22
                    date='080518_B4';
                    setElectrodes=[{[26 5 32 62 43 46 62 26 44 44]} {[41 62 4 48 26 47 6 22 24 61]}];%010518_B & B
                    setArrays=[{[9 9 12 14 8 15 13 13 10 13]} {[15 15 15 13 13 10 11 10 10 11]}];
                    setInd=60;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=123;
                    visualOnly=1;
                case 23
                    date='090518_B2';
                    setElectrodes=[{[60 34 50 37 4 1 16 15 51 52]} {[15 37 29 62 18 5 48 16 18 60]}];%010518_B & B
                    setArrays=[{[10 10 13 15 15 15 11 10 11 13]} {[15 15 15 13 13 10 10 10 11 11]}];
                    setInd=61;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=124;
                    visualOnly=1;
                case 24
                    date='090518_B4';
                    setElectrodes=[{[28 49 62 63 7 8 61 20 35 55]} {[63 5 56 35 36 55 55 48 22 62]}];%010518_B & B
                    setArrays=[{[10 13 15 15 15 11 10 10 13 13]} {[15 15 13 13 13 10 11 11 11 11]}];
                    setInd=62;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=124;
                    visualOnly=1;
                case 25
                    date='290518_B5';%15 electrodes per letter, coloured dots
                    setElectrodes=[{[4 36 27 46 4 31 64 30 26 31 26 1 34 9 42]} {[61 28 40 58 5 2 56 34 9 42 40 10 30 4 28]}];%280518_B & B?
                    setArrays=[{[16 16 8 15 15 14 12 12 12 10 9 10 10 10 10]} {[16 16 14 14 12 12 9 10 10 10 10 13 13 15 15]}];
                    setInd=69;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=127;
                    visualOnly=1;
                    %         case 26
                    %                     date='040618_B6';%coloured dots
                    %             setElectrodes=[{[56 61 29 13 27 27 29 4 32 20 46 36 17 9 34]} {[1 56 36 4 36 21 30 33 42 4 43 10 30 4 28]}];%280518_B & B?
                    %             setArrays=[{[9 12 14 14 16 8 15 15 13 13 10 10 10 10 10]} {[10 9 12 14 16 14 12 13 10 10 10 13 13 15 15]}];
                    %             setInd=69;
                    %             numTargets=2;
                    %             electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    %             currentThresholdChs=127;
                    %             visualOnly=1;
                case 26
                    date='040618_B7';%black dots
                    setElectrodes=[{[56 61 29 13 27 27 29 4 32 20 46 36 17 9 34]} {[1 56 36 4 36 21 30 33 42 4 43 10 30 4 28]}];%280518_B & B?
                    setArrays=[{[9 12 14 14 16 8 15 15 13 13 10 10 10 10 10]} {[10 9 12 14 16 14 12 13 10 10 10 13 13 15 15]}];
                    setInd=69;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=127;
                    visualOnly=1;
                    %                 case 27
                    %                     date='070618_B4';%coloured dots
                    %             setElectrodes=[{[40 6 56 52 50 48 30 1 28 23 50 3 52 28 47]} {[6 16 19 7 6 15 42 60 52 25 33 47 46 8 48]}];%280518_B & B?
                    %             setArrays=[{[16 16 16 8 8 15 16 8 14 12 12 12 12 12 13]} {[16 16 16 14 14 12 12 12 12 12 13 13 15 15 15]}];
                    %             setInd=70;
                    %             numTargets=2;
                    %             electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    %             currentThresholdChs=128;
                    %             visualOnly=1;
                case 27
                    date='070618_B7';%black dots
                    setElectrodes=[{[40 6 56 52 50 48 30 1 28 23 50 3 52 28 47]} {[6 16 19 7 6 15 42 60 52 25 33 47 46 8 48]}];%280518_B & B?
                    setArrays=[{[16 16 16 8 8 15 16 8 14 12 12 12 12 12 13]} {[16 16 16 14 14 12 12 12 12 12 13 13 15 15 15]}];
                    setInd=70;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=128;
                    visualOnly=1;
                    %         case 28
                    %                     date='070618_B5';%coloured dots
                    %             setElectrodes=[{[17 46 32 55 11 19 32 63 33 31 27 28 48 33 8]} {[1 48 9 8 17 9 45 44 31 34 9 41 29 32 27]}];%280518_B & B?
                    %             setArrays=[{[12 16 16 16 8 8 14 12 13 10 9 9 9 12 12]} {[9 9 12 12 12 16 14 12 10 10 10 13 12 14 8]}];
                    %             setInd=70;
                    %             numTargets=2;
                    %             electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    %             currentThresholdChs=128;
                    %             visualOnly=1;
                case 28
                    date='070618_B6';%black dots
                    setElectrodes=[{[17 46 32 55 11 19 32 63 33 31 27 28 48 33 8]} {[1 48 9 8 17 9 45 44 31 34 9 41 29 32 27]}];%280518_B & B?
                    setArrays=[{[12 16 16 16 8 8 14 12 13 10 9 9 9 12 12]} {[9 9 12 12 12 16 14 12 10 10 10 13 12 14 8]}];
                    setInd=70;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=128;
                    visualOnly=1;
%                 case 29%setInd 71
%                     date='180618_B3';%coloured dots
%                     setElectrodes=[{[48 22 44 15 63 19 30 63 4 61 37 14 41 58 30]} {[48 15 36 53 4 29 20 10 37 28 41 5 37 55 15]}];%280518_B & B?
%                     setArrays=[{[16 8 8 15 15 8 14 12 12 12 12 13 13 13 13]} {[16 16 16 14 14 14 12 12 12 12 13 15 15 15 15]}];
%                     setInd=71;
%                     numTargets=2;
%                     electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
%                     currentThresholdChs=130;
%                     visualOnly=1;
                case 29
                    date='180618_B5';%black dots
                    setElectrodes=[{[48 22 44 15 63 19 30 63 4 61 37 14 41 58 30]} {[48 15 36 53 4 29 20 10 37 28 41 5 37 55 15]}];%280518_B & B?
                    setArrays=[{[16 8 8 15 15 8 14 12 12 12 12 13 13 13 13]} {[16 16 16 14 14 14 12 12 12 12 13 15 15 15 15]}];
                    setInd=71;
                    numTargets=2;
                    electrodePairs=[1:length(setElectrodes{1});1:length(setElectrodes{2})];
                    currentThresholdChs=130;
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