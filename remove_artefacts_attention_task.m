function remove_artefacts_attention_task(date)
%Written by Xing 19/7/18, based on Feng's testdata.m code to remove
%microstimulation artefacts from data collected during an attention task
%(attend to a phosphene percept that is evoked by microstimulation, or
%attend to a visually presented stimulus).

localDisk=1;
if localDisk==1
    rootdir='D:\data\';
elseif localDisk==0
    rootdir='X:\best\';
end
for neuronalCh=1:128%length(neuronalChsV4)%analog input 8, records sync pulse from array 11
    for blockInd=1:5%length(goodBlocks)
        for includeIncorrect=1:2%1: include all trials; 2: exclude incorrect trials
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
            
            AMFAR = AMF;
            AVFAR = AVF;
            AMSAR = AMS;
            AVSAR = AVS;
            
            NumElec = size(AMF,3);
            
            for ElecID = 1:NumElec
                
                RawTrace = AMF(:,:,ElecID);
                RawTrace = RawTrace';
                AlignedMeanTrace = squeeze(mean(mean(AMF,1),3));
                ARTrace = RemoveArtifacts(AlignedMeanTrace,RawTrace,StimulationParam,SampleRate,SupersamplingRatio,debug);
                AMFAR(:,:,ElecID) = ARTrace';
                
                RawTrace = AVF(:,:,ElecID);
                RawTrace = RawTrace';
                AlignedMeanTrace = squeeze(mean(mean(AVF,1),3));
                ARTrace = RemoveArtifacts(AlignedMeanTrace,RawTrace,StimulationParam,SampleRate,SupersamplingRatio,debug);
                AVFAR(:,:,ElecID) = ARTrace';
                
                RawTrace = AMS(:,:,ElecID);
                RawTrace = RawTrace';
                AlignedMeanTrace = squeeze(mean(mean(AMS,1),3));
                ARTrace = RemoveArtifacts(AlignedMeanTrace,RawTrace,StimulationParam,SampleRate,SupersamplingRatio,debug);
                AMSAR(:,:,ElecID) = ARTrace';
                
                if ~isempty(AVS)%for analysis that includes only correct trials, the variable AVS will be empty
                    RawTrace = AVS(:,:,ElecID);
                    RawTrace = RawTrace';
                    AlignedMeanTrace = squeeze(mean(mean(AVS,1),3));
                    ARTrace = RemoveArtifacts(AlignedMeanTrace,RawTrace,StimulationParam,SampleRate,SupersamplingRatio,debug);
                    AVSAR(:,:,ElecID) = ARTrace';
                end
            end
            
            AMFARMUAe=[];
            AMFARlfp=[];
            AVFARMUAe=[];
            AVFARlfp=[];
            AMSARMUAe=[];
            AMSARlfp=[];
            AVSARMUAe=[];
            AVSARlfp=[];
            
            for ElecID = 1:NumElec
                RawData = AMFAR(:,:,ElecID);
                RawData = RawData';
                [MUAe, LFP] = GetMUAeLFP(RawData,SampleRate,MUAparameters,LFPparameters);
                AMFARMUAe(:,:,ElecID) = MUAe.data';
                AMFARlfp(:,:,ElecID) = LFP.data';
                
                RawData = AVFAR(:,:,ElecID);
                RawData = RawData';
                [MUAe, LFP] = GetMUAeLFP(RawData,SampleRate,MUAparameters,LFPparameters);
                AVFARMUAe(:,:,ElecID) = MUAe.data';
                AVFARlfp(:,:,ElecID) = LFP.data';
                
                RawData = AMSAR(:,:,ElecID);
                RawData = RawData';
                [MUAe, LFP] = GetMUAeLFP(RawData,SampleRate,MUAparameters,LFPparameters);
                AMSARMUAe(:,:,ElecID) = MUAe.data';
                AMSARlfp(:,:,ElecID) = LFP.data';
                
                if ~isempty(AVS)%for analysis that includes only correct trials, the variable AVS will be empty
                    RawData = AVSAR(:,:,ElecID);
                    RawData = RawData';
                    [MUAe, LFP] = GetMUAeLFP(RawData,SampleRate,MUAparameters,LFPparameters);
                    AVSARMUAe(:,:,ElecID) = MUAe.data';
                    AVSARlfp(:,:,ElecID) = LFP.data';
                end
            end
            
            artifactRemovedFolder='AR';
            artifactRemovedChPathName=fullfile(rootdir,date,subFolderName,artifactRemovedFolder);
            if ~exist(artifactRemovedChPathName,'dir')
                mkdir(artifactRemovedChPathName);
            end
            artifactRemovedChFileName=fullfile(artifactRemovedChPathName,['AR_Ch',num2str(neuronalCh),'_block',num2str(blockInd),'.mat']);
            save(artifactRemovedChFileName,'AMFAR','AVFAR','AMSAR','AVSAR')
            artifactRemovedFileName=fullfile(artifactRemovedChPathName,['AR_neural_Ch',num2str(neuronalCh),'_block',num2str(blockInd),'.mat']);
            save(artifactRemovedFileName,'AMFARMUAe','AVFARMUAe','AMSARMUAe','AVSARMUAe','AMFARlfp','AVFARlfp','AMSARlfp','AVSARlfp')
        end
    end
end