function plot_all_RFs_mlap(folder)
%Written by Xing on 6/3/19
%Modified from plot_all_RFs.m function, to label arrays by their
%medial-lateral or anterior-posterior position on the cortex, for Bing. 

% date='best_260617-280617';
%assign arrays according to layout on cortex:
arrayMtLAtP=[7 1;2 1;1 1;6 2;6 1;5 2;5 1;4 2;1 1;1 2;1 3;2 1;2 2;3 1;3 2;4 1];%coding of arrays based on their medial-to-lateral and anterior-to-posterior location on the cortex
%locations of arrays, first columns gives their rank order from medial to more lateral, 
%and second column gives their rank order going from more anterior to more posterior
%V4 arrays are coded similarly.

%compile RF data across all 8 instances:
channelRFs1000=[];
for instanceInd=1:8
    instanceName=['instance',num2str(instanceInd)];
%     fileName=fullfile('D:\data',date,['RFs_',instanceName,'.mat']);
    fileName=fullfile(folder,['RFs_',instanceName,'.mat']);
    load(fileName)
    channelRFs1000=[channelRFs1000;channelRFs];
end
SNRthreshold=2;%signal-to-noise ratio. examined visually evoked responses 
%across channels and also the identities of channels that passed the
%threshold. selected threshold of 2 because it corresponds closely with
%observations of which channels had good signals during visual checks.  
meanChannelSNR=mean(channelRFs1000(:,8:11),2);
goodInd=find(meanChannelSNR>=SNRthreshold);
badInd=find(meanChannelSNR<SNRthreshold);
length(goodInd)/1024%proportion of channels with good SNR

%all good channels, colour-coded by eccentricity
plotMtLAtP=1;%select which axis to represent. 1: medial-lateral; 2: anterior-posterior
plotV1=1;%plot V1 RFs?
plotV4=0;%plot V4 RFs?
figure
hold on
scatter(0,0,'r','o','filled');%fix spot
if plotMtLAtP==1
    colind = cool(7);
    if plotV1==0
        colind=cool(2);
    end
elseif plotMtLAtP==2
    colind = winter(3);
end
goodArrays=1:16;
% goodArrays=[1 2 3 4 9 10 11 13 14 15 16];
% colind = hsv(11);
countV4=0;
for i=1:length(goodInd)
    channelRow=goodInd(i);
    instanceInd=ceil(channelRow/128);
    channelInd=mod(channelRow,128);
    if channelInd==0
        channelInd=128;
    end
    [channelNum,arrayNum,area]=electrode_mapping(instanceInd,channelInd);
    if plotMtLAtP==1
        arrayCol=arrayMtLAtP(find(goodArrays==arrayNum),1);%medial to lateral
    elseif plotMtLAtP==2
        arrayCol=arrayMtLAtP(find(goodArrays==arrayNum),2);%anterior to posterior
    end
    if strcmp(area,'V1')
        markerCol='k';%V1
    else
        markerCol='b';%V4
    end
    if channelRow>32&&channelRow<=96||channelRow>128&&channelRow<=128+32||channelRow>128*2-32&&channelRow<=128*2%V4 RFs
        countV4=countV4+1;
        if plotV4==1
            plot(channelRFs1000(goodInd(i),1),channelRFs1000(goodInd(i),2),'MarkerEdgeColor',colind(arrayCol,:),'Marker','o');
        end
    elseif plotV1==1
        plot(channelRFs1000(goodInd(i),1),channelRFs1000(goodInd(i),2),'MarkerEdgeColor',colind(arrayCol,:),'Marker','x');
        %     ellipse(channelRFs1000(goodInd(i),12),channelRFs1000(goodInd(i),13),channelRFs1000(goodInd(i),1),channelRFs1000(goodInd(i),2));
    end
end
xlim([-50 300]);
ylim([-200 50]);

%draw other features on RF plot
plot([0 0],[-250 200],'k:')%draw dotted lines indicating [0,0]
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
axis equal
set(gca,'XTick',[0 2*pixPerDeg 4*pixPerDeg 6*pixPerDeg 8*pixPerDeg 10*pixPerDeg]);
set(gca,'XTickLabel',{'0','2','4','6','8','10'});
set(gca,'YTick',[-6*pixPerDeg -4*pixPerDeg -2*pixPerDeg 0]);
set(gca,'YTickLabel',{'-6','-4','-2','0'});

if plotV4==0
    titleText=['all good V1 channel RFs, SNR=',num2str(SNRthreshold),', ',num2str(length(goodInd)-countV4),' channels'];
end
if plotV1==0
    titleText=['all good V4 channel RFs, SNR=',num2str(SNRthreshold),', ',num2str(countV4),' channels'];
end
if plotV1==1&&plotV4==1
    titleText=['all good channel RFs, SNR=',num2str(SNRthreshold),', ',num2str(length(goodInd)),' channels'];
end
title(titleText);
if plotMtLAtP==1&&plotV1==1
    for i=1:7
        text(210,-100-i*8,num2str(i),'Color',colind(i,:))
    end
    text(210,-100-1*8,'   medial','Color',colind(1,:))
    text(210,-100-7*8,'   lateral','Color',colind(7,:))
elseif plotMtLAtP==1&&plotV1==0
    for i=1:2
        text(210,-100-i*8,num2str(i),'Color',colind(i,:))
    end
    text(210,-100-1*8,'   medial','Color',colind(1,:))
    text(210,-100-2*8,'   lateral','Color',colind(2,:))
elseif plotMtLAtP==2
    for i=1:3
        text(210,-100-i*8,num2str(i),'Color',colind(i,:))
    end
    text(210,-100-1*8,'   anterior','Color',colind(1,:))
    text(210,-100-3*8,'   posterior','Color',colind(3,:))
end
