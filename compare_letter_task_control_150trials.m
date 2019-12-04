function compare_letter_task_control_150trials
%Written by Xing 18/7/19.
%Reads in performance during first hundred trials per session during
%original (non-control) letter task, and calculates mean performance during
%these 100 trials. Compares the distributions of performance levels between
%original (visual and microstim versions) and control task (novel 'J' and 'P' letter
%stimuli).

%Lick:
meanPerf150TrialsV=[];
meanPerf150TrialsM=[];
for calculateVisual=[0 1]
    for setNo=[1:6 9 17:24 26 28:29]%1:29%[1:11 13:26 28:29]%1:24 for 10 electrodes per letter; subsequent sessions use 15 electrodes per letter
        if calculateVisual==0
            switch(setNo)
                case 1
                    date='170418_B9';%next batch of new electrode combinations
                case 2
                    date='170418_B10';
                case 3
                    date='180418_B8';
                case 4
                    date='180418_B9';
                case 5
                    date='200418_B7';
                case 6
                    date='200418_B8';
                case 7
                    date='230418_B6';
                case 8
                    date='230418_B7';
                case 9
                    date='250418_B4';
                case 10
                    date='250418_B5';
                case 11
                    date='300418_B5';
                case 12
                    date='300418_B6';
                case 13
                    date='010518_B6';
                case 14
                    date='010518_B7';
                case 15
                    date='020518_B6';
                case 16
                    date='020518_B7';
                case 17
                    date='030518_B9';
                case 18
                    date='030518_B17';
                case 19
                    date='070518_B5';
                case 20
                    date='070518_B6';
                case 21
                    date='080518_B6';
                case 22
                    date='080518_B7';
                case 23
                    date='090518_B5';
                case 24
                    date='090518_B6';
                case 25
                    date='290518_B7';%15 electrodes per letter
                case 26
                    date='040618_B10';
                case 27
                    date='140618_B5';
                case 28
                    date='140618_B7';
                case 29%setInd 71
                    date='180618_B7';
            end
            load(['D:\microPerf_',date,'.mat']);
            meanPerf150TrialsM=[meanPerf150TrialsM mean(perfMicroBin)];
        elseif calculateVisual==1
            switch(setNo)
                %visual task only:
                case 1
                    date='170418_B8';%next batch of new electrode combinations
                case 2
                    date='170418_B7';
                case 3
                    date='180418_B6';
                case 4
                    date='180418_B4';
                case 5
                    date='200418_B6';
                case 6
                    date='200418_B5';
                case 7
                    date='230418_B5';
                case 8
                    date='230418_B4';
                case 9
                    date='240418_B6';
                case 10
                    date='240418_B4';
                case 11
                    date='250418_B8';
                case 12
                    date='260418_B5';
                case 13
                    date='010518_B2';
                case 14
                    date='010518_B4';
                case 15
                    date='020518_B4';
                case 16
                    date='020518_B3';
                case 17
                    date='030518_B8';
                case 18
                    date='030518_B7';
                case 19
                    date='040518_B2';
                case 20
                    date='070518_B2';
                case 21
                    date='080518_B3';
                case 22
                    date='080518_B4';
                case 23
                    date='090518_B2';
                case 24
                    date='090518_B4';
                case 25
                    date='290518_B5';%15 electrodes per letter, coloured dots
                case 26
                    date='040618_B7';%black dots
                case 27
                    date='070618_B7';%black dots
                case 28
                    date='070618_B6';%black dots
                case 29
                    date='180618_B5';%black dots
            end
            load(['D:\visualPerf_',date,'.mat']);
            meanPerf150TrialsV=[meanPerf150TrialsV mean(perfVisualBin)];
        end
        
    end
end

%histogram:
figM=figure;
subplot(1,2,1);
edges=0:0.1:1;
h1=histogram(meanPerf100TrialsM,edges);
h1(1).FaceColor = [1 0 0];
h1(1).EdgeColor = [0 0 0];
hold on
plot([0.5 0.5],[0 10],'k:');
xlim([0 1]);
ylim([0 6]);
set(gca,'Box','off');
ax=gca;
ax.YTick=[0 3 6];
[h,p,ci,stats]=ttest(meanPerf100TrialsM,0.5)
sprintf(['t(',num2str(stats.df),') = ',num2str(stats.tstat),', p = %.4f'],p)%t(17) = 4.0797, p = 0.0008

figV=figure;
subplot(1,2,1);
edges=0:0.1:1;
h1=histogram(meanPerf100TrialsV,edges);
h1(1).FaceColor = [0 0 1];
h1(1).EdgeColor = [0 0 0];
hold on
plot([0.5 0.5],[0 10],'k:');
xlim([0 1]);
ylim([0 10]);
set(gca,'Box','off');
ax=gca;
ax.YTick=[0 5 10];
[h,p,ci,stats]=ttest(meanPerf100TrialsV,0.5)
sprintf(['t(',num2str(stats.df),') = ',num2str(stats.tstat),', p = %.4f'],p)%

%load data from control task:
load('D:\data\control_letter_behavioural_performance_all_sets_030719_B12_100trials.mat')
[h,p,ci,stats]=ttest2(meanPerfAllSets,meanPerf100TrialsV)
sprintf(['t(',num2str(stats.df),') = ',num2str(stats.tstat),', p = %.4f'],p)%
[h,p,ci,stats]=ttest2(meanPerfAllSets,meanPerf100TrialsM)
sprintf(['t(',num2str(stats.df),') = ',num2str(stats.tstat),', p = %.4f'],p)%

%Aston:
initialPerfTrials=150;
meanPerf150TrialsV=[];
meanPerf150TrialsM=[];
allPerfVisualBin=[];
allPerfMicroBin=[];
for calculateVisual=[0 1]
    for setNo=3:11
        if calculateVisual==0
            switch(setNo)
                case 3
                    date='290119_B3_aston';
                case 4
                    date='040219_B4_aston';
                case 5
                    date='050219_B8_aston';
                case 6
                    date='070219_B3_aston';
                case 7
                    date='080219_B10_aston';
                case 8
                    date='110219_B6_aston';
                case 9
                    date='140219_B3_aston';
                case 10
                    date='120219_B6_aston';
                case 11
                    date='180219_B10_aston';
                case 12
                    date='190219_B9_aston';
            end
            load(['D:\aston_data\perf_mat\microPerf_',date,'_',num2str(initialPerfTrials),'trials.mat']);
            allPerfMicroBin=[allPerfMicroBin;perfMicroBin];
            meanPerf150TrialsM=[meanPerf150TrialsM nanmean(perfMicroBin)];
        elseif calculateVisual==1
            switch(setNo)
                %visual task only:
                case 3
                    date='280119_B2_aston';
                case 4
                    date='040219_B2_aston';
                case 5
                    date='060219_B6_aston';
                case 6
                    date='060219_B7_aston';
                case 7
                    date='080219_B8_aston';
                case 8
                    date='110219_B4_aston';
                case 9
                    date='130219_B2_aston';
                case 10
                    date='120219_B2_aston';
                case 11
                    date='180219_B8_aston';
                case 12
                    date='190219_B7_aston';
            end
            load(['D:\aston_data\perf_mat\visualPerf_',date,'_',num2str(initialPerfTrials),'trials.mat']);
            allPerfVisualBin=[allPerfVisualBin;perfVisualBin];
            meanPerf150TrialsV=[meanPerf150TrialsV nanmean(perfVisualBin)];
        end        
    end
end

%histogram:
figure(figM);
subplot(1,2,2);
edges=0:0.1:1;
h1=histogram(meanPerf150TrialsM,edges);
h1(1).FaceColor = [1 0 0];
h1(1).EdgeColor = [0 0 0];
hold on
plot([0.5 0.5],[0 10],'k:');
xlim([0 1]);
ylim([0 6]);
set(gca,'Box','off');
ax=gca;
ax.YTick=[0 3 6];
[h,p,ci,stats]=ttest(meanPerf150TrialsM,0.5)
sprintf(['t(',num2str(stats.df),') = ',num2str(stats.tstat),', p = %.4f'],p)%t(8) = 2.6785, p = 0.0280

figure(figV);
subplot(1,2,2);
edges=0:0.1:1;
h1=histogram(meanPerf150TrialsV,edges);
h1(1).FaceColor = [0 0 1];
h1(1).EdgeColor = [0 0 0];
hold on
plot([0.5 0.5],[0 10],'k:');
xlim([0 1]);
ylim([0 10]);
set(gca,'Box','off');
ax=gca;
ax.YTick=[0 5 10];
[h,p,ci,stats]=ttest(meanPerf150TrialsV,0.5)
sprintf(['t(',num2str(stats.df),') = ',num2str(stats.tstat),', p = %.4f'],p)%t(8) = 40.5491, p = 0.0000

%load data from control task:
load('D:\aston_data\control_letter_behavioural_performance_all_sets_160719_B6_aston_100trials.mat')
[h,p,ci,stats]=ttest2(meanPerfAllSets,meanPerf150TrialsV)
sprintf(['t(',num2str(stats.df),') = ',num2str(stats.tstat),', p = %.4f'],p)%t(20) = -13.4793, p = 0.0000
[h,p,ci,stats]=ttest2(meanPerfAllSets,meanPerf150TrialsM)
sprintf(['t(',num2str(stats.df),') = ',num2str(stats.tstat),', p = %.4f'],p)%t(20) = -1.7241, p = 0.1001
