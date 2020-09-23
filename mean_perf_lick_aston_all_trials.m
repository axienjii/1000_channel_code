function mean_perf_lick_aston_all_trials
%Written on 27/3/20 by Xing. 
%sReads in performance across sessions and all
%three tasks for 2 monkeys, and calculates mean performance and SD.
%Replicates plotting of histograms and statistical testing using t-test, 
%that was carried out in the functions:
% analyse_microstim_2phosphene5_alltrials
% analyse_microstim_line_across_sess_2phosphenes_aston_alltrials
% analyse_microstim_motion_across_sessions_alltrials
% analyse_microstim_motion_across_sessions_aston_alltrials
% analyse_microstim_letter_across_sessions_alltrials
% analyse_microstim_letter_across_sessions_aston_alltrials

%Lick 2-phosphene task
rootdir='X:\best\';
perfMat=fullfile(rootdir,'behavioural_performance_all_sets_corrected_RFs_241017_all_trials.mat');
load(perfMat)

figure;
subplot(1,2,1);
edges=0:0.1:1;
h1=histogram(goodSetsallSetsPerfMicroAllTrials,edges);
h1(1).FaceColor = [1 0 0];
h1(1).EdgeColor = [0 0 0];
hold on
plot([0.5 0.5],[0 10],'k:');
xlim([0 1]);
ylim([0 8]);
set(gca,'Box','off');
ax=gca;
ax.YTick=[0 4 8];
[h,p,ci,stats]=ttest(goodSetsallSetsPerfMicroAllTrials,0.5)
sprintf(['t(',num2str(stats.df),') = ',num2str(stats.tstat),', p = %.4f'],p)%t(18) = 6.4583, p = 0.0000  %t(23) = 6.7987, p = 0.0000

figure;
subplot(1,2,1);
edges=0:0.1:1;
h1=histogram(goodSetsallSetsPerfVisualAllTrials,edges);
h1(1).FaceColor = [0 0 1];
h1(1).EdgeColor = [0 0 0];
hold on
plot([0.5 0.5],[0 10],'k:');
xlim([0 1]);
ylim([0 11]);
set(gca,'Box','off');
[h,p,ci,stats]=ttest(goodSetsallSetsPerfVisualAllTrials,0.5)
sprintf(['t(',num2str(stats.df),') = ',num2str(stats.tstat),', p = %.4f'],p)%t(18) = 14.6954, p = 0.0000  %t(23) = 16.5684, p = 0.0000
mean(goodSetsallSetsPerfMicroAllTrials)
std(goodSetsallSetsPerfMicroAllTrials)
length(goodSetsallSetsPerfMicroAllTrials)
mean(goodSetsallSetsPerfVisualAllTrials)
std(goodSetsallSetsPerfVisualAllTrials)
length(goodSetsallSetsPerfVisualAllTrials)

%Aston 2-phosphene task
perfMat=['D:\aston_data\behavioural_performance_first_sets_261118_all_trials_2phosphenes.mat'];
load(perfMat)

subplot(1,2,2);
edges=0:0.1:1;
h1=histogram(goodSetsallSetsPerfMicroAllTrials,edges);
h1(1).FaceColor = [1 0 0];
h1(1).EdgeColor = [0 0 0];
hold on
plot([0.5 0.5],[0 10],'k:');
xlim([0 1]);
ylim([0 5]);
set(gca,'Box','off');
ax=gca;
ax.YTick=[0 2 4];
[h,p,ci,stats]=ttest(goodSetsallSetsPerfMicroAllTrials,0.5)
sprintf(['t(',num2str(stats.df),') = ',num2str(stats.tstat),', p = %.4f'],p)%t(10) = 2.6107, p = 0.0260
mean(goodSetsallSetsPerfMicroAllTrials)
std(goodSetsallSetsPerfMicroAllTrials)

subplot(1,2,2);
edges=0:0.1:1;
h1=histogram(goodSetsallSetsPerfVisualAllTrials,edges);
h1(1).FaceColor = [0 0 1];
h1(1).EdgeColor = [0 0 0];
hold on
plot([0.5 0.5],[0 10],'k:');
xlim([0 1]);
ylim([0 4.5]);
set(gca,'Box','off');
ax=gca;
ax.YTick=[0 2 4];
[h,p,ci,stats]=ttest(goodSetsallSetsPerfVisualAllTrials,0.5)
sprintf(['t(',num2str(stats.df),') = ',num2str(stats.tstat),', p = %.4f'],p)%t(10) = 6.1496, p = 0.0001
mean(goodSetsallSetsPerfVisualAllTrials)
std(goodSetsallSetsPerfVisualAllTrials)

%Lick motion task (3-phosphene version)
perfMat='X:\best\results\behavioural_performance_all_sets_041217_all_trials_corrected_RFs.mat';
load(perfMat)

%histogram:
figure;
subplot(1,2,1);
edges=0:0.1:1;
h1=histogram(goodSetsallSetsPerfMicroAllTrials,edges);
h1(1).FaceColor = [1 0 0];
h1(1).EdgeColor = [0 0 0];
hold on
plot([0.5 0.5],[0 10],'k:');
xlim([0 1]);
ylim([0 6]);
set(gca,'Box','off');
ax=gca;
ax.YTick=[0 3 6];
[h,p,ci,stats]=ttest(goodSetsallSetsPerfMicroAllTrials,0.5)
sprintf(['t(',num2str(stats.df),') = ',num2str(stats.tstat),', p = %.4f'],p)%t(14) = 6.3953, p = 0.0000
mean(goodSetsallSetsPerfMicroAllTrials)
std(goodSetsallSetsPerfMicroAllTrials)

figure;
subplot(1,2,1);
edges=0:0.1:1;
h1=histogram(goodSetsallSetsPerfVisualAllTrials,edges);
h1(1).FaceColor = [0 0 1];
h1(1).EdgeColor = [0 0 0];
hold on
plot([0.5 0.5],[0 10],'k:');
xlim([0 1]);
ylim([0 4.5]);
set(gca,'Box','off');
ax=gca;
ax.YTick=[0 3 6];
[h,p,ci,stats]=ttest(goodSetsallSetsPerfVisualAllTrials,0.5)
sprintf(['t(',num2str(stats.df),') = ',num2str(stats.tstat),', p = %.4f'],p)%t(14) = 9.1344, p = 0.0000
mean(goodSetsallSetsPerfVisualAllTrials)
std(goodSetsallSetsPerfVisualAllTrials)

%Aston motion task
perfMat=['D:\aston_data\behavioural_performance_first_sets_171218_all_trials_motion.mat'];
load(perfMat)

%histogram:
subplot(1,2,2);
edges=0:0.1:1;
h1=histogram(goodSetsallSetsPerfMicroAllTrials,edges);
h1(1).FaceColor = [1 0 0];
h1(1).EdgeColor = [0 0 0];
hold on
plot([0.5 0.5],[0 10],'k:');
xlim([0 1]);
ylim([0 7]);
set(gca,'Box','off');
ax=gca;
ax.YTick=[0 3 6];
[h,p,ci,stats]=ttest(goodSetsallSetsPerfMicroAllTrials,0.5)
sprintf(['t(',num2str(stats.df),') = ',num2str(stats.tstat),', p = %.4f'],p)%t(18) = 5.1546, p = 0.0001
mean(goodSetsallSetsPerfMicroAllTrials)
std(goodSetsallSetsPerfMicroAllTrials)

subplot(1,2,2);
edges=0:0.1:1;
h1=histogram(goodSetsallSetsPerfVisualAllTrials,edges);
h1(1).FaceColor = [0 0 1];
h1(1).EdgeColor = [0 0 0];
hold on
plot([0.5 0.5],[0 12],'k:');
xlim([0 1]);
ylim([0 12]);
set(gca,'Box','off');
ax=gca;
ax.YTick=[0 5 10];
[h,p,ci,stats]=ttest(goodSetsallSetsPerfVisualAllTrials,0.5)
sprintf(['t(',num2str(stats.df),') = ',num2str(stats.tstat),', p = %.4f'],p)%t(18) = 15.63, p = 0.0000
mean(goodSetsallSetsPerfVisualAllTrials)
std(goodSetsallSetsPerfVisualAllTrials)
close all

%Lick letter task
perfMat=['X:\best\results\letter_behavioural_performance_all_sets_070618_B6_all_trials_corrected_RFs.mat'];
load(perfMat)

figure;
subplot(1,2,1);
edges=0:0.1:1;
h1=histogram(goodSetsallSetsPerfMicroAllTrials,edges);
h1(1).FaceColor = [1 0 0];
h1(1).EdgeColor = [0 0 0];
hold on
plot([0.5 0.5],[0 10],'k:');
xlim([0 1]);
ylim([0 4]);
set(gca,'Box','off');
ax=gca;
ax.YTick=[0 2 4];
[h,p,ci,stats]=ttest(goodSetsallSetsPerfMicroAllTrials,0.5)
sprintf(['t(',num2str(stats.df),') = ',num2str(stats.tstat),', p = %.4f'],p)%t(8) = 5.3623, p = 0.0007 previous: %t(17) = 6.2107, p = 0.0000
mean(goodSetsallSetsPerfMicroAllTrials)
std(goodSetsallSetsPerfMicroAllTrials)

figure;
subplot(1,2,1);
edges=0:0.1:1;
h1=histogram(goodSetsallSetsPerfVisualAllTrials,edges);
h1(1).FaceColor = [0 0 1];
h1(1).EdgeColor = [0 0 0];
hold on
plot([0.5 0.5],[0 10],'k:');
xlim([0 1]);
ylim([0 6]);
set(gca,'Box','off');
ax=gca;
ax.YTick=[0 3 6];
[h,p,ci,stats]=ttest(goodSetsallSetsPerfVisualAllTrials,0.5)
sprintf(['t(',num2str(stats.df),') = ',num2str(stats.tstat),', p = %.4f'],p)%t(8) = 23.1021, p = 0.0000 previous: %t(17) = 18.737, p = 0.0000
mean(goodSetsallSetsPerfVisualAllTrials)
std(goodSetsallSetsPerfVisualAllTrials)

%Aston letter task
load('D:\aston_data\letter_behavioural_performance_all_sets_190219_B7_aston_all_trials.mat')

figure;
subplot(1,2,2);
edges=0:0.1:1;
h1=histogram(goodSetsallSetsPerfMicroAllTrials,edges);
h1(1).FaceColor = [1 0 0];
h1(1).EdgeColor = [0 0 0];
hold on
plot([0.5 0.5],[0 10],'k:');
xlim([0 1]);
ylim([0 4]);
set(gca,'Box','off');
ax=gca;
ax.YTick=[0 2 4];
[h,p,ci,stats]=ttest(goodSetsallSetsPerfMicroAllTrials,0.5)
sprintf(['t(',num2str(stats.df),') = ',num2str(stats.tstat),', p = %.4f'],p)%t(9) = 3.6066, p = 0.0057
mean(goodSetsallSetsPerfMicroAllTrials)
std(goodSetsallSetsPerfMicroAllTrials)

subplot(1,2,2);
edges=0:0.1:1;
h1=histogram(goodSetsallSetsPerfVisualAllTrials,edges);
h1(1).FaceColor = [0 0 1];
h1(1).EdgeColor = [0 0 0];
hold on
plot([0.5 0.5],[0 12],'k:');
xlim([0 1]);
ylim([0 9]);
set(gca,'Box','off');
ax=gca;
ax.YTick=[0 4 8];
[h,p,ci,stats]=ttest(goodSetsallSetsPerfVisualAllTrials,0.5)
sprintf(['t(',num2str(stats.df),') = ',num2str(stats.tstat),', p = %.4f'],p)%t(9) = 36.6576, p = 0.0000
mean(goodSetsallSetsPerfVisualAllTrials)
std(goodSetsallSetsPerfVisualAllTrials)