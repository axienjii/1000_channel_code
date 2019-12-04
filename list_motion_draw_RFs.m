function list_motion_draw_RFs(date)
%11/9/19
%Written by Xing, plots corrected RFs of channels used during a direction-of-motion task.

load('D:\data\channel_area_mapping.mat')
figure;
allDatesV=[];
allDatesM=[];
subplotNo=0;
for calculateVisual=[0]
    for setNo=[1 3:6 8 10:12 14:17]%[1 3:12 14:17]
        subplotNo=subplotNo+1;
        subplot(5,5,subplotNo);
        hold on
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
%bad sets: 7 9