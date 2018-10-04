function remove_artefacts_attention_task_correction(date)
%Written by Xing 4/9/18.

localDisk=1;
if localDisk==1
    rootdir='D:\data\';
elseif localDisk==0
    rootdir='X:\best\';
end
switch(date)
    case '240718_B13'
        goodBlocks=[1 2];
    case '310718_B1'
        goodBlocks=1;
    case '290818_B1'
        goodBlocks=1:7;
        includeIncorrectInds=2;
    case '120918_B1'
        goodBlocks=1:3;
        includeIncorrectInds=1:2;
end

generateMeanBlock=1;%set to 1 to generate mean activity for each block and channel
if generateMeanBlock==1
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
                artifactRemovedFolder='AR';
                artifactRemovedChPathName=fullfile(rootdir,date,subFolderName,artifactRemovedFolder);
                
                %             artifactRemovedChFileName=fullfile(artifactRemovedChPathName,['AR_Ch',num2str(neuronalCh),'_block',num2str(blockInd),'.mat']);
                %             load(artifactRemovedChFileName,'AMFAR','AVFAR','AMSAR','AVSAR')
                artifactRemovedFileName=fullfile(artifactRemovedChPathName,['AR_neural_Ch',num2str(neuronalCh),'_block',num2str(blockInd),'.mat']);
                load(artifactRemovedFileName,'meanAVFARMUAe','meanAMFARMUAe','meanAVSARMUAe','meanAMSARMUAe')
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
        load(['D:\data\',date,'\correct_trials\AR\AR_all_mean_chs_block',num2str(goodBlocks(1)),'-',num2str(goodBlocks(end)),'.mat'])
        allMeanAMFARMUAe_cor=allMeanAMFARMUAe_cor{blockInd};
        allMeanAVFARMUAe_cor=allMeanAVFARMUAe_cor{blockInd};
        allMeanAMSARMUAe_cor=allMeanAMSARMUAe_cor{blockInd};
        allMeanAVSARMUAe_cor=allMeanAVSARMUAe_cor{blockInd};
        artifactRemovedFileName=['D:\data\',date,'\correct_trials\AR\AR_all_mean_chs_block',num2str(blockInd),'.mat'];
        save(artifactRemovedFileName,'allMeanAMFARMUAe_cor','allMeanAVFARMUAe_cor','allMeanAMSARMUAe_cor','allMeanAVSARMUAe_cor')
    end
end

