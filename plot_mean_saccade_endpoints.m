function plot_mean_saccade_endpoints
%Written by Xing 17/10/18. Plot mean saccade end points for each channel in
%one figure, either split into separate subplots (per channel), or combined
%into one figure. Uesd to examine whether mean saccade end points are
%consistent over time.
localDisk=1;
if localDisk==1
    rootdir='D:\data\';
elseif localDisk==0
    rootdir='X:\best\';
end

% date='161018_B3';
date='041018_B7';

comparePreviousChannels=1;
if comparePreviousChannels==1
    date='161018_B3';
end
switch(date)
    case '161018_B3'
        load(['D:\data\',date,'\saccade_endpoints_',date,'.mat'])
    case '041018_B7'
        load(['D:\data\',date,'\45_channels\saccade_endpoints_',date,'.mat'])
end
uniqueInd=unique([electrodeAllTrials arrayAllTrials],'rows','stable');
electrodeNums=uniqueInd(:,1);
arrayNums=uniqueInd(:,2);

if comparePreviousChannels==1
    date='041018_B7';
    load(['D:\data\',date,'\45_channels\saccade_endpoints_',date,'.mat'])
end

cols=[1 0 0;0 1 1;165/255 42/255 42/255;0 1 0;0 0 1;0 0 0;1 0 1;0.9 0.9 0;128/255 0 128/255];
arrays=8:16;
load(['D:\data\',date,'\',date(1:6),'_data\PAR.mat'])
Par.PixPerDeg=PixPerDeg;

figure;
for electrodeInd=1:length(electrodeNums)
    subplot(ceil(length(electrodeNums)/5),5,electrodeInd);hold on
    electrodeTrials=find(electrodeAllTrials==electrodeNums(electrodeInd));
    arrayTrials=find(arrayAllTrials==arrayNums(electrodeInd));
    arrayColInd=find(arrays==arrayNums(electrodeInd));
    uniqueElectrodeTrials=intersect(electrodeTrials,arrayTrials);
    meanX=nanmean(saccadeEndAllTrials(uniqueElectrodeTrials,1));
    meanY=nanmean(saccadeEndAllTrials(uniqueElectrodeTrials,2));
    plot(meanX,-meanY,'MarkerFaceColor',cols(arrayColInd,:),'MarkerEdgeColor',cols(arrayColInd,:),'Marker','o','MarkerSize',7);
    text(meanX+0.4,-meanY,num2str(electrodeNums(electrodeInd)),'FontSize',8,'Color',[0 0 0]);
    
    scatter(0,0,'r','o','filled');%fix spot
    %draw dotted lines indicating [0,0]
    plot([0 0],[-250 200],'k:');
    plot([-200 300],[0 0],'k:');
    plot([-200 300],[200 -300],'k:');
    ellipse(50,50,0,0,[0.1 0.1 0.1]);
    ellipse(100,100,0,0,[0.1 0.1 0.1]);
    ellipse(150,150,0,0,[0.1 0.1 0.1]);
    ellipse(200,200,0,0,[0.1 0.1 0.1]);
    text(sqrt(1000),-sqrt(1000),'2','FontSize',14,'Color',[0.7 0.7 0.7]);
    text(sqrt(4000),-sqrt(4000),'4','FontSize',14,'Color',[0.7 0.7 0.7]);
    text(sqrt(10000),-sqrt(10000),'6','FontSize',14,'Color',[0.7 0.7 0.7]);
    text(sqrt(18000),-sqrt(18000),'8','FontSize',14,'Color',[0.7 0.7 0.7]);
    axis equal
    xlim([-10 100]);
    ylim([-100 10]);
    if electrodeInd==1
        title('mean saccade endpoints');
    end
    for arrayInd=1:length(arrays)
        text(180,0-4*arrayInd,['array',num2str(arrays(arrayInd))],'FontSize',14,'Color',cols(arrayInd,:));
    end
    ax=gca;
    ax.XTick=[0 Par.PixPerDeg*2 Par.PixPerDeg*4 Par.PixPerDeg*6 Par.PixPerDeg*8];
    ax.XTickLabel={'0','2','4','6','8'};
    ax.YTick=[-Par.PixPerDeg*8 -Par.PixPerDeg*6 -Par.PixPerDeg*4 -Par.PixPerDeg*2 0];
    ax.YTickLabel={'-8','-6','-4','-2','0'};
end
set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
pathname=fullfile(rootdir,date,['mean_saccade_endpoints_dva_subplots_',date]);
print(pathname,'-dtiff');

figure;hold on
for electrodeInd=1:length(electrodeNums)
    electrodeTrials=find(electrodeAllTrials==electrodeNums(electrodeInd));
    arrayTrials=find(arrayAllTrials==arrayNums(electrodeInd));
    arrayColInd=find(arrays==arrayNums(electrodeInd));
    uniqueElectrodeTrials=intersect(electrodeTrials,arrayTrials);
    meanX=nanmean(saccadeEndAllTrials(uniqueElectrodeTrials,1));
    meanY=nanmean(saccadeEndAllTrials(uniqueElectrodeTrials,2));
    plot(meanX,-meanY,'MarkerFaceColor',cols(arrayColInd,:),'MarkerEdgeColor',cols(arrayColInd,:),'Marker','o','MarkerSize',7);
    text(meanX+0.4,-meanY,num2str(electrodeNums(electrodeInd)),'FontSize',8,'Color',[0 0 0]);
end
scatter(0,0,'r','o','filled');%fix spot
%draw dotted lines indicating [0,0]
plot([0 0],[-250 200],'k:');
plot([-200 300],[0 0],'k:');
plot([-200 300],[200 -300],'k:');
ellipse(50,50,0,0,[0.1 0.1 0.1]);
ellipse(100,100,0,0,[0.1 0.1 0.1]);
ellipse(150,150,0,0,[0.1 0.1 0.1]);
ellipse(200,200,0,0,[0.1 0.1 0.1]);
text(sqrt(1000),-sqrt(1000),'2','FontSize',14,'Color',[0.7 0.7 0.7]);
text(sqrt(4000),-sqrt(4000),'4','FontSize',14,'Color',[0.7 0.7 0.7]);
text(sqrt(10000),-sqrt(10000),'6','FontSize',14,'Color',[0.7 0.7 0.7]);
text(sqrt(18000),-sqrt(18000),'8','FontSize',14,'Color',[0.7 0.7 0.7]);
axis equal
xlim([-20 220]);
ylim([-200 15]);
title('mean saccade endpoints');
for arrayInd=1:length(arrays)
    text(180,0-4*arrayInd,['array',num2str(arrays(arrayInd))],'FontSize',14,'Color',cols(arrayInd,:));
end
ax=gca;
ax.XTick=[0 Par.PixPerDeg*2 Par.PixPerDeg*4 Par.PixPerDeg*6 Par.PixPerDeg*8];
ax.XTickLabel={'0','2','4','6','8'};
ax.YTick=[-Par.PixPerDeg*8 -Par.PixPerDeg*6 -Par.PixPerDeg*4 -Par.PixPerDeg*2 0];
ax.YTickLabel={'-8','-6','-4','-2','0'};
xlabel('x-coordinates (dva)')
ylabel('y-coordinates (dva)')
set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
pathname=fullfile(rootdir,date,['mean_saccade_endpoints_dva_',date]);
print(pathname,'-dtiff');
