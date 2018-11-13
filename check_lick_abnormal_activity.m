function check_lick_abnormal_activity

%check recording without a monkey in the setup, connecting the NSS during 'Other' mode, to each bank of each Cereplex M at a time:
date='131118';
% neuronalChannels=33:96;%V4 array 2 on instance 1
neuronalChannels=[1 33 65 97];%first channel on each bank
instances=1:4;
banks='ABCD';
sampFreq=30000;
for instanceInd=1:4
    instance=instances(instanceInd);
    instanceName=['instance',num2str(instance)];
    figure;
    for bankInd=1:4
        channelInd=neuronalChannels(bankInd);
        bank=banks(bankInd);
        readChannel=['c:',num2str(channelInd),':',num2str(channelInd)];
        instanceNS6FileName=['D:\data\',date,'_instance',num2str(instance),'_bank',bank,'\',instanceName,'.ns6'];
        NSchOriginal=openNSx(instanceNS6FileName,readChannel);%,'t:01:3000000');
        NSch{channelInd}=NSchOriginal.Data;
        %     for minuteCount=1:17%floor(length(NSchOriginal.Data)/(sampFreq*60))%plot a figure for each minute of data
        %         figure;
        %         subplot(4,5,minuteCount);
        plot(NSchOriginal.Data);
        neuronalDataFig=['D:\data\',date,'_instance',num2str(instance),'_bank',bank,'\',instanceName,'_bank',bank];
        saveas(gcf,neuronalDataFig,'fig')
        %     end
    end
end

%check recording prior to any stim:
date='061118_B1';
instanceName='instance1';
neuronalChannels=33:96;%V4 array 2 on instance 1
sampFreq=30000;
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
neuronalDataMat=['D:\data\',date,'\',instanceName,'_NSch_channels.mat'];
figure;
for channelInd=1%:length(neuronalChannels)
    readChannel=['c:',num2str(neuronalChannels(channelInd)),':',num2str(neuronalChannels(channelInd))];
    NSchOriginal=openNSx(instanceNS6FileName,readChannel);%,'t:01:3000000');
    NSch{channelInd}=NSchOriginal.Data;
%     for minuteCount=1:17%floor(length(NSchOriginal.Data)/(sampFreq*60))%plot a figure for each minute of data
%         figure;
%         subplot(4,5,minuteCount);
        plot(NSchOriginal.Data);
%     end
end

%check recording during simple fixation task:
date='071118_B2';
instanceName='instance1';
neuronalChannels=33:96;%V4 array 2 on instance 1
sampFreq=30000;
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
neuronalDataMat=['D:\data\',date,'\',instanceName,'_NSch_channels.mat'];
figure;
for channelInd=1%:length(neuronalChannels)
    readChannel=['c:',num2str(neuronalChannels(channelInd)),':',num2str(neuronalChannels(channelInd))];
    NSchOriginal=openNSx(instanceNS6FileName,readChannel,'t:01:3000000');
    NSch{channelInd}=NSchOriginal.Data;
%     for minuteCount=1:17%floor(length(NSchOriginal.Data)/(sampFreq*60))%plot a figure for each minute of data
%         figure;
%         subplot(4,5,minuteCount);
        plot(NSchOriginal.Data);
%     end
end

%check recording without a monkey in the setup, connecting the NSS during 'Neural' mode:
date='071118_NSS_neural';
instanceName='instance1';
neuronalChannels=33:96;%V4 array 2 on instance 1
sampFreq=30000;
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
neuronalDataMat=['D:\data\',date,'\',instanceName,'_NSch_channels.mat'];
figure;
for channelInd=1%:length(neuronalChannels)
    readChannel=['c:',num2str(neuronalChannels(channelInd)),':',num2str(neuronalChannels(channelInd))];
    NSchOriginal=openNSx(instanceNS6FileName,readChannel);%,'t:01:3000000');
    NSch{channelInd}=NSchOriginal.Data;
%     for minuteCount=1:17%floor(length(NSchOriginal.Data)/(sampFreq*60))%plot a figure for each minute of data
%         figure;
%         subplot(4,5,minuteCount);
        plot(NSchOriginal.Data);
%     end
end


%check recording without a monkey in the setup, connecting the NSS during 'Other' mode:
date='071118_NSS_other';
instanceName='instance1';
neuronalChannels=33:96;%V4 array 2 on instance 1
sampFreq=30000;
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
neuronalDataMat=['D:\data\',date,'\',instanceName,'_NSch_channels.mat'];
figure;
for channelInd=1%:length(neuronalChannels)
    readChannel=['c:',num2str(neuronalChannels(channelInd)),':',num2str(neuronalChannels(channelInd))];
    NSchOriginal=openNSx(instanceNS6FileName,readChannel);%,'t:01:3000000');
    NSch{channelInd}=NSchOriginal.Data;
%     for minuteCount=1:17%floor(length(NSchOriginal.Data)/(sampFreq*60))%plot a figure for each minute of data
%         figure;
%         subplot(4,5,minuteCount);
        plot(NSchOriginal.Data);
%     end
end

%check recording without a monkey in the setup, no NSS connected; just digital hub on and CerePlex M connected to unattached EIB:
date='081118_unconnected';
instanceName='instance1';
neuronalChannels=33:96;%V4 array 2 on instance 1
sampFreq=30000;
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
neuronalDataMat=['D:\data\',date,'\',instanceName,'_NSch_channels.mat'];
figure;
for channelInd=1%:length(neuronalChannels)
    readChannel=['c:',num2str(neuronalChannels(channelInd)),':',num2str(neuronalChannels(channelInd))];
    NSchOriginal=openNSx(instanceNS6FileName,readChannel);%,'t:01:3000000');
    NSch{channelInd}=NSchOriginal.Data;
%     for minuteCount=1:17%floor(length(NSchOriginal.Data)/(sampFreq*60))%plot a figure for each minute of data
%         figure;
%         subplot(4,5,minuteCount);
        plot(NSchOriginal.Data);
%     end
end

%check recording without a monkey in the setup, no NSS connected; just
%digital hub on and CerePlex M connected to unattached EIB. Also,
%repositioned ground clip by unclipping it from metal shelf bracket and
%clipping it to metal guide rails for monkey chair.
date='081118_unconnected2';
instanceName='instance1';
neuronalChannels=33:96;%V4 array 2 on instance 1
sampFreq=30000;
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
neuronalDataMat=['D:\data\',date,'\',instanceName,'_NSch_channels.mat'];
figure;
for channelInd=1%:length(neuronalChannels)
    readChannel=['c:',num2str(neuronalChannels(channelInd)),':',num2str(neuronalChannels(channelInd))];
    NSchOriginal=openNSx(instanceNS6FileName,readChannel);%,'t:01:3000000');
    NSch{channelInd}=NSchOriginal.Data;
%     for minuteCount=1:17%floor(length(NSchOriginal.Data)/(sampFreq*60))%plot a figure for each minute of data
%         figure;
%         subplot(4,5,minuteCount);
        plot(NSchOriginal.Data);
%     end
end

%check recording without a monkey in the setup, no NSS connected; just
%digital hub on and CerePlex M connected to unattached EIB. Also,
%repositioned ground clip by unclipping it from metal shelf bracket and
%clipping it to metal guide rails for monkey chair. And clipped wire
%between wall socket and ground clip on metal rail.
date='081118_unconnected3';
instanceName='instance1';
neuronalChannels=33:96;%V4 array 2 on instance 1
sampFreq=30000;
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
neuronalDataMat=['D:\data\',date,'\',instanceName,'_NSch_channels.mat'];
figure;
for channelInd=1%:length(neuronalChannels)
    readChannel=['c:',num2str(neuronalChannels(channelInd)),':',num2str(neuronalChannels(channelInd))];
    NSchOriginal=openNSx(instanceNS6FileName,readChannel);%,'t:01:3000000');
    NSch{channelInd}=NSchOriginal.Data;
%     for minuteCount=1:17%floor(length(NSchOriginal.Data)/(sampFreq*60))%plot a figure for each minute of data
%         figure;
%         subplot(4,5,minuteCount);
        plot(NSchOriginal.Data);
%     end
end

%check recording without a monkey in the setup, no NSS connected; just
%digital hub on and CerePlex M connected to unattached EIB. Ground clip
%connected to metal shelf bracket. Wire from wall socket 
%is not connected to anything.
date='081118_unconnected4';
instanceName='instance1';
neuronalChannels=33:96;%V4 array 2 on instance 1
sampFreq=30000;
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
neuronalDataMat=['D:\data\',date,'\',instanceName,'_NSch_channels.mat'];
figure;
for channelInd=1%:length(neuronalChannels)
    readChannel=['c:',num2str(neuronalChannels(channelInd)),':',num2str(neuronalChannels(channelInd))];
    NSchOriginal=openNSx(instanceNS6FileName,readChannel);%,'t:01:3000000');
    NSch{channelInd}=NSchOriginal.Data;
%     for minuteCount=1:17%floor(length(NSchOriginal.Data)/(sampFreq*60))%plot a figure for each minute of data
%         figure;
%         subplot(4,5,minuteCount);
        plot(NSchOriginal.Data);
%     end
end

%check recording without a monkey in the setup, no NSS connected; just
%digital hub on and CerePlex M connected to unattached EIB. Ground clip
%connected to metal shelf bracket. Wire from wall socket 
%is connected to clip.
date='081118_unconnected5';
instanceName='instance1';
neuronalChannels=33:96;%V4 array 2 on instance 1
sampFreq=30000;
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
neuronalDataMat=['D:\data\',date,'\',instanceName,'_NSch_channels.mat'];
figure;
for channelInd=1%:length(neuronalChannels)
    readChannel=['c:',num2str(neuronalChannels(channelInd)),':',num2str(neuronalChannels(channelInd))];
    NSchOriginal=openNSx(instanceNS6FileName,readChannel);%,'t:01:3000000');
    NSch{channelInd}=NSchOriginal.Data;
%     for minuteCount=1:17%floor(length(NSchOriginal.Data)/(sampFreq*60))%plot a figure for each minute of data
%         figure;
%         subplot(4,5,minuteCount);
        plot(NSchOriginal.Data);
%     end
end

%check recording without a monkey in the setup, no NSS connected; just
%digital hub on and CerePlex M connected to unattached EIB. Ground clip
%connected to metal rail. Wire from wall socket 
%is not connected.
date='081118_unconnected6';
instanceName='instance1';
neuronalChannels=33:96;%V4 array 2 on instance 1
sampFreq=30000;
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
neuronalDataMat=['D:\data\',date,'\',instanceName,'_NSch_channels.mat'];
figure;
for channelInd=1%:length(neuronalChannels)
    readChannel=['c:',num2str(neuronalChannels(channelInd)),':',num2str(neuronalChannels(channelInd))];
    NSchOriginal=openNSx(instanceNS6FileName,readChannel);%,'t:01:3000000');
    NSch{channelInd}=NSchOriginal.Data;
%     for minuteCount=1:17%floor(length(NSchOriginal.Data)/(sampFreq*60))%plot a figure for each minute of data
%         figure;
%         subplot(4,5,minuteCount);
        plot(NSchOriginal.Data);
%     end
end

%check recording without a monkey in the setup, no NSS connected; just
%digital hub on and CerePlex M disconnected from EIB. Ground clip
%connected to metal rail. Wire from wall socket is not connected.
date='081118_unconnected7';
instanceName='instance1';
neuronalChannels=33:96;%V4 array 2 on instance 1
sampFreq=30000;
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
neuronalDataMat=['D:\data\',date,'\',instanceName,'_NSch_channels.mat'];
figure;
for channelInd=1%:length(neuronalChannels)
    readChannel=['c:',num2str(neuronalChannels(channelInd)),':',num2str(neuronalChannels(channelInd))];
    NSchOriginal=openNSx(instanceNS6FileName,readChannel);%,'t:01:3000000');
    NSch{channelInd}=NSchOriginal.Data;
%     for minuteCount=1:17%floor(length(NSchOriginal.Data)/(sampFreq*60))%plot a figure for each minute of data
%         figure;
%         subplot(4,5,minuteCount);
        plot(NSchOriginal.Data);
%     end
end

%check recording without a monkey in the setup, no NSS connected; just
%digital hub on and CerePlex M disconnected from EIB. Ground clip
%connected to metal rail. Wire from wall socket is not connected. Laptop,
%computer mouse and phone are in other room.
date='081118_unconnected8';
instanceName='instance1';
neuronalChannels=33:96;%V4 array 2 on instance 1
sampFreq=30000;
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
neuronalDataMat=['D:\data\',date,'\',instanceName,'_NSch_channels.mat'];
figure;
for channelInd=1%:length(neuronalChannels)
    readChannel=['c:',num2str(neuronalChannels(channelInd)),':',num2str(neuronalChannels(channelInd))];
    NSchOriginal=openNSx(instanceNS6FileName,readChannel);%,'t:01:3000000');
    NSch{channelInd}=NSchOriginal.Data;
%     for minuteCount=1:17%floor(length(NSchOriginal.Data)/(sampFreq*60))%plot a figure for each minute of data
%         figure;
%         subplot(4,5,minuteCount);
        plot(NSchOriginal.Data);
%     end
end

%check recording without a monkey in the setup, no NSS connected; just
%digital hub on and CerePlex M disconnected from EIB. Ground clip
%connected to wire from wall socket. Digital Hub is switched off.
date='081118_unconnected9';
instanceName='instance1';
neuronalChannels=33:96;%V4 array 2 on instance 1
sampFreq=30000;
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
neuronalDataMat=['D:\data\',date,'\',instanceName,'_NSch_channels.mat'];
figure;
for channelInd=1%:length(neuronalChannels)
    readChannel=['c:',num2str(neuronalChannels(channelInd)),':',num2str(neuronalChannels(channelInd))];
    NSchOriginal=openNSx(instanceNS6FileName,readChannel);%,'t:01:3000000');
    NSch{channelInd}=NSchOriginal.Data;
%     for minuteCount=1:17%floor(length(NSchOriginal.Data)/(sampFreq*60))%plot a figure for each minute of data
%         figure;
%         subplot(4,5,minuteCount);
        plot(NSchOriginal.Data);
%     end
end

%check recording without a monkey in the setup, no NSS connected; just
%digital hub on and CerePlex M disconnected from EIB. Ground clip
%connected to wire from wall socket (along with grond clip from all Digital
%Hubs). Digital Hub is switched on. 
date='081118_unconnected10';
instanceName='instance1';
neuronalChannels=33:96;%V4 array 2 on instance 1
sampFreq=30000;
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
neuronalDataMat=['D:\data\',date,'\',instanceName,'_NSch_channels.mat'];
figure;
for channelInd=1%:length(neuronalChannels)
    readChannel=['c:',num2str(neuronalChannels(channelInd)),':',num2str(neuronalChannels(channelInd))];
    NSchOriginal=openNSx(instanceNS6FileName,readChannel);%,'t:01:3000000');
    NSch{channelInd}=NSchOriginal.Data;
%     for minuteCount=1:17%floor(length(NSchOriginal.Data)/(sampFreq*60))%plot a figure for each minute of data
%         figure;
%         subplot(4,5,minuteCount);
        plot(NSchOriginal.Data);
%     end
end

%check recording without a monkey in the setup, no NSS connected; just
%digital hub on and CerePlex M disconnected from EIB. Ground clip
%connected to wire from wall socket (along with grond clip from all Digital
%Hubs). Digital Hub is switched on. Turned off room lights, sitmulus
%control computer, eye tracker computer, camera, infrared light.
date='081118_unconnected11';
instanceName='instance1';
neuronalChannels=33:96;%V4 array 2 on instance 1
sampFreq=30000;
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
neuronalDataMat=['D:\data\',date,'\',instanceName,'_NSch_channels.mat'];
figure;
for channelInd=1%:length(neuronalChannels)
    readChannel=['c:',num2str(neuronalChannels(channelInd)),':',num2str(neuronalChannels(channelInd))];
    NSchOriginal=openNSx(instanceNS6FileName,readChannel);%,'t:01:3000000');
    NSch{channelInd}=NSchOriginal.Data;
%     for minuteCount=1:17%floor(length(NSchOriginal.Data)/(sampFreq*60))%plot a figure for each minute of data
%         figure;
%         subplot(4,5,minuteCount);
        plot(NSchOriginal.Data);
%     end
end

%check recording without a monkey in the setup, no NSS connected; just
%digital hub on and CerePlex M disconnected from EIB. Ground clip
%connected to wire from wall socket (along with ground clip from all Digital
%Hubs). Digital Hub is switched on. Turned off room lights, stimulus
%control computer, eye tracker computer, camera, infrared light, CereStims,
%CereStim power strips.
date='081118_unconnected12';
instanceName='instance1';
neuronalChannels=33:96;%V4 array 2 on instance 1
sampFreq=30000;
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
neuronalDataMat=['D:\data\',date,'\',instanceName,'_NSch_channels.mat'];
figure;
for channelInd=1%:length(neuronalChannels)
    readChannel=['c:',num2str(neuronalChannels(channelInd)),':',num2str(neuronalChannels(channelInd))];
    NSchOriginal=openNSx(instanceNS6FileName,readChannel);%,'t:01:3000000');
    NSch{channelInd}=NSchOriginal.Data;
%     for minuteCount=1:17%floor(length(NSchOriginal.Data)/(sampFreq*60))%plot a figure for each minute of data
%         figure;
%         subplot(4,5,minuteCount);
        plot(NSchOriginal.Data);
%     end
end
Fs = 30000;
transformNSch=fft(double(NSchOriginal.Data));
Y=transformNSch;
L=length(NSchOriginal.Data);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;
plot(f,P1) 
title('Single-Sided Amplitude Spectrum of X(t)')
xlabel('f (Hz)')
ylabel('|P1(f)|')
figure;
plot(1:length(transformNSch),transformNSch);

%check recording on analog channel without a monkey in the setup, no NSS connected; just
%digital hub on and CerePlex M disconnected from EIB. Ground clip
%connected to wire from wall socket (along with ground clip from all Digital
%Hubs). Digital Hub is switched on. Turned off room lights, stimulus
%control computer, eye tracker computer, camera, infrared light, CereStims,
%CereStim power strips.
date='081118_unconnected12';
instanceName='instance1';
neuronalChannels=128+1;%analog input 1
sampFreq=30000;
instanceNS6FileName=['D:\data\',date,'\',instanceName,'.ns6'];
neuronalDataMat=['D:\data\',date,'\',instanceName,'_NSch_channels.mat'];
figure;
for channelInd=1%:length(neuronalChannels)
    readChannel=['c:',num2str(neuronalChannels(channelInd)),':',num2str(neuronalChannels(channelInd))];
    NSchOriginal=openNSx(instanceNS6FileName,readChannel);%,'t:01:3000000');
    NSch{channelInd}=NSchOriginal.Data;
%     for minuteCount=1:17%floor(length(NSchOriginal.Data)/(sampFreq*60))%plot a figure for each minute of data
%         figure;
%         subplot(4,5,minuteCount);
        plot(NSchOriginal.Data);
%     end
end
%analog input 1 looks normal