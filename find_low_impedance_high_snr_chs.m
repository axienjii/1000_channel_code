function find_low_impedance_high_snr_chs
%Written by Xing 25/10/18
%Identify low-impedance channels with good RF locations, which have shown
%good current thresholds in the past, on arrays 8 to 16, in Lick.
%Generate data for movie showing eye movements during a saccade task.

date='191018';

%identify low-impedance channels, based on latest measurements:
lowImpedanceChs=[];
for arrayInd=8:16
   load(['C:\Users\User\Documents\impedance_values\',date,'\array',num2str(arrayInd),'.mat'],['array',num2str(arrayInd)]); 
   eval(['array=array',num2str(arrayInd),';'])
   ind=find(array(:,6)<=150);%cutoff for low-impedance channels
   lowImpedanceChs=[lowImpedanceChs;array(ind,:)];
end

%identify channels that still have good SNR
SNRdate='191018_B1';
allInstanceInd=1:8;
allSessionSNR=[];
for instanceCount=1:length(allInstanceInd)
    instanceInd=allInstanceInd(instanceCount);
    instanceName=['instance',num2str(instanceInd)];    
    fileName=['X:\best\',SNRdate,'\mean_MUA_instance',num2str(instanceCount),'.mat'];
    load(fileName,'channelSNR');
    allSessionSNR=[allSessionSNR;channelSNR(1:128)'];%compile SNR values across recording sessions
    clear channelSNR
end
allSessionSNRChs=allSessionSNR;
ind1024=1;
for instanceCount=1:length(allInstanceInd)
    for chCount=1:128
        [channelNum,arrayNum,area]=electrode_mapping(instanceCount,chCount);
        allSessionSNRChs(ind1024,2:3)=[arrayNum channelNum];
        ind1024=ind1024+1;
    end
end

%identify channels that previously showed good current thresholds
load('X:\best\171018_data\currentThresholdChs137.mat')
previousStimCh=[];
for arrayInd=8:16
    ind=find(lowImpedanceChs(:,7)==arrayInd);
    lowImpChsArray=lowImpedanceChs(ind,8);%identify channel numbers where impedance is low, for this array
    ind=find(goodArrays8to16New(:,7)==arrayInd);
    previousStimChsArray=goodArrays8to16New(ind,8);%identify channels that were previously used for stimulaiton, on this array
    for chInd=1:length(lowImpChsArray)
        if ismember(lowImpChsArray(chInd),previousStimChsArray)
            previousStimCh=[previousStimCh;arrayInd lowImpChsArray(chInd)];%compile list of channels that have both low impedance and were previously used for stimulation
        end
    end
end

%intersection of low-impedance channels that show good SNR, and were
%previously used for microstimulation:
SNR=[];
for ind=1:length(previousStimCh)
    array=previousStimCh(ind,1);
    electrode=previousStimCh(ind,2);
    arrayInds=find(allSessionSNRChs(:,2)==array);
    chInds=find(allSessionSNRChs(:,3)==electrode);
    SNRInd=intersect(arrayInds,chInds);
    SNR(ind,1)=allSessionSNRChs(SNRInd,1);
end
previousStimCh(:,3)=SNR;
excludeSNR=find(previousStimCh(:,3)<1);
previousStimCh(excludeSNR,:)=[];
save(['C:\Users\User\Documents\impedance_values\',date,'\low_impedance_chs_used_for_microstim.mat'],'previousStimCh');

testingChs=[];
peripheralArrays=[10 11 13];
for peripheralArrayInd=1:length(peripheralArrays)%for each of the arrays that have showed deteriorating SNR and mismatches between saccade end points and RF centres in the recent months
    ind=find(previousStimCh(:,1)==peripheralArrays(peripheralArrayInd));
    testingChs=[testingChs;previousStimCh(ind,:)];%compile a list of the channels that can be tested anew, first with current thresholding and then with a saccade task
end
testingChsOrder=[testingChs(1:10,:);testingChs(27:48,:);testingChs(11:26,:);testingChs(49:end,:)];
save(['C:\Users\User\Documents\impedance_values\',date,'\low_impedance_chs_to_test.mat'],'testingChsOrder');

