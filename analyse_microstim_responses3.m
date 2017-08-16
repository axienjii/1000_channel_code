function analyse_microstim_responses3
%Written by Xing 15/8/17 to calculate hits, misses, false alarms, and
%correct rejections during new version of microstim task.
%Load in .mat file recorded on stimulus
%presentation computer, from server. Edit further to ensure unique
%electrode identities.

close all
date='150817_B9';arrayNumber=13;electrodeNumber=37;%array 13, electrode 37 (g)
date='160817_B1';arrayNumber=13;electrodeNumber=37;%array 13, electrode 37 (g)
date='160817_B2';arrayNumber=13;electrodeNumber=38;%array 13, electrode 37 (g)
date='160817_B5';arrayNumber=13;electrodeNumber=41;%array 13, electrode 41 
date='160817_B6';arrayNumber=13;electrodeNumber=55;%array 13, electrode 55 
date='160817_B7';arrayNumber=13;electrodeNumber=56;%array 13, electrode 56 
date='160817_B8';arrayNumber=13;electrodeNumber=61;%array 13, electrode 61 

load(['X:\best\',date,'\',date,'_data\microstim_saccade_',date,'.mat'])
microstimAllHitTrials=intersect(find(allCurrentLevel>0),find(performance==1));
microstimAllMissTrials=intersect(find(allCurrentLevel>0),find(performance==-1));
catchAllCRTrials=intersect(find(allCurrentLevel==0),find(performance==1));%correct rejections
catchAllFATrials=find(allFalseAlarms==1);%false alarms
%read in current amplitude conditions:
%catch trials:
currentAmpTrials=find(allCurrentLevel==0);
correctRejections=length(intersect(catchAllCRTrials,currentAmpTrials));
falseAlarms=length(intersect(catchAllFATrials,currentAmpTrials));
%microstim trials:
hits=[];
misses=[];
if strcmp(date,'150817_B9')%staircase procedure not used
    load(['X:\best\',date,'\',date,'_data\finalCurrentVals.mat'])
    for currentAmpCond=1:length(finalCurrentVals)/2
        currentAmplitude=finalCurrentVals(currentAmpCond+length(finalCurrentVals)/2);
        currentAmpTrials=find(allCurrentLevel==currentAmplitude);
        hits(currentAmpCond)=length(intersect(microstimAllHitTrials,currentAmpTrials));
        misses(currentAmpCond)=length(intersect(microstimAllMissTrials,currentAmpTrials));
        currentAmplitudes=finalCurrentVals(find(finalCurrentVals~=0));
    end
else%staircase procedure was used
    currentAmplitudes=[];
    hits=[];
    misses=[];
    load(['X:\best\',date,'\',date,'_data\finalCurrentVals3.mat'])
    for currentAmpCond=1:length(finalCurrentVals)
        currentAmplitude=finalCurrentVals(currentAmpCond);
        currentAmpTrials=find(allCurrentLevel==currentAmplitude);
        if ~isempty(currentAmpTrials)
            hits=[hits length(intersect(microstimAllHitTrials,currentAmpTrials))];
            misses=[misses length(intersect(microstimAllMissTrials,currentAmpTrials))];
            currentAmplitudes=[currentAmplitudes currentAmplitude];
        end
    end    
end
hits./misses;
for Weibull=0:1% set to 1 to get the Weibull fit, 0 for a sigmoid fit
    threshold=analyse_current_thresholds_Plot_Psy_Fie(currentAmplitudes,hits,misses,falseAlarms,correctRejections,Weibull);
    hold on
    yLimits=get(gca,'ylim');
    plot([threshold threshold],yLimits,'k:')
    text(threshold-20,yLimits(2)-0.05,['threshold = ',num2str(round(threshold)),' uA'],'FontSize',12,'Color','k');
    ylabel('proportion of trials');
    xlabel('current amplitude (uA)');
    if Weibull==1
        title('Psychometric function for microstimulation current amplitude, Weibull fit.')
        pathname=fullfile('D:\data',date,['array',num2str(arrayNumber),'_electrode',num2str(electrodeNumber),'_current_amplitudes_weibull']);
    elseif Weibull==0
        title('Psychometric function for microstimulation current amplitude, sigmoid fit.')
        pathname=fullfile('D:\data',date,['array',num2str(arrayNumber),'_electrode',num2str(electrodeNumber),'_current_amplitudes_sigmoid']);
    end
    set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
    print(pathname,'-dtiff');
end
