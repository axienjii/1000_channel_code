function analyse_microstim_mean_saccade_eccentricity_polar_angle_lick_aston(date,allInstanceInd)
%14/10/19
%Written by Xing, modified from analyse_microstim_saccade14_letter.m, reads
%in saccade end location for each trial on a given date (e.g. 110917_B3)
%and calculates eccentricity and polar angle of saccade end point. Compares
%the values obtained for saccade end points with eccentricity and polar
%angle of RF locations, and generates figures for paper.

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

cols=[1 0 0;0 1 1;165/255 42/255 42/255;0 1 0;0 0 1;0 0 0;1 0 1;0.9 0.9 0;128/255 0 128/255];
arrays=8:16;

figInd1=figure;hold on
if ~exist('goodArrays8to16','var')
    currentThresholdChs=126;
    load('X:\best\110917_B3\110917_B3_data\currentThresholdChs.mat')
end
pixperdeg=25.8601;
for trialInd=1:length(electrodeAllTrials)
    array=arrayAllTrials(trialInd);
    arrayColInd=find(arrays==array);
    electrode=electrodeAllTrials(trialInd);
    electrodeIndTemp1=find(goodArrays8to16(:,8)==electrode);
    electrodeIndTemp2=find(goodArrays8to16(:,7)==array);
    electrodeInd=intersect(electrodeIndTemp1,electrodeIndTemp2);
    impedance=goodArrays8to16(electrodeInd,6);
    %             RFx=goodArrays8to16(electrodeInd,1);
    %             RFy=goodArrays8to16(electrodeInd,2);
    RFx=goodArrays8to16(electrodeInd,1);
    RFy=goodArrays8to16(electrodeInd,2);
    polarAngleRF=atan2(RFy,RFx);
    eccentricityRF=sqrt(RFx^2+RFy^2)/pixperdeg;
    polarAngleSac=atan2(-saccadeEndAllTrials(trialInd,2),saccadeEndAllTrials(trialInd,1));
    eccentricitySac=sqrt(saccadeEndAllTrials(trialInd,1)^2+saccadeEndAllTrials(trialInd,2)^2)/pixperdeg;
    allPolarAngleRFs(trialInd)=polarAngleRF;
    allEccentricityRFs(trialInd)=eccentricityRF;
    allPolarAngleSacs(trialInd)=polarAngleSac;
    allEccentricitySacs(trialInd)=eccentricitySac;
end

%remove outliers:
outliers1=find(allPolarAngleRFs<-2);
outliers2=find(allPolarAngleSacs<-2);
outliersPA=union(outliers1,outliers2);

outliers1=find(allEccentricityRFs>10);
outliers2=find(allEccentricitySacs>10);
outliersEcc=union(outliers1,outliers2);

outliers=union(outliersPA,outliersEcc);
allEccentricityRFs(outliers)=[];
allEccentricitySacs(outliers)=[];
allPolarAngleRFs(outliers)=[];
allPolarAngleSacs(outliers)=[];
electrodeAllTrialsNoOutliers=electrodeAllTrials;
electrodeAllTrialsNoOutliers(outliers)=[];
arrayAllTrialsNoOutliers=arrayAllTrials;
arrayAllTrialsNoOutliers(outliers)=[];

[uniqueElectrodes,iB,iA]=unique([electrodeAllTrialsNoOutliers arrayAllTrialsNoOutliers],'rows');
for uniqueElectrodeCount=1:size(uniqueElectrodes,1)
    temp1=find(electrodeAllTrialsNoOutliers==uniqueElectrodes(uniqueElectrodeCount,1));
    temp2=find(arrayAllTrialsNoOutliers==uniqueElectrodes(uniqueElectrodeCount,2));
    trialInds=intersect(temp1,temp2);
    allEccentricityRFsMean(uniqueElectrodeCount)=allEccentricityRFs(trialInds(1));%RF properties remain the same across all trials for a given electrode
    allEccentricitySacsMean(uniqueElectrodeCount)=mean(allEccentricitySacs(trialInds));
    allEccentricitySacsStd(uniqueElectrodeCount)=std(allEccentricitySacs(trialInds));
    allPolarAngleRFsMean(uniqueElectrodeCount)=allPolarAngleRFs(trialInds(1));%RF properties remain the same across all trials for a given electrode
    allPolarAngleSacsMean(uniqueElectrodeCount)=mean(allPolarAngleSacs(trialInds));
    allPolarAngleSacsStd(uniqueElectrodeCount)=std(allPolarAngleSacs(trialInds));    
end

fig1=figure;
ax1=subplot(1,2,1);
scatter(-rad2deg(allPolarAngleRFsMean),-rad2deg(allPolarAngleSacsMean),2,'ko');hold on
fig2=figure;
ax2=subplot(1,2,1);
scatter(allEccentricityRFsMean,allEccentricitySacsMean,2,'ko');hold on

figure(fig1)
subplot(1,2,1);
axis equal
axis square
ylim([0 100])
% xlabel('RF polar angle (deg)');
% ylabel('Saccade end point polar angle');
% ylabel('Saccade polar angle (deg)');
% h1 = lsline(ax1);
% h1.Color = 'r';
dlm = fitlm(-rad2deg(allPolarAngleRFsMean),-rad2deg(allPolarAngleRFsMean),'Intercept',false);
xVals=0:100;
yVals=xVals*1;%as calculated and returned in dlm.Coefficients
plot(xVals,yVals,'r-');

figure(fig2)
subplot(1,2,1);
xlim([0 10])
axis equal
axis square
% xlabel('RF eccentricity (dva)');
% ylabel('Saccade end point eccentricity');
% ylabel('Saccade eccentricity (dva)');
ax=gca;
ax.XTick=[0 5 10];
ax.XTickLabel={'0','5','10'};
ax.YTick=[0 5 10];
ax.YTickLabel={'0','5','10'};
% h2 = lsline(ax2);
% h2.Color = 'r';
dlm = fitlm(allEccentricityRFsMean,allEccentricitySacsMean,'Intercept',false);
xVals=0:10;
yVals=xVals*0.967556131993876;%as calculated and returned in dlm.Coefficients
plot(xVals,yVals,'r-');
[rhoPA,pPA]=corrcoef([-rad2deg(allPolarAngleRFsMean'),-rad2deg(allPolarAngleSacsMean')],'rows','pairwise')%r=0.72; p<0.01
[rhoEc,pEc]=corrcoef([allEccentricityRFsMean',allEccentricitySacsMean'],'rows','pairwise')%r=0.81; p<.001
Rvalue=rhoPA(2);
pval=pPA(2);
df=length(allPolarAngleRFsMean)-2;
sprintf(['Lick, polar angle: r(',num2str(df),') = ',num2str(Rvalue),', p = %.4f'],pval) 

Rvalue=rhoEc(2);
pval=pEc(2);
df=length(allEccentricityRFsMean)-2;
sprintf(['Lick, eccentricity: r(',num2str(df),') = ',num2str(Rvalue),', p = %.4f'],pval) 

%plot figure saccade end points, with same colour scheme as RF maps
figure;
hold on
colind = hsv(16);
colind(8,:)=[139/255 69/255 19/255];
for i=1:size(saccadeEndAllTrials,1)
    plot(saccadeEndAllTrials(i,1),-saccadeEndAllTrials(i,2),'MarkerEdgeColor',colind(arrayAllTrials(i),:),'Marker','o','MarkerFaceCol',colind(arrayAllTrials(i),:),'MarkerSize',3);
end
scatter(0,0,'r','o','filled');%fix spot
plot([0 0],[-250 200],'k:')
plot([-200 300],[0 0],'k:')
plot([-200 300],[200 -300],'k:')
pixPerDeg=26;
ellipse(2*pixPerDeg,2*pixPerDeg,0,0,[0.1 0.1 0.1]);
ellipse(4*pixPerDeg,4*pixPerDeg,0,0,[0.1 0.1 0.1]);
ellipse(6*pixPerDeg,6*pixPerDeg,0,0,[0.1 0.1 0.1]);
ellipse(8*pixPerDeg,8*pixPerDeg,0,0,[0.1 0.1 0.1]);
% text(sqrt(1000),-sqrt(1000),'2','FontSize',14,'Color',[0.7 0.7 0.7]);
% text(sqrt(4000),-sqrt(4000),'4','FontSize',14,'Color',[0.7 0.7 0.7]);
% text(sqrt(10000),-sqrt(10000),'6','FontSize',14,'Color',[0.7 0.7 0.7]);
% text(sqrt(18000),-sqrt(18000),'8','FontSize',14,'Color',[0.7 0.7 0.7]);
% for i=1:16
%     text(220,-5-i*8,num2str(i),'Color',colind(i,:))
% end
axis equal
ylim([-170 30]);
xlim([-30 250]);
xlim([-10 250]);
ylim([-150 20]);
set(gca,'XTick',[0 2*pixPerDeg 4*pixPerDeg 6*pixPerDeg 8*pixPerDeg 10*pixPerDeg]);
set(gca,'XTickLabel',{'0','2','4','6','8','10'});
set(gca,'YTick',[-6*pixPerDeg -4*pixPerDeg -2*pixPerDeg 0]);
set(gca,'YTickLabel',{'-6','-4','-2','0'});
set(gca,'XTick',[]);
set(gca,'YTick',[]);
set(gca,'XTickLabel',[]);
set(gca,'YTickLabel',[]);
axis on
set(gca,'XColor','none')
set(gca,'YColor','none')
% titleText=['saccade end points, N=',num2str(size(saccadeEndAllTrials,1)),' trials'];
% title(titleText);
set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))

%Aston:
electrodeAllTrials=[];
arrayAllTrials=[];
saccadeEndAllTrials=[];
allEccentricityRFs=[];
allEccentricitySacs=[];
allPolarAngleRFs=[];
allPolarAngleSacs=[];
allEccentricityRFsMean=[];
allEccentricitySacsMean=[];
allPolarAngleRFsMean=[];
allPolarAngleSacsMean=[];
addCurrentThreshData=1;%set to 0 to only include data from saccade task with interleaved electrode identities and suprathreshold current amplitudes
%set to 1 to additionally include data from current thresholding sessions, for arrays 9 and 10

date='221018_B1_aston';%first recording session, suprathreshold current amplitudes, electrode identities interleaved across trials
localDisk=0;
if localDisk==1
    rootdir='D:\data\';
    copyfile(['X:\aston\',date(1:6),'_data'],[rootdir,date,'\',date(1:6),'_data']);
elseif localDisk==0
    rootdir='X:\aston\';
end
load(['X:\aston\',date,'\saccade_endpoints_',date,'.mat'])
electrodeAllTrials1=electrodeAllTrials;
arrayAllTrials1=arrayAllTrials;
saccadeEndAllTrials1=saccadeEndAllTrials;

date2='241018_B2_aston';%second recording session, suprathreshold current amplitudes, electrode identities interleaved across trials
localDisk=0;
if localDisk==1
    rootdir='D:\data\';
    copyfile(['X:\aston\',date2(1:6),'_data'],[rootdir,date2,'\',date2(1:6),'_data']);
elseif localDisk==0
    rootdir='X:\aston\';
end
load(['X:\aston\',date2,'\saccade_endpoints_',date2,'.mat'])
electrodeAllTrials2=electrodeAllTrials;
arrayAllTrials2=arrayAllTrials;
saccadeEndAllTrials2=saccadeEndAllTrials;

if addCurrentThreshData==1
    load('D:\aston_data\results\supplementary_chs_250918-280918.mat');%other recording sessions, during current thresholding task- selected trials with highest current amplitude and performance of 100%
    electrodeAllTrials=[electrodeAllTrials1;electrodeAllTrials2;electrodeAllTrials];
    arrayAllTrials=[arrayAllTrials1;arrayAllTrials2;arrayAllTrials];
    saccadeEndAllTrials=[saccadeEndAllTrials1;saccadeEndAllTrials2;saccadeEndAllTrials];
else
    electrodeAllTrials=[electrodeAllTrials1;electrodeAllTrials2];
    arrayAllTrials=[arrayAllTrials1;arrayAllTrials2];
    saccadeEndAllTrials=[saccadeEndAllTrials1;saccadeEndAllTrials2];
end

cols=[1 0 0;0 1 1;165/255 42/255 42/255;0 1 0;0 0 1;0 0 0;1 0 1;0.9 0.9 0;128/255 0 128/255];
arrays=8:16;

figure;hold on
currentThresholdChs=126;
load('X:\aston\221018_B1_aston\221018_data\currentThresholdChs8.mat')
pixperdeg=25.8601;
for trialInd=1:length(electrodeAllTrials)
    array=arrayAllTrials(trialInd);
    arrayColInd=find(arrays==array);
    electrode=electrodeAllTrials(trialInd);
    electrodeIndTemp1=find(goodArrays8to16(:,8)==electrode);
    electrodeIndTemp2=find(goodArrays8to16(:,7)==array);
    electrodeInd=intersect(electrodeIndTemp1,electrodeIndTemp2);
    impedance=goodArrays8to16(electrodeInd,6);
    RFx=goodArrays8to16(electrodeInd,1);
    RFy=goodArrays8to16(electrodeInd,2);
    polarAngleRF=atan2(RFy,RFx);
    eccentricityRF=sqrt(RFx^2+RFy^2)/pixperdeg;
    polarAngleSac=atan2(-saccadeEndAllTrials(trialInd,2),saccadeEndAllTrials(trialInd,1));
    eccentricitySac=sqrt(saccadeEndAllTrials(trialInd,1)^2+saccadeEndAllTrials(trialInd,2)^2)/pixperdeg;
    allPolarAngleRFs(trialInd)=polarAngleRF;
    allEccentricityRFs(trialInd)=eccentricityRF;
    allPolarAngleSacs(trialInd)=polarAngleSac;
    allEccentricitySacs(trialInd)=eccentricitySac;
    if isnan(eccentricitySac)
        pauseHere=1;
    end
end

%remove outliers:
outliers1=find(allPolarAngleRFs<-2);
outliers2=find(allPolarAngleSacs<-2);
outliersPA=union(outliers1,outliers2);

outliers1=find(allEccentricityRFs>10);
outliers2=find(allEccentricitySacs>10);
outliersEcc=union(outliers1,outliers2);

outliers=union(outliersPA,outliersEcc);
allPolarAngleRFs(outliers)=[];
allPolarAngleSacs(outliers)=[];
allEccentricityRFs(outliers)=[];
allEccentricitySacs(outliers)=[];
electrodeAllTrialsNoOutliers=electrodeAllTrials;
electrodeAllTrialsNoOutliers(outliers)=[];
arrayAllTrialsNoOutliers=arrayAllTrials;
arrayAllTrialsNoOutliers(outliers)=[];

[uniqueElectrodes,iB,iA]=unique([electrodeAllTrialsNoOutliers arrayAllTrialsNoOutliers],'rows');
for uniqueElectrodeCount=1:size(uniqueElectrodes,1)
    temp1=find(electrodeAllTrialsNoOutliers==uniqueElectrodes(uniqueElectrodeCount,1));
    temp2=find(arrayAllTrialsNoOutliers==uniqueElectrodes(uniqueElectrodeCount,2));
    trialInds=intersect(temp1,temp2);
    allEccentricityRFsMean(uniqueElectrodeCount)=allEccentricityRFs(trialInds(1));%RF properties remain the same across all trials for a given electrode
    allEccentricitySacsMean(uniqueElectrodeCount)=nanmean(allEccentricitySacs(trialInds));
    allEccentricitySacsStd(uniqueElectrodeCount)=nanstd(allEccentricitySacs(trialInds));
    allPolarAngleRFsMean(uniqueElectrodeCount)=allPolarAngleRFs(trialInds(1));%RF properties remain the same across all trials for a given electrode
    allPolarAngleSacsMean(uniqueElectrodeCount)=nanmean(allPolarAngleSacs(trialInds));
    allPolarAngleSacsStd(uniqueElectrodeCount)=nanstd(allPolarAngleSacs(trialInds));    
end

figure(fig1)
ax1=subplot(1,2,2);
scatter(-rad2deg(allPolarAngleRFsMean),-rad2deg(allPolarAngleSacsMean),2,'ko');hold on
figure(fig2)
ax2=subplot(1,2,2);
scatter(allEccentricityRFsMean,allEccentricitySacsMean,2,'ko');hold on
figure(fig1)
subplot(1,2,2);
axis equal
axis square
xlim([-20 80])
ylim([-20 80])
set(gca,'XTick',[0 40 80])
set(gca,'YTick',[0 40 80])
% xlabel('RF polar angle (deg)');
% ylabel('Saccade end point polar angle');
% ylabel('Saccade polar angle (deg)');
% h1 = lsline(ax1);
% h1.Color = 'r';
dlm = fitlm(-rad2deg(allPolarAngleRFsMean),-rad2deg(allPolarAngleSacsMean),'Intercept',false);
xVals=-30:80;
yVals=xVals*0.975605779328125;%as calculated and returned in dlm.Coefficients
plot(xVals,yVals,'r-');

figure(fig2)
subplot(1,2,2);
xlim([0 10])
ylim([0 10])
axis equal
axis square
% xlabel('RF eccentricity (dva)');
% ylabel('Saccade end point eccentricity');
% ylabel('Saccade eccentricity (dva)');
ax=gca;
ax.XTick=[0 5 10];
ax.XTickLabel={'0','5','10'};
ax.YTick=[0 5 10];
ax.YTickLabel={'0','5','10'};
% h2 = lsline(ax2);
% h2.Color = 'r';
dlm = fitlm(allEccentricityRFsMean,allEccentricitySacsMean,'Intercept',false);
xVals=0:10;
yVals=xVals*0.650754192749749;%as calculated and returned in dlm.Coefficients
plot(xVals,yVals,'r-');
[rhoPA,pPA]=corrcoef([-rad2deg(allPolarAngleRFsMean'),-rad2deg(allPolarAngleSacsMean')],'rows','pairwise')%r=0.74; p<0.01
[rhoEc,pEc]=corrcoef([allEccentricityRFsMean',allEccentricitySacsMean'],'rows','pairwise')%r=0.63; p<.001
Rvalue=rhoPA(2);
pval=pPA(2);
df=length(allPolarAngleRFsMean)-2;
sprintf(['Aston, polar angle: r(',num2str(df),') = ',num2str(Rvalue),', p = %.4f'],pval) 

Rvalue=rhoEc(2);
pval=pEc(2);
df=length(allEccentricityRFsMean)-2;
sprintf(['Aston, eccentricity: r(',num2str(df),') = ',num2str(Rvalue),', p = %.4f'],pval) 

if addCurrentThreshData==0
    %plot figure saccade end points, with same colour scheme as RF maps
    figure;
    hold on
    for i=1:size(saccadeEndAllTrials,1)
        plot(saccadeEndAllTrials(i,1),-saccadeEndAllTrials(i,2),'MarkerEdgeColor',colind(arrayAllTrials(i),:),'Marker','o','MarkerFaceCol',colind(arrayAllTrials(i),:),'MarkerSize',3);
    end
    scatter(0,0,'r','o','filled');%fix spot
    plot([0 0],[-250 200],'k:')
    plot([-200 300],[0 0],'k:')
    plot([-200 300],[200 -300],'k:')
    pixPerDeg=26;
    ellipse(2*pixPerDeg,2*pixPerDeg,0,0,[0.1 0.1 0.1]);
    ellipse(4*pixPerDeg,4*pixPerDeg,0,0,[0.1 0.1 0.1]);
    ellipse(6*pixPerDeg,6*pixPerDeg,0,0,[0.1 0.1 0.1]);
    ellipse(8*pixPerDeg,8*pixPerDeg,0,0,[0.1 0.1 0.1]);
    % text(sqrt(1000),-sqrt(1000),'2','FontSize',14,'Color',[0.7 0.7 0.7]);
    % text(sqrt(4000),-sqrt(4000),'4','FontSize',14,'Color',[0.7 0.7 0.7]);
    % text(sqrt(10000),-sqrt(10000),'6','FontSize',14,'Color',[0.7 0.7 0.7]);
    % text(sqrt(18000),-sqrt(18000),'8','FontSize',14,'Color',[0.7 0.7 0.7]);
    % for i=1:16
    %     text(220,-5-i*8,num2str(i),'Color',colind(i,:))
    % end
    axis equal
    xlim([-10 120]);
    ylim([-70 25]);
    set(gca,'XTick',[0 2*pixPerDeg 4*pixPerDeg 6*pixPerDeg 8*pixPerDeg 10*pixPerDeg]);
    set(gca,'XTickLabel',{'0','2','4','6','8','10'});
    set(gca,'YTick',[-6*pixPerDeg -4*pixPerDeg -2*pixPerDeg 0]);
    set(gca,'YTickLabel',{'-6','-4','-2','0'});
    set(gca,'XTick',[]);
    set(gca,'YTick',[]);
    set(gca,'XTickLabel',[]);
    set(gca,'YTickLabel',[]);
    axis on
    set(gca,'XColor','none')
    set(gca,'YColor','none')
    % titleText=['saccade end points, N=',num2str(size(saccadeEndAllTrials,1)),' trials'];
    % title(titleText);
    set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
    %next, call the function 'saccade_endpoints_aston_current_thresholding'
    %to add data from current thresholding session using different marker
    %symbols
end

pause=1;