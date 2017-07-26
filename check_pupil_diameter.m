function check_pupil_diameter
date='240717_B2';
saveEyeData=1;
instanceName='instance1';
eyeChannels=[131 132];
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
if saveEyeData==1
    for channelInd=1:length(eyeChannels)
        readChannel=['c:',num2str(eyeChannels(channelInd)),':',num2str(eyeChannels(channelInd))];
        NSchOriginal=openNSx(instanceNS6FileName,'read',readChannel);
        NSch{channelInd}=NSchOriginal.Data;
    end
    save(['D:\data\',date,'\',instanceName,'_NSch_eye_channels_pupils.mat'],'NSch');
else
    load(['D:\data\',date,'\',instanceName,'_NSch_eye_channels_pupils.mat'],'NSch');
end