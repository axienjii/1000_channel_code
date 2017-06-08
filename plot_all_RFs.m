function plot_all_RFs
%Written by Xing 31/5/17
%Plots RF centres and sizes of all 1000 channels (can select channel 
%inclusion based on SNR of MUA).

% channelRFs(channelInd,:)=[RF.centrex RF.centrey RF.sz RF.szdeg RF.ang RF.theta RF.ecc channelSNR(channelInd,:) horizontalRadius verticalRadius];

date='060617_B2';
speed = 250/1000; %this is speed in pixels per ms
bardur = 1; %duration in seconds
bardist = speed*bardur*1000;
%x & y co-ordinates of centre-point
x0 = 70;
y0 = -70;

sampFreq=30000;
stimDurms=1000;%in ms
stimDur=stimDurms/1000;%in seconds
preStimDur=300/1000;%length of pre-stimulus-onset period, in s
postStimDur=300/1000;%length of post-stimulus-offset period, in s
downsampleFreq=30;

%assign arrays according to layout on cortex:
V1MtLAtP=[7 1;0 0;0 0;6 2;6 1;5 2;5 1;4 2;1 1;1 2;1 3;2 1;2 2;3 1;3 2;4 1];
%locations of arrays, first columns gives their rank order from medial to more lateral, 
%and second column gives their rank order going from more anterior to more posterior
%V4 arrays are coded as 0.

channelRFs1000=[];
for instanceInd=1:8
    instanceName=['instance',num2str(instanceInd)];
    fileName=fullfile('D:\data',date,['RFs_',instanceName,'.mat']);
    load(fileName)
    channelRFs1000=[channelRFs1000;channelRFs];
end
SNRthreshold=1;
meanChannelSNR=mean(channelRFs1000(:,8:11),2);
goodInd=find(meanChannelSNR>=SNRthreshold);
badInd=find(meanChannelSNR<SNRthreshold);
length(goodInd)/1024

%calculate area of sweeping bar
leftEdge=x0-bardist/2;
rightEdge=x0+bardist/2;
topEdge=y0+bardist/2;
bottomEdge=y0-bardist/2;
XVEC1 = [leftEdge rightEdge rightEdge leftEdge leftEdge];
YVEC1 = [bottomEdge bottomEdge topEdge topEdge bottomEdge];

% %all channels
% figure
% scatter(0,0,'r','o');%fix spot
% scatter(channelRFs1000(:,1),channelRFs1000(:,2),'k','x');
% xlim([-100 300]);
% ylim([-300 100]);
% ax.XTick=[0 sampFreq*preStimDur/downsampleFreq sampFreq*(preStimDur+stimDur)/downsampleFreq];
% ax.XTickLabel={num2str(preStimDur*1000),'0',num2str(stimDurms)};
% title('all channel RFs');
% 
% %all channels
% figure
% scatter(0,0,'r','o');%fix spot
% scatter(channelRFs1000(:,1),channelRFs1000(goodInd,2),'k','x');
% scatter(channelRFs1000(:,1),channelRFs1000(badInd,2),'r','x');
% xlim([-100 300]);
% ylim([-300 100]);
% ax.XTick=[0 sampFreq*preStimDur/downsampleFreq sampFreq*(preStimDur+stimDur)/downsampleFreq];
% ax.XTickLabel={num2str(preStimDur*1000),'0',num2str(stimDurms)};
% title('all channel RFs');
% 
% %all channels
% figure
% hold on
% scatter(0,0,'r','o');%fix spot
% for i=1:length(goodInd)
%     scatter(channelRFs1000(goodInd(i),1),channelRFs1000(goodInd(i),2),'k','x');
%     ellipse(channelRFs1000(goodInd(i),12),channelRFs1000(goodInd(i),13),channelRFs1000(goodInd(i),1),channelRFs1000(goodInd(i),2));
% end
% for i=1:length(badInd)
%     scatter(channelRFs1000(badInd(i),1),channelRFs1000(badInd(i),2),'r','x');
% end
% xlim([-100 300]);
% ylim([-300 100]);
% %plot area of sweeping bar
% h = line(XVEC1,YVEC1,'LineWidth',2);
% set(h,'Color','k')
% xlim([0 200]);
% ylim([-200 0]);
% axis square
% ax.XTick=[0 sampFreq*preStimDur/downsampleFreq sampFreq*(preStimDur+stimDur)/downsampleFreq];
% ax.XTickLabel={num2str(preStimDur*1000),'0',num2str(stimDurms)};
% title('all channel RFs');
% 
%all channels
figure
hold on
scatter(0,0,'r','o');%fix spot
for i=1:length(goodInd)
    if i>64&&i<192%V4 RFs
        scatter(channelRFs1000(goodInd(i),1),channelRFs1000(goodInd(i),2),'b','x');
    else
        scatter(channelRFs1000(goodInd(i),1),channelRFs1000(goodInd(i),2),'k','x');
        %     ellipse(channelRFs1000(goodInd(i),12),channelRFs1000(goodInd(i),13),channelRFs1000(goodInd(i),1),channelRFs1000(goodInd(i),2));
    end
end
for i=1:length(badInd)
    scatter(channelRFs1000(badInd(i),1),channelRFs1000(badInd(i),2),'r','x');
end
xlim([-100 300]);
ylim([-300 100]);
h = line(XVEC1,YVEC1,'LineWidth',2);
set(h,'Color','k')
xlim([leftEdge-50 rightEdge+50]);
ylim([bottomEdge-50 topEdge+50]);
axis square
ax.XTick=[0 sampFreq*preStimDur/downsampleFreq sampFreq*(preStimDur+stimDur)/downsampleFreq];
ax.XTickLabel={num2str(preStimDur*1000),'0',num2str(stimDurms)};
title('all channel RFs');

%good channels only
figure
colormap(cool)
hold on
scatter(0,0,'r','o');%fix spot
% c = linspace(0.1,1,size(V1MtLAtP,1));
% c=[c' 1-c'+0.01 c'];
c = linspace(1,10,7);
for i=1:length(goodInd)
    channelNo=channelRFs1000(goodInd(i));
    arrayNum=ceil(i/64);
    if arrayNum==2||arrayNum==3%V4 arrays
%         scatter(channelRFs1000(goodInd(i),1),channelRFs1000(goodInd(i),2),'g','x');
    else
        scatter(channelRFs1000(goodInd(i),1),channelRFs1000(goodInd(i),2),[],c(V1MtLAtP(arrayNum,1)));
    end
%     ellipse(channelRFs1000(goodInd(i),12),channelRFs1000(goodInd(i),13),channelRFs1000(goodInd(i),1),channelRFs1000(goodInd(i),2));
end
for i=1:length(badInd)
%     scatter(channelRFs1000(badInd(i),1),channelRFs1000(badInd(i),2),'r','x');
end
xlim([-100 300]);
ylim([-300 100]);
%plot area of sweeping bar
h = line(XVEC1,YVEC1,'LineWidth',2);
set(h,'Color','k')
xlim([50 150]);
ylim([-150 -50]);
axis square
ax.XTick=[0 sampFreq*preStimDur/downsampleFreq sampFreq*(preStimDur+stimDur)/downsampleFreq];
ax.XTickLabel={num2str(preStimDur*1000),'0',num2str(stimDurms)};
title('all channel RFs');