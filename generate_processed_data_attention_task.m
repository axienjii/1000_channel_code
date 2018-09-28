function generate_processed_data_attention_task(date)
%Written by Xing 12/9/18, to extract MUA data from raw traces during an attention task
%(attend to a visually presented stimulus either on the left or the right).
%Note that as no micrositmulation was delivered, no artifact removal is
%carried out. However, variables names still have 'AR' ('artifact removed')
%appended to them, to allow compatibility with next analysis script,
%(analyse_eyedata_attention_task.m).

localDisk=1;
if localDisk==1
    rootdir='D:\data\';
elseif localDisk==0
    rootdir='X:\best\';
end
switch(date)
    case '120918_B1' 
        includeIncorrectInds=[1 2];
        matFileName=fullfile(rootdir,date,'instance1_trialInfo.mat');
        load(matFileName,'goodBlocks');
        goodBlocks=1:length(goodBlocks);
end

for neuronalCh=1:128%[34:75 77:96]%76%:96%1:128%1:128%length(neuronalChsV4)%analog input 8, records sync pulse from array 11
    for blockInd=goodBlocks
        for includeIncorrect=includeIncorrectInds%1:2%1: include all trials; 2: exclude incorrect trials
            if includeIncorrect==1
                subFolderName='all_trials';
            elseif includeIncorrect==2%exclude incorrect trials
                subFolderName='correct_trials';
            end
            subFolderPath=fullfile(rootdir,date,subFolderName);
            if ~exist('subFolderPath','dir')
                mkdir(subFolderPath);
            end
            alignRawChFileName=fullfile(rootdir,date,subFolderName,['alignedRawCh',num2str(neuronalCh),'_block',num2str(blockInd),'.mat']);
            load(alignRawChFileName);
            
            StimulationParam.numberofStimPulses = 50;
            StimulationParam.PulsesFrequency = 300; %Hz
            StimulationParam.stimulationwaveformwidth = 0.4; % ms
            StimulationParam.WaveDPbefore = 20; %number of datapoints, relative to peak of artifact waveform
            StimulationParam.WaveDPafter = 20; %number of datapoints, relative to peak of artifact waveform
            
            LFPparameters.LFPsamplingrate = 500; % Hz
            LFPparameters.LFPlowpassFreq = 150; % Hz
            
            MUAparameters.MUAeSamplingrate = 700; % Hz
            MUAparameters.MUAeBandpassFreq = [500 5000]; % Hz
            MUAparameters.MUAeLowpassFreq = 200; % Hz
            
            SampleRate = 30000;
            SupersamplingRatio = 16;
            debug = 1;
            
            AMFAR = AMF(any(AMF,2),:);%remove trials where no microstimulation delivered (zero values throughout whole trial). Actually only needed for AVS variable
            AVFAR = AVF(any(AVF,2),:);
            AMSAR = AMS(any(AMS,2),:);
            AVSAR = AVS(any(AVS,2),:);
            
            AMFARMUAe=[];
            AMFARlfp=[];
            AVFARMUAe=[];
            AVFARlfp=[];
            AMSARMUAe=[];
            AMSARlfp=[];
            AVSARMUAe=[];
            AVSARlfp=[];
            
            for ElecID = 1
                RawData = AMFAR(:,:,ElecID);
                RawData = RawData';
                [MUAe, LFP] = GetMUAeLFP(RawData,SampleRate,MUAparameters,LFPparameters);
%                 MUAe.data=MUAe.data-mean(MUAe.data(50:0.3*700));%subtract activity level during spontaneous period
                AMFARMUAe(:,:,ElecID) = MUAe.data';
                AMFARlfp(:,:,ElecID) = LFP.data';
                
                if ~isempty(AVFAR)
                    RawData = AVFAR(:,:,ElecID);
                    RawData = RawData';
                    [MUAe, LFP] = GetMUAeLFP(RawData,SampleRate,MUAparameters,LFPparameters);
                    %                 MUAe.data=MUAe.data-mean(MUAe.data(50:0.3*700));%subtract activity level during spontaneous period
                    AVFARMUAe(:,:,ElecID) = MUAe.data';
                    AVFARlfp(:,:,ElecID) = LFP.data';
                end
                
                RawData = AMSAR(:,:,ElecID);
                RawData = RawData';
                [MUAe, LFP] = GetMUAeLFP(RawData,SampleRate,MUAparameters,LFPparameters);
%                 MUAe.data=MUAe.data-mean(MUAe.data(50:0.3*700));%subtract activity level during spontaneous period
                AMSARMUAe(:,:,ElecID) = MUAe.data';
                AMSARlfp(:,:,ElecID) = LFP.data';
                
                if ~isempty(AVSAR)%for analysis that includes only correct trials, the variable AVS will be empty
                    RawData = AVSAR(:,:,ElecID);
                    RawData = RawData';
                    [MUAe, LFP] = GetMUAeLFP(RawData,SampleRate,MUAparameters,LFPparameters);
%                     MUAe.data=MUAe.data-mean(MUAe.data(50:0.3*700));%subtract activity level during spontaneous period
                    AVSARMUAe(:,:,ElecID) = MUAe.data';
                    AVSARlfp(:,:,ElecID) = LFP.data';
                end
            end
            
            artifactRemovedFolder='AR';
            artifactRemovedChPathName=fullfile(rootdir,date,subFolderName,artifactRemovedFolder);
            if ~exist(artifactRemovedChPathName,'dir')
                mkdir(artifactRemovedChPathName);
            end
                     
            %plot mean traces across trials in that block, removing
            %trials where no stimulus was presented (in reality, this only occurs for AVS condition)
            meanAVFARMUAe=(mean(AVFARMUAe,1));%attend-visual, deliver microstimulation in first interval
            meanAMFARMUAe=(mean(AMFARMUAe,1));%attend-micro, deliver microstimulation in first interval
            figure;
            subplot(1,2,1);hold on
            plot(meanAVFARMUAe,'b');
            plot(meanAMFARMUAe,'r');
            ax = gca;
            ax.XTick=[0 0.3*700 (0.3+0.167)*700 (0.3+0.167+0.4)*700];
            ax.XTickLabel={'-300','0','167','400'};
            minVal=min([meanAVFARMUAe(2:end) meanAMFARMUAe(2:end)]);
            maxVal=max([meanAVFARMUAe(2:end) meanAMFARMUAe(2:end)]);
            ylim([floor(minVal)-1 ceil(maxVal)+1]);
            ylims=get(ax,'ylim');
            plot([0.3*700 0.3*700],[ylims(1) ylims(2)],'k:');
            plot([(0.3+0.167)*700 (0.3+0.167)*700],[ylims(1) ylims(2)],'k:');
            subplot(1,2,2);hold on
            plot(smooth(meanAVFARMUAe,20),'b');
            plot(smooth(meanAMFARMUAe,20),'r');
            ax = gca;
            ax.XTick=[0 0.3*700 (0.3+0.167)*700 (0.3+0.167+0.4)*700];
            ax.XTickLabel={'-300','0','167','400'};
            ylim([floor(minVal)-1 ceil(maxVal)+1]);
            ylims=get(ax,'ylim');
            plot([0.3*700 0.3*700],[ylims(1) ylims(2)],'k:');
            plot([(0.3+0.167)*700 (0.3+0.167)*700],[ylims(1) ylims(2)],'k:');
            title(['microstim in interval 1, red: attend-micro, N=',num2str(size(AMFARMUAe,1)),'; blue: attend-visual, N=',num2str(size(AVFARMUAe,1))])
            pathname=fullfile(rootdir,date,subFolderName,artifactRemovedFolder,['MUAe_NSch',num2str(neuronalCh),'_block',num2str(blockInd),'_Minterval1']);
            set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
            print(pathname,'-dtiff');
            
            meanAVSARMUAe=(mean(AVSARMUAe,1));%attend-visual, deliver microstimulation in second interval
            meanAMSARMUAe=(mean(AMSARMUAe,1));%attend-micro, deliver microstimulation in second interval
            figure;hold on
            subplot(1,2,1);hold on
            plot(meanAVSARMUAe,'b');
            plot(meanAMSARMUAe,'r');
            ylim([floor(minVal)-1 ceil(maxVal)+1]);
            ylims=get(ax,'ylim');
            ax = gca;
            ax.XTick=[0 0.3*700 (0.3+0.167)*700 (0.3+0.167+0.4)*700];
            ax.XTickLabel={'-300','0','167','400'};
            minVal=min([meanAVSARMUAe(2:end) meanAMSARMUAe(2:end)]);
            maxVal=max([meanAVSARMUAe(2:end) meanAMSARMUAe(2:end)]);
            plot([0.3*700 0.3*700],[ylims(1) ylims(2)],'k:');
            plot([(0.3+0.167)*700 (0.3+0.167)*700],[ylims(1) ylims(2)],'k:');
            subplot(1,2,2);hold on
            plot(smooth(meanAVSARMUAe,20),'b');
            plot(smooth(meanAMSARMUAe,20),'r');
            ax = gca;
            ax.XTick=[0 0.3*700 (0.3+0.167)*700 (0.3+0.167+0.4)*700];
            ax.XTickLabel={'-300','0','167','400'};
            ylim([floor(minVal)-1 ceil(maxVal)+1]);
            ylims=get(ax,'ylim');
            plot([0.3*700 0.3*700],[ylims(1) ylims(2)],'k:');
            plot([(0.3+0.167)*700 (0.3+0.167)*700],[ylims(1) ylims(2)],'k:');
            title(['microstim in interval 2, red: attend-micro, N=',num2str(size(AMSARMUAe,1)),'; blue: attend-visual, N=',num2str(size(AVSARMUAe,1))])
            pathname=fullfile(rootdir,date,subFolderName,artifactRemovedFolder,['MUAe_NSch',num2str(neuronalCh),'_block',num2str(blockInd),'_Minterval2']);
            set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
            print(pathname,'-dtiff');
            close all
            artifactRemovedChFileName=fullfile(artifactRemovedChPathName,['AR_Ch',num2str(neuronalCh),'_block',num2str(blockInd),'.mat']);
            save(artifactRemovedChFileName,'AMFAR','AVFAR','AMSAR','AVSAR')
            artifactRemovedFileName=fullfile(artifactRemovedChPathName,['AR_neural_Ch',num2str(neuronalCh),'_block',num2str(blockInd),'.mat']);
            save(artifactRemovedFileName,'AMFARMUAe','AVFARMUAe','AMSARMUAe','AVSARMUAe','AMFARlfp','AVFARlfp','AMSARlfp','AVSARlfp','meanAVFARMUAe','meanAMFARMUAe','meanAVSARMUAe','meanAMSARMUAe')
            %combine data across channels:
            if includeIncorrect==1%all trials
                allMeanAMFARMUAe_all{blockInd}(neuronalCh,:)=meanAMFARMUAe;
                allMeanAVFARMUAe_all{blockInd}(neuronalCh,:)=meanAVFARMUAe;
                allMeanAMSARMUAe_all{blockInd}(neuronalCh,:)=meanAMSARMUAe;
                allMeanAVSARMUAe_all{blockInd}(neuronalCh,:)=meanAVSARMUAe;
            elseif includeIncorrect==2%only correct trials
                allMeanAMFARMUAe_cor{blockInd}(neuronalCh,:)=meanAMFARMUAe;
                allMeanAVFARMUAe_cor{blockInd}(neuronalCh,:)=meanAVFARMUAe;
                allMeanAMSARMUAe_cor{blockInd}(neuronalCh,:)=meanAMSARMUAe;
                allMeanAVSARMUAe_cor{blockInd}(neuronalCh,:)=meanAVSARMUAe;
            end
        end
    end
end
if isequal(includeIncorrectInds,2)
    artifactRemovedFileName=fullfile(artifactRemovedChPathName,['AR_all mean_chs_block',num2str(goodBlocks(1)),'-',num2str(goodBlocks(end)),'.mat']);
    save(artifactRemovedFileName,'allMeanAMFARMUAe_cor','allMeanAVFARMUAe_cor','allMeanAMSARMUAe_cor','allMeanAVSARMUAe_cor')
elseif isequal(includeIncorrectInds,1)
    artifactRemovedFileName=fullfile(artifactRemovedChPathName,['AR_all mean_chs_block',num2str(goodBlocks(1)),'-',num2str(goodBlocks(end)),'.mat']);
    save(artifactRemovedFileName,'allMeanAMFARMUAe_all','allMeanAVFARMUAe_all','allMeanAMSARMUAe_all','allMeanAVSARMUAe_all')
elseif isequal(includeIncorrectInds,[1 2])
    artifactRemovedFileName=fullfile(artifactRemovedChPathName,['AR_all mean_chs_block',num2str(goodBlocks(1)),'-',num2str(goodBlocks(end)),'.mat']);
    save(artifactRemovedFileName,'allMeanAMFARMUAe_all','allMeanAVFARMUAe_all','allMeanAMSARMUAe_all','allMeanAVSARMUAe_all','allMeanAMFARMUAe_cor','allMeanAVFARMUAe_cor','allMeanAMSARMUAe_cor','allMeanAVSARMUAe_cor')
end
for blockInd=goodBlocks
    load([rootdir,date,'\correct_trials\AR\AR_all mean_chs_block',num2str(goodBlocks(1)),'-',num2str(goodBlocks(end)),'.mat']);
    allMeanAMFARMUAe_cor=allMeanAMFARMUAe_cor{blockInd};
    allMeanAVFARMUAe_cor=allMeanAVFARMUAe_cor{blockInd};
    allMeanAMSARMUAe_cor=allMeanAMSARMUAe_cor{blockInd};
    allMeanAVSARMUAe_cor=allMeanAVSARMUAe_cor{blockInd};
    artifactRemovedFileName=[rootdir,date,'\correct_trials\AR\AR_all mean_chs_block',num2str(blockInd),'.mat'];
    save(artifactRemovedFileName,'allMeanAMFARMUAe_cor','allMeanAVFARMUAe_cor','allMeanAMSARMUAe_cor','allMeanAVSARMUAe_cor')
end

