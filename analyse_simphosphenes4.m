function analyse_simphosphenes4(date,allInstanceInd,allGoodChannels)
%3/7/17
%Written by Xing. Loads and analyses MUA data, during presentation
%of simulated phosphene letters.

allLetters='IUALTVSYJP';
if isequal(date,'110717_B1_B2')||isequal(date,'110717_B1')||isequal(date,'110717_B2')||isequal(date,'120717_B1')||isequal(date,'110717_B1_B2_120717_B123')
    allLetters='IUALTVSYJ?';
end

saveFullMUA=1;
smoothResponse=1;

downSampling=1;
downsampleFreq=30;

stimDurms=800;%in ms
stimDur=stimDurms/1000;%in seconds
preStimDur=300/1000;%length of pre-stimulus-onset period, in s
postStimDur=400/1000;%length of post-stimulus-offset period, in s
sampFreq=30000;

normMeanChannelResponse1024=[];
normChannelsResponse=cell(1,length(allLetters));
for instanceCount=1:length(allInstanceInd)
    instanceInd=allInstanceInd(instanceCount);
    instanceName=['instance',num2str(instanceInd)];
    %         switch(instanceInd)
    %             case(4)
    %                 goodChannels=89:128;
    %             otherwise
    %                 goodChannels=1:128;
    %         end
    goodChannels=allGoodChannels{instanceCount};
    for channelCount=1:length(goodChannels)
        channelInd=goodChannels(channelCount);
        fileName=fullfile('D:\data',date,['MUA_',instanceName,'_ch',num2str(channelInd),'_downsample.mat'])
        load(fileName)
        trialData=[];
        for trialInd=1:length(timeStimOnsMatch)
            if downSampling==0
                startPoint=timeStimOnsMatch(trialInd);
                if length(channelDataMUA)>=startPoint+sampFreq*stimDur+sampFreq*postStimDur-1
                    trialData(trialInd,:)=channelDataMUA(startPoint-sampFreq*preStimDur:startPoint+sampFreq*stimDur+sampFreq*postStimDur-1);%raw data in uV, read in data during stimulus presentation
                end
            elseif downSampling==1
                startPoint=floor(timeStimOnsMatch(trialInd)/downsampleFreq);
                if length(channelDataMUA)>=startPoint+sampFreq/downsampleFreq*stimDur+sampFreq/downsampleFreq*postStimDur-1
                    trialData(trialInd,:)=channelDataMUA(startPoint-sampFreq/downsampleFreq*preStimDur:startPoint+sampFreq/downsampleFreq*stimDur+sampFreq/downsampleFreq*postStimDur-1);%raw data in uV, read in data during stimulus presentation
                end
            end
        end
        
        baseline=mean(mean(trialData(:,1:sampFreq/downsampleFreq*preStimDur)));%calculate baseline activity over initial 300-ms fixation period
        for letterCond=1:10
            meanChannelMUA(letterCond,:)=mean(trialData(find(goodTrialCondsMatch(:,1)==letterCond),:),1);
            meanChannelResponse(letterCond,:)=mean(meanChannelMUA(letterCond,sampFreq/downsampleFreq*preStimDur+1:sampFreq/downsampleFreq*(preStimDur+stimDur)));
            normChannelsResponse{letterCond}=[normChannelsResponse{letterCond};meanChannelMUA(letterCond,:)-baseline];%store activity over the whole trial. each cell contains activity levels, with channels in rows, and time in columns
        end
        normMeanChannelResponse(channelCount,:)=(meanChannelResponse-baseline)/(max(meanChannelResponse)-baseline);%normalise response for each channel to maximum, subtract spontaneous activity levels
    end
    normMeanChannelResponse1024=[normMeanChannelResponse1024;normMeanChannelResponse];%mean activity across stimulus presentation period, with channels in rows, and letter conditions in columns
    fileName=['D:\data\',date,'\visual_response_instance',num2str(instanceInd),'.mat'];
    save(fileName,'normChannelsResponse','normMeanChannelResponse1024')
    
    loadDate='best_260617-280617';
    fileName=['D:\data\',loadDate,'\RFs_instance',num2str(instanceInd),'.mat'];
    load(fileName)
    for letterCond=1:10
        figure;hold on
        col=normMeanChannelResponse(:,letterCond);
        scatter(channelRFs(1:128,1),channelRFs(1:128,2),[],col);
        scatter(0,0,'r','o','filled');%fix spot
        %draw dotted lines indicating [0,0]
        plot([0 0],[-250 200],'k:')
        plot([-200 300],[0 0],'k:')
        plot([-200 300],[200 -300],'k:')
        ellipse(50,50,0,0,[0.1 0.1 0.1]);
        ellipse(100,100,0,0,[0.1 0.1 0.1]);
        ellipse(150,150,0,0,[0.1 0.1 0.1]);
        ellipse(200,200,0,0,[0.1 0.1 0.1]);
        text(sqrt(1000),-sqrt(1000),'2','FontSize',14,'Color',[0.7 0.7 0.7]);
        text(sqrt(4000),-sqrt(4000),'4','FontSize',14,'Color',[0.7 0.7 0.7]);
        text(sqrt(10000),-sqrt(10000),'6','FontSize',14,'Color',[0.7 0.7 0.7]);
        text(sqrt(18000),-sqrt(18000),'8','FontSize',14,'Color',[0.7 0.7 0.7]);
        axis square
        xlim([0 200]);
        ylim([-200 0]);
        title(['visual responses to symbol ',allLetters(letterCond)]);
        figure;
        for timePoint=1:size(normChannelsResponse{letterCond},2)
            col=normChannelsResponse{letterCond}(:,timePoint);
            scatter(channelRFs(1:128,1),channelRFs(1:128,2),[],col);
            pause(0.01);
        end
    end
end
%             %draw dotted lines indicating stimulus presentation
%             if smoothResponse==1
%                 minResponse=min(letterYMin);
%                 [maxResponse maxLetter]=max(letterYMax);
%             end
%             diffResponse=maxResponse-minResponse;
%             if downSampling==0
%                 plot([sampFreq*preStimDur sampFreq*preStimDur],[minResponse-diffResponse/10 maxResponse+diffResponse/10],'k:')
%                 plot([sampFreq*(preStimDur+stimDur) sampFreq*(preStimDur+stimDur)],[minResponse-diffResponse/10 maxResponse+diffResponse/10],'k:')
%             elseif downSampling==1
%                 plot([sampFreq/downsampleFreq*preStimDur sampFreq/downsampleFreq*preStimDur],[minResponse-diffResponse/10 maxResponse+diffResponse/10],'k:')
%                 plot([sampFreq/downsampleFreq*(preStimDur+stimDur) sampFreq/downsampleFreq*(preStimDur+stimDur)],[minResponse-diffResponse/10 maxResponse+diffResponse/10],'k:')
%             end
%             for i=1:10
%                 if i==10
%                     plot(letterYMaxLoc(i)+diffResponse/40,letterYMax(i)+diffResponse/40,'square','Color',colind(i,:),'MarkerSize',10)
%                     plot(1485,maxResponse+diffResponse/10-i*diffResponse/40,'square','Color',colind(i,:),'MarkerSize',8)
%                 else
%                     text(letterYMaxLoc(i)+diffResponse/40,letterYMax(i)+diffResponse/40,allLetters(i),'Color',colind(i,:),'FontSize',10)
%                     text(1480,maxResponse+diffResponse/10-i*diffResponse/40,allLetters(i),'Color',colind(i,:),'FontSize',8)
%                 end
%             end
%             ylim([minResponse-diffResponse/10 maxResponse+diffResponse/10]);
%             xlim([0 length(meanChannelMUA(letterCond,:))]);
%             title([num2str(channelInd),' letters']);
%             axes('Position',[.75 .75 .15 .15])%left bottom width height: the left and bottom elements define the distance from the lower left corner of the container (typically a figure, uipanel, or uitab) to the lower left corner of the position boundary. The width and height elements are the position boundary dimensions.
%             box on
%             draw_rf_letters(instanceInd,channelInd,0)
%             set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
%             pathname=fullfile('D:\data',date,[instanceName,'_','channel_',num2str(channelInd),'_visual_response_letters_smooth']);
%             print(pathname,'-dtiff');
%             % create smaller axes in top right, and plot on it
%             close(figLetters)
%         end
%         for figInd=1:4
%             figure(figInd)
%             set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
%             pathname=fullfile('D:\data',date,[instanceName,'_',num2str(figInd),'_visual_response']);
%             print(pathname,'-dtiff');
%         end
%         close all
%     end
% end
pauseHere=1;