function plot_saccades_high_medium_current_repo(monkey,saccEccHighCurrCompare,saccEccMedCurrCompare)
%Written by Xing 19/8/20
%Plots ecentricity of mean saccade end points (averaged across trials for
%each channel), to make a comparison of saccade eccentricities observed 
%between conditions with high and medium current amplitudes.

figure;
scatter(saccEccHighCurrCompare,saccEccMedCurrCompare,2,'ko');
hold on;
axis equal;
axis square;
set(gca,'XTick',[0 5]);
set(gca,'YTick',[0 5]);
dlm = fitlm(saccEccHighCurrCompare,saccEccMedCurrCompare,'Intercept',false);
xVals=0:5;
yVals=xVals*dlm.Coefficients.Estimate;%as calculated and returned in dlm.Coefficients
plot(xVals,yVals,'r-');
ylim([0 5]);
xlim([0 5]);
plot([0 5],[0 5],'k:');
%compare eccentricity of saccades for high vs low current with paired t-test
[h,p,ci,stats]=ttest(saccEccHighCurrCompare,saccEccMedCurrCompare);
sprintf([monkey,' , undershoot high-low current stats: t(',num2str(stats.df),') = ',num2str(stats.tstat),', p = %.4f'],p) 
title(['Monkey ',monkey]);