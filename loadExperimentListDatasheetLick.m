clear all
[num,txt,raw] = xlsread('./current thresholding data folders_130319.xlsx',1,'A2:A216');

NumEntries = numel(txt);
allRecordingNames = {};
for thisEntry = 1:NumEntries
    string = txt{thisEntry};

        string = textscan(string,'%s','delimiter',',');
        Cell = string{1};
        disp(Cell)
        idx = find(Cell{1}=='_',1,'first');
        SesssionNameBase = Cell{1}(1:idx);
        Cell{1} = Cell{1}((idx+1):end);
        
        % for each cell in string, we search for '-'
        NumCells = numel(Cell);
        allBlockNumbers = [];
        for thisCell = 1:NumCells
            cellcontent = Cell{thisCell};
            idx = cellcontent=='B';
            cellcontent(idx) = [];
            idx = find(cellcontent == '-');
            if isempty(idx)
                % this cell only contains one recording
                BlockNumber = textscan(cellcontent,'%d');
                BlockNumber = BlockNumber {1};
                if numel(BlockNumber) > 1
                    error(['There are more than 1 numbers in a segment, in entry ',num2str(thisEntry), ' :', SesssionNameBase])
                end
            else
                % it contains a range of recordings
                BlockNumber = textscan(cellcontent,'%d','delimiter','-');
                BlockNumber = BlockNumber {1};
                if numel(BlockNumber) > 2
                    error(['There are more than 2 numbers in a range, in entry ',num2str(thisEntry), ' :', SesssionNameBase])
                end
                BlockNumber = BlockNumber(1):BlockNumber(2);
            end
            allBlockNumbers = [allBlockNumbers,BlockNumber];
        end
        % generate a new session list for this data entry.
        NumBlocks = numel(allBlockNumbers);
        SessionNamesinEntry = cell(NumBlocks,1);
        for thisBlock = 1:NumBlocks
            SessionNamesinEntry{thisBlock} = [SesssionNameBase,'B',num2str(allBlockNumbers(thisBlock))];
        end
        allRecordingNames = [allRecordingNames;SessionNamesinEntry];
end
save('./allRecordingNamesLick130319.mat','allRecordingNames')