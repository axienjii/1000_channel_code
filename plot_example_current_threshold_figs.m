function plot_example_current_threshold_figs
%Written by Xing 27/3/19 to generate psychometric functions with
%performance vs current amplitude for the paper.

close all
localDisk=0;
exampleFig=1;
%Lick example channel:
if localDisk==1
    rootdir='D:\data\';
elseif localDisk==0
    rootdir='X:\best\';
end
if exampleFig==1%example current thresholding plot for paper
    date='110319_B2';
    electrodeNums=[12];
    arrayNums=[12];
end
figure;
subplot(1,2,1);

finalCurrentValsFile=7;
% copyfile(['Y:\Xing\',date(1:6),'_data'],[rootdir,date,'\',date,'_data']);
% copyfile(['D:\data\',date(1:6),'_data'],[rootdir,date,'\',date,'_data']);
copyfile(['X:\best\',date(1:6),'_data'],[rootdir,date,'\',date,'_data']);
load([rootdir,date,'\',date,'_data\microstim_saccade_',date,'.mat'])
microstimAllHitTrials=intersect(find(allCurrentLevel>0),find(performance==1));
microstimAllMissTrials=intersect(find(allCurrentLevel>0),find(performance==-1));
catchAllCRTrials=intersect(find(allCurrentLevel==0),find(performance==1));%correct rejections
catchAllFATrials=find(allFalseAlarms==1);%false alarms
currentAmpTrials=find(allCurrentLevel==0);
correctRejections=length(intersect(catchAllCRTrials,currentAmpTrials));
falseAlarms=length(intersect(catchAllFATrials,currentAmpTrials));
setFalseAlarmZero=1;
if setFalseAlarmZero==1
    falseAlarms=0;
end
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
    for Weibull=1% set to 1 to get the Weibull fit, 0 for a sigmoid fit
        [theta threshold]=analyse_current_thresholds_Plot_Psy_Fie(currentAmplitudes,hits,misses,falseAlarms,correctRejections,Weibull);
        hold on
        yLimits=get(gca,'ylim');
        plot([threshold threshold],yLimits,'r:')
        if exampleFig==0
            plot([theta theta],yLimits,'k:')
        end
        if exampleFig==0
            text(threshold,yLimits(2)-0.05,['threshold = ',num2str(round(threshold)),' uA'],'FontSize',12,'Color','k');
            ylabel('proportion of trials');
            xlabel('current amplitude (uA)');
            if Weibull==1
                title(['Psychometric function for array',num2str(array),' electrode',num2str(electrode),', Weibull fit.'])
                pathname=fullfile(rootdir,date,['array',num2str(array),'_electrode',num2str(electrode),'_current_amplitudes_weibull']);
            elseif Weibull==0
                title(['Psychometric function for array',num2str(array),' electrode',num2str(electrode),', sigmoid fit.'])
                pathname=fullfile(rootdir,date,['array',num2str(array),'_electrode',num2str(electrode),'_current_amplitudes_sigmoid']);
            end
        end
        set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
        print(pathname,'-dtiff');
        thresholds(uniqueElectrode,Weibull+1)=threshold;
        thresholds(uniqueElectrode,Weibull+2)=electrode;
        thresholds(uniqueElectrode,Weibull+3)=array;
    end
end
if exampleFig==1
    set(gca,'Box','off')
    xlim([0 15])
    set(gca,'YTick',[0 0.5 1])
    set(gca,'XTick',[0 5 10 15])
end

%Aston example channel:
if localDisk==1
    rootdir='D:\aston_data\';
elseif localDisk==0
    rootdir='X:\aston\';
end
if exampleFig==1%example current thresholding plot for paper
    date='200219_B4';
    electrodeNums=[52];
    arrayNums=[13];
end
subplot(1,2,2);
date=[date,'_aston'];
finalCurrentValsFile=7;
% copyfile(['Y:\Xing\',date(1:6),'_data'],[rootdir,date,'\',date,'_data']);
% copyfile(['D:\data\',date(1:6),'_data'],[rootdir,date,'\',date,'_data']);
copyfile(['X:\aston\',date(1:6),'_data'],[rootdir,date,'\',date,'_data']);
% copyfile(['D:\aston_data\microstim_saccade_261118_B3_aston'],[rootdir,date,'\',date,'_data']);
load([rootdir,date,'\',date,'_data\microstim_saccade_',date,'.mat'])
microstimAllHitTrials=intersect(find(allCurrentLevel>0),find(performance==1));
microstimAllMissTrials=intersect(find(allCurrentLevel>0),find(performance==-1));
catchAllCRTrials=intersect(find(allCurrentLevel==0),find(performance==1));%correct rejections
catchAllFATrials=find(allFalseAlarms==1);%false alarms
currentAmpTrials=find(allCurrentLevel==0);
correctRejections=length(intersect(catchAllCRTrials,currentAmpTrials));
falseAlarms=length(intersect(catchAllFATrials,currentAmpTrials));
setFalseAlarmZero=1;
if setFalseAlarmZero==1
    falseAlarms=0;
end
allElectrodeNums=cell2mat(allElectrodeNum);
allArrayNums=cell2mat(allArrayNum);
if strcmp(date,'281218_B3_aston')
    replaceInd=find(allArrayNums==14);
    allArrayNums(replaceInd)=15;
end
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
    for Weibull=1% set to 1 to get the Weibull fit, 0 for a sigmoid fit
        [theta threshold]=analyse_current_thresholds_Plot_Psy_Fie(currentAmplitudes,hits,misses,falseAlarms,correctRejections,Weibull);
        hold on
        yLimits=get(gca,'ylim');
        plot([threshold threshold],yLimits,'r:')
        if exampleFig==0
            plot([theta theta],yLimits,'k:')
        end
        if exampleFig==0
            text(threshold,yLimits(2)-0.05,['threshold = ',num2str(round(threshold)),' uA'],'FontSize',12,'Color','k');
            ylabel('proportion of trials');
            xlabel('current amplitude (uA)');
            if Weibull==1
                title(['Psychometric function for array',num2str(array),' electrode',num2str(electrode),', Weibull fit.'])
                pathname=fullfile(rootdir,date,['array',num2str(array),'_electrode',num2str(electrode),'_current_amplitudes_weibull']);
            elseif Weibull==0
                title(['Psychometric function for array',num2str(array),' electrode',num2str(electrode),', sigmoid fit.'])
                pathname=fullfile(rootdir,date,['array',num2str(array),'_electrode',num2str(electrode),'_current_amplitudes_sigmoid']);
            end
        end
        thresholds(uniqueElectrode,Weibull+1)=threshold;
        thresholds(uniqueElectrode,Weibull+2)=electrode;
        thresholds(uniqueElectrode,Weibull+3)=array;
    end
end
if exampleFig==1
    set(gca,'Box','off')
    xlim([0 210])
    set(gca,'YTick',[0 0.5 1])
    set(gca,'XTick',[0 100 200])
end
pauseHere=1;