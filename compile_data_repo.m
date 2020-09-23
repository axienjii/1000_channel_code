function compile_data_repo
%Written by Xing on 14/8/20.
%Compiles data for upload to a repository in conjunction with publication
%of article, 'Shape perception via a high-channel-count neuroprosthesis in monkey visual cortex.'
%From scripts: combine_monkeys_performance_figures; mean_perf_lick_aston_all_trials

%RFs Lick:
allChannelRFs=[];
for instanceInd=1:8
    load(['D:\data\best_260617-280617\RFs_instance',num2str(instanceInd),'.mat'])
    allChannelRFs=[allChannelRFs;channelRFs];
end

MonkeyLData.RFx=allChannelRFs(:,1)/25.8601;
MonkeyLData.RFy=allChannelRFs(:,2)/25.8601;

load('D:\data\monkeyLGoodInd.mat','goodInd');
MonkeyLData.goodSNR=goodInd;%SNR of >2

%channel and array indexing
load('X:\best\channel_area_mapping.mat')
arrayIndexing=arrayNums(:);
channelIndexing=channelNums(:);
areaIndexing=areas(:);

MonkeyCombinedData.arrayInds=arrayIndexing;
MonkeyCombinedData.channelInds=channelIndexing;
MonkeyCombinedData.areaInds=areaIndexing;

%RFs Aston:
allChannelRFs=[];
for instanceInd=1:8
    load(['D:\aston_data\best_aston_280818-290818\RFs_instance',num2str(instanceInd),'.mat'])
    allChannelRFs=[allChannelRFs;channelRFs];
end

MonkeyAData.RFx=allChannelRFs(:,1)/25.8601;
MonkeyAData.RFy=allChannelRFs(:,2)/25.8601;

load('D:\aston_data\monkeyAGoodInd.mat','goodInd');
MonkeyAData.goodSNR=goodInd;%SNR of >2

%Lick. Coordinates, polar angle and eccentricity of saccade end points during high current amplitudes
load('D:\data\saccade_endpoints_210817_B2-290817_B42_final.mat','arrayAllTrialsNoOutliers','meanX','meanY','allPolarAngleSacs','allEccentricitySacs','allPolarAngleRFs','allEccentricityRFs')
ind1=find(isnan(meanX));
ind2=find(isnan(meanY));
ind=union(ind1,ind2);
meanX(ind)=[];
meanY(ind)=[];
%N=184

%Lick. Eccentricity of saccade end points during high vs medium current
%amplitudes
load('D:\data\saccade_endpoints_ecc_max_mid.mat','meanEccMaxFinal','meanEccMidFinal')
ind1=find(isnan(meanEccMaxFinal));
ind2=find(isnan(meanEccMidFinal));
ind=union(ind1,ind2);
meanEccMaxFinal(ind)=[];
meanEccMidFinal(ind)=[];
%N=165

MonkeyLData.saccXHighCurr=meanX;
MonkeyLData.saccYHighCurr=meanY;
MonkeyLData.saccPolarAngHighCurr=allPolarAngleSacs;
MonkeyLData.saccEccHighCurr=allEccentricitySacs;
MonkeyLData.RFPolarAngHighCurr=allPolarAngleRFs;
MonkeyLData.RFEccHighCurr=allEccentricityRFs;
MonkeyLData.saccEccHighCurrCompare=meanEccMaxFinal;
MonkeyLData.saccEccMedCurrCompare=meanEccMidFinal;
MonkeyLData.saccArrayList=arrayAllTrialsNoOutliers;

%Aston. Coordinates, polar angle and eccentricity of saccade end points during high current amplitudes
load('D:\aston_data\saccade_endpoints_110918_B3_aston-201118_B8_max_amp_final.mat','arrayAllTrialsNoOutliers','meanX','meanY','allPolarAngleSacs','allEccentricitySacs','allPolarAngleRFs','allEccentricityRFs')
ind1=find(isnan(meanX));
ind2=find(isnan(meanY));
ind=union(ind1,ind2);
meanX(ind)=[];
meanY(ind)=[];
%N=164

load('D:\aston_data\saccade_endpoints_ecc_max_mid.mat','meanEccMaxFinal','meanEccMidFinal')
ind1=find(isnan(meanEccMaxFinal));
ind2=find(isnan(meanEccMidFinal));
ind=union(ind1,ind2);
meanEccMaxFinal(ind)=[];
meanEccMidFinal(ind)=[];
%N=142

MonkeyAData.saccXHighCurr=meanX;
MonkeyAData.saccYHighCurr=meanY;
MonkeyAData.saccPolarAngHighCurr=allPolarAngleSacs;
MonkeyAData.saccEccHighCurr=allEccentricitySacs;
MonkeyAData.RFPolarAngHighCurr=allPolarAngleRFs;
MonkeyAData.RFEccHighCurr=allEccentricityRFs;
MonkeyAData.saccEccHighCurrCompare=meanEccMaxFinal;
MonkeyAData.saccEccMedCurrCompare=meanEccMidFinal;
MonkeyAData.saccArrayList=arrayAllTrialsNoOutliers;

%Current thresholds
load('X:\best\lowestCurrentThresholds_monkeyL.mat')
MonkeyLData.currentThresholds=lowestThresholdsSorted;

load('X:\aston\lowestCurrentThresholds_monkeyA.mat')
MonkeyAData.currentThresholds=lowestThresholdsSorted;

%Behav tasks
%Orientation task
load('D:\data\ori_perf_time_micro_repo.mat')
MonkeyCombinedData.oriTaskPerfWithTimeMicro=truncatedMeanAllSetsPerfMicroBin;
MonkeyCombinedData.oriTaskSemWithTimeMicro=truncatedSemMicro;
load('X:\best\behavioural_performance_all_sets_corrected_RFs_241017_all_trials.mat');
MonkeyLData.oriTaskPerfAllTrialsMicro=goodSetsallSetsPerfMicroAllTrials;
MonkeyLData.oriTaskPerfAllTrialsVisual=goodSetsallSetsPerfVisualAllTrials;
load('D:\aston_data\behavioural_performance_first_sets_261118_all_trials_2phosphenes.mat');
MonkeyAData.oriTaskPerfAllTrialsMicro=goodSetsallSetsPerfMicroAllTrials;
MonkeyAData.oriTaskPerfAllTrialsVisual=goodSetsallSetsPerfVisualAllTrials;

%Direction-of-motion task
load('D:\data\dir_perf_time_micro_repo.mat')
MonkeyCombinedData.dirTaskPerfWithTimeMicro=truncatedMeanAllSetsPerfMicroBin;
MonkeyCombinedData.dirTaskSemWithTimeMicro=truncatedSemMicro;
load('X:\best\results\behavioural_performance_all_sets_041217_all_trials_corrected_RFs.mat');
MonkeyLData.dirTaskPerfAllTrialsMicro=goodSetsallSetsPerfMicroAllTrials;
MonkeyLData.dirTaskPerfAllTrialsVisual=goodSetsallSetsPerfVisualAllTrials;
load('D:\aston_data\behavioural_performance_first_sets_171218_all_trials_motion.mat');
MonkeyAData.dirTaskPerfAllTrialsMicro=goodSetsallSetsPerfMicroAllTrials;
MonkeyAData.dirTaskPerfAllTrialsVisual=goodSetsallSetsPerfVisualAllTrials;

%Letter task
load('D:\data\letter_perf_time_micro_repo.mat')
MonkeyCombinedData.letTaskPerfWithTimeMicro=truncatedMeanAllSetsPerfMicroBin;
MonkeyCombinedData.letTaskSemWithTimeMicro=truncatedSemMicro;
load('D:\data\letter_perf_time_visual_repo.mat','truncatedMeanAllSetsPerfVisualBin','truncatedSemVisual')
MonkeyCombinedData.letTaskPerfWithTimeVisual=truncatedMeanAllSetsPerfVisualBin;
MonkeyCombinedData.letTaskSemWithTimeVisual=truncatedSemVisual;
load('X:\best\results\letter_behavioural_performance_all_sets_070618_B6_all_trials_corrected_RFs.mat');
MonkeyLData.letTaskPerfAllTrialsMicro=goodSetsallSetsPerfMicroAllTrials;
MonkeyLData.letTaskPerfAllTrialsVisual=goodSetsallSetsPerfVisualAllTrials;
load('D:\aston_data\letter_behavioural_performance_all_sets_190219_B7_aston_all_trials.mat')
MonkeyAData.letTaskPerfAllTrialsMicro=goodSetsallSetsPerfMicroAllTrials;
MonkeyAData.letTaskPerfAllTrialsVisual=goodSetsallSetsPerfVisualAllTrials;

load('D:\data\control_letter_perf_time_micro_repo.mat')
MonkeyCombinedData.controlLetTaskPerfWithTimeMicro=truncatedMeanAllSetsPerfMicroBin;
MonkeyCombinedData.controlLetTaskSemWithTimeMicro=truncatedSemMicro;
load('D:\data\control_letter_perf_time_visual_repo.mat')
MonkeyCombinedData.controlLetTaskPerfWithTimeVisual=truncatedMeanAllSetsPerfVisualBin;
MonkeyCombinedData.controlLetTaskSemWithTimeVisual=truncatedSemVisual;
load('X:\best\results\control_letter_behavioural_performance_all_sets_150819_B1_100trials.mat')
MonkeyLData.controlLetTaskPerfAllTrialsMicro=meanPerfAllSetsM';
MonkeyLData.controlLetTaskPerfAllTrialsVisual=meanPerfAllSetsV';
load('D:\aston_data\control_letter_behavioural_performance_all_sets_080819_B2_aston_100trials.mat')
MonkeyAData.controlLetTaskPerfAllTrialsMicro=meanPerfAllSetsM';
MonkeyAData.controlLetTaskPerfAllTrialsVisual=meanPerfAllSetsV';

%V4 data
load('D:\data\v4_repo_dataset\psychometricExample.mat','HitrateCurve','UniCurrentLevels','hitrate','SEMhitrate','HitrateThreshold')
load('D:\data\v4_repo_dataset\neurometricExample.mat','MUAcurve','UniCurrentLevels','Rstim','SEMstim','MUAthreshold')
MonkeyCombinedData.HitrateCurve=HitrateCurve;
MonkeyCombinedData.UniCurrentLevels=UniCurrentLevels;
MonkeyCombinedData.hitrate=hitrate;
MonkeyCombinedData.SEMhitrate=SEMhitrate;
MonkeyCombinedData.MUAcurve=MUAcurve;
MonkeyCombinedData.MUAthreshold=MUAthreshold;
MonkeyCombinedData.Rstim=Rstim;
MonkeyCombinedData.SEMstim=SEMstim;
MonkeyCombinedData.HitrateThreshold=HitrateThreshold;

load('D:\data\v4_repo_dataset\v4trialActExample.mat','v4trialActExample','Rmax','NumCurrentLevels')
MonkeyCombinedData.v4trialActExample=v4trialActExample;
MonkeyCombinedData.Rmax=Rmax;
MonkeyCombinedData.NumCurrentLevels=NumCurrentLevels;
load('D:\data\v4_repo_dataset\supplementaryfiguredata.mat')
MonkeyCombinedData.figuredata=figuredata;

%save .mat files
fileName=fullfile('D:\data\data_repo_monkeyL');
save(fileName,'MonkeyLData');

fileName=fullfile('D:\data\data_repo_monkeyA');
save(fileName,'MonkeyAData');

fileName=fullfile('D:\data\data_repo_monkeysCombined');
save(fileName,'MonkeyCombinedData');