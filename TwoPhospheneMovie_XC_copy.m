clc, clear, close all
% read in data
datapath = 'goodArrays8to16_new.mat';
load(datapath)
datapath = './eye_data.mat';
load(datapath)

discountFactor = 0.995;
NumDiscountDP = 400;
NumDiscountDP = 0;
% discountFactor = 1;
samplerate = 15000; % Hz, movie sample rate, the lower the value, the slower the movie.
TrueSampleRate = 30000; % Hz, the real sample rate of the eye data
blanktime = [0.1 0.3]; % second(s), time before stimulus onset, used to align eye traces

smoothwindow = 850; % span of the smooth window

pixperdegX = 233*1.3; % from Xing
pixperdegY = 312*1.3; % from Xing
RFpixperdeg = 25.8601;

NumTotalTrialsInMovie = 32;
% NumTotalTrialsInMovie = numel(eyeDataXFinal);
randPermTrials=0;
if randPermTrials==1
    ReRandTrialNumber = randperm(NumTotalTrialsInMovie);
else
    ReRandTrialNumber = 1:NumTotalTrialsInMovie;
end

rainbow = 0;

% find number of trials
numTrials = numel(eyeDataXFinal);

h=figure('position',[100 100 1000 750]);
set(h,'color',[1 1 1]);
totalFrame = 0;
Conditions = [];
trials = 0;

colors = lines(5);


for thisTrial = 1:NumTotalTrialsInMovie
     disp(['working on trial ', num2str(thisTrial),'/',num2str(NumTotalTrialsInMovie)]);
%     thisTrialIdx = trialBlockIdx(thisTrial,sortedtrialblockidx(thisMovie));
    thisTrialIdx = thisTrial;
    thisTrialIdx = ReRandTrialNumber(thisTrial);
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
    
    array = allArrayNumFinal{thisTrialIdx};
    elec = allElectrodeNumFinal{thisTrialIdx};
    numElec = numel(array);
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
          idx = goodArrays8to16(:,7) == array(thisElec) & goodArrays8to16(:,8) == elec(thisElec);
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
    trialData.x = trialData.x- mean(trialData.x(round(blanktime(1)*TrueSampleRate):round(blanktime(2)*TrueSampleRate)));
    trialData.y = trialData.y- mean(trialData.y(round(blanktime(1)*TrueSampleRate):round(blanktime(2)*TrueSampleRate)));
    
    % damp first n samples
%     trialData.x(round(blanktime(1)*TrueSampleRate):round(blanktime(2)*TrueSampleRate)) = trialData.x(round(blanktime(1)*TrueSampleRate):round(blanktime(2)*TrueSampleRate))/2;
%     trialData.y(round(blanktime(1)*TrueSampleRate):round(blanktime(2)*TrueSampleRate)) = trialData.y(round(blanktime(1)*TrueSampleRate):round(blanktime(2)*TrueSampleRate))/2;
    
    % smooth the data
    trialData.x = smooth(trialData.x,smoothwindow,'lowess');
    trialData.y = smooth(trialData.y,smoothwindow,'lowess');
    for thisDP = 1:round(40/1000*samplerate):numDP
%         subplot(4,4,[1:12])
        hold off
        % plot RF locations
%         plot(RF.x(goodRFidx),RF.y(goodRFidx),'.','color',[0.1, 0.4,0.1])
%         plot(goodArrays8to16(:,1)/RFpixperdeg,goodArrays8to16(:,2)/RFpixperdeg,'.','color',[0.1, 0.4,0.1])
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
            % up
%             text(-0.75, 7.7, 'V','FontSize',32,'FontName','Sloan')
%             plot(0,8,'k.','markersize',40)
%             plot(0,7.4,'k.','markersize',40)
            plot(0,7.0,'ko','MarkerSize',8,'MarkerFaceColor','k')
            plot(0,7.6,'ko','MarkerSize',8,'MarkerFaceColor','k')
            % down
%             text(-0.75, -7.7, 'H','FontSize',32,'FontName','Sloan')
%             plot(-0.3,-7.7,'k.','markersize',40)
%             plot(0.3,-7.7,'k.','markersize',40)
            plot(-0.3,-7.3,'ko','MarkerSize',8,'MarkerFaceColor','k')
            plot(0.3,-7.3,'ko','MarkerSize',8,'MarkerFaceColor','k')
        end
        
        % add a discount
%         for i = max(1,thisDP-400):thisDP
        for i = max(1,thisDP-NumDiscountDP):thisDP
            if ~rainbow
                tmp = colorspace('HSL->RGB',[240 - (240 -203.2258) *discountFactor^(thisDP-i),    1*discountFactor^(thisDP-i), 0.6- (0.6-0.3647)*discountFactor^(thisDP-i)]); % normal version
            else
                tmp = colorspace('HSL->RGB',[mod(240 + 360 - (240 + 360 -239) * discountFactor^(thisDP-i),360),    1*discountFactor^(thisDP-i),    0.6- (0.6-0.3647)*discountFactor^(thisDP-i)]); % rainbow version
            end
            plot(trialData.x(i),trialData.y(i),'.','markersize',32,'color',tmp)
            
        end
%         xlabel('Azimuth (degree)')
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

        totalFrame = totalFrame + 1;
        set(gca,'color',[0.6 0.6 0.6]);
        F = getframe(h);
        [X, Map] = frame2im(F);
        FrameData(:,:,:,totalFrame) = X;
    end
end

% write to movie
myVideo = VideoWriter(['./movie',num2str(1),'_XC.mp4'],'MPEG-4');
myVideo.FrameRate = 25;
myVideo.Quality = 100;
open(myVideo);

for thisframe = 1:totalFrame
    
        thisFrameData = squeeze(FrameData(:,:,:,thisframe));
        writeVideo(myVideo, thisFrameData);
        
end

close(myVideo);