function plot_performance_repo(task,perfMicro,perfVisual)
%Written by Xing 19/8/20.
%Plots mean performance (across each session), during both microstimulation
%and visual versions of orientation, direction-of-motion, and letter
%discrimination tasks.

%Plot data:
figure;
hold on;
edges=0:0.1:1;
subplot(1,2,1);
h1=histogram(perfMicro,edges);
h1(1).FaceColor = [0 1 0];
h1(1).EdgeColor = [0 0 0];
hold on;
plot([0.5 0.5],[0 10],'k:');
xlim([0 1]);
ylim([0 6]);
set(gca,'Box','off');
ax=gca;
ax.YTick=[0 3 6];
[h,p,ci,stats]=ttest(perfMicro,0.5);
sprintf(['t(',num2str(stats.df),') = ',num2str(stats.tstat),', p = %.4f'],p)%t(23) = 6.7987, p = 0.0000
if strcmp(task,'ori')
    title('Orientation task, Micro')
elseif strcmp(task,'dir')
    title('Direction-of-motion task, Micro')
elseif strcmp(task,'let')
    title('Letter task, Micro')
elseif strcmp(task,'con')
    title('Control task, Micro')
end

subplot(1,2,2);
h2=histogram(perfVisual,edges);
h2(1).FaceColor = [0 0 1];
h2(1).EdgeColor = [0 0 0];
hold on
plot([0.5 0.5],[0 10],'k:');
xlim([0 1]);
ylim([0 6]);
set(gca,'Box','off');
ax=gca;
ax.YTick=[0 3 6];
title('Visual')
[h,p,ci,stats]=ttest(perfVisual,0.5);
sprintf(['t(',num2str(stats.df),') = ',num2str(stats.tstat),', p = %.4f'],p)%t(23) = 6.7987, p = 0.0000
