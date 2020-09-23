function plot_RFs_repo(RFx,RFy,goodSNR,arrayInds,channelInds,areaInds)
%Written by Xing 19/8/20
%Plots RF maps across 1024 channels

figure;
hold on;
scatter(0,0,'r','o','filled');%fix spot
colind = hsv(16);
colind(8,:)=[139/255 69/255 19/255];
plotCircles=1;
for i=1:length(goodSNR)
    channelRow=goodSNR(i);
    channelNum=channelInds(channelRow);
    arrayNum=arrayInds(channelRow);
    area=areaInds(channelRow);
    arrayCol=arrayNum;
    if area==1
        if plotCircles==1
            plot(RFx(channelRow),RFy(channelRow),'MarkerEdgeColor',colind(arrayCol,:),'Marker','o','MarkerSize',3,'MarkerFaceColor',colind(arrayCol,:));
        elseif plotCircles==0
            text(RFx(channelRow),RFy(channelRow),num2str(channelNum),'Color',colind(arrayCol,:));
        end
    elseif area==4
        if plotCircles==1
            plot(RFx(channelRow),RFy(channelRow),'MarkerEdgeColor',colind(arrayCol,:),'Marker','o','MarkerSize',3);
        elseif plotCircles==0
            text(RFx(channelRow),RFy(channelRow),num2str(channelNum),'Color',colind(arrayCol,:));
        end
    end
end
xlim([-50 250]);
ylim([-250 50]);
plot([0 0],[-250 200],'k:');
plot([-200 300],[0 0],'k:');
plot([-200 300],[200 -300],'k:');
pixPerDeg=26;
ellipse(2,2,0,0,[0.1 0.1 0.1]);
ellipse(4,4,0,0,[0.1 0.1 0.1]);
ellipse(6,6,0,0,[0.1 0.1 0.1]);
ellipse(8,8,0,0,[0.1 0.1 0.1]);
axis square;
set(gca,'XTick',[0 2 4 6 8 10]);
set(gca,'XTickLabel',{'0','2','4','6','8','10'});
set(gca,'YTick',[-6 -4 -2 0]);
set(gca,'YTickLabel',{'-6','-4','-2','0'});
titleText='all good channel RFs, SNR=2';
title(titleText);
for i=1:16
    text(8,-i*0.3,num2str(i),'Color',colind(i,:));
end

axis equal;
xlim([-10/pixPerDeg 220/pixPerDeg]);
ylim([-150/pixPerDeg 20/pixPerDeg]);