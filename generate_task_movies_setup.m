function generate_task_movies_setup
%Written by Xing on 17/4/20, to process eye data and generate movies for
%paper, for orientation, direction-of motion and letter discrimination
%tasks.

%To select the best sessions, examine the performance from the beginning of
%the session, and plot RF locations of stimulated electrodes:

load('D:\aston_data\behavioural_performance_first_sets_261118_71trials_2phosphenes.mat')
tally=[];
for i=1:size(allSetsPerfMicroBin,2)
    tally(:,i)=sum(allSetsPerfMicroBin(:,1:i),2);
end
%Set breakpoint in function and run: list_2phosphene_aston

load('D:\aston_data\behavioural_performance_first_sets_171218_100trials_motion.mat')
tally=[];
for i=1:size(allSetsPerfMicroBin,2)
    tally(:,i)=sum(allSetsPerfMicroBin(:,1:i),2);
end
%Set breakpoint in function and run: list_motion_draw_RFs_aston

load('D:\data\letter_behavioural_performance_all_sets_corrected_RFs_070618_B6_100trials.mat')
tally=[];
for i=1:size(allSetsPerfMicroBin,2)
    tally(:,i)=sum(allSetsPerfMicroBin(:,1:i),2);
end
%Set breakpoint in function and run: list_letter_draw_RFs

%Lick:
analyse_microstim_2phosphene5_moviedata
analyse_microstim_motion_moviedata
analyse_microstim_letter_moviedata

render_letter_task2(1)%best
render_letter_task2(2)

%Aston:
analyse_microstim_2phosphene5_moviedata_aston
analyse_microstim_motion_moviedata_aston
analyse_microstim_letter_moviedata_aston

render_orientation_task_aston(2)%best
render_motion_task_aston(1)%best
render_motion_task_aston(2)
render_letter_task_aston(1)
render_letter_task_aston(2)
render_letter_task_aston(3)


