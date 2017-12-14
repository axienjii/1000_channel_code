function analyse_microstim_responses4
%Written by Xing 05/12/17 to calculate hits, misses, false alarms, and
%correct rejections during new version of microstim task.
%Load in .mat file recorded on stimulus
%presentation computer, from server. Edit further to ensure unique
%electrode identities.

close all
localDisk=1;
if localDisk==1
    rootdir='D:\data\';
elseif localDisk==0
    rootdir='X:\best\';
end

% arrayNums=[8 10 10 10 10 10 10 10 10 10 10 11 11 11 12 12 12 12 12 12 12 12 12 13 13 13 13 13 13 13 13 14 14 14 15 16 16];
% electrodeNums=[40 40 35 46 57 55 58 37 62 59 20 55 24 18 61 40 50 28 10 34 29 41 20 35 48 47 53 55 38 56 32 43 12 30 49 21 39];
% date='051217_T4';
% date='051217_B2';
% date='051217_B3';
% arrayNums=arrayNums(6:end);
% electrodeNums=electrodeNums(6:end);
% date='051217_B4';
% arrayNums=arrayNums(1:5);
% electrodeNums=electrodeNums(1:5);
% date='051217_B5';
% arrayNums=[10 13];
% electrodeNums=[20 48];
% date='051217_B6';
% arrayNums=[13];
% electrodeNums=[53];
% date='051217_B11';
% arrayNums=[14];
% electrodeNums=[13];
% date='061217_B1';
% arrayNums=[9 9];
% electrodeNums=[17 19];
% date='061217_B3';
% arrayNums=[10 10 10 10 10 10 10 10 10 10 11 11 11 12 12 12 12 12 12 12 12 12 13 13 13 13 13 13 13 13 14 14 14 15 16 16];
% electrodeNums=[40 35 46 57 55 58 37 62 59 20 55 24 18 61 40 50 28 10 34 29 41 20 35 48 47 53 55 38 56 32 43 12 30 49 21 39];
% arrayNums=arrayNums(1:21);
% electrodeNums=electrodeNums(1:21);
% date='061217_B4';
% arrayNums=[10 10 10 10 10 10 10 10 10 10 11 11 11 12 12 12 12 12 12 12 12 12 13 13 13 13 13 13 13 13 14 14 14 15 16 16];
% electrodeNums=[40 35 46 57 55 58 37 62 59 20 55 24 18 61 40 50 28 10 34 29 41 20 35 48 47 53 55 38 56 32 43 12 30 49 21 39];
% arrayNums=arrayNums(22:end);
% electrodeNums=electrodeNums(22:end);
% date='061217_B5';
% arrayNums=[9];
% electrodeNums=[44];
% date='061217_B6';
% arrayNums=[10 11 12 12];
% electrodeNums=[59 18 40 34];
% date='061217_B7';
% arrayNums=49;
% electrodeNums=15;
% date='071217_B1';
% arrayNums=[8 8 9 9 9 12 12 12 12 12 12 12 12 13 13 13 14 14 14 14 15 15 15 16 16 16 16 16 16 16 16 16];
% electrodeNums=[43 19 27 44 26 35 12 2 57 41 22 30 29 47 61 53 39 58 43 29 48 55 46 38 47 40 50 64 61 15 12 7];
% arrayNums=arrayNums(1:10);
% electrodeNums=electrodeNums(1:10);
% date='071217_B2';
% arrayNums=[8 8 9 9 9 12 12 12 12 12 12 12 12 13 13 13 14 14 14 14 15 15 15 16 16 16 16 16 16 16 16 16];
% electrodeNums=[43 19 27 44 26 35 12 2 57 41 22 30 29 47 61 53 39 58 43 29 48 55 46 38 47 40 50 64 61 15 12 7];
% arrayNums=arrayNums(11:end);
% electrodeNums=electrodeNums(11:end);
% date='071217_B3';
% arrayNums=[8 8 9 9 9 12 12 12 12 12 12 12 12 13 13 13 14 14 14 14 15 15 15 16 16 16 16 16 16 16 16 16];
% electrodeNums=[43 19 27 44 26 35 12 2 57 41 22 30 29 47 61 53 39 58 43 29 48 55 46 38 47 40 50 64 61 15 12 7];
% arrayNums=arrayNums(1:10);
% electrodeNums=electrodeNums(1:10);
% date='071217_B4';
% arrayNums=[8 8 9 9 9 12 12 12 12 12 12 12 12 13 13 13 14 14 14 14 15 15 15 16 16 16 16 16 16 16 16 16];
% electrodeNums=[43 19 27 44 26 35 12 2 57 41 22 30 29 47 61 53 39 58 43 29 48 55 46 38 47 40 50 64 61 15 12 7];
% arrayNums=arrayNums(11:20);
% electrodeNums=electrodeNums(11:20);
% date='071217_B5';
% arrayNums=[8 8 9 9 9 12 12 12 12 12 12 12 12 13 13 13 14 8 14 14 15 15 15 16 16 16 16 16 16 16 16 16];
% electrodeNums=[43 19 27 44 26 35 12 2 57 41 22 30 29 47 61 53 39 58 43 29 48 55 46 38 47 40 50 64 61 15 12 7];
% arrayNums=arrayNums(18:end);
% electrodeNums=electrodeNums(18:end);
% date='071217_B6';
% arrayNums=[8 8 9 9 9 12 12 12 12 12 12 12 12 13 13 13 14 14 14 14 15 15 15 16 16 16 16 16 16 16 16 16];
% electrodeNums=[43 19 27 44 26 35 12 2 57 41 22 30 29 47 61 53 39 58 43 29 48 55 46 38 47 40 50 64 61 15 12 7];
% arrayNums=arrayNums(19:end);
% electrodeNums=electrodeNums(19:end);
% date='071217_B7';
% arrayNums=[8 8 9 9 9 12 12 12 12 12 12 12 12 13 13 13 14 14 14 14 15 15 15 16 16 16 16 16 16 16 16 16];
% electrodeNums=[43 19 27 44 26 35 12 2 57 41 22 30 29 47 61 53 39 58 13 29 48 55 46 38 47 40 50 64 61 15 12 7];
% arrayNums=arrayNums(19:end);
% electrodeNums=electrodeNums(19:end);
% date='071217_B8';
% arrayNums=[9 9 12];
% electrodeNums=[27 26 41];
% date='071217_B10';
% electrodeNums=[30 13 61 53 39 55 46 40 64 61 12];
% arrayNums=[12 14 13 13 14 15 15 16 16 16 16];
% date='071217_B12';
% electrodeNums=[30 58 55 46 40];
% arrayNums=[12 14 15 15 16];
% date='071217_B13';
% electrodeNums=58;
% arrayNums=14;
% date='071217_B14';
% electrodeNums=55;
% arrayNums=15;
% date='081217_B1';
% electrodeNums=[35 39 33];
% arrayNums=[16 12 12];
% date='081217_B3';
% electrodeNums=[35 39 33 64 9 45 30 16 23 37 22 27 43 21 61 45 44 50 15 7 41 49 51 55 22 52 28 34 35 55];
% arrayNums=[16 12 12 9 9 8 16 14 12 12 16 16 14 12 12 8 8 8 15 15 13 13 13 11 11 12 12 13 13 13];%electrodes 37 and 38 (indices 12 & 13, respectively) on array 13
% arrayNums=arrayNums(6:12);
% electrodeNums=electrodeNums(6:12);
% date='081217_B4';
% electrodeNums=[35 39 33 64 9 45 30 16 23 37 22 27 43 21 61 45 44 50 15 7 41 49 51 55 22 52 28 34 35 55];
% arrayNums=[16 12 12 9 9 8 16 14 12 12 16 16 14 12 12 8 8 8 15 15 13 13 13 11 11 12 12 13 13 13];%electrodes 37 and 38 (indices 12 & 13, respectively) on array 13
% arrayNums=arrayNums(21:end);
% electrodeNums=electrodeNums(21:end);
% date='081217_B5';
% electrodeNums=[35 39 33 64 9 45 30 16 23 37 22 27 43 21 61 45 44 50 15 7 41 49 51 55 22 52 28 34 35 55];
% arrayNums=[16 12 12 9 9 8 16 14 12 12 16 16 14 12 12 8 8 8 15 15 13 13 13 11 11 12 12 13 13 13];%electrodes 37 and 38 (indices 12 & 13, respectively) on array 13
% arrayNums=arrayNums(22:end);
% electrodeNums=electrodeNums(22:end);
% date='081217_B6';
% electrodeNums=[41 64 9];
% arrayNums=[13 9 9];
% date='081217_B7';
% electrodeNums=15;
% arrayNums=15;
% date='121217_B1';
% electrodeNums=[35 39 33 64 9 22 27 13 21 61 45 44 50 15 7 41 49 51 55 22];
% arrayNums=[16 12 12 9 9 16 16 14 12 12 8 8 8 15 15 13 13 13 11 11];
% date='121217_B2';
% electrodeNums=[50 22 55 21 39 41 49 27 44];
% arrayNums=[8 11 11 12 12 13 13 16 8];
% date='121217_B3';
% electrodeNums=33;
% arrayNums=13;
% date='131217_B3';
% electrodeNums=[45 30 16];
% arrayNums=[8 16 14];
% date='131217_B5';
% electrodeNums=[23 37 22 27 13 21 61 38 47 39 35 27 52 28];
% arrayNums=[12 12 16 16 14 12 12 16 16 14 12 9 12 12];
% date='131217_B6';
% electrodeNums=[45 30 16 23 37 22 27 13 21 61 38 47 39 35 27 52 28 34 35 55 2 57 47 61 53 40 7 43 48 55];
% arrayNums=[8 16 14 12 12 16 16 14 12 12 16 16 14 12 9 12 12 13 13 13 12 12 13 13 13 16 16 8 15 15];
% electrodeNums=electrodeNums(18:end);
% arrayNums=arrayNums(18:end);
% date='131217_B8';
% electrodeNums=[48 55 16];
% arrayNums=[15 15 14];
date='131217_B9';
electrodeNums=[23 27 34];
arrayNums=[12 16 13];

finalCurrentValsFile=7;

copyfile(['Y:\Xing\',date(1:6),'_data'],[rootdir,date,'\',date,'_data']);
load([rootdir,date,'\',date,'_data\microstim_saccade_',date,'.mat'])
microstimAllHitTrials=intersect(find(allCurrentLevel>0),find(performance==1));
microstimAllMissTrials=intersect(find(allCurrentLevel>0),find(performance==-1));
catchAllCRTrials=intersect(find(allCurrentLevel==0),find(performance==1));%correct rejections
catchAllFATrials=find(allFalseAlarms==1);%false alarms
currentAmpTrials=find(allCurrentLevel==0);
correctRejections=length(intersect(catchAllCRTrials,currentAmpTrials));
falseAlarms=length(intersect(catchAllFATrials,currentAmpTrials));
allElectrodeNums=cell2mat(allElectrodeNum);
allArrayNums=cell2mat(allArrayNum);
for uniqueElectrode=1:length(electrodeNums)
    array=arrayNums(uniqueElectrode);
    electrode=electrodeNums(uniqueElectrode);
    temp1=find(allElectrodeNums==electrode);
    temp2=find(allArrayNums==array);
    uniqueElectrodeTrials=intersect(temp1,temp2);
    if finalCurrentValsFile==2%staircase procedure was used, finalCurrentVals3.mat
        load([rootdir,date,'\',date,'_data\finalCurrentVals3.mat'])
    elseif finalCurrentValsFile==3%staircase procedure was used, finalCurrentVals4.mat
        load([rootdir,date,'\',date,'_data\finalCurrentVals4.mat'])
    elseif finalCurrentValsFile==4%staircase procedure was used, finalCurrentVals4.mat
        load([rootdir,date,'\',date,'_data\finalCurrentVals5.mat'])
    elseif finalCurrentValsFile==5%staircase procedure was used, finalCurrentVals4.mat
        load([rootdir,date,'\',date,'_data\finalCurrentVals6.mat'])
    elseif finalCurrentValsFile==6%staircase procedure was used, finalCurrentVals4.mat
        load([rootdir,date,'\',date,'_data\finalCurrentVals7.mat'])
    elseif finalCurrentValsFile==7%staircase procedure was used, finalCurrentVals4.mat
        load([rootdir,date,'\',date,'_data\finalCurrentVals8.mat'])
    end
    currentAmplitudes=[];
    hits=[];
    misses=[];    
    currentAmpTrials=allCurrentLevel(uniqueElectrodeTrials);
    uniqueCurrentAmp=unique(currentAmpTrials);
    for currentAmpCond=1:length(uniqueCurrentAmp)
        currentAmplitude=uniqueCurrentAmp(currentAmpCond);
        currentAmpTrials=find(allCurrentLevel==currentAmplitude);
        if ~isempty(currentAmpTrials)
            temp3=intersect(microstimAllHitTrials,currentAmpTrials);
            temp4=intersect(temp3,uniqueElectrodeTrials);
            hits=[hits length(temp4)];
            temp5=intersect(microstimAllMissTrials,currentAmpTrials);
            temp6=intersect(temp5,uniqueElectrodeTrials);
            misses=[misses length(temp6)];
            currentAmplitudes=[currentAmplitudes currentAmplitude];
        end
    end
    hits./misses;
    for Weibull=0:1% set to 1 to get the Weibull fit, 0 for a sigmoid fit
        [theta threshold]=analyse_current_thresholds_Plot_Psy_Fie(currentAmplitudes,hits,misses,falseAlarms,correctRejections,Weibull);
        hold on
        yLimits=get(gca,'ylim');
        plot([threshold threshold],yLimits,'r:')
        plot([theta theta],yLimits,'k:')
        %     text(threshold-10,yLimits(2)-0.05,['threshold = ',num2str(round(threshold)),' uA'],'FontSize',12,'Color','k');
        text(threshold,yLimits(2)-0.05,['threshold = ',num2str(round(threshold)),' uA'],'FontSize',12,'Color','k');
        ylabel('proportion of trials');
        xlabel('current amplitude (uA)');
        if Weibull==1
            title(['Psychometric function for array',num2str(array),' electrode',num2str(electrode),', Weibull fit.'])
            pathname=fullfile('D:\data',date,['array',num2str(array),'_electrode',num2str(electrode),'_current_amplitudes_weibull']);
        elseif Weibull==0
            title(['Psychometric function for array',num2str(array),' electrode',num2str(electrode),', sigmoid fit.'])
            pathname=fullfile('D:\data',date,['array',num2str(array),'_electrode',num2str(electrode),'_current_amplitudes_sigmoid']);
        end
        set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
        print(pathname,'-dtiff');
        thresholds(uniqueElectrode,Weibull+1)=threshold;
        thresholds(uniqueElectrode,Weibull+2)=electrode;
        thresholds(uniqueElectrode,Weibull+3)=array;
    end
end
save(['D:\data\',date,'\',date,'_thresholds.mat'],'thresholds');