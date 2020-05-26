function analyse_microstim_saccade_combine_sessions_current_threshold3
%Written by Xing 25/5/20
%Calls function, 'analyse_microstim_saccade14_combine_sessions_read_current' to read in
%current amplitudes, for high and medium amplitude conditions.

% dates={
% % '180817_B2';
% % '180817_B3';
% % '180817_B4';
% % '180817_B5';
% % '180817_B7';
% % '180817_B8';
% '210817_B2-B4';
% '210817_B6-B21';
% '220817_B1-B11';
% '220817_B26-B39';
% '230817_B1-B19';
% '240817_B1-B16';
% '240817_B17-B27';
% '240817_B28-B38';
% '250817_B3-B30';
% '280817_B1-B31';
% '290817_B1-B42';
% '300817_B3-B9';
% '300817_B16-B27';
% '300817_B29-B37';
% '040917_B1-B7';
% '040917_B8-B17';
% '040917_B8-B41';
% '050917_B1-B12';
% '050917_B17-B40';
% '060917_B1-B24';
% '060917_B28-B36';
% '070917_B1-B5';
% '070917_B13'};
% % '110917_B3'};
% 
% % dates={
% %     '270917_B1';
% % '270917_B2';
% % '270917_B3';
% % '270917_B4';
% % '270917_B5';
% % '270917_B6';
% % '270917_B7';
% % '270917_B8';
% % '270917_B10';
% % '270917_B11';
% % '270917_B14';
% % '270917_B16';
% % '270917_B17';
% % '270917_B19';
% % '270917_B21';
% % '270917_B22';
% % '270917_B23';
% % '270917_B24';
% % '270917_B25';
% % '270917_B26';
% % };

% dates={
% '031017_B15';
% '031017_B16';
% '031017_B17';
% '041017_B6-B19';
% '051017_B1-B29';
% '091017_B8';
% '091017_B9';
% '091017_B10';
% '091017_B11';
% '101017_B1-B34';
% '101017_B43';
% '101017_B44';
% '101017_B45';
% '111017_B2-B5';
% '111017_B20-B22';
% '121017_B2-B13';
% '121017_B17-B21';
% '171017_B1-B14';
% '171017_B15-B17';
% '171017_B18-B19';
% '171017_B20-B47';
% '181017_B1-B15';
% '181017_B22-B25';
% '181017_B29-B32';
% '191017_B1-B26';
% '201017_B2-B24';
% '231017_B2-B6';
% '231017_B12-B14';
% '231017_B16-B36';
% '241017_B6-B14';
% '251017_B1-B13';
% '251017_B20-B41';
% '081117_B3-B29';
% '091117_B27-B30';
% '271117_B2-B24';
% '281117_B2-B10';
% '291117_B1-B6';
% '291117_B13-B43';
% '301117_B1-B13';
% '301117_B23-B43';
% '041217_B1-B18';
% '041217_B26-B31';
% '051217_B1-B6';
% '051217_B11';
% '061217_B1-B7';
% '071217_B1-B8';
% '071217_B10';
% '071217_B12';
% '081212_B1-B7';
% '121217_B1-B3';
% '131217_B3';
% '131217_B5-B8';
% '131217_B11';
% '141217_B1';
% '141217_B3';
% '151217_B1-B3';
% '181217_B2';
% '181217_B5';
% '181217_B13';
% '191217_B1';
% '191217_B3';
% '191217_B5';
% '191217_B7';
% '191217_B9';
% '201217_B1';
% '201217_B3';
% '211217_B2';
% '211217_BB5';
% '221217_B1';
% '221217_B5';
% '221217_B6'};


% dates={
% % '180817_B2';
% % '180817_B3';
% % '180817_B4';
% % '180817_B5';
% % '180817_B7';
% % '180817_B8';
% '210817_B2-B4';
% '210817_B6-B21';
% '220817_B1-B11';
% '220817_B26-B39';
% '230817_B1-B19';
% '240817_B1-B16';
% '240817_B17-B27';
% '240817_B28-B38';
% '250817_B3-B30';
% '280817_B1-B31';
% '290817_B1-B42';
% '300817_B3-B9';
% '300817_B16-B27';
% '300817_B29-B37';
% '040917_B1-B7';
% '040917_B8-B17';
% '040917_B8-B41';
% '050917_B1-B12';
% '050917_B17-B40';
% '060917_B1-B24';
% '060917_B28-B36';
% '070917_B1-B5';
% '070917_B13';
% '110917_B3';
% '270917_B1';
% '270917_B2';
% '270917_B3';
% '270917_B4';
% '270917_B5';
% '270917_B6';
% '270917_B7';
% '270917_B8';
% '270917_B10';
% '270917_B11';
% '270917_B14';
% '270917_B16';
% '270917_B17';
% '270917_B19';
% '270917_B21';
% '270917_B22';
% '270917_B23';
% '270917_B24';
% '270917_B25';
% '270917_B26';
% };

dates={
% '180817_B2';
% '180817_B3';
% '180817_B4';
% '180817_B5';
% '180817_B7';
% '180817_B8';
'210817_B2-B4';
'210817_B6-B21';
'220817_B1-B11';
'220817_B26-B39';
'230817_B1-B19';
'240817_B1-B16';
'240817_B17-B27';
'240817_B28-B38';
'250817_B3-B30';
'280817_B1-B31';
'290817_B1-B42';
'300817_B3-B9';
'300817_B16-B27';
'300817_B29-B37';
'040917_B1-B7';
'040917_B8-B17';
'040917_B8-B41';
'050917_B1-B12';
'050917_B17-B40';
'060917_B1-B24';
'060917_B28-B36';
'070917_B1-B5';
'070917_B13';
'110917_B3';
'270917_B1';
'270917_B2';
'270917_B3';
'270917_B4';
'270917_B5';
'270917_B6';
'270917_B7';
'270917_B8';
'270917_B10';
'270917_B11';
'270917_B14';
'270917_B16';
'270917_B17';
'270917_B19';
'270917_B21';
'270917_B22';
'270917_B23';
'270917_B24';
'270917_B25';
'270917_B26';
'031017_B15';
'031017_B16';
'031017_B17';
'041017_B6-B19';
'051017_B1-B29';
'091017_B8';
'091017_B9';
'091017_B10';
'091017_B11';
'101017_B1-B34';
'101017_B43';
'101017_B44';
'101017_B45';
'111017_B2-B5';
'111017_B20-B22';
'121017_B2-B13';
'121017_B17-B21';
'171017_B1-B14';
'171017_B15-B17';
'171017_B18-B19';
'171017_B20-B47';
'181017_B1-B15';
'181017_B22-B25';
'181017_B29-B32';
'191017_B1-B26';
'201017_B2-B24';
'231017_B2-B6';
'231017_B12-B14';
'231017_B16-B36';
'241017_B6-B14';
'251017_B1-B13';
'251017_B20-B41';
'081117_B3-B29';
'091117_B27-B30';
'271117_B2-B24';
'281117_B2-B10';
'291117_B1-B6';
'291117_B13-B43';
'301117_B1-B13';
'301117_B23-B43';
'041217_B1-B18';
'041217_B26-B31';
'051217_B1-B6';
'051217_B11';
'061217_B1-B7';
'071217_B1-B8';
'071217_B10';
'071217_B12';
'081212_B1-B7';
'121217_B1-B3';
'131217_B3';
'131217_B5-B8';
'131217_B11';
'141217_B1';
'141217_B3';
'151217_B1-B3';
'181217_B2';
'181217_B5';
'181217_B13';
'191217_B1';
'191217_B3';
'191217_B5';
'191217_B7';
'191217_B9';
'201217_B1';
'201217_B3';
'211217_B2';
'211217_BB5';
'221217_B1';
'221217_B5';
'221217_B6'};

% suprathresholdCurrent=0;%set to 1 to use conditions with high current amplitudes, with no hits accrued. Set to 0 to use conditions with lower current amplitudes instead
differentCriteria=0;
if differentCriteria==1%||suprathresholdCurrent==0
    ind=strfind(dates,'110917_B3');
    removeInd=find(not(cellfun('isempty',ind)));
    dates=dates([1:removeInd-1 removeInd+1:end]);
end

for dateInd=1:length(dates)
    date=dates{dateInd};
    hyphenInd=find(date=='-');
    if ~isempty(hyphenInd)
        bInd=find(date=='B');
        firstSessionNum=str2num(date(bInd(1)+1:hyphenInd-1));
        lastSessionNum=str2num(date(bInd(2)+1:end));
        sessionNums=firstSessionNum:lastSessionNum;
        for sessionInd=1:length(sessionNums)
            dates{dateInd,sessionInd}=[date(1:bInd(1)),num2str(sessionNums(sessionInd))];
        end
    end
end
datesReshape=reshape(dates,1,size(dates,1)*size(dates,2));
dates=datesReshape(~cellfun('isempty',datesReshape));

readData=0;
for suprathresholdCurrent=[0]
    extractCurrentOnly=1;
    calcThresholdList={};
    if readData==1
        for dateInd=1:length(dates)
            close all
            try
                if extractCurrentOnly==0
                    analyse_microstim_saccade14_combine_sessions(dates{dateInd},1,suprathresholdCurrent);
                    close all
                elseif extractCurrentOnly==1
                    calThresholdList=analyse_microstim_saccade14_combine_sessions_read_current(dates{dateInd},1,calcThresholdList);
                    close all
                end
            catch ME
                dates{dateInd}
            end
        end
    end
end

localDisk=0;
if localDisk==1
    rootdir='D:\data\';
elseif localDisk==0
    rootdir='X:\best\';
end
cols=[1 0 0;0 1 1;165/255 42/255 42/255;0 1 0;0 0 1;0 0 0;1 0 1;0.9 0.9 0;128/255 0 128/255];

cols = hsv(16);
cols(8,:)=[139/255 69/255 19/255];
arrays=8:16;
allPosIndXChs=[];
allPosIndYChs=[];
allMaxCurrentListAllTrials=[];
allMidCurrentListAllTrials=[];
figure;hold on
allElectrodeAllTrials=[];
allArrayAllTrials=[];
allElectrodeAllTrialsMax=[];
allArrayAllTrialsMax=[];
allElectrodeAllTrialsMid=[];
allArrayAllTrialsMid=[];
allProportionc50Max=[];
allProportionc50Mid=[];
for dateInd=1:length(dates)
    date=dates{dateInd};
    fileName=[rootdir,date,'\saccade_data_',date,'_fix_to_rew_max_amp.mat'];
%     if exist(fileName,'file')
%         load(fileName,'posIndXChs','posIndYChs','currentAmplitudeAllTrials','allElectrodeNumsList','allArrayNumsList');
%         allPosIndXChs=[allPosIndXChs posIndXChs];
%         allPosIndYChs=[allPosIndYChs posIndYChs];
%         if extractCurrentOnly==1
%             indRemove1=find(allElectrodeNumsList==0);
%             allElectrodeNumsList(indRemove1)=[];
%             allArrayNumsList(indRemove1)=[];
%         end
%         allElectrodeAllTrials=[allElectrodeAllTrials allElectrodeNumsList];
%         allArrayAllTrials=[allArrayAllTrials allArrayNumsList];
%         originalAllElectrodeNumsList=allElectrodeNumsList;
%         originalAllArraysNumList=allArrayNumsList;
%         originalElectrodesArrays=[allElectrodeNumsList' allArrayNumsList'];
        if extractCurrentOnly==1
            fileName=[rootdir,date,'\saccade_data_',date,'_fix_to_rew_max_amp_list.mat'];
            if exist(fileName,'file')
                load(fileName);
                %                        pauseHere=1;
                indRemove1=find(allElectrodeNumsMax==0);
                if ~isempty(indRemove1)
                    allElectrodeNumsMax(indRemove1)=[];
                    allArrayNumsMax(indRemove1)=[];
                end
                %                 if suprathresholdCurrent==1
                %                     if exist('proportionc50Max','var')
                if length(allElectrodeNumsMax)==length(allMaxCurrentList)%&&length(allElectrodeNumsList)==length(proportionc50Max)
                    %                             proportionc50Max(indRemove1)=[];
                    maxElectrodesArrays=[allElectrodeNumsMax' allArrayNumsMax'];
                    if ~isempty(indRemove1)
                        allMaxCurrentList(indRemove1)=[];
                    end
%                     [temp indOri uniqueInd]=intersect(originalElectrodesArrays,maxElectrodesArrays,'rows','stable');
                    allMaxCurrentListAllTrials=[allMaxCurrentListAllTrials allMaxCurrentList];
                    allElectrodeAllTrialsMax=[allElectrodeAllTrialsMax allElectrodeNumsMax];
                    allArrayAllTrialsMax=[allArrayAllTrialsMax allArrayNumsMax];
%                     allMaxCurrentListAllTrials=[allMaxCurrentListAllTrials allMaxCurrentList(uniqueInd)];
%                     allElectrodeAllTrialsMax=[allElectrodeAllTrialsMax allElectrodeNumsMax(uniqueInd)];
%                     allArrayAllTrialsMax=[allArrayAllTrialsMax allArrayNumsMax(uniqueInd)];
                    %                             allProportionc50Max=[allProportionc50Max proportionc50Max(uniqueInd)];
                end
            end
            %                     end
            %                 elseif suprathresholdCurrent==0
            fileName=[rootdir,date,'\saccade_data_',date,'_fix_to_rew_mid_amp_list.mat'];
            if exist(fileName,'file')
                load(fileName);
                indRemove1=find(allElectrodeNumsMid==0);
                if ~isempty(indRemove1)
                    allElectrodeNumsMid(indRemove1)=[];
                    allArrayNumsMid(indRemove1)=[];
                end
                %                     if exist('proportionc50Mid','var')
                if length(allElectrodeNumsMid)==length(allMidCurrentList)%&&length(allElectrodeNumsList)==length(proportionc50Mid)
                    %                             proportionc50Mid(indRemove1)=[];
                    minElectrodesArrays=[allElectrodeNumsMid' allArrayNumsMid'];
                    if ~isempty(indRemove1)
                        allMidCurrentList(indRemove1)=[];
                    end
%                     [temp indOri uniqueInd]=intersect(originalElectrodesArrays,minElectrodesArrays,'rows','stable');
                    allMidCurrentListAllTrials=[allMidCurrentListAllTrials allMidCurrentList];
                    allElectrodeAllTrialsMid=[allElectrodeAllTrialsMid allElectrodeNumsMid];
                    allArrayAllTrialsMid=[allArrayAllTrialsMid allArrayNumsMid];
%                     allMidCurrentListAllTrials=[allMidCurrentListAllTrials allMidCurrentList(uniqueInd)];
%                     allElectrodeAllTrialsMid=[allElectrodeAllTrialsMid allElectrodeNumsMid(uniqueInd)];
%                     allArrayAllTrialsMid=[allArrayAllTrialsMid allArrayNumsMid(uniqueInd)];
                    %                             allProportionc50Mid=[allProportionc50Mid proportionc50Mid(uniqueInd)];
                end
                %                     end
                %                 end
            end
        end
%     end
end

if differentCriteria==1
    %include all trials for session 110917_B3 (supra-threshold current
    %amplitude; electrode identity interleaved from trial to trial):
    date='110917_B3';
    localDisk=0;
    if localDisk==1
        rootdir='D:\data\';
        copyfile(['X:\best\',date(1:6),'_data'],[rootdir,date,'\',date(1:6),'_data']);
    elseif localDisk==0
        rootdir='X:\best\';
    end
    dataDir=[rootdir,date,'\',date(1:6),'_data'];
    load(['X:\best\',date,'\saccade_endpoints_',date,'.mat'])
    allElectrodeAllTrials=[allElectrodeAllTrials electrodeAllTrials'];
    allArrayAllTrials=[allArrayAllTrials arrayAllTrials'];
    allPosIndXChs=[allPosIndXChs num2cell(saccadeEndAllTrials(:,1))'];
    allPosIndYChs=[allPosIndYChs num2cell(saccadeEndAllTrials(:,2))'];
end


% indRemove=find(allElectrodeAllTrials==0);
% allElectrodeAllTrials(indRemove)=[];
% allArrayAllTrials(indRemove)=[];
% allPosIndXChs(indRemove)=[];
% allPosIndYChs(indRemove)=[];
% uniqueInd=unique([allElectrodeAllTrials' allArrayAllTrials'],'rows','stable');
% electrodeNums=uniqueInd(:,1);
% arrayNums=uniqueInd(:,2);

%load in previous channel and array numbers, for reference:
load('D:\data\saccade_endpoints_210817_B2-290817_B42_max_amp.mat');
uniqueElectrodeListMax=uniqueElectrodeList;
uniqueArrayListMax=uniqueArrayList;
channelIDsMax=[uniqueElectrodeListMax' uniqueArrayListMax'];
load('D:\data\saccade_endpoints_210817_B2-290817_B42_mid_amp.mat');
uniqueElectrodeListMid=uniqueElectrodeList;
uniqueArrayListMid=uniqueArrayList;
channelIDsMid=[uniqueElectrodeListMid' uniqueArrayListMid'];
%find intersecting channels, from high and medium current conditions
[intersectRows indMax indMid]=intersect(channelIDsMax,channelIDsMid,'rows');

% channelIDsMax=[allElectrodeAllTrialsMax' allArrayAllTrialsMax'];
% channelIDsMid=[allElectrodeAllTrialsMid' allArrayAllTrialsMid'];
% [intersectRows indMax indMid]=intersect(channelIDsMax,channelIDsMid,'rows');
electrodeNums=intersectRows(:,1);
arrayNums=intersectRows(:,2);
for uniqueElectrode=1:length(electrodeNums)
    uniqueElectrodeList(uniqueElectrode)=electrodeNums(uniqueElectrode);
    uniqueArrayList(uniqueElectrode)=arrayNums(uniqueElectrode);
%     if suprathresholdCurrent==1
        temp1=find(allElectrodeAllTrialsMax==electrodeNums(uniqueElectrode));
        temp2=find(allArrayAllTrialsMax==arrayNums(uniqueElectrode));
        ind=intersect(temp1,temp2);
        allMaxCurrentUnique(uniqueElectrode)={allMaxCurrentListAllTrials(ind)};
%         allProportionc50MaxUnique(uniqueElectrode)={allProportionc50Max(ind)};
%     elseif suprathresholdCurrent==0
        temp1=find(allElectrodeAllTrialsMid==electrodeNums(uniqueElectrode));
        temp2=find(allArrayAllTrialsMid==arrayNums(uniqueElectrode));
        ind=intersect(temp1,temp2);
        allMidCurrentUnique(uniqueElectrode)={allMidCurrentListAllTrials(ind)};
%         allProportionc50MidUnique(uniqueElectrode)={allProportionc50Mid(ind)};
%     end
end

%load lowest current threshold values:
load('D:\data\meanThresholds_Lick.mat')
% load('D:\data\lowestThresholds_Lick.mat')
for chInd=1:length(intersectRows)
    temp1=find(lickMeanThresholds(:,2)==intersectRows(chInd,1));
    temp2=find(lickMeanThresholds(:,1)==intersectRows(chInd,2));
    ind=intersect(temp1,temp2);
    if ~isempty(ind)
        thresholdFinal(chInd)=lickMeanThresholds(ind,3);
    end
end
for chInd=1:length(electrodeNums)
    if ~isempty(allMaxCurrentUnique)&&~isempty(allMidCurrentUnique)
       meanMax(chInd)=mean(allMaxCurrentUnique{chInd}); 
       meanMid(chInd)=mean(allMidCurrentUnique{chInd}); 
%        meanProportionc50Max(chInd)=mean(allProportionc50MaxUnique{chInd}); 
%        meanProportionc50Mid(chInd)=mean(allProportionc50MidUnique{chInd}); 
    end
end

%remove channel(s) where no threshold obtained:
removeInd=find(thresholdFinal==0);
thresholdFinal(removeInd)=[];
meanMax(removeInd)=[];
meanMid(removeInd)=[];
proportionC50Max=meanMax./thresholdFinal;
proportionC50Mid=meanMid./thresholdFinal;

grandMeanProportionc50Max=nanmean(proportionC50Max)
grandStdProportionc50Max=nanstd(proportionC50Max)
grandMeanProportionc50Mid=nanmean(proportionC50Mid)
grandStdProportionc50Mid=nanstd(proportionC50Mid)

proportion=meanMid./meanMax;
meanProportion=nanmean(proportion);
stdProportion=nanstd(proportion);
