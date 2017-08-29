function plot_current_vs_impedance
%Written by Xing 25/8/17
%Load impedance values and current thresholds for channels on which
%microstim was delivered, check for any relationship.

load('D:\data\currentThresholds_250817.mat')
load('Y:\Xing\240817_data\array10.mat')
load('Y:\Xing\240817_data\array11.mat')
load('Y:\Xing\240817_data\array12.mat')
load('Y:\Xing\240817_data\array13.mat')
load('Y:\Xing\250817_data\array14.mat')

figure;hold on
arrays=[10 11 12 13 14];
for arrayInd=1:length(arrays)
    subplot(1,length(arrays)+1,arrayInd)
    evalText=['indCurrents=find(array',num2str(arrays(arrayInd)),'_currentThresholds~=0);'];
    eval(evalText);
    evalText=['goodCurrents=array',num2str(arrays(arrayInd)),'_currentThresholds(indCurrents);'];
    eval(evalText);
    evalText=['goodImpedances=array',num2str(arrays(arrayInd)),'(indCurrents,6);'];
    eval(evalText);
    plot(goodImpedances,goodCurrents,'ko');
    ylim([0 200])
end
xlabel('impedance (kOhms)');
ylabel('current threshold at 50%');

figure;hold on
allGoodImpedances=[];
allGoodCurrents=[];
cols='rgbkm';
for arrayInd=1:length(arrays)
    evalText=['indCurrents=find(array',num2str(arrays(arrayInd)),'_currentThresholds~=0);'];
    eval(evalText);
    evalText=['goodCurrents=array',num2str(arrays(arrayInd)),'_currentThresholds(indCurrents);'];
    eval(evalText);
    allGoodCurrents=[allGoodCurrents;goodCurrents];
    evalText=['goodImpedances=array',num2str(arrays(arrayInd)),'(indCurrents,6);'];
    eval(evalText);
    allGoodImpedances=[allGoodImpedances;goodImpedances];
    scatter(goodImpedances,goodCurrents,[],cols(arrayInd),'filled');
    text(80,170-4*arrayInd,['array',num2str(arrays(arrayInd))],'FontSize',14,'Color',cols(arrayInd));
end
xlabel('impedance (kOhms)');
ylabel('current threshold at 50% (uA)');
title(['current thresholds vs electrode impedances, colour-coded by array, N = ',num2str(length(allGoodCurrents))]);

figure;hold on
allRFx=[];
allRFy=[];
cols='rgbkm';
for arrayInd=1:length(arrays)
    evalText=['indCurrents=find(array',num2str(arrays(arrayInd)),'_currentThresholds~=0);'];
    eval(evalText);
    evalText=['RFx=array',num2str(arrays(arrayInd)),'(indCurrents,1);'];
    eval(evalText);
    allRFx=[allRFx;RFx];
    evalText=['RFy=array',num2str(arrays(arrayInd)),'(indCurrents,2);'];
    eval(evalText);
    allRFy=[allRFy;RFy];
    scatter(RFx,RFy,[],cols(arrayInd),'filled');
    text(80,170-4*arrayInd,['array',num2str(arrays(arrayInd))],'FontSize',14,'Color',cols(arrayInd));
end
xlabel('x-coordinates (pixels)');
ylabel('y-coordinates (pixels)');
title(['RF centres for channels with good current thresholds, colour-coded by array, N = ',num2str(length(allGoodCurrents))]);

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
xlim([-10 200]);
ylim([-160 10]);
