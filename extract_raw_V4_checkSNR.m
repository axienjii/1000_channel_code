function extract_raw_V4_checkSNR(date)
%8/5/20
%Written by Xing. Extracts raw data from .NS6 file, during presentation
%of fullscreen flashing checkerboard stimuli to generate example data for
%artifact removal from visually evoked responses.
date='040717_B2';
notRisingEdge=0;%set to 0 for digital input that detects only rising edge; set to 1 for session where digital input was mistakenly set to detect any change (whether rising or falling), i.e. 270219_B1
switch(date)
    case '040717_B2'
        whichDir=2;
        best=1;
        bestSNRChs=[37 50 57 73 75];
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
for instanceCount=1
    instanceInd=allInstanceInd(instanceCount);
    instanceName=['instance',num2str(instanceInd)];
    instanceNEVFileName=fullfile(topDir,date,[instanceName,'.nev']);
    NEV=openNEV(instanceNEVFileName);
    readRaw=1;
    if readRaw==1
        codeStimOn=1;%In runstim code, StimB (stimulus bit) is 1.
        %dasbit sends a change in the bit (either high or low) on one of the 8 ports
        indStimOns=find(NEV.Data.SerialDigitalIO.UnparsedData==2^codeStimOn);%starts at 2^0, till 2^7
        if notRisingEdge
            indStimOns=find(NEV.Data.SerialDigitalIO.UnparsedData==65314);
        end
        timeStimOns=NEV.Data.SerialDigitalIO.TimeStamp(indStimOns);%time stamps corresponding to stimulus onset
        channelData={};
        instanceNS6FileName=fullfile(topDir,date,[instanceName,'.ns6']);
%         chName=['e:',num2str(channelInd),':',num2str(channelInd)];
        NS=openNSx(instanceNS6FileName);
        sampFreq=NS.MetaTags.SamplingFreq;
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
        for channelInd=bestSNRChs
            for trialInd=1:length(trialData)
                channelData{channelInd}(trialInd,:)=trialData{trialInd}(channelInd,:);
            end
%             fileName=fullfile('D:\data',date,['raw_example_ch_',num2str(channelInd),'.mat'],'channelData');
       end
    end
    fileName=fullfile('D:\data',date,['raw_example_chs.mat']);
    save(fileName,'channelData');
    
end
pause=1;