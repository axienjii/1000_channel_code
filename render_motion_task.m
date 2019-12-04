function render_motion_task
%Written by Xing 29/5/19. Read in images of monkeys in setup, identify
%x- and y-coordinates of arrays on cortex, and assign pixels on each array
%to each electrode. Combines pixel coordinates with microstimulation, RF
%centres, and eye movements. 

for monkeyInd=1
    if monkeyInd==1%Lick
        A = imread('D:\data\barsweep_video_in_setup\lick_realistic_skin_intact11.jpg');
        rootDir='D:\data';
        remoteDir='X:\best';
    elseif monkeyInd==2%Aston
        A = imread('D:\aston_data\barsweep_video_in_setup\aston_realistic_skin_intact11.jpg');
        rootDir='D:\aston_data';
        remoteDir='X:\aston';
    end
    image(A);
    copyA=A;
    for xInd=365:385
        for yInd=335:355
            copyA(yInd,xInd,:)=[149 149 149];
        end
    end
    hold on
    if monkeyInd==1%Lick
        load('D:\data\barsweep_video_in_setup\lick_cornerCoords.mat')
    elseif monkeyInd==2%Aston
        load('D:\aston_data\barsweep_video_in_setup\aston_cornerCoords.mat')
    end
    selectScreenCorners=0;
    if selectScreenCorners==1
        [xScreenCorners yScreenCorners]=ginput(4);
        scatter(xScreenCorners,yScreenCorners,'filled','y')
        if monkeyInd==1%Lick
            save('D:\data\motion_video_in_setup\lick_screenCornerCoords.mat','xScreenCorners','yScreenCorners')
        end
    else
        load('D:\data\motion_video_in_setup\lick_screenCornerCoords.mat')
    end
    
    numElectrodesPerEdge=8;%8-by-8 arrays
    numArrays=16;%total number of arrays per hemisphere
    load([rootDir,'\barsweep_video_in_setup\allPixelIDs.mat'])
    
    %read in RF, eye data
    pixperdeg = 25.8601;
    bardur = 1000; %duration in miliseconds
    
    direct{1} = 'L to R';
    direct{2} = 'D to U';
    direct{3} = 'R to L';
    direct{4} = 'U to D';
    
    stimDurms=167;%in ms
    preStimDur=300/1000;%length of pre-stimulus-onset period, in s
    
    if monkeyInd==1
        cd W:\Feng\behaviormovies\motion_task_movie
        datapath = 'goodArrays8to16_new.mat';
        load(datapath)
        datapath = './eye_data.mat';
        load(datapath)
        discountFactor = 0.995;
        NumDiscountDP = 400;
        samplerate = 15000; % Hz, movie sample rate, the lower the value, the slower the movie.
        TrueSampleRate = 30000; % Hz, the real sample rate of the eye data
        blanktime = [0.1 0.3]; % second(s), time before stimulus onset, used to align eye traces
        
        smoothwindow = 850; % span of the smooth window
        
        pixperdegX = 233*1.3; % from Xing
        pixperdegY = 312*1.3; % from Xing
        RFpixperdeg = 25.8601;
        
        NumTotalTrialsInMovie = numel(eyeDataXFinal);
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
    end
    
    drawFrames=1;
    if drawFrames==1
        frameNo=1;
        for thisTrial = 1:NumTotalTrialsInMovie
            disp(['working on trial ', num2str(thisTrial),'/',num2str(NumTotalTrialsInMovie)]);
            thisTrialIdx = ReRandTrialNumber(thisTrial);            
            % get RF locations
            thisCond = targetLocationsFinal(thisTrialIdx)
            
            array = allArrayNumFinal{thisTrialIdx};
            array = array{1};
            elec = allElectrodeNumFinal{thisTrialIdx};
            elec = elec{1};
            numElec = numel(array);
            elecRFs.x = zeros(numElec,1);
            elecRFs.y = zeros(numElec,1);
            for thisElec = 1:numElec
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
            % smooth the data
            trialData.x = smooth(trialData.x,smoothwindow,'lowess');
            trialData.y = smooth(trialData.y,smoothwindow,'lowess');
            for thisDP = 1:round(40/1000*samplerate):numDP%27001%9001
                copyA2=copyA;
                hold off
                %colour arrays based on delivery of microstimulation on individual electrodes:
                for arrayInd=1:numArrays
                    pixelIDs=allPixelIDs{arrayInd};
                    for colCount=1:numElectrodesPerEdge%each column of electrodes
                        for rowCount=1:numElectrodesPerEdge%each row of electrodes
                            if ~isempty(pixelIDs{rowCount,colCount})
                                for pixelCount=1:size(pixelIDs{rowCount,colCount},1)
                                    copyA2(round(pixelIDs{rowCount,colCount}(pixelCount,2)),round(pixelIDs{rowCount,colCount}(pixelCount,1)),:)=[0 0 255];%set to blue
                                end
                            end
                        end
                    end
                end
                
                image(copyA2);
                h2=figure;
                ax=gca;
                ax.Color=[149/255 149/255 149/255];
                hold on

                if thisDP/TrueSampleRate < (300 + 600)/1000 || thisDP/TrueSampleRate >= (300 + 600 + 250)/1000
                    plot(0,0,'ro','MarkerSize',8,'MarkerFaceColor',[1 0 0])
                end
                
                if thisDP/TrueSampleRate >= (300 + 600)/1000 && thisDP/TrueSampleRate < (300 + 600 + 250)/1000
                    plot(0,7.3,'ko','MarkerSize',10,'MarkerFaceColor','k')
                    plot(0,-7.3,'ko','MarkerSize',10,'MarkerFaceColor','k')
                end
                
                for i = max(1,thisDP-NumDiscountDP):thisDP
                    if ~rainbow
                        tmp = colorspace('HSL->RGB',[240 - (240 -203.2258) *discountFactor^(thisDP-i),    1*discountFactor^(thisDP-i), 0.6- (0.6-0.3647)*discountFactor^(thisDP-i)]); % normal version
                    else
                        tmp = colorspace('HSL->RGB',[mod(240 + 360 - (240 + 360 -239) * discountFactor^(thisDP-i),360),    1*discountFactor^(thisDP-i),    0.6- (0.6-0.3647)*discountFactor^(thisDP-i)]); % rainbow version
                    end
                    plot(trialData.x(i),trialData.y(i),'.','markersize',32,'color',tmp)
                end
                ax.XTick=[];
                ax.XTickLabel={'-10','-5','0','5','10'};
                ax.YTick=[];
                ax.YTickLabel={'-10','-5','0','5','10'};
                set(gca,'Box','off');
                set(gcf,'color','k');
                xlim([-13 13])
                ylim([-10 10])
                set(gca,'LooseInset',get(gca,'TightInset'))
                movingPoints=[0 0;1344 0;1344 917;0 917];
                yScreenCorners(3)=200;
                xScreenCorners(1)=103;
                xScreenCorners(2)=629;
                xScreenCorners(3)=630;
                xScreenCorners(4)=87;
                fixedPoints=[xScreenCorners*2 yScreenCorners*2];
                tform_cpp = fitgeotrans(movingPoints,fixedPoints,'projective');
                F = getframe(h2);
                F.cdata=flipud(F.cdata);%for images, x and y coordinates are swapped, hence target locations need to be flipped
                B = imwarp(F.cdata,tform_cpp);%warp the screen
                figure;
%                 imshow(B);
                for xInd=1:size(B,1)%draw targets on setup image
                    for yInd=1:size(B,2)
                        targetsArea=0;
                        if xInd>30&&xInd<325&&yInd>250&&yInd<340
                            targetsArea=1;
                            if sum(B(xInd,yInd,:))==0
                                pauseHere=1;
                            end
                        end
                        if sum(diff(B(xInd,yInd,:)))>1||targetsArea%sum(B(xInd,yInd,:))>50
                            copyA2(round(xScreenCorners(4))+90+xInd,round(yScreenCorners(4))-63+yInd,:)=B(xInd,yInd,:);
                        end
                    end
                end
                
                NumelectrodethisTrial = numel(elecRFs.x);   
                for thisStimElec = 1:NumelectrodethisTrial
                    if thisDP/TrueSampleRate >= (300+(thisStimElec-1)*167)/1000 && thisDP/TrueSampleRate <= (300 + thisStimElec*167)/1000
                    % highlight stimulating electrodes on setup image
                        arrayInd=array(thisStimElec);
                        elecInd=elec(thisStimElec);
                        rowCount=mod(elecInd,8);
                        if rowCount==0
                            rowCount=8;
                        end
                        colCount=ceil(elecInd/8);
                        pixelIDs=allPixelIDs{arrayInd};
                        if ~isempty(pixelIDs{rowCount,colCount})
                            for pixelCount=1:size(pixelIDs{rowCount,colCount},1)
                                copyA2(round(pixelIDs{rowCount,colCount}(pixelCount,2)),round(pixelIDs{rowCount,colCount}(pixelCount,1)),:)=[255 255 0];%set to yellow
                            end
                        end
                    end
                end
                image(copyA2);                
                             
                for thisStimElec = 1:NumelectrodethisTrial
                    if thisDP/TrueSampleRate >= (300+(thisStimElec-1)*167)/1000 && thisDP/TrueSampleRate <= (300 + thisStimElec*167)/1000
                        %                 plot(elecRFs.x(thisStimElec),elecRFs.y(thisStimElec),'.','color',[1 1 1],'markersize',12)
                        % plot phosphene percepts
                        hold on
                        ms=15;
                        [x,y]=meshgrid(-ms:ms, -ms:ms);
                        %generate Gaussian-shaped phosphene
                        xsd=ms/2;
                        ysd=ms/2;
                        maskblob=round(exp(-((x/xsd).^2)-((y/ysd).^2))*255);
                        for rgbInd=1:3%for images, x and y coordinates are swapped
                            copyA2(600+floor(elecRFs.y(thisStimElec)*-40):600+floor(elecRFs.y(thisStimElec)*-40)-1+size(maskblob,2),400+floor(elecRFs.x(thisStimElec)*40):400+floor(elecRFs.x(thisStimElec)*40)-1+size(maskblob,1),rgbInd)=maskblob;
%                             copyA2(800+floor(elecRFs.y(thisStimElec)*40):800+floor(elecRFs.y(thisStimElec)*40)-1+size(maskblob,2),400+floor(elecRFs.x(thisStimElec)*40):400+floor(elecRFs.x(thisStimElec)*40)-1+size(maskblob,1),rgbInd)=maskblob;
                        end
                    end
                end
                
                image(copyA2);
                
                set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
                set(gca,'LooseInset',get(gca,'TightInset'))
                set(gca,'visible','off')
%                 totalFrame = totalFrame + 1;
%                 set(gca,'color',[0.6 0.6 0.6]);
%                 F = getframe(h);
%                 [X, Map] = frame2im(F);
%                 FrameData(:,:,:,totalFrame) = X;
                framesResponse(frameNo)=getframe;
                frameNo=frameNo+1;
                close all
            end
        end
        pathname=[rootDir,'\motion_video_in_setup\setup 1024-channel motion.mat'];
        save(pathname,'framesResponse','-v7.3')
    end

    % write to movie
    myVideo = VideoWriter(['./motion_movie',num2str(1),'_XC.mp4'],'MPEG-4');
    myVideo.FrameRate = 25;
    myVideo.Quality = 100;
    open(myVideo);
    
    for thisframe = 1:length(framesResponse)        
%         thisFrameData = squeeze(framesResponse(:,:,:,thisframe));
        writeVideo(myVideo, framesResponse(thisframe));        
    end    
    close(myVideo);    
end
