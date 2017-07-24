function align_resting_state
%Written by Xing 18/7/17
%Read events from NEV files, check that they are identical across
%instances. Also reads in code that was generated by a Matlab script,
%sync_pulse_resting_state.m, to check that the same sequence is present.
%The precise length of the sequences may differ slightly between the MAT
%and NEV files, as the NEV file may contain a few extra numbers before
%and/or after the shared sequence.
date='180717_resting_state';
date='200717_resting_state';
date='210717_resting_state';
for instanceInd=1:8
    instanceName=['instance',num2str(instanceInd)];
    instanceNEVFileName=['D:\data\',date,'\',instanceName,'.nev'];
    NEV=openNEV(instanceNEVFileName);
    events{instanceInd}=NEV.Data.SerialDigitalIO.UnparsedData;
end
for instanceInd=1:8-1
    identicalEvents(instanceInd)=isequal(events{instanceInd},events{instanceInd+1});
end
if sum(identicalEvents)~=7
    sprintf('Events are not identical across instances. Check and debug.')
end

%read in pulse numbers that were generated by a Matlab script:
switch date
    case '180717_resting_state'
        load('D:\data\180717_B1\180717_data\sync_pulse_resting_state_180717.mat')        
    case '200717_resting_state';
        load('D:\data\200717_resting_state\200717_data\sync_pulse_resting_state_200717_B7.mat')        
    case '210717_resting_state';
        load('D:\data\210717_resting_state\210717_data\sync_pulse_resting_state_210717.mat')        
end
convertedAllBits=2.^allBits;%convert into the code that is saved in the NEV events file by the NSPs

if length(events{5})~=length(convertedAllBits)+1
    sprintf('Events are not identical between MAT and NEV files. Check and debug.')
end
%check that numbers match (NEV events should have 1 extra number at the end, compared to MAT events):
isequal(events{5}(1:end-1),convertedAllBits')