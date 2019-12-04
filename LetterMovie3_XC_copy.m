clc, clear, close all
skipTrials = [58 162 364];
% read in data
datapath = 'goodArrays8to16_new.mat';
load(datapath)
datapath = './eye_data.mat';
load(datapath)
datapath = './RFinfo.mat';
load(datapath)
datapath = './channel_area_mapping.mat';
load(datapath)

discountFactor = 0.995;

samplerate = 15000; % Hz, movie sample rate, the lower the value, the slower the movie.
TrueSampleRate = 30000; % Hz, the real sample rate of the eye data
blanktime = 0.25; % second(s), time before stimulus onset, used to align eye traces

smoothwindow = 850; % span of the smooth window

pixperdegX = 233; % from Xing
pixperdegY = 312; % from Xing
RFpixperdeg = 25.8601;

NumTotalTrialsInMovie = 20;
PerformanceThreshold1 = 0.85;
PerformanceThreshold2 = 0.99;

rainbow = 0;



% only look at correct trials
% trialidx = perfNEVFinal == 1;
% eyeDataXFinal = eyeDataXFinal(trialidx);
% eyeDataYFinal = eyeDataYFinal(trialidx);
% targetLocationsFinal = targetLocationsFinal(trialidx);

% find number of trials
numTrials = numel(eyeDataXFinal);

% find blocks
trialBlockNumber = 0;
for thisTrial = 1:(numTrials - NumTotalTrialsInMovie + 1)
    trialIdx = thisTrial:(thisTrial+NumTotalTrialsInMovie-1);
    blockPerf = perfNEVFinal(trialIdx);
    blockhitrate = sum(blockPerf == 1) / NumTotalTrialsInMovie;
    if blockhitrate >= PerformanceThreshold1 && blockhitrate < PerformanceThreshold2
        trialBlockNumber = trialBlockNumber + 1;
        trialBlockIdx(:,trialBlockNumber) = trialIdx;
        thisTrial = thisTrial + NumTotalTrialsInMovie / 2;
    end
end

% find a trialBlock that has all four conditions
for thisTrialBlock = 1:trialBlockNumber
    conditionID(:,thisTrialBlock) = targetLocationsFinal(trialBlockIdx(:,thisTrialBlock));
end

Condvar = var(conditionID);
for thisCond = 1:4
    NumConditionID(thisCond,:) = sum(conditionID == thisCond,1);
end

prodConditionID = prod(NumConditionID,1);

Condvar = Condvar/max(Condvar);
prodConditionID = prodConditionID/max(prodConditionID);

a = 1;
b = 1;

[~,sortedtrialblockidx] = sort(a*Condvar+b*prodConditionID,'descend');
% show data from trials (for debugging)
% trialidx = 1:numTrials; % sequencial
% trialidx = randperm(numTrials); % random

h=figure('position',[100 100 1000 750]);
set(h,'color',[1 1 1]);
totalFrame = 0;
Conditions = [];
trials = 0;

colors = lines(5);

% rootdir='U:\Feng\2-phosphene_data\';
% matFile=[rootdir,date,'\',date,'_data\microstim_saccade_',date,'.mat'];
% dataDir=[rootdir,date,'\',date,'_data'];
% for electrodeCount=1:size(setElectrodes,2)    
%     for setInd=1:2        
%         electrode=setElectrodes(setInd,electrodeCount);        
%         array=setArrays(setInd,electrodeCount);        
%         load([dataDir,'\array',num2str(array),'.mat']);        
%         electrodeIndtemp1=find(goodArrays8to16(:,8)==electrode);%matching channel number        
%         electrodeIndtemp2=find(goodArrays8to16(:,7)==array);%matching array number        
%         electrodeInd=intersect(electrodeIndtemp1,electrodeIndtemp2);%channel number        
%         RFx=goodArrays8to16(electrodeInd,1);        
%         RFy=goodArrays8to16(electrodeInd,2);        
%         plot(RFx,RFy,'o','Color',cols(array-7,:),'MarkerFaceColor',cols(array-7,:));hold on        
%     end    
% end

goodRFidx = RF.x > 0 & RF.y < 0;

for thisMovie = 6
%     targetLocationsFinal(thisTrial,sortedtrialblockidx(2))

for thisTrial = 1:NumTotalTrialsInMovie
    thisTrialIdx = trialBlockIdx(thisTrial,sortedtrialblockidx(thisMovie));
    
    % skip trials
%     if sum(skipTrials == thisTrialIdx) > 0
%         continue
%     end
    
    % get RF locations
    thisCond = targetLocationsFinal(thisTrialIdx)
    % skip if we've already had this condition
%     if sum(Conditions == thisCond) > 0
%         continue
%     end
%     trials = trials + 1;
%     if trials > NumTotalTrialsInMovie
%         break
%     end
%     Conditions = [Conditions,thisCond];
%     
%     if numel(Conditions) == 4
%         Conditions = [];
%     end
    
    arrays = setArrays{thisCond};
    elec = setElectrodes{thisCond};
    numElec = numel(arrays);
    elecRFs.x = zeros(numElec,1);
    elecRFs.y = zeros(numElec,1);
    for thisElec = 1:numElec
        % my original method
%         idx = arrayNums == arrays(thisElec) & channelNums == elec(thisElec);
%         elecRFs.x(thisElec) = RF.x(idx);
%         elecRFs.y(thisElec) = RF.y(idx);
        % method using data from Xing's array* matrix
%           load(['.\array',num2str(arrays(thisElec)),'.mat']);  
%           cmd = ['idx = array',num2str(arrays(thisElec)),'(:,8) == elec(thisElec);'];
%           eval(cmd)
%           cmd = ['elecRFs.x(thisElec) = array',num2str(arrays(thisElec)),'(idx,1);'];
%           eval(cmd)
%           cmd = ['elecRFs.y(thisElec) = array',num2str(arrays(thisElec)),'(idx,2);'];
%           eval(cmd)
        % method using updated version of goodArrays8to16
          idx = goodArrays8to16(:,7) == arrays(thisElec) & goodArrays8to16(:,8) == elec(thisElec);
          elecRFs.x(thisElec) = goodArrays8to16(idx,1);
          elecRFs.y(thisElec) = goodArrays8to16(idx,2);
    end
    elecRFs.x = elecRFs.x / RFpixperdeg;
    elecRFs.y = elecRFs.y / RFpixperdeg;
    
    % prepare eye data
    numDP = numel(eyeDataXFinal{thisTrialIdx});
    trialData.x = -double(eyeDataXFinal{thisTrialIdx})/pixperdegX;
    trialData.y = -double(eyeDataYFinal{thisTrialIdx})/pixperdegY;
    % subtract first n samples
    trialData.x = trialData.x- mean(trialData.x(1:round(blanktime*TrueSampleRate)));
    trialData.y = trialData.y- mean(trialData.y(1:round(blanktime*TrueSampleRate)));
    % smooth the data
    trialData.x = smooth(trialData.x,smoothwindow,'lowess');
    trialData.y = smooth(trialData.y,smoothwindow,'lowess');
    for thisDP = 1:round(40/1000*samplerate):numDP
%         subplot(4,4,[1:12])
        hold off
        % plot RF locations
%         plot(RF.x(goodRFidx),RF.y(goodRFidx),'.','color',[0.1, 0.4,0.1])
        plot(1000,1000,'.','color',[0.1, 0.4,0.1])%dummy
        hold on
        h2 = gca;
        h2.Box = 'off';
        set(h2,'FontSize',16)
        if thisDP/TrueSampleRate < (300 + 600)/1000 || thisDP/TrueSampleRate >= (300 + 600 + 250)/1000
            % plot fixtion point
%             plot([-0.5 0.5],[0 0],'red','linewidth',1.5)
%             plot([0 0],[-0.5 0.5],'red','linewidth',1.5)
            plot(0,0,'ro','MarkerSize',8,'MarkerFaceColor',[1 0 0])
        end
        
        if thisDP/TrueSampleRate >= (300 + 600)/1000 && thisDP/TrueSampleRate < (300 + 600 + 250)/1000
            % plot targets
            % left
            text(-8.5,0,'T','FontSize',32,'FontName','Sloan','Color',[0.75 0.75 0])
            % right
            text(7,0,'O','FontSize',32,'FontName','Sloan','Color',[0.75 0.75 0])
            % up
            text(-0.75, 7.7, 'A','FontSize',32,'FontName','Sloan','Color',[0.75 0.75 0])
            % down
            text(-0.75, -7.7, 'L','FontSize',32,'FontName','Sloan','Color',[0.75 0.75 0])
        end
        
        % add a discount
        for i = max(1,thisDP-400):thisDP
            if ~rainbow
                tmp = colorspace('HSL->RGB',[240 - (240 -203.2258) *discountFactor^(thisDP-i),    1*discountFactor^(thisDP-i), 0.6- (0.6-0.3647)*discountFactor^(thisDP-i)]); % normal version
            else
                tmp = colorspace('HSL->RGB',[mod(240 + 360 - (240 + 360 -239) * discountFactor^(thisDP-i),360),    1*discountFactor^(thisDP-i),    0.6- (0.6-0.3647)*discountFactor^(thisDP-i)]); % rainbow version
            end
            plot(trialData.x(i),trialData.y(i),'.','markersize',32,'color',tmp)
            
        end
%         xlabel('Azimuth (degree)')
% %         text(-3,-13,'Azimuth (degree)')
%         ylabel('Elevation (degree)')
        ax=gca;
        ax.XTick=[];
        ax.XTickLabel={'-10','-5','0','5','10'};
        ax.YTick=[];
        ax.YTickLabel={'-10','-5','0','5','10'};
%         xlabel('x-coordinates (dva)')
%         ylabel('y-coordinates (dva)')
        set(gca,'Box','off');
        set(gcf,'color','k');
        
        
        % plot stimulating electrodes
        if thisDP/TrueSampleRate >= 300/1000 && thisDP/ TrueSampleRate <= (300+167)/1000            
%             plot(elecRFs.x,elecRFs.y,'o','color',[1 0 0],'linewidth',1.8)
%             if mod(totalFrame,2) == 0
                plot(elecRFs.x,elecRFs.y,'.','color',[1 1 1],'markersize',12)
%             end
        end
        
        xlim([-13 13])
        ylim([-10 10])
%         h2 = subplot(4,4,[13:16]);
%         xdata = (1:numel(trialData.x))/TrueSampleRate;
%         hold off
%         plot(xdata,trialData.x,'color',colors(3,:))
%         hold on
%         h2.Box = 'off';
%         ylim([-15 15])
%         plot(xdata,trialData.y,'color',colors(4,:))
%         
%         if thisDP/TrueSampleRate >= 300/1000 && thisDP/ TrueSampleRate <= (300+167)/1000
%             plot([thisDP/TrueSampleRate thisDP/TrueSampleRate],[-20 10],'color','red')
%         else
%             plot([thisDP/TrueSampleRate thisDP/TrueSampleRate],[-20 10],'color','black')
%         end
%         text(0.55,16,'Azimuth (degree)','FontSize',12)
%         xlabel('Time (s)')
%         ylabel('Dva (deg)')
%         pause(0.04)
        totalFrame = totalFrame + 1;
        set(gca,'color',[0.6 0.6 0.6]);
        F = getframe(h);
        [X, Map] = frame2im(F);
        FrameData(:,:,:,totalFrame) = X;
    end
end


% write to movie
% myVideo1 = VideoWriter('./movie.avi', 'Uncompressed AVI');
% myVideo1.FrameRate = 25;
% myVideo2 = VideoWriter('./movie.mj2','Motion JPEG AVI');
% myVideo2.FrameRate = 25;
% myVideo2.Quality = 100;
myVideo3 = VideoWriter(['./movie',num2str(thisMovie),'_XC.mp4'],'MPEG-4');
myVideo3.FrameRate = 25;
myVideo3.Quality = 100;
% open(myVideo1);
% open(myVideo2);
open(myVideo3);

for thisframe = 1:totalFrame
    
        thisFrameData = squeeze(FrameData(:,:,:,thisframe));
        
%         % add a discount
%         traceData = zeros(size(thisFrameData));
%         for i = 1:thisframe
%             tmpData = squeeze(FrameData(:,:,:,i));
%             tmpData = double(tmpData);
%             idx = tmpData(:,:,1) == 0 & tmpData(:,:,2) == 114 & tmpData(:,:,3) == 189;
%             idx = cat(3,idx,idx,idx);
%             tmpData(~idx) = 0;
%             tmpData = tmpData.*discountFactor^(thisframe - i);
% %             idx = traceData(:,:,1) == 0 & traceData(:,:,2) == 0 & traceData(:,:,3) == 0;
% %             idx = cat(3,idx,idx,idx);
% %             traceData(idx) = traceData(idx) + tmpData(idx);
%             traceData = traceData + tmpData;
%         end
%         traceData(:,:,2) = traceData(:,:,2) / max(max(max(traceData(:,:,2)))) * 114;
%         traceData(:,:,3) = traceData(:,:,3) / max(max(max(traceData(:,:,3)))) * 189;
%         idx = thisFrameData(:,:,1) == 0 & thisFrameData(:,:,2) == 114 & thisFrameData(:,:,3) == 189;
%         idx = cat(3,idx,idx,idx);
%         thisFrameData(idx) = 0;
%         traceData = uint8(traceData);
%         thisFrameData = thisFrameData + traceData;
%         thisFrameData(~idx) = thisFrameData(~idx) + traceData(~idx);
        % get the gaze position
        
        
%         writeVideo(myVideo1, thisFrameData);
%         writeVideo(myVideo2, thisFrameData);
        writeVideo(myVideo3, thisFrameData);
        
end
% close(myVideo1);
% close(myVideo2);
close(myVideo3);

end