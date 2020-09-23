function plot_performance_time_repo(task,perfWithTime,semWithTime)
%Written by Xing 19/8/20.
%Plots performance (combined across two monkeys) as a function of trial
%number, during both microstimulation and visual versions of orientation,
%direction-of-motion, and letter discrimination tasks.

%Plot data:
figure;
hold on;
errorbar(1:length(perfWithTime),perfWithTime,semWithTime);
ylim([0 1]);
xlim([0 length(perfWithTime)+1]);
xLimits=get(gca,'xlim');
plot([0 xLimits(2)],[0.5 0.5],'k:');
if strcmp(task,'ori')
    title('Orientation task');
elseif strcmp(task,'dir')
    title('Direction-of-motion task');
elseif strcmp(task,'let')
    title('Letter task');
elseif strcmp(task,'con')
    title('Control task');
end