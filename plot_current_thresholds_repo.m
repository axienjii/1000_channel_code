function plot_current_thresholds_repo(thresholds)
%Written by Xing 19/8/20
%Plots cumulative histograms of current thresholds across channels.

figure;
[counts bins]=histcounts(thresholds);
cdf=cumsum(counts);
binCentres=bins(2:end)-(bins(2)-bins(1))/2;
binCentresAdd=binCentres(end):(bins(2)-bins(1))/2:210;
binCentres=[binCentres(1:end-1) binCentresAdd];
cdf=[cdf cdf(end)*ones(1,length(binCentresAdd)-1)];
plot(binCentres,cdf/max(cdf),'Color',[0.5 0.5 0.5]);
sprintf(['mean threshold: ',num2str(mean(thresholds)),', std: ',num2str(std(thresholds)),', median: ',num2str(median(thresholds)),'IQR: ',num2str(iqr(thresholds))])
% mean(thresholds)
% std(thresholds)
% median(thresholds)
% iqr(thresholds)
xlabel('current threshold (uA)');
ylabel('count');
set(gca,'box','off');
axis square
xlim([0 110]);
set(gca,'XTick',[0 100 200]);
set(gca,'YTick',[0 150 300]);