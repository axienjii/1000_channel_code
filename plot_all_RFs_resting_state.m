function plot_all_RFs_resting_state
%Written by Xing 31/5/17
%Plots RF centres of all 1000 channels.

date='best_260617-280617';

channelRFs1000=[];
for instanceInd=1:8
    instanceName=['instance',num2str(instanceInd)];
    fileName=fullfile('D:\data',date,['RFs_',instanceName,'.mat']);
    load(fileName)
    channelRFs1000=[channelRFs1000;channelRFs];
end
SNRthreshold=2;
meanChannelSNR=mean(channelRFs1000(:,8:11),2);
goodInd=find(meanChannelSNR>=SNRthreshold);
badInd=find(meanChannelSNR<SNRthreshold);
length(goodInd)/1024

%all channels (for paper)
figure
hold on
scatter(0,0,'r','o','filled');%fix spot
colind = hsv(16);
colind(8,:)=[139/255 69/255 19/255];
arrayNums=[];
goodArrays=1:16;
plotCircles=1;
badQuadrant=[];
for i=1:length(goodInd)
    channelRow=goodInd(i);
    instanceInd=ceil(channelRow/128);
    channelInd=mod(channelRow,128);
    if channelInd==0
        channelInd=128;
    end
    [channelNum,arrayNum,area]=electrode_mapping(instanceInd,channelInd);
    arrayCol=find(goodArrays==arrayNum);
    arrayNums=[arrayNums arrayNum];
    if strcmp(area,'V1')
        markerCol='k';%V1
    else
        markerCol='b';%V4
    end
%     if channelRow>32&&channelRow<=96||channelRow>128&&channelRow<=128+32||channelRow>128*2-32&&channelRow<=128*2%V4 RFs
%         plot(channelRFs1000(goodInd(i),1),channelRFs1000(goodInd(i),2),'MarkerEdgeColor',markerCol,'Marker','o');
%     else
%         plot(channelRFs1000(goodInd(i),1),channelRFs1000(goodInd(i),2),'MarkerEdgeColor',markerCol,'Marker','x');
%         %     ellipse(channelRFs1000(goodInd(i),12),channelRFs1000(goodInd(i),13),channelRFs1000(goodInd(i),1),channelRFs1000(goodInd(i),2));
%     end
    if channelRFs1000(goodInd(i),1)<0||channelRFs1000(goodInd(i),2)>10
        if area=='V1'
            areaNum=1;
        elseif area=='V4'
            areaNum=4;
        end
        badQuadrant=[badQuadrant;arrayNum channelNum areaNum instanceInd channelInd];
    end
    if area=='V1'
        areaNum=1;
        if plotCircles==1
            plot(channelRFs1000(goodInd(i),1),channelRFs1000(goodInd(i),2),'MarkerEdgeColor',colind(arrayCol,:),'Marker','o','MarkerSize',3,'MarkerFaceColor',colind(arrayCol,:));
        elseif plotCircles==0
            text(channelRFs1000(goodInd(i),1),channelRFs1000(goodInd(i),2),num2str(channelNum),'Color',colind(arrayCol,:));
        end
    elseif area=='V4'
        areaNum=4;
        if plotCircles==1
            plot(channelRFs1000(goodInd(i),1),channelRFs1000(goodInd(i),2),'MarkerEdgeColor',colind(arrayCol,:),'Marker','o','MarkerSize',3);
        elseif plotCircles==0
            text(channelRFs1000(goodInd(i),1),channelRFs1000(goodInd(i),2),num2str(channelNum),'Color',colind(arrayCol,:));
        end
    end
end
xlim([-100 300]);
ylim([-300 100]);
xlim([-50 250]);
ylim([-250 50]);
arrayNums=unique(arrayNums);
%draw dotted lines indicating [0,0]
plot([0 0],[-250 200],'k:')
plot([-200 300],[0 0],'k:')
plot([-200 300],[200 -300],'k:')
pixPerDeg=26;
ellipse(2*pixPerDeg,2*pixPerDeg,0,0,[0.1 0.1 0.1]);
ellipse(4*pixPerDeg,4*pixPerDeg,0,0,[0.1 0.1 0.1]);
ellipse(6*pixPerDeg,6*pixPerDeg,0,0,[0.1 0.1 0.1]);
ellipse(8*pixPerDeg,8*pixPerDeg,0,0,[0.1 0.1 0.1]);
text(sqrt(1000),-sqrt(1000),'2','FontSize',14,'Color',[0.7 0.7 0.7]);
text(sqrt(4000),-sqrt(4000),'4','FontSize',14,'Color',[0.7 0.7 0.7]);
text(sqrt(10000),-sqrt(10000),'6','FontSize',14,'Color',[0.7 0.7 0.7]);
text(sqrt(18000),-sqrt(18000),'8','FontSize',14,'Color',[0.7 0.7 0.7]);
xlim([leftEdge-50 rightEdge+50]);
ylim([bottomEdge-50 topEdge+50]);
axis square
set(gca,'XTick',[0 2*pixPerDeg 4*pixPerDeg 6*pixPerDeg 8*pixPerDeg 10*pixPerDeg]);
set(gca,'XTickLabel',{'0','2','4','6','8','10'});
set(gca,'YTick',[-6*pixPerDeg -4*pixPerDeg -2*pixPerDeg 0]);
set(gca,'YTickLabel',{'-6','-4','-2','0'});
titleText=['all good channel RFs, SNR=',num2str(SNRthreshold),', ',num2str(length(goodInd)),' channels'];
title(titleText);
for i=1:16
    text(220,-5-i*8,num2str(i),'Color',colind(i,:))
end
axis equal
xlim([-40 260]);
ylim([-170 30]);
xlim([-30 250]);
pathname=fullfile('D:\data\results\RFs_map_figure');
set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
% print(pathname,'-dtiff','-r600');

%all channels (for RF size)
figure
hold on
scatter(0,0,'r','o','filled');%fix spot
colind = hsv(16);
arrayNums=[];
goodArrays=1:16;
% goodArrays=[1 2 3 4 9 10 11 13 14 15 16];
% colind = hsv(11);
badQuadrant=[];
for i=1:length(goodInd)
    channelRow=goodInd(i);
    instanceInd=ceil(channelRow/128);
    channelInd=mod(channelRow,128);
    if channelInd==0
        channelInd=128;
    end
    [channelNum,arrayNum,area]=electrode_mapping(instanceInd,channelInd);
    arrayCol=find(goodArrays==arrayNum);
    arrayNums=[arrayNums arrayNum];
    if strcmp(area,'V1')
        markerCol='k';%V1
    else
        markerCol='b';%V4
    end
    if channelRFs1000(goodInd(i),1)<0||channelRFs1000(goodInd(i),2)>10
        if area=='V1'
            areaNum=1;
        elseif area=='V4'
            areaNum=4;
        end
        badQuadrant=[badQuadrant;arrayNum channelNum areaNum instanceInd channelInd];
    end
    if channelRow>32&&channelRow<=96||channelRow>128&&channelRow<=128+32||channelRow>128*2-32&&channelRow<=128*2
        plot(channelRFs1000(goodInd(i),1),channelRFs1000(goodInd(i),2),'MarkerEdgeColor',colind(arrayCol,:),'Marker','o','MarkerSize',3,'MarkerFaceColor',colind(arrayCol,:));%V4 RFs, unfilled circles
        ellipse(channelRFs1000(goodInd(i),12),channelRFs1000(goodInd(i),13),channelRFs1000(goodInd(i),1),channelRFs1000(goodInd(i),2),colind(arrayCol,:));
    else
        plot(channelRFs1000(goodInd(i),1),channelRFs1000(goodInd(i),2),'MarkerEdgeColor',colind(arrayCol,:),'Marker','o','MarkerSize',3,'MarkerFaceColor',colind(arrayCol,:));%V1 RFs, filled circles
        ellipse(channelRFs1000(goodInd(i),12),channelRFs1000(goodInd(i),13),channelRFs1000(goodInd(i),1),channelRFs1000(goodInd(i),2),colind(arrayCol,:));
    end
end
xlim([-100 300]);
ylim([-300 100]);
xlim([-50 250]);
ylim([-250 50]);
arrayNums=unique(arrayNums);
%draw dotted lines indicating [0,0]
plot([0 0],[-250 200],'k:')
plot([-200 300],[0 0],'k:')
pixPerDeg=26;
% ellipse(2*pixPerDeg,2*pixPerDeg,0,0,[0.1 0.1 0.1]);
% ellipse(4*pixPerDeg,4*pixPerDeg,0,0,[0.1 0.1 0.1]);
% ellipse(6*pixPerDeg,6*pixPerDeg,0,0,[0.1 0.1 0.1]);
% ellipse(8*pixPerDeg,8*pixPerDeg,0,0,[0.1 0.1 0.1]);
text(sqrt(1000),-sqrt(1000),'2','FontSize',14,'Color',[0.7 0.7 0.7]);
text(sqrt(4000),-sqrt(4000),'4','FontSize',14,'Color',[0.7 0.7 0.7]);
text(sqrt(10000),-sqrt(10000),'6','FontSize',14,'Color',[0.7 0.7 0.7]);
text(sqrt(18000),-sqrt(18000),'8','FontSize',14,'Color',[0.7 0.7 0.7]);
xlim([leftEdge-50 rightEdge+50]);
ylim([bottomEdge-50 topEdge+50]);
axis square
set(gca,'XTick',[-6*pixPerDeg -4*pixPerDeg -2*pixPerDeg 0 2*pixPerDeg 4*pixPerDeg 6*pixPerDeg 8*pixPerDeg 10*pixPerDeg]);
set(gca,'XTickLabel',{'-6','-4','-2','0','2','4','6','8','10'});
set(gca,'YTick',[-8*pixPerDeg -6*pixPerDeg -4*pixPerDeg -2*pixPerDeg 0 2*pixPerDeg 4*pixPerDeg 6*pixPerDeg]);
set(gca,'YTickLabel',{'-8','-6','-4','-2','0','2','4','6'});
titleText=['all good channel RFs, SNR=',num2str(SNRthreshold),', ',num2str(length(goodInd)),' channels'];
title(titleText);
for i=1:16
    text(220,100-i*8,num2str(i),'Color',colind(i,:))
end
axis equal
xlim([-100 300]);
ylim([-220 150]);
pathname=fullfile('D:\data\results\RFs_map_figure_RFsizes_all');
set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
print(pathname,'-dtiff','-r200');