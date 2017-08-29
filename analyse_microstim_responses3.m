function analyse_microstim_responses3
%Written by Xing 15/8/17 to calculate hits, misses, false alarms, and
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

date='220817_B1';arrayNumber=12;electrodeNumber=34;finalCurrentValsFile=6; %(m) uses quest
% date='220817_B2';arrayNumber=12;electrodeNumber=36;finalCurrentValsFile=6; %(m) uses quest
% date='220817_B4';arrayNumber=12;electrodeNumber=42;finalCurrentValsFile=6; %(m) uses quest
% date='220817_B5';arrayNumber=12;electrodeNumber=2;finalCurrentValsFile=6; %(r) uses quest
% date='220817_B7';arrayNumber=12;electrodeNumber=12;finalCurrentValsFile=6; %(m) uses quest
% date='220817_B10';arrayNumber=12;electrodeNumber=3;finalCurrentValsFile=6; %(m) uses quest
useFinalCurrentVals=0;

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
% date='230817_B16';arrayNumber=12;electrodeNumber=29;finalCurrentValsFile=6; %(m)
% date='230817_B17';arrayNumber=12;electrodeNumber=19;finalCurrentValsFile=6; %(r)%can discard
% date='230817_B18';arrayNumber=12;electrodeNumber=13;finalCurrentValsFile=6; %(g)
% date='230817_B19';arrayNumber=12;electrodeNumber=26;finalCurrentValsFile=6; %(m)
% useFinalCurrentVals=1;

date='240817_B1';arrayNumber=12;electrodeNumber=57;finalCurrentValsFile=6; %(m)
date='240817_B2';arrayNumber=12;electrodeNumber=40;finalCurrentValsFile=6; %(m)
date='240817_B3';arrayNumber=12;electrodeNumber=21;finalCurrentValsFile=6; %(r)
date='240817_B4';arrayNumber=12;electrodeNumber=6;finalCurrentValsFile=6; %(r)
% date='240817_B5';arrayNumber=12;electrodeNumber=43;finalCurrentValsFile=6; %(g)
% date='240817_B6';arrayNumber=12;electrodeNumber=11;finalCurrentValsFile=6; %(g)
% date='240817_B7';arrayNumber=12;electrodeNumber=34;finalCurrentValsFile=6; %(g)
% date='240817_B8';arrayNumber=12;electrodeNumber=36;finalCurrentValsFile=6; %(g)
% date='240817_B9';arrayNumber=12;electrodeNumber=42;finalCurrentValsFile=6; %(g)
% date='240817_B10';arrayNumber=12;electrodeNumber=2;finalCurrentValsFile=6; %(r)
% date='240817_B11';arrayNumber=12;electrodeNumber=12;finalCurrentValsFile=6; %(g)
% date='240817_B12';arrayNumber=12;electrodeNumber=29;finalCurrentValsFile=6; %(m-g)
% date='240817_B13';arrayNumber=12;electrodeNumber=4;finalCurrentValsFile=6; %(r)
% date='240817_B15';arrayNumber=12;electrodeNumber=26;finalCurrentValsFile=6; %(g)
% date='240817_B16';arrayNumber=12;electrodeNumber=60;finalCurrentValsFile=6; %(r)
% date='240817_B17';arrayNumber=13;electrodeNumber=35;finalCurrentValsFile=6; %(g)
% date='240817_B18';arrayNumber=13;electrodeNumber=33;finalCurrentValsFile=6; %(g)
% date='240817_B19';arrayNumber=13;electrodeNumber=34;finalCurrentValsFile=6; %(m)
% date='240817_B20';arrayNumber=13;electrodeNumber=50;finalCurrentValsFile=6; %(g)
% date='240817_B21';arrayNumber=13;electrodeNumber=51;finalCurrentValsFile=6; %(g)
% date='240817_B22';arrayNumber=13;electrodeNumber=11;finalCurrentValsFile=6; %(g)
% date='240817_B23';arrayNumber=13;electrodeNumber=12;finalCurrentValsFile=6; %(g)
% date='240817_B24';arrayNumber=13;electrodeNumber=13;finalCurrentValsFile=6; %(r)
% date='240817_B25';arrayNumber=13;electrodeNumber=52;finalCurrentValsFile=6; %(m-g)
% date='240817_B26';arrayNumber=13;electrodeNumber=53;finalCurrentValsFile=6; %(m)
% date='240817_B27';arrayNumber=13;electrodeNumber=14;finalCurrentValsFile=6; %(r)
date='240817_B28';arrayNumber=11;electrodeNumber=3;finalCurrentValsFile=6; %(g) repeat with lower currents
date='240817_B29';arrayNumber=11;electrodeNumber=3;finalCurrentValsFile=6; %(g) repeat with lower currents
date='240817_B30';arrayNumber=11;electrodeNumber=3;finalCurrentValsFile=6; %(g) final
% date='240817_B31';arrayNumber=11;electrodeNumber=18;finalCurrentValsFile=6; %(g)
% date='240817_B32';arrayNumber=11;electrodeNumber=22;finalCurrentValsFile=6; %(g)
% date='240817_B33';arrayNumber=11;electrodeNumber=22;finalCurrentValsFile=6; %(g)
% date='240817_B36';arrayNumber=11;electrodeNumber=55;finalCurrentValsFile=6; %(m)
% date='240817_B38';arrayNumber=11;electrodeNumber=34;finalCurrentValsFile=6; %(r)
useFinalCurrentVals=1;

date='250817_B3';arrayNumber=12;electrodeNumber=6;finalCurrentValsFile=6; %(m)
% date='250817_B4';arrayNumber=12;electrodeNumber=22;finalCurrentValsFile=6; %(g)
% date='250817_B5';arrayNumber=12;electrodeNumber=41;finalCurrentValsFile=6; %(g)
date='250817_B6';arrayNumber=12;electrodeNumber=6;finalCurrentValsFile=6; %(r)
% date='250817_B7';arrayNumber=12;electrodeNumber=2;finalCurrentValsFile=6; %(r)
% date='250817_B8';arrayNumber=12;electrodeNumber=4;finalCurrentValsFile=6; %(r)
% date='250817_B9';arrayNumber=12;electrodeNumber=44;finalCurrentValsFile=6; %(g)
% date='250817_B10';arrayNumber=12;electrodeNumber=60;finalCurrentValsFile=6; %(m)
% date='250817_B12';arrayNumber=13;electrodeNumber=13;finalCurrentValsFile=6; %(g)
% date='250817_B13';arrayNumber=13;electrodeNumber=14;finalCurrentValsFile=6; %(r)
% date='250817_B14';arrayNumber=10;electrodeNumber=48;finalCurrentValsFile=6; %(g)
% date='250817_B15';arrayNumber=10;electrodeNumber=48;finalCurrentValsFile=6; %(g)
% date='250817_B20';arrayNumber=11;electrodeNumber=51;finalCurrentValsFile=6; %(m-g)
% date='250817_B21';arrayNumber=11;electrodeNumber=21;finalCurrentValsFile=6; %(g) can discard
% date='250817_B22';arrayNumber=11;electrodeNumber=21;finalCurrentValsFile=6; %(g)
% date='250817_B23';arrayNumber=11;electrodeNumber=34;finalCurrentValsFile=6; %(g)
% date='250817_B24';arrayNumber=11;electrodeNumber=24;finalCurrentValsFile=6; %(g)
% date='250817_B25';arrayNumber=11;electrodeNumber=34;finalCurrentValsFile=6; %(g)
% date='250817_B26';arrayNumber=14;electrodeNumber=5;finalCurrentValsFile=6; %(g)
% date='250817_B27';arrayNumber=14;electrodeNumber=4;finalCurrentValsFile=6; %(g)
% date='250817_B29';arrayNumber=14;electrodeNumber=12;finalCurrentValsFile=6; %(m-g)
% date='250817_B30';arrayNumber=14;electrodeNumber=21;finalCurrentValsFile=6; %(g)
useFinalCurrentVals=1;

date='280817_B1';arrayNumber=14;electrodeNumber=20;finalCurrentValsFile=6; %(g)
date='280817_B2';arrayNumber=14;electrodeNumber=20;finalCurrentValsFile=6; %(m) 
date='280817_B3';arrayNumber=14;electrodeNumber=28;finalCurrentValsFile=6; %(g)
date='280817_B4';arrayNumber=14;electrodeNumber=63;finalCurrentValsFile=6; %(g)
date='280817_B5';arrayNumber=14;electrodeNumber=13;finalCurrentValsFile=6; %(m)
date='280817_B6';arrayNumber=14;electrodeNumber=62;finalCurrentValsFile=6; %(g)
date='280817_B7';arrayNumber=14;electrodeNumber=54;finalCurrentValsFile=6; %(g)
date='280817_B8';arrayNumber=14;electrodeNumber=55;finalCurrentValsFile=6; %(g)
date='280817_B9';arrayNumber=14;electrodeNumber=29;finalCurrentValsFile=6; %(r)
date='280817_B11';arrayNumber=14;electrodeNumber=37;finalCurrentValsFile=6; %(g)
date='280817_B12';arrayNumber=14;electrodeNumber=36;finalCurrentValsFile=6; %(g)
date='280817_B13';arrayNumber=14;electrodeNumber=31;finalCurrentValsFile=6; %(g)
date='280817_B14';arrayNumber=14;electrodeNumber=53;finalCurrentValsFile=6; %(r) can discard
date='280817_B16';arrayNumber=14;electrodeNumber=53;finalCurrentValsFile=6; %(g)
% date='280817_B19';arrayNumber=14;electrodeNumber=3;finalCurrentValsFile=6; %(r)
% date='280817_B20';arrayNumber=14;electrodeNumber=32;finalCurrentValsFile=6; %(g)
% date='280817_B21';arrayNumber=14;electrodeNumber=47;finalCurrentValsFile=6; %(g)
% date='280817_B22';arrayNumber=14;electrodeNumber=59;finalCurrentValsFile=6; %(g)
% date='280817_B23';arrayNumber=14;electrodeNumber=40;finalCurrentValsFile=6; %(g)
% date='280817_B24';arrayNumber=14;electrodeNumber=61;finalCurrentValsFile=6; %(g)
% date='280817_B25';arrayNumber=14;electrodeNumber=39;finalCurrentValsFile=6; %(g)
% date='280817_B27';arrayNumber=14;electrodeNumber=15;finalCurrentValsFile=6; %(r)
% date='280817_B28';arrayNumber=14;electrodeNumber=58;finalCurrentValsFile=6; %(r)
% date='280817_B29';arrayNumber=14;electrodeNumber=44;finalCurrentValsFile=6; %(r)
% date='280817_B30';arrayNumber=14;electrodeNumber=45;finalCurrentValsFile=6; %(g)
% date='280817_B31';arrayNumber=14;electrodeNumber=46;finalCurrentValsFile=6; %(g)
useFinalCurrentVals=1;

date='290817_B1';arrayNumber=14;electrodeNumber=16;finalCurrentValsFile=6; %(g)
date='290817_B2';arrayNumber=14;electrodeNumber=30;finalCurrentValsFile=6; %(g)
date='290817_B3';arrayNumber=14;electrodeNumber=30;finalCurrentValsFile=6; %(g)
date='290817_B4';arrayNumber=14;electrodeNumber=13;finalCurrentValsFile=6; %(r)
date='290817_B7';arrayNumber=14;electrodeNumber=29;finalCurrentValsFile=6; %(m-g)
date='290817_B9';arrayNumber=14;electrodeNumber=3;finalCurrentValsFile=6; %(g)
date='290817_B10';arrayNumber=14;electrodeNumber=15;finalCurrentValsFile=6; %(g)
date='290817_B13';arrayNumber=14;electrodeNumber=58;finalCurrentValsFile=6; %(g)
date='290817_B14';arrayNumber=14;electrodeNumber=44;finalCurrentValsFile=6; %(g)
date='290817_B21';arrayNumber=13;electrodeNumber=44;finalCurrentValsFile=6; %(g)
date='290817_B23';arrayNumber=13;electrodeNumber=41;finalCurrentValsFile=6; %(r)
date='290817_B23';arrayNumber=13;electrodeNumber=41;finalCurrentValsFile=6; %(r)
date='290817_B24';arrayNumber=13;electrodeNumber=62;finalCurrentValsFile=6; %(g)
date='290817_B25';arrayNumber=13;electrodeNumber=62;finalCurrentValsFile=6; %(g)
date='290817_B26';arrayNumber=13;electrodeNumber=43;finalCurrentValsFile=6; %(g)
date='290817_B28';arrayNumber=13;electrodeNumber=32;finalCurrentValsFile=6; %(g)
date='290817_B29';arrayNumber=13;electrodeNumber=48;finalCurrentValsFile=6; %(g)
date='290817_B30';arrayNumber=13;electrodeNumber=49;finalCurrentValsFile=6; %(g)
date='290817_B31';arrayNumber=13;electrodeNumber=22;finalCurrentValsFile=6; %(g)
date='290817_B33';arrayNumber=13;electrodeNumber=58;finalCurrentValsFile=6; %(r)
date='290817_B34';arrayNumber=13;electrodeNumber=31;finalCurrentValsFile=6; %(g)
date='290817_B36';arrayNumber=13;electrodeNumber=25;finalCurrentValsFile=6; %(g)
date='290817_B37';arrayNumber=13;electrodeNumber=3;finalCurrentValsFile=6; %(g) use log fit
date='290817_B38';arrayNumber=13;electrodeNumber=23;finalCurrentValsFile=6; %(g)
date='290817_B39';arrayNumber=13;electrodeNumber=47;finalCurrentValsFile=6; %(g) use log fit
date='290817_B40';arrayNumber=13;electrodeNumber=26;finalCurrentValsFile=6; %(g)
date='290817_B41';arrayNumber=13;electrodeNumber=42;finalCurrentValsFile=6; %(g)
date='290817_B42';arrayNumber=13;electrodeNumber=3;finalCurrentValsFile=6; %(r)
date='290817_B44';arrayNumber=13;electrodeNumber=55;finalCurrentValsFile=6; %(m-g) bipolar, 55+56
date='290817_B45';arrayNumber=13;electrodeNumber=55;finalCurrentValsFile=6; %(m-g) bipolar, 55+56
date='290817_B46';arrayNumber=13;electrodeNumber=37;finalCurrentValsFile=6; %(m) bipolar, 37+38
useFinalCurrentVals=1;

copyfile(['Y:\Xing\',date(1:6),'_data'],[rootdir,date,'\',date,'_data']);
load([rootdir,date,'\',date,'_data\microstim_saccade_',date,'.mat'])
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
        load([rootdir,date,'\',date,'_data\finalCurrentVals.mat'])
        for currentAmpCond=1:length(finalCurrentVals)/2
            currentAmplitude=finalCurrentVals(currentAmpCond+length(finalCurrentVals)/2);
            currentAmpTrials=find(allCurrentLevel==currentAmplitude);
            hits(currentAmpCond)=length(intersect(microstimAllHitTrials,currentAmpTrials));
            misses(currentAmpCond)=length(intersect(microstimAllMissTrials,currentAmpTrials));
            currentAmplitudes=finalCurrentVals(find(finalCurrentVals~=0));
        end
    else
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
%     perfInd=find(performance~=0);
%     q=QuestUpdate(q,log10(intensity(reps,n)),correct);
%         currentthresh(reps,n) = 10.^QuestMean(q);
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
