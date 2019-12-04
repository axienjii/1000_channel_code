function list_motion_5phosphenes_draw_RFs(date)
%11/9/19
%Written by Xing, plots corrected RFs of channels used during a direction-of-motion task with 5 phosphenes (as opposed to 3).

load('D:\data\channel_area_mapping.mat')
figure;
allDatesV=[];
allDatesM=[];
subplotNo=0;
for calculateVisual=[0]
    %bad sets: 3? 4 6 7 8 9 12? 14 15 16 17 18 19 20 21 22 23
    for setNo=[1 2 5 10 11 13]
        subplotNo=subplotNo+1;
        subplot(5,5,subplotNo);
        hold on
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
            allDatesV=[allDatesV;{date}];
        end
        chRFs=[];
        for chInd=1:size(setElectrodes,2)
            electrode=setElectrodes(1,chInd);
            array=setArrays(1,chInd);
            instance=ceil(array/2);
            temp1=find(channelNums(:,instance)==electrode);
            temp2=find(arrayNums(:,instance)==array);
            ind=intersect(temp1,temp2);
            load(['D:\data\best_260617-280617\RFs_instance',num2str(instance),'.mat']);
            chRFs(chInd,:)=channelRFs(ind,1:2);
        end
        plot(chRFs(:,1),chRFs(:,2),'-')
        plot(chRFs(1,1),chRFs(1,2),'o')
        hold on
        title(setNo);
%         for condInd=1:size(setElectrodes,1)
%             chRFs=[];
%             for chInd=1:size(setElectrodes,2)
%                 electrode=setElectrodes(condInd,chInd);
%                 array=setArrays(condInd,chInd);
%                 instance=ceil(array/2);
%                 temp1=find(channelNums(:,instance)==electrode);
%                 temp2=find(arrayNums(:,instance)==array);
%                 ind=intersect(temp1,temp2);
%                 load(['D:\data\best_260617-280617\RFs_instance',num2str(instance),'.mat']);
%                 chRFs(chInd,:)=channelRFs(ind,1:2);
%             end
%             plot(chRFs(:,1),chRFs(:,2),'-')
%             hold on
%         end
    end
end
%bad sets: 3? 4 6 7 8 9 12? 14 15 16 17 18 19 20 21 22 23