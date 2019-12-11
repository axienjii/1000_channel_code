function compare_visual_microstim_all_tasks
%Written by Xing 9/12/19
%Compares performance between visual and microstim version of 2-phosphene,
%motion, and letter tasks, in both Lick and Aston.

%Lick 2-phosphene task
load('X:\best\behavioural_performance_all_sets_241017_50trials_corrected_RFs.mat')
%Aston 2-phosphene task
load('D:\aston_data\behavioural_performance_first_sets_261118_71trials_2phosphenes.mat')

%Lick motion task (3-phosphenes)
load('D:\data\behavioural_performance_all_sets_041217_41trials_corrected_RFs.mat')
%Aston motion task
load('D:\aston_data\behavioural_performance_first_sets_171218_100trials_motion.mat')

%Lick letter task
load('D:\data\letter_behavioural_performance_all_sets_corrected_RFs_070618_B6_100trials.mat')
%Aston letter task
load('D:\aston_data\letter_behavioural_performance_all_sets_190219_B7_aston_100trials.mat')
g1=[zeros(size(allSetsPerfMicroBin,1),size(allSetsPerfMicroBin,2));ones(size(allSetsPerfVisualBin,1),size(allSetsPerfVisualBin,2))];%factor: microstimulation or visual
numSessions=1:size(allSetsPerfMicroBin,1);
g2=repmat(numSessions',1,size(allSetsPerfMicroBin,2));
g2=[g2;g2];%factor: session number
dataset=[allSetsPerfMicroBin;allSetsPerfVisualBin];
dataset=dataset(:);
[p,tbl,stats]=anovan(dataset,{g1(:) g2(:)})
results = multcompare(stats,'Dimension',[1 2])
results = multcompare(stats,'Dimension',1)%factor: microstimulation or visual
results = multcompare(stats,'Dimension',2)%factor: session number