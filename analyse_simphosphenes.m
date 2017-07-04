function analyse_simphosphenes
%3/7/17
%Written by Xing. Extracts MUA data from raw .NS6 file, during presentation
%of sweeping white bar stimuli for RF mapping.
stimDurms=800;%in ms
stimDur=stimDurms/1000;%in seconds
date='040717_B1';
matFile=['D:\data\',date,'\',date,'_data\simphosphenes5_2017',date,'.mat'];
load(matFile);
[dummy goodTrials]=find(performance~=0);
goodTrialConds=allTrialCond(goodTrials,:);
goodTrialIDs=TRLMAT(goodTrials,:);

processRaw=1;
if processRaw==1
    for instanceInd=6:8
        instanceName=['instance',num2str(instanceInd)];
        instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
        NEV=openNEV(instanceNEVFileName);
        codeStimOn=1;%In runstim code, StimB (stimulus bit) is 1.
        codeTargOn=2;%In runstim code, TargB (target bit) is 2.
        corrBit=7;
        ErrorBit=0;
        %dasbit sends a change in the bit (either high or low) on one of the 8 ports
        oldIndStimOns=find(NEV.Data.SerialDigitalIO.UnparsedData==2^codeStimOn);%starts at 2^0, till 2^7
        oldTimeStimOns=NEV.Data.SerialDigitalIO.TimeStamp(oldIndStimOns);%time stamps corresponding to stimulus onset
        correctTrialCodes=[codeStimOn codeTargOn 4 corrBit];%identify trials where fixation was maintained throughout
        incorrectTrialCodes=[codeStimOn codeTargOn 4 ErrorBit];%identify trials where fixation was maintained throughout
        indStimOns=[];
        timeStimOns=[];
        trialStimConds=[];
        for i=1:length(oldIndStimOns)
            if oldIndStimOns(i)+11<length(NEV.Data.SerialDigitalIO.UnparsedData)
                trialCodes(i,:)=NEV.Data.SerialDigitalIO.UnparsedData(oldIndStimOns(i):oldIndStimOns(i)+11);
                if sum(trialCodes(i,1:length(correctTrialCodes))==2.^correctTrialCodes)==length(correctTrialCodes)||sum(trialCodes(i,1:length(correctTrialCodes))==2.^incorrectTrialCodes)==length(incorrectTrialCodes)
                    indStimOns=[indStimOns oldIndStimOns(i)];
                    timeStimOns=[timeStimOns oldTimeStimOns(i)];
                    trialStimConds=[trialStimConds NEV.Data.SerialDigitalIO.UnparsedData(oldIndStimOns(i)+4:oldIndStimOns(i)+11)];%read out stimulus condition
                end
            end
        end             
        convertedGoodTrialIDs=goodTrialIDs';
        convertedGoodTrialIDs=2.^convertedGoodTrialIDs;
        goodTrialIDscounter=1;
        goodTrialsInd=[];
        indStimOnsMatch=[];
        timeStimOnsMatch=[];
        matMatchInd=[];
        for rowInd=1:length(indStimOns)
            matchInd=1;
            ID=[];
            for nevSeqInd=1:7
                match=find(trialStimConds(nevSeqInd,rowInd)==convertedGoodTrialIDs(matchInd:8,goodTrialIDscounter));
                if ~isempty(match)
                    match=match(1);                    
                    ID=[ID trialStimConds(nevSeqInd,rowInd)];
                end
            end
            if length(ID)>=6
                goodTrialsInd=[goodTrialsInd rowInd];
                indStimOnsMatch=[indStimOnsMatch indStimOns(rowInd)];
                timeStimOnsMatch=[timeStimOnsMatch timeStimOns(rowInd)];
                IDs(:,rowInd)=convertedGoodTrialIDs(1:6,goodTrialIDscounter);
                matMatchInd=[matMatchInd goodTrialIDscounter];
                goodTrialIDscounter=goodTrialIDscounter+1;
            else%if the trials do not align at first, search through subsequent trials in goodTrialIDs to find matching one. If none match, then that trial (although present in NEV data) will be excluded
                matchFlag=0;
                while matchFlag==0
                    matchInd=1;
                    ID=[];
                    for nevSeqInd=1:7
                        match=find(trialStimConds(nevSeqInd,rowInd)==convertedGoodTrialIDs(matchInd:8,goodTrialIDscounter));
                        if ~isempty(match)
                            match=match(1);
                            ID=[ID trialStimConds(nevSeqInd,rowInd)];
                        end
                    end
                    if length(ID)>=6
                        goodTrialIDscounter=goodTrialIDscounter+1;
                        goodTrialsInd=[goodTrialsInd rowInd];
                        indStimOnsMatch=[indStimOnsMatch indStimOns(rowInd)];
                        timeStimOnsMatch=[timeStimOnsMatch timeStimOns(rowInd)];
                        IDs(:,rowInd)=convertedGoodTrialIDs(1:6,goodTrialIDscounter);%store the X- and Y- positions for that stimulus presentation
                        matchFlag=1;
                        matMatchInd=[matMatchInd goodTrialIDscounter];
                    else
                        goodTrialIDscounter=goodTrialIDscounter+1;
                    end
                end
            end
        end
        
        %read in neural data:
        instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6']; 
        for channelInd=1:128
            readChannel=['c:',num2str(channelInd),':',num2str(channelInd)];
            NSch=openNSx(instanceNS6FileName,'read',readChannel);
            %         NS=openNSx(instanceNS6FileName);
            % NS=openNSx('t:1:6000000');%200 s
            
            S=double(NSch.Data);%for MUA extraction, process data for that channel at one shot, across entire session
            %extract MUA for each channel and trial:
            tic
            channelDataMUA=[];
            %MAKE MUAe
            %Bandpassed, rectified and low-passed data
            %================================================
            Fs=sampFreq;%sampling frequency
            %BANDPASS
            Fbp=[500,9000];
            N  = 2;    % filter order
            Fn = Fs/2; % Nyquist frequency
            [B, A] = butter(N, [min(Fbp)/Fn max(Fbp)/Fn]); % compute filter coefficients
            dum1 = filtfilt(B, A, S); % apply filter to the data
            %RECTIFY
            dum2 = abs(dum1);
            
            %LOW-PASS
            Fl=200;
            N  = 2;    % filter order
            Fn = Fs/2; % Nyquist frequency
            [B, A] = butter(N,Fl/Fn,'low'); % compute filter coefficients
            muafilt = filtfilt(B, A, dum2);
            %Downsample
            muafilt = downsample(muafilt,downsampleFreq); % apply filter to the data and downsample
            
            %Kill the first sample to get rid of artifact
            muafilt = muafilt(2:end);
            
            %50Hz removal
            FsD = Fs/downsampleFreq;
            Fn = FsD/2; % Downsampled Nyquist frequency
            for v = [50 100 150];
                Fbp = [v-2,v+2];
                [Blp, Alp] = butter(N, [min(Fbp)/Fn max(Fbp)/Fn],'stop'); % compute filter coefficients
                muafilt = filtfilt(Blp, Alp, muafilt);
            end
            MUA = muafilt;
            
            %Assign to vargpout
            channelDataMUA=MUA;
            %         channelDataMUA(trialInd,:)=MUA;
            %     end
            fileName=fullfile('D:\data',date,['MUA_',instanceName,'_ch',num2str(channelInd),'_new.mat']);
            save(fileName,'channelDataMUA','trialStimConds','matMatchInd','timeStimOnsMatch','indStimOnsMatch','goodTrialsInd');
            toc
        end
    end
end
                
%         sampFreq=NS.MetaTags.SamplingFreq;
%         trialData={};
%         preStimDur=300/1000;%length of pre-stimulus-onset period, in s
%         postStimDur=400/1000;%length of post-stimulus-offset period, in s
%         for trialInd=1:length(timeStimOns)
%             trialData{trialInd}=NS.Data(:,timeStimOnsMatch(trialInd)-sampFreq*preStimDur:timeStimOnsMatch(trialInd)+sampFreq*stimDur+sampFreq*postStimDur-1);%raw data in uV, read in data during stimulus presentation
%         end
%         
%         %Average across trials and plot activity:
%         % load(fileName);
%         % figure(1)
%         % hold on
%         meanChannelMUA(channelInd,:)=mean(channelDataMUA{1},1);
%         for channelInd=1:NS.MetaTags.ChannelCount
%             figInd=ceil(channelInd/36);
%             figure(figInd);hold on
%             subplotInd=channelInd-((figInd-1)*36);
%             subplot(6,6,subplotInd);
%             plot(meanChannelMUA(channelInd,:))
%             ax=gca;
%             ax.XTick=[0 sampFreq*preStimDur/downsampleFreq sampFreq*(preStimDur+stimDur)/downsampleFreq];
%             ax.XTickLabel={num2str(preStimDur*1000),'0',num2str(stimDurms)};
%             %     set(gca,'ylim',[0 max(meanChannelMUA(channelInd,:))]);
%             title(num2str(channelInd));
%         end
%         
%         %Sort trials according to stimulus condition:
% %         stimCondCol='rgbk';
% %         for stimCond=3:6
% %             meanChannelMUA=[];
% %             for channelInd=1:NS.MetaTags.ChannelCount
% %                 stimCondInd=find(trialStimConds==2^stimCond);
% %                 stimCondChannelDataMUA=channelDataMUA{channelInd}(stimCondInd,:);
% %                 meanChannelMUA(channelInd,:)=mean(stimCondChannelDataMUA,1);
% %                 %         allStimCondChannelDataMUA{stimCond-2}=stimCondChannelDataMUA;
% %                 %     plot(meanChannelMUA(channelInd,:))
% %             end
% %             fileName=fullfile('D:\data',date,['mean_MUA_',instanceName,'cond',num2str(stimCond-2)','.mat']);
% %             save(fileName,'meanChannelMUA');
% %             
% %             for channelInd=1:NS.MetaTags.ChannelCount
% %                 figInd=ceil(channelInd/36);
% %                 figure(figInd);hold on
% %                 subplotInd=channelInd-((figInd-1)*36);
% %                 subplot(6,6,subplotInd);
% %                 plot(meanChannelMUA(channelInd,:),stimCondCol(stimCond-2))
% %                 ax=gca;
% %                 ax.XTick=[0 sampFreq*preStimDur/downsampleFreq sampFreq*(preStimDur+stimDur)/downsampleFreq];
% %                 ax.XTickLabel={num2str(preStimDur*1000),'0',num2str(stimDurms)};
% %                 %     set(gca,'ylim',[0 max(meanChannelMUA(channelInd,:))]);
% %                 title(num2str(channelInd));
% %             end
% %         end
%         clearvars -except stimDurms stimDur date instanceInd
%         close all
%     end
% end
% 
% %to draw plots from previously processed data:
% loadData=1;
% if loadData==1
%     for instanceInd=5:8
%         instanceName=['instance',num2str(instanceInd)];
%         %     instanceName='instance1';
%         fileName=['D:\data\',date,'\MUA_',instanceName,'.mat'];
%         load(fileName)
%         sampFreq=30000;
%         stimDurms=1000;%in ms
%         stimDur=stimDurms/1000;%in seconds
%         preStimDur=300/1000;%length of pre-stimulus-onset period, in s
%         postStimDur=300/1000;%length of post-stimulus-offset period, in s
%         downsampleFreq=30;
%         
%         for channelInd=1:128
%             meanChannelMUA(channelInd,:)=mean(channelDataMUA{channelInd},1);
%             figInd=ceil(channelInd/36);
%             figure(figInd);hold on
%             subplotInd=channelInd-((figInd-1)*36);
%             subplot(6,6,subplotInd);
%             plot(meanChannelMUA(channelInd,:))
%             ax=gca;
%             ax.XTick=[0 sampFreq*preStimDur/downsampleFreq sampFreq*(preStimDur+stimDur)/downsampleFreq];
%             ax.XTickLabel={num2str(preStimDur*1000),'0',num2str(stimDurms)};
%             %     set(gca,'ylim',[0 max(meanChannelMUA(channelInd,:))]);
%             title(num2str(channelInd));
%         end
%         for figInd=1:4
%             figure(figInd)
%             set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
%             pathname=fullfile('D:\data',date,[instanceName,'_',num2str(figInd),'_visual_response']);
%             print(pathname,'-dtiff');
%         end
%         
% %         stimCondCol='rgbk';
% %         for stimCond=3:6
% %             meanChannelMUA=[];
% %             for channelInd=1:128
% %                 stimCondInd=find(trialStimConds==2^stimCond);
% %                 stimCondChannelDataMUA=channelDataMUA{channelInd}(stimCondInd,:);
% %                 meanChannelMUA(channelInd,:)=mean(stimCondChannelDataMUA,1);
% %                 %     plot(meanChannelMUA(channelInd,:))
% %             end
% %             fileName=fullfile('D:\data',date,['mean_MUA_',instanceName,'cond',num2str(stimCond-2)','.mat']);
% %             save(fileName,'meanChannelMUA');
% %             
% %             for channelInd=1:128
% %                 figInd=ceil(channelInd/36);
% %                 figure(figInd);hold on
% %                 subplotInd=channelInd-((figInd-1)*36);
% %                 subplot(6,6,subplotInd);
% %                 plot(meanChannelMUA(channelInd,:),stimCondCol(stimCond-2))
% %                 ax=gca;
% %                 ax.XTick=[0 sampFreq*preStimDur/downsampleFreq sampFreq*(preStimDur+stimDur)/downsampleFreq];
% %                 ax.XTickLabel={num2str(preStimDur*1000),'0',num2str(stimDurms)};
% %                 %     set(gca,'ylim',[0 max(meanChannelMUA(channelInd,:))]);
% %                 title(num2str(channelInd));
% %             end
% %         end
% %         for figInd=1:4
% %             figure(figInd)
% %             set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
% %             pathname=fullfile('D:\data',date,[instanceName,'_',num2str(figInd)]);
% %             print(pathname,'-dtiff');
% %         end
%         close all
%     end
% end
% pause=1;