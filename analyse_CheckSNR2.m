function analyse_CheckSNR2(date)
%26/9/17
%Written by Xing. Extracts MUA data from raw .NS6 file, during presentation
%of fullscreen flashing checkerboard stimuli to analyse signals for
%visually evoked responses. Calculates SNR, saves to file. Works with data
%on local disk or on server, depending on the date.
% date='240717_B2';
best=1;
notRisingEdge=0;%set to 0 for digital input that detects only rising edge; set to 1 for session where digital input was mistakenly set to detect any change (whether rising or falling), i.e. 270219_B1
switch(date)
    case '040717_B2'
        whichDir=2;
        best=0;
    case '050717_B3'
        whichDir=2;
    case '060717_B2'
        whichDir=2;
    case '110717_B3'
        whichDir=2;
        best=1;
    case '180717_B1'
        whichDir=1;
        best=1;
    case '200717_B7'
        whichDir=2;
        best=1;
    case '210717_B4'%forgot to turn off impedance mode on CerePlex Ms connected to instance 1
        whichDir=1;
        best=1;
    case '240717_B2'%strange noise on most instances
        whichDir=1;
        best=1;
    case '250717_B2'
        whichDir=2;
        best=1;
    case '260717_B3'
        whichDir=2;
        best=1;
    case '080817_B7'
        whichDir=2;
        best=1;
    case '090817_B8'
        whichDir=2;
        best=1;
    case '100817_B2'
        whichDir=2;
        best=1;
    case '180817_B10'
        whichDir=2;
        best=1;
    case '230817_B20'
        whichDir=2;
    case '240817_B39'
        whichDir=2;
    case '290817_B48'
        whichDir=2;
        best=1;
    case '200917_B2'
        whichDir=2;
        best=1;
    case '061017_B6'
        whichDir=1;
        best=1;
    case '091017_B2'
        whichDir=1;
        best=1;
    case '201017_B32'
        whichDir=1;
        best=1;
    case '240118_B2'
        whichDir=2;
        best=1;
    case '250118_B1'
        whichDir=2;
        best=1;
    case '260118_B10'
        whichDir=2;
        best=1;
    case '280218_B1'
        whichDir=2;
        best=1;
    case '080618_B1'
        whichDir=2;
        best=1;
    case '020818_B1'
        whichDir=2;
        best=1;
    case '070818_B1'
        whichDir=2;
        best=1;
    case '280918_B4'
        whichDir=1;
        best=1;
    case '191018_B1'
        whichDir=2;
        best=1;
    case '061118_B1'
        whichDir=2;
        best=1;
    case '071118_B1'
        whichDir=2;
        best=1;
    case '071118_B2'%simple fixation task, not checkSNR
        whichDir=1;
        best=1;
    case '181218_B4'
        whichDir=1;
        best=1;
    case '270219_B1'
        whichDir=1;
        best=1;
    case '170419_B1'
        whichDir=2;
        best=1;
        notRisingEdge=1;
    case '170419_B1'
        whichDir=1;
        best=1;
    case '260419_B1'%checkSNR
        whichDir=1;
        best=1;
end
if whichDir==1%local copy available
    topDir='D:\data';
elseif whichDir==2%local copy deleted; use server copy
    if best==1
        topDir='X:\best';
    elseif best==0
        topDir='X:\other';
    end
end
copyRemotely=0;%make a copy to the remote directory?
if copyRemotely==1
    if best==1
        copyDir='X:\best';
    elseif best==0
        copyDir='X:\other';
    end
end
stimDur=400/1000;%in seconds
allInstanceInd=1:8;
preStimDur=300/1000;%length of pre-stimulus-onset period, in s
postStimDur=300/1000;%length of post-stimulus-offset period, in s
downsampleFreq=30;
allSNR=[];
for instanceCount=1:length(allInstanceInd)
    instanceInd=allInstanceInd(instanceCount);
    instanceName=['instance',num2str(instanceInd)];
    instanceNEVFileName=fullfile(topDir,date,[instanceName,'.nev']);
    NEV=openNEV(instanceNEVFileName);
    instanceNS6FileName=fullfile(topDir,date,[instanceName,'.ns6']);
    readRaw=0;
    if readRaw==1
        NS=openNSx(instanceNS6FileName);
        sampFreq=NS.MetaTags.SamplingFreq;
        codeStimOn=1;%In runstim code, StimB (stimulus bit) is 1.
        %dasbit sends a change in the bit (either high or low) on one of the 8 ports
        indStimOns=find(NEV.Data.SerialDigitalIO.UnparsedData==2^codeStimOn);%starts at 2^0, till 2^7
        if notRisingEdge
            indStimOns=find(NEV.Data.SerialDigitalIO.UnparsedData==65314);
        end
        timeStimOns=NEV.Data.SerialDigitalIO.TimeStamp(indStimOns);%time stamps corresponding to stimulus onset
        trialData={};
        for trialInd=1:length(timeStimOns)
            if strcmp(class(NS.Data),'cell')
                NSnew.Data=[];
                for cellInd=1:length(NS.Data)
                    NSnew.Data=[NSnew.Data NS.Data{cellInd}];
                end
                NS.Data=NSnew.Data;
                clear NSnew
                if size(NS.Data,2)>=timeStimOns(trialInd)+sampFreq*stimDur+sampFreq*postStimDur-1
                    trialData{trialInd}=NS.Data(:,timeStimOns(trialInd)-sampFreq*preStimDur:timeStimOns(trialInd)+sampFreq*stimDur+sampFreq*postStimDur-1);%raw data in uV, read in data during stimulus presentation
                end
            elseif strcmp(class(NS.Data),'double')
                if size(NS.Data,2)>=timeStimOns(trialInd)+sampFreq*stimDur+sampFreq*postStimDur-1
                    trialData{trialInd}=NS.Data(:,timeStimOns(trialInd)-sampFreq*preStimDur:timeStimOns(trialInd)+sampFreq*stimDur+sampFreq*postStimDur-1);%raw data in uV, read in data during stimulus presentation
                end
            elseif strcmp(class(NS.Data),'int16')
                if size(NS.Data,2)>=timeStimOns(trialInd)+sampFreq*stimDur+sampFreq*postStimDur-1
                    trialData{trialInd}=NS.Data(:,timeStimOns(trialInd)-sampFreq*preStimDur:timeStimOns(trialInd)+sampFreq*stimDur+sampFreq*postStimDur-1);%raw data in uV, read in data during stimulus presentation
                end
            end
        end
        channelData={};
        for channelInd=1:NS.MetaTags.ChannelCount
            for trialInd=1:length(trialData)
                channelData{channelInd}(trialInd,:)=trialData{trialInd}(channelInd,:);
            end
        end
        
        %extract MUA for each channel and trial:
        channelDataMUA=[];
        for channelInd=1:NS.MetaTags.ChannelCount
            for trialInd=1:length(trialData)
                S=double(channelData{channelInd}(trialInd,:)');
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
                channelDataMUA{channelInd}(trialInd,:)=MUA;
            end
        end
        fileName=fullfile(topDir,date,['MUA_',instanceName,'.mat']);
        save(fileName,'channelDataMUA');
        if copyRemotely==1
            fileName=fullfile(copyDir,date,['MUA_',instanceName,'.mat']);
            save(fileName,'channelDataMUA');
        end
    else
        fileName=fullfile(topDir,date,['MUA_',instanceName,'.mat']);
        load(fileName,'channelDataMUA');
        sampFreq=30000;
        
        %Average across trials and plot activity:
        % load(fileName);
        % figure(1)
        % hold on
        meanChannelMUA=[];
        for channelInd=1:128%NS.MetaTags.ChannelCount
            meanChannelMUA(channelInd,:)=mean(channelDataMUA{channelInd}(:,:),1);
            %     plot(meanChannelMUA(channelInd,:))
            
            MUAm=meanChannelMUA(channelInd,:);%each value corresponds to 1 ms
            %Get noise levels before smoothing
            BaseT = 1:sampFreq*preStimDur/downsampleFreq;
%             Base = nanmean(MUAm(BaseT));
%             BaseS = nanstd(MUA(BaseT));
            Base = MUAm(:,BaseT);
            BaseS = nanmean(nanstd(Base,[],2));
            
            %Smooth it to get a maximum...
            sm = smooth(MUAm,20);
            [mx,mi] = max(sm);
            Scale = mx-nanmean(Base);
            
            %calculate SNR
            SNR=Scale/BaseS;
            channelSNR(channelInd)=SNR;
        end
        fileName=fullfile(topDir,date,['mean_MUA_',instanceName,'_new.mat']);
        save(fileName,'meanChannelMUA','channelSNR');
        if copyRemotely==1
            fileName=fullfile(copyDir,date,['mean_MUA_',instanceName,'.mat']);
            save(fileName,'meanChannelMUA','channelSNR');
        end
    end
    if readRaw==0
        NS=openNSx(instanceNS6FileName,'read','t:01:02');
        sampFreq=NS.MetaTags.SamplingFreq;
        fileName=fullfile(topDir,date,['mean_MUA_',instanceName,'.mat']);
        load(fileName);
    end
    allSNR=[allSNR;channelSNR(1:128)];
    
    for channelInd=1:128%NS.MetaTags.ChannelCount
        figInd=ceil(channelInd/36);
        figure(figInd);hold on
        subplotInd=channelInd-((figInd-1)*36);
        subplot(6,6,subplotInd);
        plot(meanChannelMUA(channelInd,:))
        ax=gca;
        ax.XTick=[0 sampFreq*preStimDur/downsampleFreq sampFreq*(preStimDur+stimDur)/downsampleFreq];
        ax.XTickLabel={'-300','0','400'};
        set(gca,'ylim',[min(meanChannelMUA(channelInd,2:end)) max(meanChannelMUA(channelInd,:))]);
        title(num2str(channelInd));
    end
    plot1024=1;
    for figInd=1:4
        figure(figInd)
        set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
        pathname=fullfile(topDir,date,[instanceName,'_',num2str(figInd),'_visual_response']);
        if plot1024==0
            print(pathname,'-dtiff');
            if copyRemotely==1
                pathname=fullfile(copyDir,date,[instanceName,'_',num2str(figInd),'_visual_response']);
                print(pathname,'-dtiff');
            end
        end
    end
    if plot1024==1
        if instanceCount==1
            allFigure=figure;
        else
            figure(allFigure)
        end
        for channelInd=1:128
            subaxis(32,32,channelInd+(instanceCount-1)*128, 'sh', 0.01, 'sv', 0.01, 'padding', 0, 'margin', 0);
            meanChannelMUASmoothed(channelInd,:)=smooth(meanChannelMUA(channelInd,:),50);%smoothing
            plot(meanChannelMUASmoothed(channelInd,10:end-9),'k');
            set(gca,'ylim',[min(meanChannelMUASmoothed(channelInd,10:end-9)) max(meanChannelMUASmoothed(channelInd,300:end-9))]);
%             plot(meanChannelMUA(channelInd,:),'k');
%             set(gca,'ylim',[min(meanChannelMUA(channelInd,2:end)) max(meanChannelMUA(channelInd,300:end))]);
            set(gca,'Visible','off')
        end
    end
    if plot1024==0
        close all
    end
end
pause=1;