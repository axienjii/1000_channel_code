function calculate_stats_1024_results
%Written by Xing 29/3/19
analysisTypes=1:7;
for analysisTypeInd=analysisTypes
    switch(analysisTypeInd)
        case 1%2-phosphene task, Lick
            load('D:\data\behavioural_performance_all_sets_241017_all_trials.mat')
        case 2%2-phosphene task, Aston
            load('D:\aston_data\behavioural_performance_first_sets_261118_all_trials_2phosphenes.mat')         
        case 3%motion task, Lick (3-phosphene version)
            load('D:\data\behavioural_performance_all_sets_041217_all_trials.mat')
        case 4%motion task, Aston
            load('D:\aston_data\behavioural_performance_first_sets_171218_all_trials_motion.mat')         
        case 5%motion task, Lick (5-phosphene version)
            load('D:\data\behavioural_performance_all_sets_121217_all_trials.mat')
        case 6%letter task, Lick
            load('D:\data\letter_behavioural_performance_all_sets_180618_B5_all_trials.mat')
        case 7%letter task, Aston
            load('D:\aston_data\letter_behavioural_performance_all_sets_190219_B7_aston_all_trials.mat')         
    end
    [h p ci stats]=ttest(goodSetsallSetsPerfMicroAllTrials,0.5)
    pM(analysisTypeInd,:)=[p stats.df];
    ciM(analysisTypeInd,:)=ci;
    statsM(analysisTypeInd)=stats;
    stringM=sprintf(['t(',num2str(stats.df),') = ',num2str(stats.tstat),', p = %.4f'],p);
    reportStringM(analysisTypeInd,1:length(stringM))=stringM;
    [h p ci stats]=ttest(goodSetsallSetsPerfVisualAllTrials,0.5)
    pV(analysisTypeInd,:)=[p stats.df];
    ciV(analysisTypeInd,:)=ci;
    statsV(analysisTypeInd)=stats;
    stringV=sprintf(['t(',num2str(stats.df),') = ',num2str(stats.tstat),', p = %.4f'],p);
    reportStringV(analysisTypeInd,1:length(stringV))=stringV;
end
pauseHere=1;