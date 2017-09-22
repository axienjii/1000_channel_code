function compare_visual_response_before_after_microstim
%Written by Xing 27/7/17. Plots visually evoked responses to fullscreen
%flashing checkerboard stimuli, comparing responses before and after
%microstimulation was delivered to a particular electrode.

stimDur=400/1000;%in seconds
preStimDur=300/1000;%length of pre-stimulus-onset period, in s
postStimDur=300/1000;%length of post-stimulus-offset period, in s

sampFreq=30000;
downsampleFreq=30;

for dateInd=9
    useOtherDate=[];
    switch dateInd
        case 1
            date='200717_B7';
            electrodeInds=[1 2 5 6];
            previousDate='110717_B3';
        case 2
            date='210717_B4';%strange signals- almost certainly on impedance mode, or forgot to reconnect CerePlex M?
%             useOtherDate='240717_B2';%use the next session's SNR instead
            useOtherDate='250717_B2';%use the next session's SNR instead
            electrodeInds=[3 4 9 10 11:14];
            previousDate='200717_B7';
        case 3
            date='240717_B2';
%             useOtherDate='250717_B2';%use the next session's SNR instead
            electrodeInds=1:6;
            previousDate='200717_B7';
        case 4
            date='250717_B2';
            electrodeInds=1:7;
            previousDate='240717_B7';
        case 5
            date='260717_B3';%something wrong with NEV file for instance 6 on this day
            electrodeInds=1:7;
            previousDate='250717_B2';
        case 6
            date='080817_B7';
            electrodeInds=1:10;
            previousDate='260717_B3';
        case 7
            date='090817_B8';%array 10; adjust code in lookup_microstim_electrodes to set this date to array 10
            electrodeInds=1:6;
            previousDate='260717_B3';
        case 8
            date='090817_B8';%array 12; adjust code in lookup_microstim_electrodes to set this date to array 12
            electrodeInds=1:13;
            previousDate='080817_B7';
        case 9
            date='200917_B2';%arrays 8-16
            electrodeInds=1:20;
%             electrodeInds=21:40;
%             electrodeInds=41:60;
%             electrodeInds=61:80;
%             electrodeInds=81:100;
%             electrodeInds=101:120;
%             electrodeInds=121:140;
%             electrodeInds=141:160;
%             electrodeInds=161:180;
%             electrodeInds=181:200;
            electrodeInds=201:201;
            previousDate='090817_B8';
    end
    figure;
    for electrodeInd=1:length(electrodeInds)
        electrodeNum=electrodeInds(electrodeInd);%out of 64 electrodes on a given array
        [electrode RFx RFy array instance SNR impedance]=lookup_microstim_electrodes(date,electrodeNum);%return electrode number (out of 64) on that array
        [channel_InstanceNo channel_1024No]=convert_channel_1024(array,electrode);%return the channel number (out of 128)
        instanceInd=ceil(array/2);
        instanceName=['instance',num2str(instanceInd)];
        %plot data from previous checkSNR session:
        fileName=fullfile('D:\data',previousDate,['mean_MUA_',instanceName,'.mat']);
        load(fileName,'meanChannelMUA');
        subplot(ceil(length(electrodeInds)/4),4,electrodeInd);
        plot(meanChannelMUA(channel_InstanceNo,:),'k')
        hold on
        %plot data from checkSNR immediately after microstimulation:
        if isempty(useOtherDate)
            fileName=fullfile('D:\data',date,['mean_MUA_',instanceName,'.mat']);
        else
            fileName=fullfile('D:\data',useOtherDate,['mean_MUA_',instanceName,'.mat']);
        end
        load(fileName,'meanChannelMUA');
        plot(meanChannelMUA(channel_InstanceNo,:),'r')
        ax=gca;
        ax.XTick=[0 sampFreq*preStimDur/downsampleFreq sampFreq*(preStimDur+stimDur)/downsampleFreq];
        ax.XTickLabel={'-300','0','400'};
        %     set(gca,'ylim',[0 max(meanChannelMUA(channelInd,:))]);
        title(['array ',num2str(array),', channel ',num2str(electrode)]);
    end
    set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
    if isempty(useOtherDate)
        pathname=fullfile('D:\data',date,[instanceName,'_visual_response_before_after_microstim_',date,'_vs_',previousDate]);
    else
        pathname=fullfile('D:\data',date,[instanceName,'_visual_response_before_after_microstim_',useOtherDate,'_vs_',previousDate]);
    end
    print(pathname,'-dtiff');
    close all
end