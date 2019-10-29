function analyse_microstim_saccade_combine_sessions_current_thresholding
%Written by Xing 10/10/19
%Calls function, 'analyse_microstim_saccade14_combine_sessions' to extract
%eye position data and calculate saccade end points, for current
%thresholding sessions. Calculates mean saccade end point across trials for
%each channel, and plots mean saccade end point in figure.

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

suprathresholdCurrent=1;%set to 1 to use conditions with high current amplitudes, with no hits accrued. Set to 0 to use conditions with lower current amplitudes instead
differentCriteria=0;
if differentCriteria==1||suprathresholdCurrent==0
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
if readData==1
    for dateInd=1:length(dates)
        try
            analyse_microstim_saccade14_combine_sessions(dates{dateInd},1,suprathresholdCurrent);
            close all
        catch ME
            dates{dateInd}
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
allElectrodeAllTrials=[];
allArrayAllTrials=[];
figure;hold on
for dateInd=1:length(dates)
    date=dates{dateInd};
    if suprathresholdCurrent==1
        fileName=[rootdir,date,'\saccade_data_',date,'_fix_to_rew_max_amp.mat'];
    elseif suprathresholdCurrent==0
        fileName=[rootdir,date,'\saccade_data_',date,'_fix_to_rew_mid_amp.mat'];
    end
    if exist(fileName,'file')
        load(fileName,'posIndXChs','posIndYChs','currentAmplitudeAllTrials','allElectrodeNumsList','allArrayNumsList');
        allPosIndXChs=[allPosIndXChs posIndXChs];
        allPosIndYChs=[allPosIndYChs posIndYChs];
        allElectrodeAllTrials=[allElectrodeAllTrials allElectrodeNumsList];
        allArrayAllTrials=[allArrayAllTrials allArrayNumsList];
    end
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

uniqueInd=unique([allElectrodeAllTrials' allArrayAllTrials'],'rows','stable');
electrodeNums=uniqueInd(:,1);
arrayNums=uniqueInd(:,2);
for uniqueElectrode=1:length(electrodeNums)
    temp1=find(allElectrodeAllTrials==electrodeNums(uniqueElectrode));
    temp2=find(allArrayAllTrials==arrayNums(uniqueElectrode));
    ind=intersect(temp1,temp2);
    uniqueElectrodeList(uniqueElectrode)=electrodeNums(uniqueElectrode);
    uniqueArrayList(uniqueElectrode)=arrayNums(uniqueElectrode);
    allPosIndXChsUnique(uniqueElectrode)={cell2mat(allPosIndXChs(ind))};
    allPosIndYChsUnique(uniqueElectrode)={cell2mat(allPosIndYChs(ind))};
end
indRemove=find(uniqueElectrodeList==0);
uniqueElectrodeList(indRemove)=[];
uniqueArrayList(indRemove)=[];
allPosIndXChsUnique(indRemove)=[];
allPosIndYChsUnique(indRemove)=[];
electrodeNums(indRemove)=[];
arrayNums(indRemove)=[];

for chNum=1:length(uniqueElectrodeList)
    if ~isempty(allPosIndXChsUnique{chNum})
        array=arrayNums(chNum);
        arrayColInd=find(arrays==array);
        meanX(chNum)=nanmean(allPosIndXChsUnique{chNum});
        meanY(chNum)=nanmean(allPosIndYChsUnique{chNum});
        plot(meanX(chNum),-meanY(chNum),'MarkerFaceColor',cols(array,:),'MarkerEdgeColor',cols(array,:),'Marker','o','MarkerSize',3);
    end
end
% save(['D:\data\saccade_endpoints_',dates{1},'-',dates{end},'.mat'],'uniqueElectrodeList','uniqueArrayList','allPosIndXChsUnique','allPosIndYChsUnique','meanX','meanY')
scatter(0,0,'r','o','filled');%fix spot
%draw dotted lines indicating [0,0]
plot([0 0],[-250 200],'k:');
plot([-200 300],[0 0],'k:');
plot([-200 300],[200 -300],'k:');
pixPerDeg=26;
ellipse(2*pixPerDeg,2*pixPerDeg,0,0,[0.1 0.1 0.1]);
ellipse(4*pixPerDeg,4*pixPerDeg,0,0,[0.1 0.1 0.1]);
ellipse(6*pixPerDeg,6*pixPerDeg,0,0,[0.1 0.1 0.1]);
ellipse(8*pixPerDeg,8*pixPerDeg,0,0,[0.1 0.1 0.1]);
axis equal
% xlim([-20 220]);
% ylim([-200 15]);
title('saccade endpoints');
for arrayInd=1:length(arrays)
%     text(180,0-4*arrayInd,['array',num2str(arrays(arrayInd))],'FontSize',14,'Color',cols(arrays(arrayInd),:));
end
xlabel('x-coordinates (dva)')
ylabel('y-coordinates (dva)')
ax=gca;
set(gca,'XTick',[0 2*pixPerDeg 4*pixPerDeg 6*pixPerDeg 8*pixPerDeg 10*pixPerDeg]);
set(gca,'XTickLabel',{'0','2','4','6','8','10'});
set(gca,'YTick',[-6*pixPerDeg -4*pixPerDeg -2*pixPerDeg 0]);
set(gca,'YTickLabel',{'-6','-4','-2','0'});
set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
pathname=fullfile(rootdir,date,['saccade_endpoints_dva_max_amp_',date]);
pathname=fullfile(rootdir,date,['saccade_endpoints_dva_mid_amp_',date]);
%         print(pathname,'-dtiff','-r600');
% ylim([-140 25]);
xlim([-10 220]);
ylim([-150 20]);
set(gca,'visible','off')

figure; 
hold on
for chNum=1:length(uniqueElectrodeList)
    if ~isempty(allPosIndXChsUnique{chNum})
        array=arrayNums(chNum);
        arrayColInd=find(arrays==array);
        for trialInd=1:length(allPosIndXChsUnique{chNum})
            plot(allPosIndXChsUnique{chNum}(trialInd),-allPosIndYChsUnique{chNum}(trialInd),'MarkerFaceColor',cols(array,:),'MarkerEdgeColor',cols(array,:),'Marker','o','MarkerSize',3);
        end
    end
end
scatter(0,0,'r','o','filled');%fix spot
%draw dotted lines indicating [0,0]
plot([0 0],[-250 200],'k:');
plot([-200 300],[0 0],'k:');
plot([-200 300],[200 -300],'k:');
pixPerDeg=26;
ellipse(2*pixPerDeg,2*pixPerDeg,0,0,[0.1 0.1 0.1]);
ellipse(4*pixPerDeg,4*pixPerDeg,0,0,[0.1 0.1 0.1]);
ellipse(6*pixPerDeg,6*pixPerDeg,0,0,[0.1 0.1 0.1]);
ellipse(8*pixPerDeg,8*pixPerDeg,0,0,[0.1 0.1 0.1]);
axis equal
xlim([-20 220]);
ylim([-200 15]);
title('saccade endpoints');
for arrayInd=1:length(arrays)
    text(180,0-4*arrayInd,['array',num2str(arrays(arrayInd))],'FontSize',14,'Color',cols(arrays(arrayInd),:));
end
xlabel('x-coordinates (dva)')
ylabel('y-coordinates (dva)')
ax=gca;
set(gca,'XTick',[0 2*pixPerDeg 4*pixPerDeg 6*pixPerDeg 8*pixPerDeg 10*pixPerDeg]);
set(gca,'XTickLabel',{'0','2','4','6','8','10'});
set(gca,'YTick',[-6*pixPerDeg -4*pixPerDeg -2*pixPerDeg 0]);
set(gca,'YTickLabel',{'-6','-4','-2','0'});
set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
pause=1;