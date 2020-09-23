function visual_prosthesis_monkey_script
%Written by Xing Chen on 18/8/20.
%Loads data from .mat files in data repository and runs plotting and
%analysis scripts in conjunction with publication of article, 'Shape
%perception via a high-channel-count neuroprosthesis in monkey visual
%cortex.'

%--------------------------------------------------------------------------
%Load .mat files containing data:
load('..\Data\data_repo_monkeyL','MonkeyLData');%Monkey L
load('..\Data\data_repo_monkeyA','MonkeyAData');%Monkey A
load('..\Data\data_repo_monkeysCombined','MonkeyCombinedData');%Data combined across Monkeys L & A
load('..\Data\data_repo_monkeysCombined_V4')%Data for V4 task; takes several seconds to load
%--------------------------------------------------------------------------
%Channel indexing to look up electrode number, array number, and area of
%implantation:
% MonkeyCombinedData.arrayInds;
% MonkeyCombinedData.channelInds;
% MonkeyCombinedData.areaInds;
%--------------------------------------------------------------------------
%RFs:
% MonkeyLData.RFx;
% MonkeyLData.RFy;
% MonkeyAData.RFx;
% MonkeyAData.RFy;
plot_RFs_repo(MonkeyLData.RFx,MonkeyLData.RFy,MonkeyLData.goodSNR,MonkeyCombinedData.arrayInds,MonkeyCombinedData.channelInds,MonkeyCombinedData.areaInds)
plot_RFs_repo(MonkeyAData.RFx,MonkeyAData.RFy,MonkeyAData.goodSNR,MonkeyCombinedData.arrayInds,MonkeyCombinedData.channelInds,MonkeyCombinedData.areaInds)
%--------------------------------------------------------------------------
%Current thresholds:
% MonkeyLData.currentThresholds;
% MonkeyAData.currentThresholds;
plot_current_thresholds_repo(MonkeyLData.currentThresholds)
plot_current_thresholds_repo(MonkeyAData.currentThresholds)
%--------------------------------------------------------------------------
% Saccade-to-phosphene task:
%Monkey L. Coordinates, polar angle and eccentricity of saccade end points
%during high current amplitudes:
% MonkeyLData.saccXHighCurr;%X-coordinates of saccade end points
% MonkeyLData.saccYHighCurr;%Y-coordinates of saccade end points
% MonkeyLData.saccPolarAngHighCurr;%Polar angle of saccade end points
% MonkeyLData.saccEccHighCurr;%Eccentricity of saccade end points
% MonkeyLData.RFPolarAngHighCurr;%Polar angle of RFs (for comparison with that of saccade end points)
% MonkeyLData.RFEccHighCurr;%Eccentricity of RFs (for comparison with that of saccade end points)
plot_saccades_repo('L',MonkeyLData.saccXHighCurr,MonkeyLData.saccYHighCurr,MonkeyLData.saccPolarAngHighCurr,MonkeyLData.saccEccHighCurr,MonkeyLData.RFPolarAngHighCurr,MonkeyLData.RFEccHighCurr,MonkeyLData.saccArrayList)

%Monkey L. Eccentricity of saccade end points during high vs medium current
%amplitudes, where channels are matched between the two current amplitude
%conditions:
% MonkeyLData.saccEccHighCurrCompare;%Eccentricity of saccade end points during microstimulation at high current amplitudes
% MonkeyLData.saccEccMedCurrCompare;%Eccentricity of saccade end points during microstimulation at medium current amplitudes
plot_saccades_high_medium_current_repo('L',MonkeyLData.saccEccHighCurrCompare,MonkeyLData.saccEccMedCurrCompare)

%Monkey A. Coordinates, polar angle and eccentricity of saccade end points
%during high current amplitudes:
% MonkeyAData.saccXHighCurr;%X-coordinates of saccade end points
% MonkeyAData.saccYHighCurr;%Y-coordinates of saccade end points
% MonkeyAData.saccPolarAngHighCurr;%Polar angle of saccade end points
% MonkeyAData.saccEccHighCurr;%Eccentricity of saccade end points
% MonkeyAData.RFPolarAngHighCurr;%Polar angle of RFs (for comparison with that of saccade end points)
% MonkeyAData.RFEccHighCurr;%Eccentricity of RFs (for comparison with that of saccade end points)
plot_saccades_repo('A',MonkeyAData.saccXHighCurr,MonkeyAData.saccYHighCurr,MonkeyAData.saccPolarAngHighCurr,MonkeyAData.saccEccHighCurr,MonkeyAData.RFPolarAngHighCurr,MonkeyAData.RFEccHighCurr,MonkeyAData.saccArrayList)

%Monkey A. Eccentricity of saccade end points during high vs medium current
%amplitudes, where channels are matched between the two current amplitude
%conditions:
% MonkeyAData.saccEccHighCurrCompare;%Eccentricity of saccade end points during microstimulation at high current amplitudes
% MonkeyAData.saccEccMedCurrCompare;%Eccentricity of saccade end points during microstimulation at medium current amplitudes
plot_saccades_high_medium_current_repo('A',MonkeyAData.saccEccHighCurrCompare,MonkeyAData.saccEccMedCurrCompare)

% V4 activity during saccade-to-phosphene task:
plot_psycho_neuro_v4_repo(MonkeyCombinedData.HitrateCurve,MonkeyCombinedData.UniCurrentLevels,MonkeyCombinedData.hitrate,MonkeyCombinedData.SEMhitrate,MonkeyCombinedData.MUAcurve,MonkeyCombinedData.Rstim,MonkeyCombinedData.SEMstim,MonkeyCombinedData.HitrateThreshold,MonkeyCombinedData.MUAthreshold);
plot_trial_act_v4_repo(MonkeyCombinedData.v4trialActExample,MonkeyCombinedData.Rmax,MonkeyCombinedData.UniCurrentLevels);
plot_artefact_removal_repo(MonkeyCombinedData.figuredata);
plot_low_med_high_thresh_repo(ResponseDB,allV4Threshold,allBehaviorThreshold);
%--------------------------------------------------------------------------
%Behav tasks
%--------------------------------------------------------------------------
%Orientation task:
% MonkeyCombinedData.oriTaskPerfWithTimeMicro;
% MonkeyCombinedData.oriTaskSemWithTimeMicro;
%Performance as a function of trial number, combined across two monkeys.
plot_performance_time_repo('ori',MonkeyCombinedData.oriTaskPerfWithTimeMicro,MonkeyCombinedData.oriTaskSemWithTimeMicro);

% MonkeyLData.oriTaskPerfAllTrialsMicro;
% MonkeyLData.oriTaskPerfAllTrialsVisual;
%Monkey L. Histograms of performance, across multiple electrode sets.
plot_performance_repo('ori',MonkeyLData.oriTaskPerfAllTrialsMicro,MonkeyLData.oriTaskPerfAllTrialsVisual);

% MonkeyAData.oriTaskPerfAllTrialsMicro;
% MonkeyAData.oriTaskPerfAllTrialsVisual;
%Monkey A. Histograms of performance, across multiple electrode sets.
plot_performance_repo('ori',MonkeyAData.oriTaskPerfAllTrialsMicro,MonkeyAData.oriTaskPerfAllTrialsVisual);
%--------------------------------------------------------------------------
%Direction-of-motion task:
% MonkeyCombinedData.dirTaskPerfWithTimeMicro;
% MonkeyCombinedData.dirTaskSemWithTimeMicro;
%Performance as a function of trial number, combined across two monkeys.
plot_performance_time_repo('dir',MonkeyCombinedData.dirTaskPerfWithTimeMicro,MonkeyCombinedData.dirTaskSemWithTimeMicro);

% MonkeyLData.dirTaskPerfAllTrialsMicro;
% MonkeyLData.dirTaskPerfAllTrialsVisual;
%Monkey L. Histograms of performance, across multiple electrode sets.
plot_performance_repo('dir',MonkeyLData.dirTaskPerfAllTrialsMicro,MonkeyLData.dirTaskPerfAllTrialsVisual);

% MonkeyAData.dirTaskPerfAllTrialsMicro;
% MonkeyAData.dirTaskPerfAllTrialsVisual;
%Monkey A. Histograms of performance, across multiple electrode sets.
plot_performance_repo('dir',MonkeyAData.dirTaskPerfAllTrialsMicro,MonkeyAData.dirTaskPerfAllTrialsVisual);
%--------------------------------------------------------------------------
%Letter task:
% MonkeyCombinedData.letTaskPerfWithTimeMicro;
% MonkeyCombinedData.letTaskSemWithTimeMicro;
% MonkeyCombinedData.letTaskPerfWithTimeVisual;
% MonkeyCombinedData.letTaskSemWithTimeVisual;
%Performance as a function of trial number, combined across two monkeys.
plot_performance_time_repo('let',MonkeyCombinedData.letTaskPerfWithTimeMicro,MonkeyCombinedData.letTaskSemWithTimeMicro);

% MonkeyLData.letTaskPerfAllTrialsMicro;
% MonkeyLData.letTaskPerfAllTrialsVisual;
%Monkey L. Histograms of performance, across multiple electrode sets.
plot_performance_repo('let',MonkeyLData.letTaskPerfAllTrialsMicro,MonkeyLData.letTaskPerfAllTrialsVisual);

% MonkeyAData.letTaskPerfAllTrialsMicro;
% MonkeyAData.letTaskPerfAllTrialsVisual;
%Monkey A. Histograms of performance, across multiple electrode sets.
plot_performance_repo('let',MonkeyAData.letTaskPerfAllTrialsMicro,MonkeyAData.letTaskPerfAllTrialsVisual);
%--------------------------------------------------------------------------
%Control task:
% MonkeyCombinedData.controlLetTaskPerfWithTimeMicro;
% MonkeyCombinedData.controlLetTaskSemWithTimeMicro;
% MonkeyCombinedData.controlLetTaskPerfWithTimeVisual;
% MonkeyCombinedData.controlLetTaskSemWithTimeVisual;
%Performance as a function of trial number, combined across two monkeys.
plot_performance_time_repo('con',MonkeyCombinedData.controlLetTaskPerfWithTimeMicro,MonkeyCombinedData.controlLetTaskSemWithTimeMicro);

% MonkeyLData.controlLetTaskPerfAllTrialsMicro;
% MonkeyLData.controlLetTaskPerfAllTrialsVisual;
%Monkey L. Histograms of performance, across multiple electrode sets.
plot_performance_repo('con',MonkeyLData.controlLetTaskPerfAllTrialsMicro,MonkeyLData.controlLetTaskPerfAllTrialsVisual);

% MonkeyAData.controlLetTaskPerfAllTrialsMicro;
% MonkeyAData.controlLetTaskPerfAllTrialsVisual;
%Monkey A. Histograms of performance, across multiple electrode sets.
plot_performance_repo('con',MonkeyAData.controlLetTaskPerfAllTrialsMicro,MonkeyAData.controlLetTaskPerfAllTrialsVisual);