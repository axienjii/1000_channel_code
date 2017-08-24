function analyse_microstim_responses3
%Written by Xing 15/8/17 to calculate hits, misses, false alarms, and
%correct rejections during new version of microstim task.
%Load in .mat file recorded on stimulus
%presentation computer, from server. Edit further to ensure unique
%electrode identities.

close all
date='150817_B9';arrayNumber=13;electrodeNumber=37;finalCurrentValsFile=1;%array 13, electrode 37 (g)
date='160817_B1';arrayNumber=13;electrodeNumber=37;finalCurrentValsFile=2;%array 13, electrode 37 (g)
date='160817_B2';arrayNumber=13;electrodeNumber=38;finalCurrentValsFile=2;%array 13, electrode 38 (g)
date='160817_B5';arrayNumber=13;electrodeNumber=41;finalCurrentValsFile=2;%array 13, electrode 41 (r)
date='160817_B6';arrayNumber=13;electrodeNumber=55;finalCurrentValsFile=2;%array 13, electrode 55 (r)
date='160817_B7';arrayNumber=13;electrodeNumber=56;finalCurrentValsFile=2;%array 13, electrode 56 (r)
date='160817_B8';arrayNumber=13;electrodeNumber=61;finalCurrentValsFile=2;%array 13, electrode 61 (r)
date='170817_B1';arrayNumber=13;electrodeNumber=41;finalCurrentValsFile=3; %(g)
date='170817_B3';arrayNumber=13;electrodeNumber=55;finalCurrentValsFile=3; %(g)
date='170817_B4';arrayNumber=13;electrodeNumber=56;finalCurrentValsFile=3; %(g)
date='170817_B5';arrayNumber=13;electrodeNumber=61;finalCurrentValsFile=3; %(g)
date='170817_B12';arrayNumber=10;electrodeNumber=56;finalCurrentValsFile=3; %(g)
date='170817_B18';arrayNumber=10;electrodeNumber=45;finalCurrentValsFile=3;
date='180817_B1';arrayNumber=10;electrodeNumber=48;finalCurrentValsFile=3;%.mat file from stimulus presentation computer corrupted- only 1 KB in size
date='180817_B2';arrayNumber=10;electrodeNumber=38;finalCurrentValsFile=3; %(g)
date='180817_B3';arrayNumber=10;electrodeNumber=47;finalCurrentValsFile=3; %(g)
date='180817_B4';arrayNumber=10;electrodeNumber=46;finalCurrentValsFile=3; %(g)
date='180817_B5';arrayNumber=10;electrodeNumber=39;finalCurrentValsFile=3; %(g)
date='180817_B6';arrayNumber=10;electrodeNumber=39;finalCurrentValsFile=3;
date='180817_B7';arrayNumber=10;electrodeNumber=45;finalCurrentValsFile=3; %(m)
date='180817_B8';arrayNumber=10;electrodeNumber=59;finalCurrentValsFile=4; %(g)
useFinalCurrentVals=1;

date='210817_B2';arrayNumber=12;electrodeNumber=57;finalCurrentValsFile=4; %(m?) 
% date='210817_B3';arrayNumber=12;electrodeNumber=57;finalCurrentValsFile=4; %(m?) 
% date='210817_B4';arrayNumber=12;electrodeNumber=22;finalCurrentValsFile=4; %(r) 
% date='210817_B6';arrayNumber=12;electrodeNumber=22;finalCurrentValsFile=5; %(m) 
% date='210817_B7';arrayNumber=12;electrodeNumber=24;finalCurrentValsFile=5; %   ?
% date='210817_B8';arrayNumber=12;electrodeNumber=41;finalCurrentValsFile=6; % 
% date='210817_B10';arrayNumber=12;electrodeNumber=5;finalCurrentValsFile=6; %(r) 
% date='210817_B11';arrayNumber=12;electrodeNumber=23;finalCurrentValsFile=6; %(r) 
% date='210817_B12';arrayNumber=12;electrodeNumber=39;finalCurrentValsFile=6; %(r) 
% date='210817_B13';arrayNumber=12;electrodeNumber=58;finalCurrentValsFile=6; %(r) 
% date='210817_B14';arrayNumber=12;electrodeNumber=59;finalCurrentValsFile=6; %(r) %and electrode 21?
% date='210817_B15';arrayNumber=12;electrodeNumber=59;finalCurrentValsFile=6; %(r) 
% date='210817_B16';arrayNumber=12;electrodeNumber=20;finalCurrentValsFile=6; %(g)
% date='210817_B17';arrayNumber=12;electrodeNumber=27;finalCurrentValsFile=6; %(g) 
% date='210817_B18';arrayNumber=12;electrodeNumber=28;finalCurrentValsFile=6; %(r) 
% date='210817_B19';arrayNumber=12;electrodeNumber=35;finalCurrentValsFile=6; %(r) 
% date='210817_B20';arrayNumber=12;electrodeNumber=19;finalCurrentValsFile=6; %(r) 
% date='210817_B21';arrayNumber=12;electrodeNumber=43;finalCurrentValsFile=6; %(m) 
useFinalCurrentVals=1;

% date='220817_B1';arrayNumber=12;electrodeNumber=34;finalCurrentValsFile=6; %(m) uses quest
% date='220817_B2';arrayNumber=12;electrodeNumber=36;finalCurrentValsFile=6; %(m) uses quest
% date='220817_B4';arrayNumber=12;electrodeNumber=42;finalCurrentValsFile=6; %(m) uses quest
% date='220817_B5';arrayNumber=12;electrodeNumber=2;finalCurrentValsFile=6; %(r) uses quest
% date='220817_B7';arrayNumber=12;electrodeNumber=12;finalCurrentValsFile=6; %(m) uses quest
% date='220817_B10';arrayNumber=12;electrodeNumber=3;finalCurrentValsFile=6; %(m) uses quest
% useFinalCurrentVals=0;

% date='220817_B26';arrayNumber=12;electrodeNumber=3;finalCurrentValsFile=6; %(g)
% date='220817_B30';arrayNumber=12;electrodeNumber=29;finalCurrentValsFile=6; %(r)
% date='220817_B31';arrayNumber=12;electrodeNumber=13;finalCurrentValsFile=6; %(r)
% date='220817_B33';arrayNumber=12;electrodeNumber=26;finalCurrentValsFile=6; %(r)
% date='220817_B34';arrayNumber=12;electrodeNumber=44;finalCurrentValsFile=6; %(m-g)
% date='220817_B37';arrayNumber=12;electrodeNumber=49;finalCurrentValsFile=6; %(g)
% date='220817_B39';arrayNumber=12;electrodeNumber=37;finalCurrentValsFile=6; %(m)
% useFinalCurrentVals=1;

% date='230817_B1';arrayNumber=12;electrodeNumber=37;finalCurrentValsFile=6; %(g)
% date='230817_B2';arrayNumber=12;electrodeNumber=22;finalCurrentValsFile=6; %(g)
% date='230817_B3';arrayNumber=12;electrodeNumber=24;finalCurrentValsFile=6; %(g)
% date='230817_B4';arrayNumber=12;electrodeNumber=41;finalCurrentValsFile=6; %(g)
% date='230817_B5';arrayNumber=12;electrodeNumber=5;finalCurrentValsFile=6; %(g)
% date='230817_B7';arrayNumber=12;electrodeNumber=23;finalCurrentValsFile=6; %(g)
% date='230817_B8';arrayNumber=12;electrodeNumber=39;finalCurrentValsFile=6; %(g)
% date='230817_B9';arrayNumber=12;electrodeNumber=58;finalCurrentValsFile=6; %(g)
% date='230817_B10';arrayNumber=12;electrodeNumber=59;finalCurrentValsFile=6; %(g)
% date='230817_B11';arrayNumber=12;electrodeNumber=28;finalCurrentValsFile=6; %(g)
% date='230817_B12';arrayNumber=12;electrodeNumber=35;finalCurrentValsFile=6; %(g)
% date='230817_B13';arrayNumber=12;electrodeNumber=19;finalCurrentValsFile=6; %(g)
date='230817_B16';arrayNumber=12;electrodeNumber=29;finalCurrentValsFile=6; %(m)
% date='230817_B17';arrayNumber=12;electrodeNumber=19;finalCurrentValsFile=6; %(r)%can discard
% date='230817_B18';arrayNumber=12;electrodeNumber=13;finalCurrentValsFile=6; %(g)
% date='230817_B19';arrayNumber=12;electrodeNumber=26;finalCurrentValsFile=6; %(m)
useFinalCurrentVals=1;

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
if useFinalCurrentVals==1
    if finalCurrentValsFile==1%strcmp(date,'150817_B9'), staircase procedure not used
        load(['X:\best\',date,'\',date,'_data\finalCurrentVals.mat'])
        for currentAmpCond=1:length(finalCurrentVals)/2
            currentAmplitude=finalCurrentVals(currentAmpCond+length(finalCurrentVals)/2);
            currentAmpTrials=find(allCurrentLevel==currentAmplitude);
            hits(currentAmpCond)=length(intersect(microstimAllHitTrials,currentAmpTrials));
            misses(currentAmpCond)=length(intersect(microstimAllMissTrials,currentAmpTrials));
            currentAmplitudes=finalCurrentVals(find(finalCurrentVals~=0));
        end
    else
        if finalCurrentValsFile==2%staircase procedure was used, finalCurrentVals3.mat
            load(['X:\best\',date,'\',date,'_data\finalCurrentVals3.mat'])
        elseif finalCurrentValsFile==3%staircase procedure was used, finalCurrentVals4.mat
            load(['X:\best\',date,'\',date,'_data\finalCurrentVals4.mat'])
        elseif finalCurrentValsFile==4%staircase procedure was used, finalCurrentVals4.mat
            load(['X:\best\',date,'\',date,'_data\finalCurrentVals5.mat'])
        elseif finalCurrentValsFile==5%staircase procedure was used, finalCurrentVals4.mat
            load(['X:\best\',date,'\',date,'_data\finalCurrentVals6.mat'])
        elseif finalCurrentValsFile==6%staircase procedure was used, finalCurrentVals4.mat
            load(['X:\best\',date,'\',date,'_data\finalCurrentVals7.mat'])
        end
        currentAmplitudes=[];
        hits=[];
        misses=[];
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
elseif useFinalCurrentVals==0
    currentAmplitudes=[];
    hits=[];
    misses=[];
    finalCurrentVals=unique(allStimCurrentLevel);
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
    [theta threshold]=analyse_current_thresholds_Plot_Psy_Fie(currentAmplitudes,hits,misses,falseAlarms,correctRejections,Weibull);
    hold on
    yLimits=get(gca,'ylim');
    plot([threshold threshold],yLimits,'r:')
    plot([theta theta],yLimits,'k:')
    text(threshold-20,yLimits(2)-0.05,['threshold = ',num2str(round(threshold)),' uA'],'FontSize',12,'Color','k');
    ylabel('proportion of trials');
    xlabel('current amplitude (uA)');
    if Weibull==1
        title(['Psychometric function for array',num2str(arrayNumber),' electrode',num2str(electrodeNumber),', Weibull fit.'])
        pathname=fullfile('D:\data',date,['array',num2str(arrayNumber),'_electrode',num2str(electrodeNumber),'_current_amplitudes_weibull']);
    elseif Weibull==0
        title(['Psychometric function for array',num2str(arrayNumber),' electrode',num2str(electrodeNumber),', sigmoid fit.'])
        pathname=fullfile('D:\data',date,['array',num2str(arrayNumber),'_electrode',num2str(electrodeNumber),'_current_amplitudes_sigmoid']);
    end
    set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
    print(pathname,'-dtiff');
end
