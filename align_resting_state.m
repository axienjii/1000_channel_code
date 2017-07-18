function align_resting_state
%Written by Xing 18/7/17
%Read events from NEV files, check that they are identical across
%instances. 
date='180717_resting_state';
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