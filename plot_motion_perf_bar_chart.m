function plot_motion_perf_bar_chart
%Written by Xing 10/1/19.
%Loads performance (calculated across electrode sets), for 2 versions of
%motion task in Lick: with 3 electrodes per set, and 5 electrodes per set.
%Used in figure on results from motion task, for the paper.

%motion task with 3 phosphenes:
load('D:\data\results\behavioural_performance_all_sets_041217_10trials.mat')
meanPerfThree=mean(meanAllSetsPerfVisualBin(1:10))%average across first 10 trials
stdPerfThree=std(meanAllSetsPerfVisualBin(1:10));
%motion task with 5 phosphenes:
load('D:\data\results\behavioural_performance_all_sets_121217_10trials.mat')
meanPerfFive=mean(meanAllSetsPerfVisualBin(1:10))
stdPerfFive=std(meanAllSetsPerfVisualBin(1:10));

figure;
hold on
b=bar([meanPerfThree meanPerfFive],'FaceColor','flat');
errorbar([meanPerfThree meanPerfFive],[stdPerfThree stdPerfFive],'k','LineStyle','none');
b(1).FaceColor = [0.5 0.5 0.5];
b(2).FaceColor = [0.5 0.5 0.5];
b(1).FaceColor = [0 0 0];
b(2).FaceColor = [0 0 0];
set(gca,'XTick',1:2)
set(gca,'XTickLabel', {'3' '5'})
set(gca,'YTick',[0 0.5 1])
set(gca,'YTickLabel', {'0' '0.5' '1'})
xLimits=get(gca,'xlim');
txt=sprintf('%.2f',meanPerfThree);
text(1,0.95,txt)
txt=sprintf('%.2f',meanPerfFive);
text(2,0.95,txt)
xlim([0.2 2.8])
ylim([0 1])
hold on
plot([xLimits(1) xLimits(2)],[1/2 1/2],'k:');
title('mean performance across first 10 trials');
title('');
xlabel('number of electrodes');
ylabel('mean performance');
%041217_121217_motion_3_5_phosphenes_perf_10trials.eps
