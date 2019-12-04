function saccade_eccentricity_vs_current_amplitude
%Written by Xing 13/6/19
%For Lick: Loads in saccade end point data and current amplitude data, to check to
%correlation between the two.
%For Aston: Loads in saccade end point data or freq/num pulses data, to check to
%correlation between the two.

pixperdeg=25.8601;
%Lick data (varying current amplitude)
rootdir='X:\best\';
topDate='171018_B';
figure;
subplotInd=1;
for dateInd=[1 2 5:11]
    meanEccentricity=[];
    stdEccentricity=[];
    date=[topDate,num2str(dateInd)];
    load([rootdir,date,'\saccade_endpoints_',date,'.mat']);
    load([rootdir,date,'\saccade_data_',date,'_fix_to_rew.mat'],'currentAmplitudeAllTrials');
    for trialInd=1:length(electrodeAllTrials)
        polarAngleSac(trialInd)=atan2(-saccadeEndAllTrials(trialInd,2),saccadeEndAllTrials(trialInd,1));
        eccentricitySac(trialInd)=sqrt(saccadeEndAllTrials(trialInd,1)^2+saccadeEndAllTrials(trialInd,2)^2)/pixperdeg;
    end
    uniqueCurrentConds=unique(currentAmplitudeAllTrials);
    for currentInd=1:length(uniqueCurrentConds)
        currentIndTrials=find(currentAmplitudeAllTrials==uniqueCurrentConds(currentInd));
        meanEccentricity(currentInd)=mean(currentIndTrials);
        stdEccentricity(currentInd)=std(currentIndTrials);
    end
    subplot(3,3,subplotInd);
    errorbar(uniqueCurrentConds,meanEccentricity,stdEccentricity);
    title(['e',num2str(electrodeAllTrials(1)),' a',num2str(arrayAllTrials(1))]);
    subplotInd=subplotInd+1;
    % plot(currentAmplitudeAllTrials,eccentricitySac);
end

pixperdeg=25.8601;
%Lick data (varying current amplitude, local disk)
rootdir='D:\data\';
dates=[{'010719_B14'} {'020719_B3'} {'020719_B11'} {'020719_B12'}];
figure;
subplotInd=1;
for dateInd=1:length(dates)
    meanEccentricity=[];
    stdEccentricity=[];
    date=dates{dateInd};
    load([rootdir,date,'\saccade_endpoints_',date,'.mat']);
    load([rootdir,date,'\saccade_data_',date,'_fix_to_rew.mat'],'currentAmplitudeAllTrials');
    for trialInd=1:length(electrodeAllTrials)
        polarAngleSac(trialInd)=atan2(-saccadeEndAllTrials(trialInd,2),saccadeEndAllTrials(trialInd,1));
        eccentricitySac(trialInd)=sqrt(saccadeEndAllTrials(trialInd,1)^2+saccadeEndAllTrials(trialInd,2)^2)/pixperdeg;
    end
    uniqueCurrentConds=unique(currentAmplitudeAllTrials);
    for currentInd=1:length(uniqueCurrentConds)
        currentIndTrials=find(currentAmplitudeAllTrials==uniqueCurrentConds(currentInd));
        meanEccentricity(currentInd)=mean(currentIndTrials);
        stdEccentricity(currentInd)=std(currentIndTrials);
    end
    subplot(2,ceil(length(dates)/2),subplotInd);
    errorbar(uniqueCurrentConds,meanEccentricity,stdEccentricity);
    title(['e',num2str(electrodeAllTrials(1)),' a',num2str(arrayAllTrials(1))]);
    xlim([0 210]);
    subplotInd=subplotInd+1;
    % plot(currentAmplitudeAllTrials,eccentricitySac);
end

%Aston data (varying current amplitude)
rootdir='D:\aston_data\';
dates=[{'020719_B5'} {'030719_B2'} {'080719_B2'} {'080719_B3'} {'090719_B2'} {'090719_B3'} {'090719_B4'}];%{''} {''} {''} {''}
figure;
subplotInd=1;
for dateInd=1:length(dates)
    meanEccentricity=[];
    stdEccentricity=[];
    date=[dates{dateInd},'_aston'];
    load([rootdir,date,'\saccade_endpoints_',date,'.mat']);
    load([rootdir,date,'\saccade_data_',date,'_fix_to_rew.mat'],'currentAmplitudeAllTrials');
    for trialInd=1:length(electrodeAllTrials)
        polarAngleSac(trialInd)=atan2(-saccadeEndAllTrials(trialInd,2),saccadeEndAllTrials(trialInd,1));
        eccentricitySac(trialInd)=sqrt(saccadeEndAllTrials(trialInd,1)^2+saccadeEndAllTrials(trialInd,2)^2)/pixperdeg;
    end
    uniqueCurrentConds=unique(currentAmplitudeAllTrials);
    for currentInd=1:length(uniqueCurrentConds)
        currentIndTrials=find(currentAmplitudeAllTrials==uniqueCurrentConds(currentInd));
        meanEccentricity(currentInd)=mean(currentIndTrials);
        stdEccentricity(currentInd)=std(currentIndTrials);
    end
    subplot(3,3,subplotInd);
    errorbar(uniqueCurrentConds,meanEccentricity,stdEccentricity);
    title(['e',num2str(electrodeAllTrials(1)),' a',num2str(arrayAllTrials(1))]);
    subplotInd=subplotInd+1;
    % plot(currentAmplitudeAllTrials,eccentricitySac);
end

%Lick data (varying frequency)
dates=[{'010719_B6'} {'010719_B10'} {'020719_B2'} {'020719_B5'} {'020719_B8'} {'020719_B10'}];% {''} {''} {''} {''}
rootdir='D:\data\';
figure;
hold on
subplotInd=1;
for dateInd=1:length(dates)
    meanEccentricity=[];
    stdEccentricity=[];
    date=[dates{dateInd}];
    load([rootdir,date,'\saccade_endpoints_',date,'.mat']);
    load([rootdir,date,'\saccade_data_',date,'_fix_to_rew.mat'],'freqAllTrials');
    for trialInd=1:length(electrodeAllTrials)
        polarAngleSac(trialInd)=atan2(-saccadeEndAllTrials(trialInd,2),saccadeEndAllTrials(trialInd,1));
        eccentricitySac(trialInd)=sqrt(saccadeEndAllTrials(trialInd,1)^2+saccadeEndAllTrials(trialInd,2)^2)/pixperdeg;
    end
    uniqueFreqConds=unique(freqAllTrials);
    for freqInd=1:length(uniqueFreqConds)
        freqIndTrials=find(freqAllTrials==uniqueFreqConds(freqInd));
        meanEccentricity(freqInd)=mean(freqIndTrials);
        stdEccentricity(freqInd)=std(freqIndTrials);
    end
    subplot(2,ceil(length(dates)/2),subplotInd);
    errorbar(uniqueFreqConds,meanEccentricity,stdEccentricity);
    title(['e',num2str(electrodeAllTrials(1)),' a',num2str(arrayAllTrials(1))]);
    subplotInd=subplotInd+1;
end

%Lick data (varying number of pulses)
dates=[{'010719_B5'} {'010719_B9'} {'010719_B11'} {'020719_B4'} {'020719_B7'} {'020719_B9'}];% {''} {''} {''}
figure;
hold on
subplotInd=1;
for dateInd=1:length(dates)
    meanEccentricity=[];
    stdEccentricity=[];
    date=[dates{dateInd}];
    load([rootdir,date,'\saccade_endpoints_',date,'.mat']);
    load([rootdir,date,'\saccade_data_',date,'_fix_to_rew.mat'],'numPulsesAllTrials');
    for trialInd=1:length(electrodeAllTrials)
        polarAngleSac(trialInd)=atan2(-saccadeEndAllTrials(trialInd,2),saccadeEndAllTrials(trialInd,1));
        eccentricitySac(trialInd)=sqrt(saccadeEndAllTrials(trialInd,1)^2+saccadeEndAllTrials(trialInd,2)^2)/pixperdeg;
    end
    uniqueNumPulsesConds=unique(numPulsesAllTrials);
    for numPulsesInd=1:length(uniqueNumPulsesConds)
        numPulsesIndTrials=find(numPulsesAllTrials==uniqueNumPulsesConds(numPulsesInd));
        meanEccentricity(numPulsesInd)=mean(numPulsesIndTrials);
        stdEccentricity(numPulsesInd)=std(numPulsesIndTrials);
    end
    subplot(2,ceil(length(dates)/2),subplotInd);
    errorbar(uniqueNumPulsesConds,meanEccentricity,stdEccentricity);
    title(['e',num2str(electrodeAllTrials(1)),' a',num2str(arrayAllTrials(1))]);
    subplotInd=subplotInd+1;
end

%Aston data (varying frequency)
dates=[{'040319_B3'} {'040319_B8'} {'050319_B2'} {'050319_B4'} {'280619_B3'} {'010719_B2'}];
rootdir='X:\aston\';
figure;
hold on
subplotInd=1;
for dateInd=1:length(dates)
    meanEccentricity=[];
    stdEccentricity=[];
    date=[dates{dateInd},'_aston'];
    load([rootdir,date,'\saccade_endpoints_',date,'.mat']);
    load([rootdir,date,'\saccade_data_',date,'_fix_to_rew.mat'],'freqAllTrials');
    for trialInd=1:length(electrodeAllTrials)
        polarAngleSac(trialInd)=atan2(-saccadeEndAllTrials(trialInd,2),saccadeEndAllTrials(trialInd,1));
        eccentricitySac(trialInd)=sqrt(saccadeEndAllTrials(trialInd,1)^2+saccadeEndAllTrials(trialInd,2)^2)/pixperdeg;
    end
    uniqueFreqConds=unique(freqAllTrials);
    for freqInd=1:length(uniqueFreqConds)
        freqIndTrials=find(freqAllTrials==uniqueFreqConds(freqInd));
        meanEccentricity(freqInd)=mean(freqIndTrials);
        stdEccentricity(freqInd)=std(freqIndTrials);
    end
    subplot(2,ceil(length(dates)/2),subplotInd);
    errorbar(uniqueFreqConds,meanEccentricity,stdEccentricity);
    title(['e',num2str(electrodeAllTrials(1)),' a',num2str(arrayAllTrials(1))]);
    subplotInd=subplotInd+1;
end

%Aston data (varying number of pulses)
dates=[{'040319_B6'} {'040319_B9'} {'050319_B3'} {'050319_B5'} {'280619_B2'} {'280619_B4'} {'090719_B5'}];%{'040319_B5'} 
figure;
hold on
subplotInd=1;
for dateInd=1:length(dates)
    meanEccentricity=[];
    stdEccentricity=[];
    date=[dates{dateInd},'_aston'];
    load([rootdir,date,'\saccade_endpoints_',date,'.mat']);
    load([rootdir,date,'\saccade_data_',date,'_fix_to_rew.mat'],'numPulsesAllTrials');
    for trialInd=1:length(electrodeAllTrials)
        polarAngleSac(trialInd)=atan2(-saccadeEndAllTrials(trialInd,2),saccadeEndAllTrials(trialInd,1));
        eccentricitySac(trialInd)=sqrt(saccadeEndAllTrials(trialInd,1)^2+saccadeEndAllTrials(trialInd,2)^2)/pixperdeg;
    end
    uniqueNumPulsesConds=unique(numPulsesAllTrials);
    for numPulsesInd=1:length(uniqueNumPulsesConds)
        numPulsesIndTrials=find(numPulsesAllTrials==uniqueNumPulsesConds(numPulsesInd));
        meanEccentricity(numPulsesInd)=mean(numPulsesIndTrials);
        stdEccentricity(numPulsesInd)=std(numPulsesIndTrials);
    end
    subplot(2,ceil(length(dates)/2),subplotInd);
    errorbar(uniqueNumPulsesConds,meanEccentricity,stdEccentricity);
    title(['e',num2str(electrodeAllTrials(1)),' a',num2str(arrayAllTrials(1))]);
    subplotInd=subplotInd+1;
end