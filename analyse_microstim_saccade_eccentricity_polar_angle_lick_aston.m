function analyse_microstim_saccade_eccentricity_polar_angle_lick_aston(date,allInstanceInd)
%8/1/19
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
outliers1=find(allEccentricityRFs>10);
outliers2=find(allEccentricitySacs>10);
outliers=union(outliers1,outliers2);
allEccentricityRFs(outliers)=[];
allEccentricitySacs(outliers)=[];

fig1=figure;
ax1=subplot(1,2,1);
scatter(-rad2deg(allPolarAngleRFs),-rad2deg(allPolarAngleSacs),2,'ko');hold on
fig2=figure;
ax2=subplot(1,2,1);
scatter(allEccentricityRFs,allEccentricitySacs,2,'ko');hold on

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
dlm = fitlm(-rad2deg(allPolarAngleRFs),-rad2deg(allPolarAngleRFs),'Intercept',false);
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
dlm = fitlm(allEccentricityRFs,allEccentricitySacs,'Intercept',false);
xVals=0:10;
yVals=xVals*0.967556131993876;%as calculated and returned in dlm.Coefficients
plot(xVals,yVals,'r-');
[rhoPA,pPA]=corrcoef([-rad2deg(allPolarAngleRFs'),-rad2deg(allPolarAngleSacs')],'rows','pairwise')%r=0.72; p<0.01
[rhoEc,pEc]=corrcoef([allEccentricityRFs',allEccentricitySacs'],'rows','pairwise')%r=0.81; p<.001

%Aston:
electrodeAllTrials=[];
arrayAllTrials=[];
saccadeEndAllTrials=[];
allEccentricityRFs=[];
allEccentricitySacs=[];
allPolarAngleRFs=[];
allPolarAngleSacs=[];

date='221018_B1_aston';
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

date2='241018_B2_aston';
localDisk=0;
if localDisk==1
    rootdir='D:\data\';
    copyfile(['X:\aston\',date2(1:6),'_data'],[rootdir,date2,'\',date2(1:6),'_data']);
elseif localDisk==0
    rootdir='X:\aston\';
end
load(['X:\aston\',date2,'\saccade_endpoints_',date2,'.mat'])
electrodeAllTrials=[electrodeAllTrials1;electrodeAllTrials];
arrayAllTrials=[arrayAllTrials1;arrayAllTrials];
saccadeEndAllTrials=[saccadeEndAllTrials1;saccadeEndAllTrials];

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
end

%remove outliers:
outliers1=find(allPolarAngleRFs<-2);
outliers2=find(allPolarAngleSacs<-2);
outliers=union(outliers1,outliers2);
allPolarAngleRFs(outliers)=[];
allPolarAngleSacs(outliers)=[];

outliers1=find(allEccentricityRFs>10);
outliers2=find(allEccentricitySacs>10);
outliers=union(outliers1,outliers2);
allEccentricityRFs(outliers)=[];
allEccentricitySacs(outliers)=[];

figure(fig1)
ax1=subplot(1,2,2);
scatter(-rad2deg(allPolarAngleRFs),-rad2deg(allPolarAngleSacs),2,'ko');hold on
figure(fig2)
ax2=subplot(1,2,2);
scatter(allEccentricityRFs,allEccentricitySacs,2,'ko');hold on
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
dlm = fitlm(-rad2deg(allPolarAngleRFs),-rad2deg(allPolarAngleSacs),'Intercept',false);
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
dlm = fitlm(allEccentricityRFs,allEccentricitySacs,'Intercept',false);
xVals=0:10;
yVals=xVals*0.650754192749749;%as calculated and returned in dlm.Coefficients
plot(xVals,yVals,'r-');
[rhoPA,pPA]=corrcoef([-rad2deg(allPolarAngleRFs'),-rad2deg(allPolarAngleSacs')],'rows','pairwise')%r=0.74; p<0.01
[rhoEc,pEc]=corrcoef([allEccentricityRFs',allEccentricitySacs'],'rows','pairwise')%r=0.63; p<.001

pause=1;