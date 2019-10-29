function combine_monkeys_performance_figures
%Written by Xing 17/10/19.
%Combines data across two animals, plots performance during
%microstimulation and visual versions of 2-phosphene, motion, and letter
%tasks.

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
hold on
meanAllSetsPerfMicroBin=mean(allSetsPerfMicroBin,1);
if smoothTrials
    meanAllSetsPerfMicroBin=smooth(meanAllSetsPerfMicroBin,3);
end
plot(meanAllSetsPerfMicroBin,'r');
ylim([0 1]);
xLimits=get(gca,'xlim');
plot([0 xLimits(2)],[0.5 0.5],'k:');
subplot(2,1,2);
hold on
meanAllSetsPerfVisualBin=mean(allSetsPerfVisualBin,1);
if smoothTrials
    meanAllSetsPerfVisualBin=smooth(meanAllSetsPerfVisualBin,3);
end
plot(meanAllSetsPerfVisualBin,'b');
ylim([0 1]);
xLimits=get(gca,'xlim');
plot([0 xLimits(2)],[0.5 0.5],'k:');


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
    meanAllSetsPerfMicroBin=smooth(meanAllSetsPerfMicroBin,3);
end
plot(meanAllSetsPerfMicroBin,'r');
ylim([0 1]);
xLimits=get(gca,'xlim');
plot([0 xLimits(2)],[0.5 0.5],'k:');
xlim([0 length(meanAllSetsPerfMicroBin)]);
subplot(2,1,2);
hold on
meanAllSetsPerfVisualBin=mean(allSetsPerfVisualBin,1);
if smoothTrials
    meanAllSetsPerfVisualBin=smooth(meanAllSetsPerfVisualBin,3);
end
plot(meanAllSetsPerfVisualBin,'b');
ylim([0 1]);
xLimits=get(gca,'xlim');
plot([0 xLimits(2)],[0.5 0.5],'k:');
xlim([0 length(meanAllSetsPerfMicroBin)]);

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
figure;
subplot(2,1,1);
hold on
meanAllSetsPerfMicroBin=mean(allSetsPerfMicroBin,1);
if smoothTrials
    meanAllSetsPerfMicroBin=smooth(meanAllSetsPerfMicroBin,3);
end
plot(meanAllSetsPerfMicroBin,'r');
ylim([0 1]);
xLimits=get(gca,'xlim');
plot([0 xLimits(2)],[0.5 0.5],'k:');
subplot(2,1,2);
hold on
meanAllSetsPerfVisualBin=mean(allSetsPerfVisualBin,1);
if smoothTrials
    meanAllSetsPerfVisualBin=smooth(meanAllSetsPerfVisualBin,3);
end
plot(meanAllSetsPerfVisualBin,'b');
ylim([0 1]);
xLimits=get(gca,'xlim');
plot([0 xLimits(2)],[0.5 0.5],'k:');

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
subplot(2,1,1);
hold on
meanAllSetsPerfMicroBin=mean(allSetsPerfMicroBin,1);
if smoothTrials
    meanAllSetsPerfMicroBin=smooth(meanAllSetsPerfMicroBin,3);
end
plot(meanAllSetsPerfMicroBin,'Color',greenCol);
ylim([0 1]);
xLimits=get(gca,'xlim');
plot([0 xLimits(2)],[0.5 0.5],'k:');
subplot(2,1,2);
hold on
meanAllSetsPerfVisualBin=mean(allSetsPerfVisualBin,1);
if smoothTrials
    meanAllSetsPerfVisualBin=smooth(meanAllSetsPerfVisualBin,3);
end
plot(meanAllSetsPerfVisualBin,'Color',greenCol);
ylim([0 1]);
xLimits=get(gca,'xlim');
plot([0 xLimits(2)],[0.5 0.5],'k:');