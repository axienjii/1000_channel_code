function combine_monkeys_performance_figures
%Written by Xing 17/10/19.
%Combines data across two animals, plots performance during
%microstimulation and visual versions of 2-phosphene, motion, and letter
%tasks.

truncateXlim=1;
if truncateXlim==1
    xlimTruncate=[30 30 60];
end
smoothTrials=3;%set to 0 to turn off smoothing across trials. to enable smoothing across trials, set to number of trials desired
%Lick 2-phosphene task
load('X:\best\results\behavioural_performance_all_sets_241017_50trials_corrected_RFs.mat')
allSetsPerfMicroBinLick=allSetsPerfMicroBin;
allSetsPerfVisualBinLick=allSetsPerfVisualBin;

%Aston 2-phosphene task
load('D:\aston_data\behavioural_performance_first_sets_261118_71trials_2phosphenes.mat')
allSetsPerfMicroBinAston=allSetsPerfMicroBin;
allSetsPerfVisualBinAston=allSetsPerfVisualBin;

maxNumTrials=min([size(allSetsPerfMicroBinLick,2) size(allSetsPerfMicroBinAston,2)]);

%Combine across monkeys:
allSetsPerfMicroBin=[allSetsPerfMicroBinLick(:,1:maxNumTrials);allSetsPerfMicroBinAston(:,1:maxNumTrials)];
allSetsPerfVisualBin=[allSetsPerfVisualBinLick(:,1:maxNumTrials);allSetsPerfVisualBinAston(:,1:maxNumTrials)];

%Plot combined data:
figure;
subplot(2,1,1);
% subplot(2,5,1:3);
hold on
meanAllSetsPerfMicroBin=mean(allSetsPerfMicroBin,1);
if smoothTrials
    meanAllSetsPerfMicroBin=smooth(meanAllSetsPerfMicroBin,smoothTrials);
end
plot(meanAllSetsPerfMicroBin,'r');
ylim([0 1]);
xLimits=get(gca,'xlim');
plot([0 xLimits(2)],[0.5 0.5],'k:');
if truncateXlim==1
    xlim([0 xlimTruncate(1)]);
    ax=gca;
    ax.XTick=0:10:xlimTruncate(1);
end
subplot(2,1,2);
% subplot(2,5,6:8);
hold on
meanAllSetsPerfVisualBin=mean(allSetsPerfVisualBin,1);
if smoothTrials
    meanAllSetsPerfVisualBin=smooth(meanAllSetsPerfVisualBin,smoothTrials);
end
plot(meanAllSetsPerfVisualBin,'b');
ylim([0 1]);
xLimits=get(gca,'xlim');
plot([0 xLimits(2)],[0.5 0.5],'k:');
if truncateXlim==1
    xlim([0 xlimTruncate(1)]);
    ax=gca;
    ax.XTick=0:10:xlimTruncate(1);
end
figure;
if truncateXlim==1
    sessionPerfML=mean(allSetsPerfMicroBinLick(:,1:xlimTruncate(1)),2);
    sessionPerfMA=mean(allSetsPerfMicroBinAston(:,1:xlimTruncate(1)),2);
    sessionPerfVL=mean(allSetsPerfVisualBinLick(:,1:xlimTruncate(1)),2);
    sessionPerfVA=mean(allSetsPerfVisualBinAston(:,1:xlimTruncate(1)),2);
elseif truncateXlim==0
    sessionPerfML=mean(allSetsPerfMicroBinLick,2);
    sessionPerfMA=mean(allSetsPerfMicroBinAston,2);
    sessionPerfVL=mean(allSetsPerfVisualBinLick,2);
    sessionPerfVA=mean(allSetsPerfVisualBinAston,2);
end
subplot(2,2,1);
%     subplot(2,5,4);
edges=0:0.1:1;
h1=histogram(sessionPerfML,edges);
h1(1).FaceColor = [1 0 0];
h1(1).EdgeColor = [0 0 0];
hold on
plot([0.5 0.5],[0 10],'k:');
xlim([0 1]);
%     ylim([0 7]);
ylim([0 6]);
set(gca,'Box','off');
ax=gca;
ax.YTick=[0 3 6];
[h,p,ci,stats]=ttest(sessionPerfML,0.5)
sprintf(['t(',num2str(stats.df),') = ',num2str(stats.tstat),', p = %.4f'],p)%t(23) = 6.7987, p = 0.0000

subplot(2,2,2);
%     subplot(2,5,5);
edges=0:0.1:1;
h1=histogram(sessionPerfMA,edges);
h1(1).FaceColor = [1 0 0];
h1(1).EdgeColor = [0 0 0];
hold on
plot([0.5 0.5],[0 10],'k:');
xlim([0 1]);
%     ylim([0 7]);
ylim([0 6]);
set(gca,'Box','off');
ax=gca;
ax.YTick=[0 3 6];
[h,p,ci,stats]=ttest(sessionPerfMA,0.5)
sprintf(['t(',num2str(stats.df),') = ',num2str(stats.tstat),', p = %.4f'],p)%t(23) = 6.7987, p = 0.0000

subplot(2,2,3);
%     subplot(2,5,9);
edges=0:0.1:1;
h1=histogram(sessionPerfVL,edges);
h1(1).FaceColor = [0 0 1];
h1(1).EdgeColor = [0 0 0];
hold on
plot([0.5 0.5],[0 10],'k:');
xlim([0 1]);
%     ylim([0 7]);
ylim([0 8]);
set(gca,'Box','off');
ax=gca;
%     ax.YTick=[0 3 6];
ax.YTick=[0 4 8];
[h,p,ci,stats]=ttest(sessionPerfVL,0.5)
sprintf(['t(',num2str(stats.df),') = ',num2str(stats.tstat),', p = %.4f'],p)%t(23) = 6.7987, p = 0.0000

subplot(2,2,4);
%     subplot(2,5,10);
edges=0:0.1:1;
h1=histogram(sessionPerfVA,edges);
h1(1).FaceColor = [0 0 1];
h1(1).EdgeColor = [0 0 0];
hold on
plot([0.5 0.5],[0 10],'k:');
xlim([0 1]);
%     ylim([0 7]);
ylim([0 8]);
set(gca,'Box','off');
ax=gca;
%     ax.YTick=[0 3 6];
ax.YTick=[0 4 8];
[h,p,ci,stats]=ttest(sessionPerfVA,0.5)
sprintf(['t(',num2str(stats.df),') = ',num2str(stats.tstat),', p = %.4f'],p)%t(23) = 6.7987, p = 0.0000


%Lick direction-of-motion task
load('D:\data\behavioural_performance_all_sets_041217_41trials_corrected_RFs.mat')
allSetsPerfMicroBinLick=allSetsPerfMicroBin;
allSetsPerfVisualBinLick=allSetsPerfVisualBin;

%Aston direction-of-motion task
load('D:\aston_data\behavioural_performance_first_sets_171218_100trials_motion.mat')
allSetsPerfMicroBinAston=allSetsPerfMicroBin;
allSetsPerfVisualBinAston=allSetsPerfVisualBin;

maxNumTrials=min([size(allSetsPerfMicroBinLick,2) size(allSetsPerfMicroBinAston,2)]);

%Combine across monkeys:
allSetsPerfMicroBin=[allSetsPerfMicroBinLick(:,1:maxNumTrials);allSetsPerfMicroBinAston(:,1:maxNumTrials)];
allSetsPerfVisualBin=[allSetsPerfVisualBinLick(:,1:maxNumTrials);allSetsPerfVisualBinAston(:,1:maxNumTrials)];

%Plot combined data:
figure;
subplot(2,1,1);
hold on
meanAllSetsPerfMicroBin=mean(allSetsPerfMicroBin,1);
if smoothTrials
    meanAllSetsPerfMicroBin=smooth(meanAllSetsPerfMicroBin,smoothTrials);
end
plot(meanAllSetsPerfMicroBin,'r');
ylim([0 1]);
xLimits=get(gca,'xlim');
plot([0 xLimits(2)],[0.5 0.5],'k:');
xlim([0 length(meanAllSetsPerfMicroBin)]);
if truncateXlim==1
    xlim([0 xlimTruncate(2)]);
    ax=gca;
    ax.XTick=0:10:xlimTruncate(2);
end
subplot(2,1,2);
hold on
meanAllSetsPerfVisualBin=mean(allSetsPerfVisualBin,1);
if smoothTrials
    meanAllSetsPerfVisualBin=smooth(meanAllSetsPerfVisualBin,smoothTrials);
end
plot(meanAllSetsPerfVisualBin,'b');
ylim([0 1]);
xLimits=get(gca,'xlim');
plot([0 xLimits(2)],[0.5 0.5],'k:');
xlim([0 length(meanAllSetsPerfMicroBin)]);
if truncateXlim==1
    xlim([0 xlimTruncate(2)]);
    ax=gca;
    ax.XTick=0:10:xlimTruncate(2);
end
figure;
if truncateXlim==1
    sessionPerfML=mean(allSetsPerfMicroBinLick(:,1:xlimTruncate(1)),2);
    sessionPerfMA=mean(allSetsPerfMicroBinAston(:,1:xlimTruncate(1)),2);
    sessionPerfVL=mean(allSetsPerfVisualBinLick(:,1:xlimTruncate(1)),2);
    sessionPerfVA=mean(allSetsPerfVisualBinAston(:,1:xlimTruncate(1)),2);
elseif truncateXlim==0
    sessionPerfML=mean(allSetsPerfMicroBinLick,2);
    sessionPerfMA=mean(allSetsPerfMicroBinAston,2);
    sessionPerfVL=mean(allSetsPerfVisualBinLick,2);
    sessionPerfVA=mean(allSetsPerfVisualBinAston,2);
end
subplot(2,2,1);
edges=0:0.1:1;
h1=histogram(sessionPerfML,edges);
h1(1).FaceColor = [1 0 0];
h1(1).EdgeColor = [0 0 0];
hold on
plot([0.5 0.5],[0 10],'k:');
xlim([0 1]);
ylim([0 6]);
set(gca,'Box','off');
ax=gca;
ax.YTick=[0 3 6];
[h,p,ci,stats]=ttest(sessionPerfML,0.5)
sprintf(['t(',num2str(stats.df),') = ',num2str(stats.tstat),', p = %.4f'],p)%t(23) = 6.7987, p = 0.0000

subplot(2,2,2);
edges=0:0.1:1;
h1=histogram(sessionPerfMA,edges);
h1(1).FaceColor = [1 0 0];
h1(1).EdgeColor = [0 0 0];
hold on
plot([0.5 0.5],[0 10],'k:');
xlim([0 1]);
ylim([0 6]);
set(gca,'Box','off');
ax=gca;
ax.YTick=[0 3 6];
[h,p,ci,stats]=ttest(sessionPerfMA,0.5)
sprintf(['t(',num2str(stats.df),') = ',num2str(stats.tstat),', p = %.4f'],p)%t(23) = 6.7987, p = 0.0000

subplot(2,2,3);
edges=0:0.1:1;
h1=histogram(sessionPerfVL,edges);
h1(1).FaceColor = [0 0 1];
h1(1).EdgeColor = [0 0 0];
hold on
plot([0.5 0.5],[0 10],'k:');
xlim([0 1]);
ylim([0 6]);
set(gca,'Box','off');
ax=gca;
ax.YTick=[0 3 6];
[h,p,ci,stats]=ttest(sessionPerfVL,0.5)
sprintf(['t(',num2str(stats.df),') = ',num2str(stats.tstat),', p = %.4f'],p)%t(23) = 6.7987, p = 0.0000

subplot(2,2,4);
edges=0:0.1:1;
h1=histogram(sessionPerfVA,edges);
h1(1).FaceColor = [0 0 1];
h1(1).EdgeColor = [0 0 0];
hold on
plot([0.5 0.5],[0 14],'k:');
xlim([0 1]);
ylim([0 14]);
set(gca,'Box','off');
ax=gca;
ax.YTick=[0 7 14];
[h,p,ci,stats]=ttest(sessionPerfVA,0.5)
sprintf(['t(',num2str(stats.df),') = ',num2str(stats.tstat),', p = %.4f'],p)%t(23) = 6.7987, p = 0.0000

%Lick letter task
load('D:\data\letter_behavioural_performance_all_sets_corrected_RFs_070618_B6_100trials.mat')
allSetsPerfMicroBinLick=allSetsPerfMicroBin;
allSetsPerfVisualBinLick=allSetsPerfVisualBin;

%Aston letter task
load('D:\aston_data\letter_behavioural_performance_all_sets_190219_B7_aston_100trials.mat')
allSetsPerfMicroBinAston=allSetsPerfMicroBin;
allSetsPerfVisualBinAston=allSetsPerfVisualBin;

maxNumTrials=min([size(allSetsPerfMicroBinLick,2) size(allSetsPerfMicroBinAston,2)]);

%Combine across monkeys:
allSetsPerfMicroBin=[allSetsPerfMicroBinLick(:,1:maxNumTrials);allSetsPerfMicroBinAston(:,1:maxNumTrials)];
allSetsPerfVisualBin=[allSetsPerfVisualBinLick(:,1:maxNumTrials);allSetsPerfVisualBinAston(:,1:maxNumTrials)];

%Plot combined data:
letterFigure=figure;
subplot(2,1,1);
hold on
meanAllSetsPerfMicroBin=mean(allSetsPerfMicroBin,1);
if smoothTrials
    meanAllSetsPerfMicroBin=smooth(meanAllSetsPerfMicroBin,smoothTrials);
end
plot(meanAllSetsPerfMicroBin,'r');
ylim([0 1]);
xLimits=get(gca,'xlim');
plot([0 xLimits(2)],[0.5 0.5],'k:');
if truncateXlim==1
    xlim([0 xlimTruncate(3)]);
    ax=gca;
    ax.XTick=0:10:xlimTruncate(3);
end
ax=gca;
ax.XTick=[0 30 60];
subplot(2,1,2);
hold on
meanAllSetsPerfVisualBin=mean(allSetsPerfVisualBin,1);
if smoothTrials
    meanAllSetsPerfVisualBin=smooth(meanAllSetsPerfVisualBin,smoothTrials);
end
plot(meanAllSetsPerfVisualBin,'b');
ylim([0 1]);
xLimits=get(gca,'xlim');
plot([0 xLimits(2)],[0.5 0.5],'k:');
if truncateXlim==1
    xlim([0 xlimTruncate(3)]);
    ax=gca;
    ax.XTick=0:10:xlimTruncate(3);
end
ax=gca;
ax.XTick=[0 30 60];

figure;
if truncateXlim==1
    sessionPerfML=mean(allSetsPerfMicroBinLick(:,1:xlimTruncate(1)),2);
    sessionPerfMA=mean(allSetsPerfMicroBinAston(:,1:xlimTruncate(1)),2);
    sessionPerfVL=mean(allSetsPerfVisualBinLick(:,1:xlimTruncate(1)),2);
    sessionPerfVA=mean(allSetsPerfVisualBinAston(:,1:xlimTruncate(1)),2);
elseif truncateXlim==0
    sessionPerfML=mean(allSetsPerfMicroBinLick,2);
    sessionPerfMA=mean(allSetsPerfMicroBinAston,2);
    sessionPerfVL=mean(allSetsPerfVisualBinLick,2);
    sessionPerfVA=mean(allSetsPerfVisualBinAston,2);
end
subplot(2,2,1);
edges=0:0.1:1;
h1=histogram(sessionPerfML,edges);
h1(1).FaceColor = [1 0 0];
h1(1).EdgeColor = [0 0 0];
hold on
plot([0.5 0.5],[0 10],'k:');
xlim([0 1]);
ylim([0 6]);
set(gca,'Box','off');
ax=gca;
ax.YTick=[0 3 6];
[h,p,ci,stats]=ttest(sessionPerfML,0.5)
sprintf(['t(',num2str(stats.df),') = ',num2str(stats.tstat),', p = %.4f'],p)%t(23) = 6.7987, p = 0.0000

subplot(2,2,2);
edges=0:0.1:1;
h1=histogram(sessionPerfMA,edges);
h1(1).FaceColor = [1 0 0];
h1(1).EdgeColor = [0 0 0];
hold on
plot([0.5 0.5],[0 10],'k:');
xlim([0 1]);
ylim([0 6]);
set(gca,'Box','off');
ax=gca;
ax.YTick=[0 3 6];
[h,p,ci,stats]=ttest(sessionPerfMA,0.5)
sprintf(['t(',num2str(stats.df),') = ',num2str(stats.tstat),', p = %.4f'],p)%t(23) = 6.7987, p = 0.0000

subplot(2,2,3);
edges=0:0.1:1;
h1=histogram(sessionPerfVL,edges);
h1(1).FaceColor = [0 0 1];
h1(1).EdgeColor = [0 0 0];
hold on
plot([0.5 0.5],[0 10],'k:');
xlim([0 1]);
ylim([0 8]);
set(gca,'Box','off');
ax=gca;
ax.YTick=[0 4 8];
[h,p,ci,stats]=ttest(sessionPerfVL,0.5)
sprintf(['t(',num2str(stats.df),') = ',num2str(stats.tstat),', p = %.4f'],p)%t(23) = 6.7987, p = 0.0000

subplot(2,2,4);
edges=0:0.1:1;
h1=histogram(sessionPerfVA,edges);
h1(1).FaceColor = [0 0 1];
h1(1).EdgeColor = [0 0 0];
hold on
plot([0.5 0.5],[0 10],'k:');
xlim([0 1]);
ylim([0 8]);
set(gca,'Box','off');
ax=gca;
ax.YTick=[0 4 8];
[h,p,ci,stats]=ttest(sessionPerfVA,0.5)
sprintf(['t(',num2str(stats.df),') = ',num2str(stats.tstat),', p = %.4f'],p)%t(23) = 6.7987, p = 0.0000

%Lick control letter task
load('X:\best\results\control_letter_behavioural_performance_all_sets_150819_B1_100trials.mat')
allSetsPerfMicroBinLick=allSetsPerfMicroBin;
allSetsPerfVisualBinLick=allSetsPerfVisualBin;

%Aston control letter task
load('D:\aston_data\control_letter_behavioural_performance_all_sets_080819_B2_aston_100trials.mat')
allSetsPerfMicroBinAston=allSetsPerfMicroBin;
allSetsPerfVisualBinAston=allSetsPerfVisualBin;

maxNumTrials=min([size(allSetsPerfMicroBinLick,2) size(allSetsPerfMicroBinAston,2)]);

%Combine control data across monkeys:
allSetsPerfMicroBin=[allSetsPerfMicroBinLick(:,1:maxNumTrials);allSetsPerfMicroBinAston(:,1:maxNumTrials)];
allSetsPerfVisualBin=[allSetsPerfVisualBinLick(:,1:maxNumTrials);allSetsPerfVisualBinAston(:,1:maxNumTrials)];

%Plot combined control data:
greenCol=[50/255 170/255 80/255];
figure(letterFigure)
subplot(2,1,1);
hold on
meanAllSetsPerfMicroBin=mean(allSetsPerfMicroBin,1);
if smoothTrials
    meanAllSetsPerfMicroBin=smooth(meanAllSetsPerfMicroBin,smoothTrials);
end
plot(meanAllSetsPerfMicroBin,'Color',greenCol);
ylim([0 1]);
xLimits=get(gca,'xlim');
plot([0 xLimits(2)],[0.5 0.5],'k:');
subplot(2,1,2);
hold on
meanAllSetsPerfVisualBin=mean(allSetsPerfVisualBin,1);
if smoothTrials
    meanAllSetsPerfVisualBin=smooth(meanAllSetsPerfVisualBin,smoothTrials);
end
plot(meanAllSetsPerfVisualBin,'Color',greenCol);
ylim([0 1]);
xLimits=get(gca,'xlim');
plot([0 xLimits(2)],[0.5 0.5],'k:');

pauseHere=1;