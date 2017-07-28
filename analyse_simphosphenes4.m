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

stimDurCheckerboard=400/1000;%in seconds
preStimDurCheckerboard=300/1000;%length of pre-stimulus-onset period, in s
postStimDurCheckerboard=300/1000;%length of post-stimulus-offset period, in s

calculateVisualResponses=1;
if calculateVisualResponses==1
    for instanceCount=1:length(allInstanceInd)
        instanceInd=allInstanceInd(instanceCount);
        instanceName=['instance',num2str(instanceInd)];
        normMeanChannelResponse1024=[];
        normChannelsResponse=cell(1,length(allLetters));
        goodChannels=allGoodChannels{instanceCount};
        %load data from checkerboard task, to obtain maximum responses for
        %each channel:
        maxCheckerboardResp=[];
        loadDate='110717_B3';
        instanceName=['instance',num2str(instanceInd)];
        fileName=fullfile('D:\data',loadDate,['mean_MUA_',instanceName,'.mat']);
        load(fileName,'meanChannelMUA')
        for channelCount=1:length(goodChannels)
            channelInd=goodChannels(channelCount);
            
            %calculate max response during checkerboard task:
            maxCheckerboard=max(meanChannelMUA(channelInd,sampFreq*preStimDurCheckerboard/downsampleFreq:sampFreq*(preStimDurCheckerboard+stimDurCheckerboard)/downsampleFreq));
            baselineRespCheckerboard=mean(meanChannelMUA(channelInd,1:sampFreq*preStimDurCheckerboard/downsampleFreq-1));
            maxCheckerboardResp=maxCheckerboard-baselineRespCheckerboard;

            %letter task:
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
                meanChannelMUAletter(letterCond,:)=mean(trialData(find(goodTrialCondsMatch(:,1)==letterCond),:),1);
                meanChannelResponse(letterCond,:)=mean(meanChannelMUAletter(letterCond,sampFreq/downsampleFreq*preStimDur+1:sampFreq/downsampleFreq*(preStimDur+stimDur)));
                normChannelsResponse{letterCond}=[normChannelsResponse{letterCond};meanChannelMUAletter(letterCond,:)-baseline];%store activity over the whole trial. each cell contains activity levels, with channels in rows, and time in columns
            end
            normMeanChannelResponse(channelCount,:)=(meanChannelResponse-baseline)/maxCheckerboardResp;%normalise response for each channel to maximum observed during checkerboard task, subtract spontaneous activity levels
            %normMeanChannelResponse(channelCount,:)=(meanChannelResponse-baseline)/(max(meanChannelResponse)-baseline);%normalise response for each channel to maximum, subtract spontaneous activity levels
        end
        normMeanChannelResponse1024=[normMeanChannelResponse1024;normMeanChannelResponse];%mean activity across stimulus presentation period, with channels in rows, and letter conditions in columns
        fileName=['D:\data\',date,'\visual_response_instance',num2str(instanceInd),'.mat'];
        save(fileName,'normChannelsResponse','normMeanChannelResponse1024')        
    end
<<<<<<< HEAD
    normMeanChannelResponse1024=[normMeanChannelResponse1024;normMeanChannelResponse];%mean activity across stimulus presentation period, with channels in rows, and letter conditions in columns
    fileName=['D:\data\',date,'\visual_response_instance',num2str(instanceInd),'.mat'];
    save(fileName,'normChannelsResponse','normMeanChannelResponse1024')
end
    
=======
end

%combine RF data and visual response data across 4 of the instances:
allChannelRFs=[];
for instanceInd=1:8
>>>>>>> e0dd07bfd8fa750695d358cd07bf1e7939811859
    loadDate='best_260617-280617';
    fileName=['D:\data\',loadDate,'\RFs_instance',num2str(instanceInd),'.mat'];
    load(fileName)
    allChannelRFs=[allChannelRFs;channelRFs];
end
allNormMeanChannelResponse1024=[];
allNormChannelsResponse=cell(1,10);
for instanceInd=1:8
    loadDate='best_260617-280617';
    fileName=['D:\data\',loadDate,'\RFs_instance',num2str(instanceInd),'.mat'];
    load(fileName)
    allChannelRFs=[allChannelRFs;channelRFs];
    instanceInd=allInstanceInd(instanceInd);
    instanceName=['instance',num2str(instanceInd)];
    fileName=['D:\data\',date,'\visual_response_instance',num2str(instanceInd),'.mat'];
    load(fileName,'normChannelsResponse','normMeanChannelResponse1024')
    allNormMeanChannelResponse1024=[allNormMeanChannelResponse1024;normMeanChannelResponse1024];
    for letterCond=1:10
<<<<<<< HEAD
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
            pause(0.001);
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
=======
        allNormChannelsResponse{letterCond}=[allNormChannelsResponse{letterCond};normChannelsResponse{letterCond}];
    end
end
for letterCond=1:10
    figure;hold on
    colInd=allNormMeanChannelResponse1024(:,letterCond)./maxCheckerboardResp;
    col=[colInd*255 colInd*255 colInd];
    scatter(allChannelRFs(:,1),allChannelRFs(:,2),[],col);
    xlim([0 200]);
    ylim([-200 0]);
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
    allLetters='IUALTVSYJP';
    screenWidth=1024;
    screenHeight=768;
    sampleSize=112;%a multiple of 14, the number of divisions in the letters
    visualWidth=sampleSize;%in pixels
    visualHeight=visualWidth;%in pixels
    Par.PixPerDeg=25.860053410707074;
    
    topLeft=1;%distance from fixation spot to top-left corner of sample, measured diagonally (eccentricity)
    sampleX = round(sqrt((topLeft^2)/2)*Par.PixPerDeg);%randi([30 100]);%location of sample stimulus, in RF quadrant 150 230%want to try 20
    sampleY = round(sqrt((topLeft^2)/2)*Par.PixPerDeg);%randi([30 100]);%[30 140]
    destRect=[screenWidth/2+sampleX screenHeight/2+sampleY screenWidth/2+sampleX+visualWidth screenHeight/2+sampleY+visualHeight];
    plot([0 0],[-240 60],'k:')
    plot([-60 240],[0 0],'k:')
    colind = hsv(10);
    targetLetter=allLetters(letterCond);
    letterPath=['D:\data\letters\',targetLetter,'.bmp'];
    originalOutline=imread(letterPath);
    shape=imresize(originalOutline,[visualHeight,visualWidth]);
    whiteMask=shape==0;
    whiteMask=whiteMask*255;
    shapeRGB(:,:,1)=whiteMask+shape*255*colind(letterCond,1);
    shapeRGB(:,:,2)=whiteMask+shape*255*colind(letterCond,2);
    shapeRGB(:,:,3)=whiteMask+shape*255*colind(letterCond,3);
    h=image(sampleX,-sampleY-visualHeight,flip(shapeRGB,1)); 
    set(h, 'AlphaData', 0.1);
%     figure;
%     for timePoint=1:size(normChannelsResponse{letterCond},2)
%         col=allNormChannelsResponse{letterCond}(:,timePoint);
%         scatter(allChannelRFs(:,1),allChannelRFs(:,2),[],col);
%         axis square
%         xlim([0 200]);
%         ylim([-200 0]);
%         pause(0.0001);
>>>>>>> e0dd07bfd8fa750695d358cd07bf1e7939811859
%     end
end
pauseHere=1;