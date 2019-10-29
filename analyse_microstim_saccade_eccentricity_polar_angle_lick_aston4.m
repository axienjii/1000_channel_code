function analyse_microstim_saccade_eccentricity_polar_angle_lick_aston4(date,allInstanceInd)
%16/10/19
%Written by Xing, modified from analyse_microstim_saccade_eccentricity_polar_angle_lick_aston3.m, reads
%in saccade end location for each trial on a given date (e.g. 110917_B3)
%and calculates eccentricity and polar angle of saccade end point. Compares
%the values obtained for saccade end points with eccentricity and polar
%angle of RF locations, and generates figures for paper.

localDisk=0;
if localDisk==1
    rootdir='D:\data\';
    copyfile(['X:\best\',date(1:6),'_data'],[rootdir,date,'\',date(1:6),'_data']);
elseif localDisk==0
    rootdir='X:\best\';
end
load('D:\data\saccade_endpoints_210817_B2-290817_B42.mat')

cols=[1 0 0;0 1 1;165/255 42/255 42/255;0 1 0;0 0 1;0 0 0;1 0 1;0.9 0.9 0;128/255 0 128/255];
arrays=8:16;

figInd1=figure;hold on
pixperdeg=26;
load('D:\data\channel_area_mapping.mat')
for chInd=1:length(uniqueElectrodeList)
    array=uniqueArrayList(chInd);
    arrayColInd=find(arrays==array);
    electrode=uniqueElectrodeList(chInd);
    instance=ceil(array/2);
    temp1=find(channelNums(:,instance)==electrode);
    temp2=find(arrayNums(:,instance)==array);
    ind=intersect(temp1,temp2);
    load(['D:\data\best_260617-280617\RFs_instance',num2str(instance),'.mat']);
    RFx=channelRFs(ind,1);
    RFy=channelRFs(ind,2);
    polarAngleRF=atan2(RFy,RFx);
    eccentricityRF=sqrt(RFx^2+RFy^2)/pixperdeg;
    polarAngleSac=atan2(-meanY(chInd),meanX(chInd));
    eccentricitySac=sqrt(meanX(chInd)^2+meanY(chInd)^2)/pixperdeg;
    allPolarAngleRFs(chInd)=polarAngleRF;
    allEccentricityRFs(chInd)=eccentricityRF;
    allPolarAngleSacs(chInd)=polarAngleSac;
    allEccentricitySacs(chInd)=eccentricitySac;
end

%remove outliers
outliers1=find(allPolarAngleRFs<-2);
outliers2=find(allPolarAngleSacs<-2);
outliersPA1=union(outliers1,outliers2);

outliers1=find(allPolarAngleRFs>1);
outliers2=find(allPolarAngleSacs>1);
outliersPA2=union(outliers1,outliers2);
outliersPA=union(outliersPA1,outliersPA2);

outliers1=find(allEccentricityRFs>10);
outliers2=find(allEccentricitySacs>10);
outliersEcc=union(outliers1,outliers2);

outliers=union(outliersPA,outliersEcc);
allEccentricityRFs(outliers)=[];
allEccentricitySacs(outliers)=[];
allPolarAngleRFs(outliers)=[];
allPolarAngleSacs(outliers)=[];
electrodeAllTrialsNoOutliers=uniqueElectrodeList;
electrodeAllTrialsNoOutliers(outliers)=[];
arrayAllTrialsNoOutliers=uniqueArrayList;
arrayAllTrialsNoOutliers(outliers)=[];

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
% xlabel('RF polar angle (deg)');
% ylabel('Saccade end point polar angle');
% ylabel('Saccade polar angle (deg)');
% h1 = lsline(ax1);
% h1.Color = 'r';
ax=gca;
ax.XTick=[0 50 100];
ax.XTickLabel={'0','50','100'};
ax.YTick=[0 50 100];
ax.YTickLabel={'0','50','100'};
dlm = fitlm(-rad2deg(allPolarAngleRFs),-rad2deg(allPolarAngleRFs),'Intercept',false);
xVals=0:100;
yVals=xVals*1;%as calculated and returned in dlm.Coefficients
plot(xVals,yVals,'r-');
xlim([0 100])
ylim([0 100])

figure(fig2)
subplot(1,2,1);
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
yVals=xVals*0.796224663810548;%as calculated and returned in dlm.Coefficients
plot(xVals,yVals,'r-');
xlim([0 10])
ylim([0 10])
[rhoPA,pPA]=corrcoef([-rad2deg(allPolarAngleRFs'),-rad2deg(allPolarAngleSacs')],'rows','pairwise')%r=0.72; p<0.01
[rhoEc,pEc]=corrcoef([allEccentricityRFs',allEccentricitySacs'],'rows','pairwise')%r=0.81; p<.001
Rvalue=rhoPA(2);
pval=pPA(2);
df=length(allPolarAngleRFs)-2;
sprintf(['Lick, polar angle: r(',num2str(df),') = ',num2str(Rvalue),', p = %.4f'],pval) 

Rvalue=rhoEc(2);
pval=pEc(2);
df=length(allEccentricityRFs)-2;
sprintf(['Lick, eccentricity: r(',num2str(df),') = ',num2str(Rvalue),', p = %.4f'],pval) 

%plot figure of mean saccade end points, with same colour scheme as RF maps
figure;
hold on
colind = hsv(16);
colind(8,:)=[139/255 69/255 19/255];
for i=1:length(meanX)
    plot(meanX(i),-meanY(i),'MarkerEdgeColor',colind(uniqueArrayList(i),:),'Marker','o','MarkerFaceCol',colind(uniqueArrayList(i),:),'MarkerSize',3);
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

load('D:\aston_data\saccade_endpoints_110918_B3_aston-201118_B8.mat')
localDisk=0;
if localDisk==1
    rootdir='D:\data\';
    copyfile(['X:\aston\',date(1:6),'_data'],[rootdir,date,'\',date(1:6),'_data']);
elseif localDisk==0
    rootdir='X:\aston\';
end
cols=[1 0 0;0 1 1;165/255 42/255 42/255;0 1 0;0 0 1;0 0 0;1 0 1;0.9 0.9 0;128/255 0 128/255];
arrays=8:16;

figure;hold on
pixperdeg=26;
load('D:\aston_data\channel_area_mapping_aston.mat')
for chInd=1:length(uniqueElectrodeList)
    array=uniqueArrayList(chInd);
    arrayColInd=find(arrays==array);
    electrode=uniqueElectrodeList(chInd);
    instance=ceil(array/2);
    temp1=find(channelNums(:,instance)==electrode);
    temp2=find(arrayNums(:,instance)==array);
    ind=intersect(temp1,temp2);
    load(['D:\aston_data\best_aston_280818-290818\RFs_instance',num2str(instance),'.mat']);
    RFx=channelRFs(ind,1);
    RFy=channelRFs(ind,2);
    polarAngleRF=atan2(RFy,RFx);
    eccentricityRF=sqrt(RFx^2+RFy^2)/pixperdeg;
    polarAngleSac=atan2(-meanY(chInd),meanX(chInd));
    eccentricitySac=sqrt(meanX(chInd)^2+meanY(chInd)^2)/pixperdeg;
    allPolarAngleRFs(chInd)=polarAngleRF;
    allEccentricityRFs(chInd)=eccentricityRF;
    allPolarAngleSacs(chInd)=polarAngleSac;
    allEccentricitySacs(chInd)=eccentricitySac;
    if isnan(eccentricitySac)
        pauseHere=1;
    end
end
nanIndPolarAngleRFs=find(isnan(allPolarAngleRFs));
nanIndEccentricityRFs=find(isnan(allEccentricityRFs));
nanIndPolarAngleSacs=find(isnan(allPolarAngleSacs));
nanIndEccentricitySacs=find(isnan(allEccentricitySacs));
nanRemove=unique([nanIndPolarAngleRFs nanIndEccentricityRFs nanIndPolarAngleSacs nanIndEccentricitySacs]);
allPolarAngleRFs(nanRemove)=[];
allEccentricityRFs(nanRemove)=[];
allPolarAngleSacs(nanRemove)=[];
allEccentricitySacs(nanRemove)=[];
%remove outliers
outliers1=find(allPolarAngleRFs<-2);
outliers2=find(allPolarAngleSacs<-2);
outliersPA1=union(outliers1,outliers2);

outliers1=find(allPolarAngleRFs>2);
outliers2=find(allPolarAngleSacs>2);
outliersPA2=union(outliers1,outliers2);
outliersPA=union(outliersPA1,outliersPA2);

outliers1=find(allEccentricityRFs>8);
outliers2=find(allEccentricitySacs>8);
outliersEcc=union(outliers1,outliers2);

outliers=union(outliersPA,outliersEcc);
allEccentricityRFs(outliers)=[];
allEccentricitySacs(outliers)=[];
allPolarAngleRFs(outliers)=[];
allPolarAngleSacs(outliers)=[];
electrodeAllTrialsNoOutliers=uniqueElectrodeList;
electrodeAllTrialsNoOutliers(outliers)=[];
arrayAllTrialsNoOutliers=uniqueArrayList;
arrayAllTrialsNoOutliers(outliers)=[];

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
set(gca,'XTick',[0 40 80])
set(gca,'YTick',[0 40 80])
% xlabel('RF polar angle (deg)');
% ylabel('Saccade end point polar angle');
% ylabel('Saccade polar angle (deg)');
% h1 = lsline(ax1);
% h1.Color = 'r';
dlm = fitlm(-rad2deg(allPolarAngleRFs),-rad2deg(allPolarAngleSacs),'Intercept',false);
xVals=-30:80;
yVals=xVals*0.841132470389613;%as calculated and returned in dlm.Coefficients
plot(xVals,yVals,'r-');
ylim([-10 80])
xlim([-10 80])

figure(fig2)
subplot(1,2,2);
axis equal
axis square
% xlabel('RF eccentricity (dva)');
% ylabel('Saccade end point eccentricity');
% ylabel('Saccade eccentricity (dva)');
ax=gca;
ax.XTick=[0 3 6];
ax.XTickLabel={'0','3','6'};
ax.YTick=[0 3 6];
ax.YTickLabel={'0','3','6'};
% h2 = lsline(ax2);
% h2.Color = 'r';
dlm = fitlm(allEccentricityRFs,allEccentricitySacs,'Intercept',false);
xVals=0:10;
yVals=xVals*0.689666659935434;%as calculated and returned in dlm.Coefficients
plot(xVals,yVals,'r-');
xlim([0 6])
ylim([0 6])
[rhoPA,pPA]=corrcoef([-rad2deg(allPolarAngleRFs'),-rad2deg(allPolarAngleSacs')],'rows','pairwise')%r=0.74; p<0.01
[rhoEc,pEc]=corrcoef([allEccentricityRFs',allEccentricitySacs'],'rows','pairwise')%r=0.63; p<.001
Rvalue=rhoPA(2);
pval=pPA(2);
df=length(allPolarAngleRFs)-2;
sprintf(['Aston, polar angle: r(',num2str(df),') = ',num2str(Rvalue),', p = %.4f'],pval) 

Rvalue=rhoEc(2);
pval=pEc(2);
df=length(allEccentricityRFs)-2;
sprintf(['Aston, eccentricity: r(',num2str(df),') = ',num2str(Rvalue),', p = %.4f'],pval) 

%plot figure of mean saccade end points, with same colour scheme as RF maps
figure;
hold on
for i=1:length(meanX)
    plot(meanX(i),-meanY(i),'MarkerEdgeColor',colind(uniqueArrayList(i),:),'Marker','o','MarkerFaceCol',colind(uniqueArrayList(i),:),'MarkerSize',3);
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

pause=1;