function analyse_RF_klink
%29/5/17
%Written by Xing. Extracts MUA data from raw .NS6 file, during presentation
%of sweeping white bar stimuli for RF mapping.
stimDurms=1000;%in ms
stimDur=stimDurms/1000;%in seconds
date='020818_B2';
processRaw=1;
if processRaw==1
    for instanceInd=1:4
        instanceName=['instance',num2str(instanceInd)];
        instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
        NEV=openNEV(instanceNEVFileName);
        instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
        NS=openNSx(instanceNS6FileName);%200 s
        % NS=openNSx('t:1:6000000');%200 s
        sampFreq=NS.MetaTags.SamplingFreq;
        channelData={};
        for channelInd=1:NS.MetaTags.ChannelCount
            channelData{channelInd}=NS.Data(channelInd,:);
        end
        
        %extract MUA for each channel and trial:
        channelDataMUA=[];
        for channelInd=1:NS.MetaTags.ChannelCount
            S=double(channelData{channelInd}');
            %MAKE MUAe
            %Bandpassed, rectified and low-passed data
            %================================================
            Fs=30000;%sampling frequency
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
            downsampleFreq=30;
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
            
            %remove outlying samples of MUA
            %         dumz = abs((muafilt-mean(muafilt))./std(muafilt));
            %         muafilt(dumz>4) = NaN;
            
            %Baseline correct and store
            %Find background MUAe activity
            MUA = muafilt;
            
            %Assign to vargpout
            channelDataMUA{channelInd}=MUA;
        end
        fileName=fullfile('D:\data',date,['MUA_',instanceName,'.mat']);
        save(fileName,'channelDataMUA');        
    end
end

%to draw plots from previously processed data:
loadData=1;
if loadData==1
    for instanceInd=1:8
        instanceName=['instance',num2str(instanceInd)];
        %     instanceName='instance1';
        fileName=['D:\data\',date,'\MUA_',instanceName,'.mat'];
        load(fileName)
        sampFreq=30000;
        stimDurms=1000;%in ms
        stimDur=stimDurms/1000;%in seconds
        preStimDur=300/1000;%length of pre-stimulus-onset period, in s
        postStimDur=300/1000;%length of post-stimulus-offset period, in s
        downsampleFreq=30;
        stimCondCol='rgbk';
        for stimCond=3:6
            meanChannelMUA=[];
            for channelInd=1:128
                stimCondInd=find(trialStimConds==2^stimCond);
                stimCondChannelDataMUA=channelDataMUA{channelInd}(stimCondInd,:);
                meanChannelMUA(channelInd,:)=mean(stimCondChannelDataMUA,1);
                %     plot(meanChannelMUA(channelInd,:))
            end
            fileName=fullfile('D:\data',date,['mean_MUA_',instanceName,'cond',num2str(stimCond-2)','.mat']);
            save(fileName,'meanChannelMUA');
            
            for channelInd=1:128
                figInd=ceil(channelInd/36);
                figure(figInd);hold on
                subplotInd=channelInd-((figInd-1)*36);
                subplot(6,6,subplotInd);
                plot(meanChannelMUA(channelInd,:),stimCondCol(stimCond-2))
                ax=gca;
                ax.XTick=[0 sampFreq*preStimDur/downsampleFreq sampFreq*(preStimDur+stimDur)/downsampleFreq];
                ax.XTickLabel={num2str(preStimDur*1000),'0',num2str(stimDurms)};
                %     set(gca,'ylim',[0 max(meanChannelMUA(channelInd,:))]);
                title(num2str(channelInd));
            end
        end
        for figInd=1:4
            figure(figInd)
            set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
            pathname=fullfile('D:\data',date,[instanceName,'_',num2str(figInd)]);
            print(pathname,'-dtiff');
        end
        close all
    end
end
pause=1;