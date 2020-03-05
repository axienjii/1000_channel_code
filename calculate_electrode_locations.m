function calculate_electrode_locations
%Written by Xing 8/1/20. Read in images of arrays on cortex, identify
%x- and y-coordinates of arrays on cortex, and assign pixels on each array
%to each electrode.  

formatIn = 'ddmmyy';
for monkeyInd=1:2
    if monkeyInd==1%Lick
        A = imread('D:\data\anatomy\IMG_6680_crop.jpg');
        rootDir='D:\data';
    elseif monkeyInd==2%Aston
        A = imread('D:\aston_data\anatomy\20180726_150426_crop.jpg');
        rootDir='D:\aston_data';
    end
    image(A);
    copyA=A;
    hold on
    selectCorners=1;
    if selectCorners==1
        [xCorners yCorners]=ginput(16*4);%4 clicks per array: 1) top left corner; 2) top right corner; 3) bottom right corner; 4) bottom left corner (array as seen from above, with wire emerging from top of array)
        scatter(xCorners,yCorners,'filled','y')
        if monkeyInd==1%Lick
            save('D:\data\anatomy\lick_cornerCoords.mat','xCorners','yCorners')
        elseif monkeyInd==2%Aston
            save('D:\aston_data\anatomy\aston_cornerCoords.mat','xCorners','yCorners')
        end
    else
        if monkeyInd==1%Lick
            load('D:\data\anatomy\lick_cornerCoords.mat')
        elseif monkeyInd==2%Aston
            load('D:\aston_data\anatomy\aston_cornerCoords.mat')
        end
    end
    
    numElectrodesPerEdge=8;%8-by-8 arrays
    numArrays=16;%total number of arrays per hemisphere
    calcPixelIDs=1;
    if calcPixelIDs==1
        allPixelIDs=cell(numArrays,1);
        for arrayInd=1:numArrays
            %identify coordinates of the four corners of a particular array
            cornerCoords=[xCorners(4*(arrayInd-1)+1:4*(arrayInd)) yCorners(4*(arrayInd-1)+1:4*(arrayInd))];%first row: x and y of top left corner; second row: top right corner; third row: bottom right corner; fourth row: bottom left corner (array as seen from above, with wire emerging from top of array)
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
        save([rootDir,'\anatomy\allPixelIDs.mat'],'allPixelIDs','allXCoordsGrid','allYCoordsGrid')
    else
        load([rootDir,'\anatomy\allPixelIDs.mat'])
    end
    
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
    
    %calculate coordinates corresponding to middle of the 'square' that
    %corresponds to each electrode:
    for arrayInd=1:size(allXCoordsGrid,3)
        for colCount=1:numElectrodesPerEdge%each column of electrodes
            for rowCount=1:numElectrodesPerEdge%each row of electrodes
                allMiddleXCoordsGrid(rowCount,colCount,arrayInd)=(allXCoordsGrid(rowCount,colCount,arrayInd)+allXCoordsGrid(rowCount+1,colCount,arrayInd)+allXCoordsGrid(rowCount,colCount+1,arrayInd)+allXCoordsGrid(rowCount+1,colCount+1,arrayInd))/4;
                allMiddleYCoordsGrid(rowCount,colCount,arrayInd)=(allYCoordsGrid(rowCount,colCount,arrayInd)+allYCoordsGrid(rowCount+1,colCount,arrayInd)+allYCoordsGrid(rowCount,colCount+1,arrayInd)+allYCoordsGrid(rowCount+1,colCount+1,arrayInd))/4;
            end
        end
    end
    save([rootdir,'\anatomy\allPixelIDs.mat'],'allPixelIDs','allXCoordsGrid','allYCoordsGrid','allMiddleXCoordsGrid','allMiddleYCoordsGrid')
end
