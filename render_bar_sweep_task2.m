function render_bar_sweep_task2
%Written by Xing 11/4/19. Read in images of monkeys in setup, identify
%x- and y-coordinates of arrays on cortex, and assign pixels on each array
%to each electrode. Combines pixel coordinates with neuronal activity.

for monkeyInd=2
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
    hold on
    selectCorners=0;
    if selectCorners==1
        [xCorners yCorners]=ginput(16*4);
        scatter(xCorners,yCorners,'filled','y')
        if monkeyInd==1%Lick
            save('D:\data\barsweep_video_in_setup\lick_cornerCoords.mat','xCorners','yCorners')
        elseif monkeyInd==2%Aston
            save('D:\custom_implants\aston_pedestal\aston_cornerCoords.mat','xCorners','yCorners')
        end
    else
        if monkeyInd==1%Lick
            load('D:\data\barsweep_video_in_setup\lick_cornerCoords.mat')
        elseif monkeyInd==2%Aston
            load('D:\aston_data\barsweep_video_in_setup\aston_cornerCoords.mat')
        end
    end
    
    numElectrodesPerEdge=8;%8-by-8 arrays
    numArrays=16;%total number of arrays per hemisphere
    calcPixelIDs=0;
    if calcPixelIDs==1
        allPixelIDs=cell(numArrays,1);
        for arrayInd=1:numArrays
            %identify coordinates of the four corners of a particular array
            cornerCoords=[xCorners(4*(arrayInd-1)+1:4*(arrayInd)) yCorners(4*(arrayInd-1)+1:4*(arrayInd))];%first row: x and y of top left corner; second row: top right corner; third row: bottom right corner; fourth row: bottom left corner (array as seen from above, with wire emerging from left side of array)
            %medial edge (between corners 1 and 2, i.e. top-left and top-right):
            APcornersM=cornerCoords(1:2,:);%coordinates of corners, going from anterior to posterior, on the medial-most edge
            xDistance=(APcornersM(2,1)-APcornersM(1,1))/numElectrodesPerEdge;
            yDistance=(APcornersM(2,2)-APcornersM(1,2))/numElectrodesPerEdge;
            APcoordsM=APcornersM(1,:);
            for electrodeCount=1:numElectrodesPerEdge
                APcoordsM=[APcoordsM;APcornersM(1,1)+xDistance*electrodeCount APcornersM(1,2)+yDistance*electrodeCount];
            end
            %posterior edge (between corners 2 and 3, i.e. top-right and bottom-right):
            MLcornersP=cornerCoords(2:3,:);%coordinates of corners, going from medial to lateral, on the posterior-most edge
            xDistance=(MLcornersP(2,1)-MLcornersP(1,1))/numElectrodesPerEdge;
            yDistance=(MLcornersP(2,2)-MLcornersP(1,2))/numElectrodesPerEdge;
            MLcoordsP=MLcornersP(1,:);
            for electrodeCount=1:numElectrodesPerEdge
                MLcoordsP=[MLcoordsP;MLcornersP(1,1)+xDistance*electrodeCount MLcornersP(1,2)+yDistance*electrodeCount];
            end
            %lateral edge (between corners 3 and 4, i.e. bottom-right and bottom-left):
            APcornersL=cornerCoords(3:4,:);%coordinates of corners, going from posterior to anterior, on the lateral-most edge
            xDistance=(APcornersL(2,1)-APcornersL(1,1))/numElectrodesPerEdge;
            yDistance=(APcornersL(2,2)-APcornersL(1,2))/numElectrodesPerEdge;
            APcoordsL=APcornersL(1,:);
            for electrodeCount=1:numElectrodesPerEdge
                APcoordsL=[APcoordsL;APcornersL(1,1)+xDistance*electrodeCount APcornersL(1,2)+yDistance*electrodeCount];
            end
            %anterior edge (between corners 4 and 1, i.e. bottom-left and top-left):
            MLcornersA=cornerCoords([4 1],:);%coordinates of corners, going from lateral to medial, on the anterior-most edge
            xDistance=(MLcornersA(2,1)-MLcornersA(1,1))/numElectrodesPerEdge;
            yDistance=(MLcornersA(2,2)-MLcornersA(1,2))/numElectrodesPerEdge;
            MLcoordsA=MLcornersA(1,:);
            for electrodeCount=1:numElectrodesPerEdge
                MLcoordsA=[MLcoordsA;MLcornersA(1,1)+xDistance*electrodeCount MLcornersA(1,2)+yDistance*electrodeCount];
            end
            %coordinates calculated for all four edges:
            scatter(APcoordsM(:,1),APcoordsM(:,2),'r.');
            scatter(MLcoordsP(:,1),MLcoordsP(:,2),'g.');
            scatter(APcoordsL(:,1),APcoordsL(:,2),'b.');
            scatter(MLcoordsA(:,1),MLcoordsA(:,2),'w.');
            %calculate coordinates for 7 'internal' edges as well:
            internalEdgeCoords=APcoordsM;%coordinates for first row exist
            for internalEdgeCount=1:numElectrodesPerEdge-1%append coordinates for subsequent rows
                edgeCoords=[MLcoordsA(end-internalEdgeCount,1) MLcoordsA(end-internalEdgeCount,2);MLcoordsP(internalEdgeCount+1,1) MLcoordsP(internalEdgeCount+1,2)];
                xDistance=(edgeCoords(2,1)-edgeCoords(1,1))/numElectrodesPerEdge;
                yDistance=(edgeCoords(2,2)-edgeCoords(1,2))/numElectrodesPerEdge;
                internalEdgeCoords=[internalEdgeCoords;edgeCoords(1,:)];
                for electrodeCount=1:numElectrodesPerEdge
                    internalEdgeCoords=[internalEdgeCoords;edgeCoords(1,1)+xDistance*electrodeCount edgeCoords(1,2)+yDistance*electrodeCount];
                end
            end
            internalEdgeCoords=[internalEdgeCoords;flipud(APcoordsL)];%append existing coordinates for last row
            scatter(internalEdgeCoords(:,1),internalEdgeCoords(:,2),'kx');
            
            %identify pixels that end up within a given square on the grid, using a 'shot-gun' approach
            %find boundary box of whole array:
            xCoordsGrid=reshape(internalEdgeCoords(:,1),9,9)';
            yCoordsGrid=reshape(internalEdgeCoords(:,2),9,9)';
            allXCoordsGrid(:,:,arrayInd)=xCoordsGrid;
            allYCoordsGrid(:,:,arrayInd)=yCoordsGrid;
            xBounds=[min(internalEdgeCoords(:,1)) max(internalEdgeCoords(:,1))];
            yBounds=[min(internalEdgeCoords(:,2)) max(internalEdgeCoords(:,2))];
            %for each pixel within the boundary box, check whether it falls within
            %any of the grid squares, and identify which one:
            pixelIDs=cell(numElectrodesPerEdge,numElectrodesPerEdge);
            for xInd=xBounds(1):xBounds(2)%each column in boundary box 917 694
                for yInd=yBounds(1):yBounds(2)%each row in boundary box
                    for colCount=1:numElectrodesPerEdge%each column of electrodes
                        for rowCount=1:numElectrodesPerEdge%each row of electrodes
                            xCoordsSquare=[xCoordsGrid(rowCount,colCount:colCount+1) xCoordsGrid(rowCount+1,colCount+1) xCoordsGrid(rowCount+1,colCount)];%x-coords of particular square in grid
                            yCoordsSquare=[yCoordsGrid(rowCount,colCount:colCount+1) yCoordsGrid(rowCount+1,colCount+1) yCoordsGrid(rowCount+1,colCount)];%y-coords of particular square in grid
                            [inGridSquare onEdge]=inpolygon(xInd,yInd,xCoordsSquare,yCoordsSquare);%first 2 input args: x and y coordinates of pixel of interest; next 2 input args: x and y coordinates of polygon defined by the grid
                            if inGridSquare==1||onEdge==1%first value in 'inGridSquare' indicates whether pixel fell within grid square; second value indicates whether pixel fell on edge of grid square
                                pixelIDs{rowCount,colCount}=[pixelIDs{rowCount,colCount};xInd yInd];
                            end
                        end
                    end
                end
            end
            for colCount=1:numElectrodesPerEdge%each column of electrodes
                for rowCount=1:numElectrodesPerEdge%each row of electrodes
                    if ~isempty(pixelIDs{rowCount,colCount})
                        for pixelCount=1:size(pixelIDs{rowCount,colCount},1)
                            copyA(round(pixelIDs{rowCount,colCount}(pixelCount,2)),round(pixelIDs{rowCount,colCount}(pixelCount,1)),:)=[100 100 0];
                        end
                    end
                    %             scatter(pixelIDs{rowCount,colCount}(:,1),pixelIDs{rowCount,colCount}(:,2),'w.');
                end
            end
            allPixelIDs{arrayInd}=pixelIDs;
        end
        save([rootDir,'\barsweep_video_in_setup\allPixelIDs.mat'],'allPixelIDs')
        figure;
        image(copyA)
        hold on
        %plot boundaries between electrodes:
        for arrayInd=1:numArrays
            for rowInd=1:numElectrodesPerEdge+1
                plot(allXCoordsGrid(rowInd,:,arrayInd),allYCoordsGrid(rowInd,:,arrayInd),'k-');
            end
            for colInd=1:numElectrodesPerEdge+1
                plot(allXCoordsGrid(:,colInd,arrayInd),allYCoordsGrid(:,colInd,arrayInd),'k-');
            end
        end
    else
        load([rootDir,'\barsweep_video_in_setup\allPixelIDs.mat'])
    end
    
    %read in neuronal data
    pixperdeg = 25.8601;
    bardur = 1000; %duration in miliseconds
    
    direct{1} = 'L to R';
    direct{2} = 'D to U';
    direct{3} = 'R to L';
    direct{4} = 'U to D';
    
    stimDurms=1000;%in ms
    preStimDur=300/1000;%length of pre-stimulus-onset period, in s
    
    if monkeyInd==1
        date='260617_B1';
        switch(date)%x & y co-ordinates of centre-point
            case '060617_B2'
                x0 = 70;
                y0 = -70;
                speed = 250/1000; %this is speed in pixels per ms
            case '060617_B4'
                x0 = 100;
                y0 = -100;
                speed = 250/1000;
            case '260617_B1'
                x0 = 70;
                y0 = -70;
                speed = 500/1000;
            case '280617_B1'
                x0 = 30;
                y0 = -30;
                speed = 100/1000;
        end
    elseif monkeyInd==2
        date='280818_B2_aston';
        switch(date)%x & y co-ordinates of centre-point
            case '280818_B2_aston'
                x0 = 70;
                y0 = -70;
                speed = 20*pixperdeg/1000; %this is speed in pixels per ms
        end
    end
    normalisedResponse=cell(1,4);
    
    drawFrames=0;
    if drawFrames==1
        fileName=fullfile('X:\best',date,['normalised_visual_response_all_conds','.mat']);
        fileName=fullfile(remoteDir,date,['normalised_visual_response_all_conds','.mat']);
        load(fileName,'normalisedResponse')
        %combine RF data across the instances:
        allChannelRFs=[];
        for instanceInd=1:8
            if monkeyInd==1
                loadDate='best_260617-280617\RFs_8_instances';%Lick
            elseif monkeyInd==2
                loadDate='best_aston_280818-290818';%Aston
            end
            fileName=[remoteDir,'\',loadDate,'\RFs_instance',num2str(instanceInd),'.mat'];
            load(fileName)
            allChannelRFs=[allChannelRFs;channelRFs];
        end
        SNRthreshold=2;
        meanChannelSNR=mean(allChannelRFs(:,8:11),2);
        goodInd=find(meanChannelSNR>=SNRthreshold);
        badInd=find(meanChannelSNR<SNRthreshold);
        for stimCond=1:4
            frameNo=1;
            for timePoint=1:1599%size(normalisedResponse{stimCond},2)
                col=normalisedResponse{stimCond}(:,timePoint);
                newcol=255*(col-min(col(:)))/(max(col(:))-min(col(:)));
                newcol=newcol-90;%zoom in on range of values above 90- to show activity modulation more clearly in figure
                lowInd=find(newcol<0);
                newcol(lowInd)=0;
                newcol=newcol*255/(255-90);
                reshapedCol=reshape(newcol,128,8);
                arrayCols=[];
                for instanceInd=1:8
                    for channelInd=1:128
                        [channelNum,arrayNum,area]=electrode_mapping(instanceInd,channelInd);
                        rowInd=mod(channelNum,8);
                        if rowInd==0
                            rowInd=8;
                        end
                        colInd=ceil(channelNum/8);
                        if colInd==0
                            colInd=8;
                        end
                        arrayCols(arrayNum,rowInd,colInd)=reshapedCol(channelInd,instanceInd);
                    end
                end
                
                %colour arrays based on activity on individual electrodes:
                for arrayInd=1:numArrays
                    pixelIDs=allPixelIDs{arrayInd};
                    for colCount=1:numElectrodesPerEdge%each column of electrodes
                        for rowCount=1:numElectrodesPerEdge%each row of electrodes
                            if ~isempty(pixelIDs{rowCount,colCount})
                                for pixelCount=1:size(pixelIDs{rowCount,colCount},1)
                                    copyA(round(pixelIDs{rowCount,colCount}(pixelCount,2)),round(pixelIDs{rowCount,colCount}(pixelCount,1)),:)=[arrayCols(arrayInd,rowCount,colCount) arrayCols(arrayInd,rowCount,colCount) 255-arrayCols(arrayInd,rowCount,colCount)];
                                end
                            end
                        end
                    end
                end
                image(copyA);
                
                %Draw bar
                barStartX=x0-(speed*1000)/2;
                barEndX=x0+(speed*1000)/2;
                barStartY=y0-(speed*1000)/2;
                barEndY=y0+(speed*1000)/2;
                
                %Transform to coordinates on small screen in diagram of setup
                %during plotting
                if timePoint>preStimDur*1000&&timePoint<=preStimDur*1000+stimDurms
                    barWidth=6;
                    barLength=30*pixperdeg;%estimate based on dimensions of visual stimulus on screen- not precise
                    if stimCond==1
                        rectangle('Position',[266+(timePoint-300)*0.256 262-(timePoint-300)*0.02 barWidth barLength/3],'FaceColor',[1 1 1],'EdgeColor','none');
                        %                 plot([x0-(speed*1000)/2+timePoint-preStimDur*1000 x0-(speed*1000)/2+timePoint-preStimDur*1000],[y0-(speed*1000)/2 y0+(speed*1000)/2],'r-')
                    elseif stimCond==2
                        center=[266+barLength/6 510-(timePoint-300)*0.245];
                        width=barLength/3;
                        height=barWidth;
                        coords = [center(1)-(width/2) center(1)-(width/2) center(1)+(width/2) center(1)+(width/2);...
                            center(2)-(height/2) center(2)+(height/2) center(2)+(height/2) center(2)-(height/2)];
                        shift_coords=coords;
                        shift_coords(2,3:4)=shift_coords(2,3:4)-16+(timePoint-300)*0.01;
                        hold on
                        plot(coords(1,[2 4]),shift_coords(2,[2 4]),'Color','w','LineWidth',barWidth/3);
                        %                     rectangle('Position',[336 490-(timePoint-300)*0.256 barLength/3 barWidth],'FaceColor',[1 1 1],'EdgeColor','none');
                        %                 plot([x0-(speed*1000)/2 x0+(speed*1000)/2],[y0-(speed*1000)/2+timePoint-preStimDur*1000 y0-(speed*1000)/2+timePoint-preStimDur*1000],'r-')
                    elseif stimCond==3
                        %                     rectangle('Position',[(barEndX-barWidth/2-(timePoint-preStimDur*1000)*speed+1200)/3 (barStartY+3500+(timePoint-300)/10)/10 barWidth barLength/3],'FaceColor',[1 1 1],'EdgeColor','none');
                        rectangle('Position',[522-(timePoint-300)*0.256 240+(timePoint-300)*0.02 barWidth barLength/3],'FaceColor',[1 1 1],'EdgeColor','none');
                        %                 plot([x0+(speed*1000)/2-timePoint+preStimDur*1000 x0+(speed*1000)/2-timePoint+preStimDur*1000],[y0-(speed*1000)/2 y0+(speed*1000)/2],'r-')
                    elseif stimCond==4
                        center=[266+barLength/6 262+(timePoint-300)*0.245];
                        width=barLength/3;
                        height=barWidth;
                        coords = [center(1)-(width/2) center(1)-(width/2) center(1)+(width/2) center(1)+(width/2);...
                            center(2)-(height/2) center(2)+(height/2) center(2)+(height/2) center(2)-(height/2)];
                        shift_coords=coords;
                        shift_coords(2,3:4)=shift_coords(2,3:4)-8-(timePoint-300)*0.004;
                        hold on
                        plot(coords(1,[2 4]),shift_coords(2,[2 4]),'Color','w','LineWidth',barWidth/3);
                        %                     rectangle('Position',[336 317+(timePoint-300)*0.256 barLength/3 barWidth],'FaceColor',[1 1 1],'EdgeColor','none');
                        %                 plot([x0-(speed*1000)/2 x0+(speed*1000)/2],[y0+(speed*1000)/2-timePoint+preStimDur*1000 y0+(speed*1000)/2-timePoint+preStimDur*1000],'r-')
                    end
                end
                %             axis equal
                %             xlim([-20 200]);
                %             ylim([-180 40]);
                %             plot([10; 35], [-135; -135], '-k', 'LineWidth', 2)
                %             text(23,-140, '1 dva', 'HorizontalAlignment','center','FontSize',14)
                %
                %             set(gca,'xtick',[])
                %             set(gca,'ytick',[])
                %             set(gca,'xticklabel',[])
                set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
                set(gca,'LooseInset',get(gca,'TightInset'))
                set(gca,'visible','off')
                framesResponse(frameNo)=getframe;
                frameNo=frameNo+1;
                close all
            end
            pathname=[rootDir,'\barsweep_video_in_setup\setup 1024-channel responses to bar sweeping ',direct{stimCond},'.mat'];
            save(pathname,'framesResponse','-v7.3')
        end
    end
    
    makeIndividualMovies=0;
    if makeIndividualMovies==1
        for stimCond=1:4
            pathname=[rootDir,'\barsweep_video_in_setup\setup 1024-channel responses to bar sweeping ',direct{stimCond},'.mat'];
            load(pathname)
            
            moviename=[rootDir,'\barsweep_video_in_setup\setup 1024-channel responses to  bar sweeping ',direct{stimCond},'2.avi'];
            v = VideoWriter(moviename);
            v.Quality=100;
            v.FrameRate=500;%has to be a factor of the number of frames, otherwise part of data will not be written. I.e. for 1500-frame movie, cannot set frame rate to be 1000
            open(v)
            for timePoint=1:length(framesResponse)-100
                if size(framesResponse(timePoint).cdata,1)~=915||size(framesResponse(timePoint).cdata,2)~=1240
                    framesResponse(timePoint).cdata=framesResponse(timePoint).cdata(1:915,1:1240,:);
%                     framesResponse(timePoint).cdata=framesResponse(timePoint-1).cdata;
                    timePoint
                end
                if size(framesResponse(timePoint).cdata,2)==1240
                    framesResponse(timePoint).cdata=framesResponse(timePoint).cdata(1:914,3:1238,:);
                end
                writeVideo(v,framesResponse(timePoint))
            end
            close(v)
            
            moviename=[rootDir,'\barsweep_video_in_setup\setup 1024-channel responses to  bar sweeping ',direct{stimCond}];
            v = VideoWriter(moviename,'MPEG-4');
            v.Quality=100;
            v.FrameRate=50;%has to be a factor of the number of frames, otherwise part of data will not be written. I.e. for 1500-frame movie, cannot set frame rate to be 1000
            sampleFactor=1600/v.FrameRate;
            open(v)
            for timePoint=1:ceil((length(framesResponse)-100)/sampleFactor)
                %             if size(framesResponse(timePoint*sampleFactor).cdata,1)~=771||size(framesResponse(timePoint*sampleFactor).cdata,2)~=995
                %                 framesResponse(timePoint*sampleFactor).cdata=framesResponse(timePoint*sampleFactor-1).cdata;
                %                 timePoint
                %             end
                if size(framesResponse(timePoint*sampleFactor).cdata,1)~=914||size(framesResponse(timePoint*sampleFactor).cdata,2)~=1236
                    framesResponse(timePoint*sampleFactor).cdata=framesResponse(timePoint*sampleFactor-1).cdata(1:914,1:1236,:);
                end
                if size(framesResponse(timePoint).cdata,2)==1240
                    framesResponse(timePoint).cdata=framesResponse(timePoint).cdata(1:914,3:1238,:);
                end
                if timePoint*sampleFactor<=size(framesResponse,2)
                    writeVideo(v,framesResponse(timePoint*sampleFactor))
                end
            end
            close(v)
        end
    end
end

% %create combined MP4 video across conditions:
% moviename=[rootDir,'\barsweep_video_in_setup\setup 1024-channel responses to sweeping bar'];
% v = VideoWriter(moviename,'MPEG-4');
% v.Quality=100;
% v.FrameRate=50;%has to be a factor of the number of frames, otherwise part of data will not be written. I.e. for 1500-frame movie, cannot set frame rate to be 1000
% sampleFactor=1600/v.FrameRate;
% open(v)
% for stimCond=1:4
%     pathname=[rootDir,'\barsweep_video_in_setup\setup 1024-channel responses to bar sweeping ',direct{stimCond},'.mat'];
%     load(pathname)
%     
%     for timePoint=1:ceil((length(framesResponse)-100)/sampleFactor)
%         if size(framesResponse(timePoint*sampleFactor).cdata,1)~=771||size(framesResponse(timePoint*sampleFactor).cdata,2)~=995
%             framesResponse(timePoint*sampleFactor).cdata=framesResponse(timePoint*sampleFactor-1).cdata;
%             timePoint
%         end
%         writeVideo(v,framesResponse(timePoint*sampleFactor))
%     end
% end
% close(v)

%create combined MP4 video across conditions and monkeys:
realtime=0;%set to 1 to run movie at real time. set to 0 to slow it down
%Lick:
moviename='D:\aston_data\barsweep_video_in_setup\setup 1024-channel responses to sweeping bar_both_monkeys';
if realtime==0
    slowedDownFactor=5;%2: 50% speed; 4: 25%; 5: 20%; 10: 10%
    moviename=[moviename,'_slowed_',num2str(slowedDownFactor),'x'];
end
v = VideoWriter(moviename,'MPEG-4');
v.Quality=100;
v.FrameRate=50;%has to be a factor of the number of frames, otherwise part of data will not be written. I.e. for 1500-frame movie, cannot set frame rate to be 1000
sampleFactor=1600/v.FrameRate;
if realtime==0
    v.FrameRate=v.FrameRate/slowedDownFactor;
end
open(v)
figure;hold on
set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
set(gca,'LooseInset',get(gca,'TightInset'))
set(gca,'visible','off')
set(gca,'Color','k');
set(gca,'xtick',[])
set(gca,'ytick',[])
text(0.4,0.5,'Monkey L','FontSize',40,'FontName','Calibri','FontWeight','bold','Color',[0.2 0.2 0.2]);
if realtime==0
    text(0.405,0.4,['Speed: 1/',num2str(slowedDownFactor),' x'],'FontSize',30,'FontName','Calibri','FontWeight','bold','Color',[0.2 0.2 0.2]);
end
framesResponse(1)=getframe;
if size(framesResponse(1).cdata,1)~=914
    framesResponse(1).cdata=framesResponse(1).cdata(2:915,:,:);
end
if size(framesResponse(1).cdata,2)~=1236
    framesResponse(1).cdata=framesResponse(1).cdata(:,3:1238,:);
end
for i=1:v.FrameRate*2%multiply by 1: set to 1 second; multiply by 2: set to 2 seconds
    writeVideo(v,framesResponse(1))
end
close all
figure;
for dissolveInd=1:11%dissolve skin
    A = imread(['D:\data\barsweep_video_in_setup\lick_realistic_skin_intact',num2str(dissolveInd),'.jpg']);
    image(A);
    set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
    set(gca,'LooseInset',get(gca,'TightInset'))
    set(gca,'visible','off')
    framesResponse(1)=getframe;
    if size(framesResponse(1).cdata,1)~=914
        framesResponse(1).cdata=framesResponse(1).cdata(2:915,:,:);
    end
    if size(framesResponse(1).cdata,2)~=1236
        framesResponse(1).cdata=framesResponse(1).cdata(:,3:1238,:);
    end
    if dissolveInd<11
        for i=1:v.FrameRate*0.5%set to 0.5 seconds
            writeVideo(v,framesResponse(1))
        end
    elseif dissolveInd==11%leave last image (of arrays) on for longer
        for i=1:v.FrameRate*1.5%set to 1.5 seconds
            writeVideo(v,framesResponse(1))
        end
    end
end

for stimCond=1:4
    pathname=['D:\data\barsweep_video_in_setup\setup 1024-channel responses to bar sweeping ',direct{stimCond},'.mat'];
    load(pathname)
    
    for timePoint=1:ceil((length(framesResponse)-100)/sampleFactor)
        if size(framesResponse(timePoint*sampleFactor).cdata,1)~=914||size(framesResponse(timePoint*sampleFactor).cdata,2)~=1236
            framesResponse(timePoint*sampleFactor).cdata=framesResponse(timePoint*sampleFactor-1).cdata;
            timePoint
        end
        if size(framesResponse(timePoint*sampleFactor).cdata,1)==915
            framesResponse(timePoint*sampleFactor).cdata=framesResponse(timePoint*sampleFactor).cdata(2:915,:,:);
        end
        if size(framesResponse(timePoint*sampleFactor).cdata,2)==1240
            framesResponse(timePoint*sampleFactor).cdata=framesResponse(timePoint*sampleFactor).cdata(:,3:1238,:);
        end
        writeVideo(v,framesResponse(timePoint*sampleFactor))
    end
end
%Aston:
figure;hold on
set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
set(gca,'LooseInset',get(gca,'TightInset'))
set(gca,'visible','off')
set(gca,'Color','k');
set(gca,'xtick',[])
set(gca,'ytick',[])
text(0.4,0.5,'Monkey A','FontSize',40,'FontName','Calibri','FontWeight','bold','Color',[0.2 0.2 0.2]);
if realtime==0
    text(0.405,0.4,['Speed: 1/',num2str(slowedDownFactor),' x'],'FontSize',30,'FontName','Calibri','FontWeight','bold','Color',[0.2 0.2 0.2]);
end
clear framesResponse
framesResponse(1)=getframe;
if size(framesResponse(1).cdata,1)~=914
    framesResponse(1).cdata=framesResponse(1).cdata(2:915,:,:);
end
if size(framesResponse(1).cdata,2)~=1236
    framesResponse(1).cdata=framesResponse(1).cdata(:,3:1238,:);
end
for i=1:v.FrameRate*2%multiply by 1: set to 1 second; multiply by 2: set to 2 seconds
    writeVideo(v,framesResponse(1))
end
close all
figure;
for dissolveInd=1:11%dissolve skin
    A = imread(['D:\aston_data\barsweep_video_in_setup\aston_realistic_skin_intact',num2str(dissolveInd),'.jpg']);
    image(A);
    set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
    set(gca,'LooseInset',get(gca,'TightInset'))
    set(gca,'visible','off')
    framesResponse(1)=getframe;
    if size(framesResponse(1).cdata,1)==915
        framesResponse(1).cdata=framesResponse(1).cdata(2:915,:,:);
    end
    if size(framesResponse(1).cdata,2)==1240
        framesResponse(1).cdata=framesResponse(1).cdata(:,3:1238,:);
    end
    if dissolveInd<11
        for i=1:v.FrameRate*0.5%set to 0.5 seconds
            writeVideo(v,framesResponse(1))
        end
    elseif dissolveInd==11%leave last image (of arrays) on for longer
        for i=1:v.FrameRate*1.5%set to 1.5 seconds
            writeVideo(v,framesResponse(1))
        end
    end
end
for stimCond=1:4
    pathname=['D:\aston_data\barsweep_video_in_setup\setup 1024-channel responses to bar sweeping ',direct{stimCond},'.mat'];
    load(pathname)
    
    for timePoint=1:ceil((length(framesResponse)-100)/sampleFactor)
        if size(framesResponse(timePoint*sampleFactor).cdata,1)~=915||size(framesResponse(timePoint*sampleFactor).cdata,2)~=1236
            framesResponse(timePoint*sampleFactor).cdata=framesResponse(timePoint*sampleFactor-1).cdata;
            timePoint
        end
        if size(framesResponse(timePoint*sampleFactor).cdata,1)==915
            framesResponse(timePoint*sampleFactor).cdata=framesResponse(timePoint*sampleFactor).cdata(2:915,:,:);
        end
        if size(framesResponse(timePoint*sampleFactor).cdata,2)==1240
            framesResponse(timePoint*sampleFactor).cdata=framesResponse(timePoint*sampleFactor).cdata(:,3:1238,:);
        end
        writeVideo(v,framesResponse(timePoint*sampleFactor))
    end
end
close(v)
pauseHere=1;
