function render_SNR_time
%Written by Xing 23/12/19. Read in images of arrays on cortex, identify
%x- and y-coordinates of arrays on cortex, and assign pixels on each array
%to each electrode. Combines pixel coordinates with SNR values over time. 

formatIn = 'ddmmyy';
for monkeyInd=2
    if monkeyInd==1%Lick
        A = imread('D:\data\signal_quality\lick_arrays.jpg');
        rootDir='D:\data';
        remoteDir='X:\best';
        load('X:\best\results\allSNR_260419_B1_dateVals.mat');
        surgery=datenum('200417',formatIn);
    elseif monkeyInd==2%Aston
        A = imread('D:\aston_data\signal_quality\aston_arrays_new_colour.jpg');
        rootDir='D:\aston_data';
        remoteDir='X:\aston';
        load('D:\aston_data\results\allSNR_140819.mat');
        surgery=datenum('260718',formatIn);
    end
    image(A);
    copyA=A;
    hold on
    selectCorners=0;
    if selectCorners==1
        [xCorners yCorners]=ginput(16*4);
        scatter(xCorners,yCorners,'filled','y')
        if monkeyInd==1%Lick
            save('D:\data\signal_quality\lick_cornerCoords.mat','xCorners','yCorners')
        elseif monkeyInd==2%Aston
            save('D:\aston_data\signal_quality\aston_cornerCoords.mat','xCorners','yCorners')
        end
    else
        if monkeyInd==1%Lick
            load('D:\data\signal_quality\lick_cornerCoords.mat')
        elseif monkeyInd==2%Aston
            load('D:\aston_data\signal_quality\aston_cornerCoords.mat')
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
        save([rootDir,'\signal_quality\allPixelIDs.mat'],'allPixelIDs')
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
        load([rootDir,'\signal_quality\allPixelIDs.mat'])
    end        
    
    %read in SNR data
    drawFrames=1;
    if drawFrames==1
        SNRthreshold=1;
        frameNo=1;
        for timePoint=1:size(allSNR,2)
            goodInd1=find(allSNR(:,timePoint)>=SNRthreshold);
            goodInd2=find(allSNR(:,timePoint)>=SNRthreshold*5);
            goodInd3=find(allSNR(:,timePoint)>=SNRthreshold*10);
            badInd=find(allSNR(:,timePoint)<SNRthreshold);
            col=allSNR(:,timePoint);
            col(badInd)=0;
            col(goodInd1)=1;
            col(goodInd2)=2;
            col(goodInd3)=3;
            newcol=255*col/3;
%             newcol=newcol-1;%zoom in on range of values above 1- to show activity modulation more clearly in figure
%             lowInd=find(newcol<0);
%             newcol(lowInd)=0;
%             newcol=newcol*255/(255-90);
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
            
            set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
            set(gca,'LooseInset',get(gca,'TightInset'))
            set(gca,'visible','off')
            framesResponse(frameNo)=getframe;
            frameNo=frameNo+1;
            close all
        end
        pathname=[rootDir,'\signal_quality\SNR_over_time_cortex.mat'];
        save(pathname,'framesResponse','-v7.3')
    end
    
    makeIndividualMovies=1;
    if makeIndividualMovies==1
        days=xval-surgery;
        duration=days(end)+round(days(end)/8);
        pathname=[rootDir,'\signal_quality\SNR_over_time_cortex.mat'];
        load(pathname)
        
        moviename=[rootDir,'\signal_quality\SNR_over_time_cortex.avi'];
        v = VideoWriter(moviename);
        v.Quality=100;
        v.FrameRate=100;%has to be a factor of the number of frames, otherwise part of data will not be written. I.e. for 1500-frame movie, cannot set frame rate to be 1000
        open(v)
        for timePoint=1:duration
            sessionInd=find(days>timePoint);
            if ~isempty(sessionInd)
                sessionInd=sessionInd(1);
            else
                sessionInd=length(days);
            end
            writeVideo(v,framesResponse(sessionInd))
        end
        close(v)
        
        moviename=[rootDir,'\signal_quality\SNR_over_time_cortex'];
        v = VideoWriter(moviename,'MPEG-4');
        v.Quality=100;
        v.FrameRate=100;%has to be a factor of the number of frames, otherwise part of data will not be written. I.e. for 1500-frame movie, cannot set frame rate to be 1000
        open(v)
        for timePoint=1:duration
            sessionInd=find(days>timePoint);
            if ~isempty(sessionInd)
                sessionInd=sessionInd(1);
            else
                sessionInd=length(days);
            end
            writeVideo(v,framesResponse(sessionInd))
        end
        close(v)
    end
end

%Create colour bar:
figure;
hold on
for i=1:255
    plot(1,i+3,'Color',[i/255 i/255 (255-i)/255],'Marker','s','MarkerFaceColor',[i/255 i/255 (255-i)/255],'MarkerSize',10);
end
xlim([1 1.001]);
ylim([0 255]);
set(gca,'xtick',[])
set(gca,'YTick',[0 255/2 255]);
set(gca,'YTickLabels',[0 1.5 3]);