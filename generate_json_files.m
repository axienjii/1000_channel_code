function generate_json_files
%Written by Xing on 8/11/19
%Read information from Excel sheet to create JSON files for metadata cataloguing.

monkey=2;%1: Lick; 2: Aston
readData=0;
if readData==1
    %Read out data from Excel sheet:
    if monkey==1
        [num,txt,raw] = xlsread('D:\Lick & Aston paradigms_081119.xlsx',1,'D2:K1324');
        txt=txt(:,[1 2 3 5 6 7 8 4]);%shift torque wrench measurements to last column, for Lick, as this column does not exist for Aston
    elseif monkey==2
        [num,txt,raw] = xlsread('D:\Lick & Aston paradigms_081119.xlsx',2,'D2:J450');
    end
    
    emptyCells=cellfun(@isempty,txt);
    emptyDateRows=find(emptyCells(:,1)==1);%look for the rows without a date entry
    txt(emptyDateRows,:)=[];%remove empty rows
    
    NumEntries = size(txt,1);
    allRecordingNames = {};%date ID
    allOtherInfo={};%other metadata
    for thisEntry = 1:NumEntries
        skip=0;
        string = txt{thisEntry,1};%read date entry
        if monkey==1
            if strcmp(string,'best_260717-280617')||strcmp(string,'110717_B1_B2_120717_B123')||strcmp(string,'150817_B9 to 060917_B36')||strcmp(string,'210618 - 100718')
                skip=1;
            end
        end
        if monkey==2&&length(string)>21
            if strcmp(string(1:22),'aston_impedance_values')
                skip=1;
            end
        end
        if skip==0
            info=txt(thisEntry,2:end);%read entries in other columns
            idxU = find(string(:)=='_');
            numberAbsent=0;
            if ~isempty(idxU)
                afterFirstUnderscore=string(idxU(1)+1:end);
                numPresent=regexp(afterFirstUnderscore,'\d');
                if isempty(numPresent)
                    numberAbsent=1;
                end
            end
            idxB = string(:)=='B';
            if sum(idxB)==0||numberAbsent%the letter 'B' is not present, and no other numbers are present after the date segment
                allRecordingNames = [allRecordingNames;{string}];
                infoBlocks(thisBlock,:)=info;
                allOtherInfo=[allOtherInfo;infoBlocks];
            else
                string = textscan(string,'%s','delimiter',',');
                Cell = string{1};
                %                 disp(Cell)
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
                    if monkey==2
                        idx = strfind(cellcontent,'_aston');
                        cellcontent(idx:idx+5) = [];
                    end
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
                infoBlocks=cell(NumBlocks,length(info));
                for thisBlock = 1:NumBlocks
                    SessionNamesinEntry{thisBlock} = [SesssionNameBase,'B',num2str(allBlockNumbers(thisBlock))];
                    infoBlocks(thisBlock,:)=info;
                end
                allRecordingNames = [allRecordingNames;SessionNamesinEntry];
                allOtherInfo=[allOtherInfo;infoBlocks];
            end
        end
    end
    allMetaData=[allRecordingNames allOtherInfo];
    if monkey==1
        save('D:\lick_metadata_081119.mat','allMetaData')
    elseif monkey==2
        save('D:\aston_metadata_081119.mat','allMetaData')
    end
end

%Generate JSON files:
if readData==0
    if monkey==1
        load('D:\lick_metadata_081119.mat')
    elseif monkey==2
        load('D:\aston_metadata_081119.mat')
    end
end
dataSets=[{'runstim_checkSNR'};{'runstim_RF_barsweep'};{'runstim_RF_GridMap'};{'runstim_simphosphenes'};{'runstim_monkeyfood'};{'sync_pulse_resting_state'};{'runstim_microstim_saccade'};{'runstim_muckli_images'};{'runstim_microstim_motion'};{'runstim_microstim_line'};{'runstim_microstim_saccade_catch61'};{'runstim_microstim_saccade_catch_batch'};{'runstim_microstim_line_12patterns'};{'runstim_microstim_saccade_catch_batch_cable_test'};{'runstim_microstim_saccade_catch_batch_compare_v4'};{'runstim_microstim_RF_vs_saccade'};{'runstim_microstim_line_low_vs_high_current'};{'runstim_microstim_line_2point5'};{'runstim_microstim_letter'};{'runstim_eye_calibration'};{'runstim_RForitune'};{'runstim_SFtune'};{'runstim_microstim_saccade_attention'};{'Chris Klink'};{'runstim_microstim_saccade_endpoints_letter'};{'runstim_visual_saccade_attention'};{'runstim_microstim_visual_saccade_endpoints'};{'runstim_fixate'};{'runstim_simple_fixation_RFmapping'};{'runstim_saccade_catch'}];
for sessionInd=1:size(allMetaData,1)
    descriptionMatch={};
    lengthDescription=[];
    for descriptorInd=1:length(dataSets)
        match=strfind(allMetaData{sessionInd,2},dataSets{descriptorInd});
        if match==1
            descriptionMatch=[descriptionMatch;{dataSets{descriptorInd}}];
            lengthDescription=[lengthDescription;length(dataSets{descriptorInd})];
        end
    end
    if size(descriptionMatch,1)>1
        [dummy,ind]=max(lengthDescription);
        descriptionMatch=descriptionMatch(ind);
    end
    if strcmp(descriptionMatch,'Chris Klink')
        descriptionMatch='Chris_Klink_RF_mapping';
    end
    allDataSets(sessionInd,1)={descriptionMatch};
end
%Check that dates are correctly formatted:
for sessionInd=1:size(allMetaData,1)
    ind = find(allMetaData{sessionInd,1}=='_');
    if ind(1)~=7
        allMetaData{sessionInd,1}
        sessionInd
    end
end
%Check for sessions without descriptions:
indEmpty=cellfun(@isempty,allDataSets);
emptyDescriptions=find(indEmpty==1);
allMetaData{emptyDescriptions,2}%print descriptions from Excel sheet from those sessions, to doublecheck that they have no runstim entry
%For sessions without a runstim file, enter data set name manually:
badSessions=allMetaData(emptyDescriptions,1);
if monkey==1
    badSessionsManual=[{'020617_B1'};{'060617_B4'};{'270617_B2'};{'030717_B1'};{'040717_test_serialport'};{'120717_test_serialport'};{'120717_resting_state'};{'180717_test_resting_state'};{'200717_cerestim_test'};{'251017_B46'};{'251017_B47'}];
    badSessionDescriptions=[{'discard'};{'discard'};{'discard'};{'discard'};{'test'};{'test'};{'discard'};{'test'};{'test'};{'discard'};{'discard'}];
end
for badSessionInd=1:length(badSessionsManual)
    rowBools=strfind(allMetaData(:,1),badSessionsManual(badSessionInd));
    rowInd = find(not(cellfun('isempty',rowBools)))
    allMetaData(rowInd,2)=badSessionDescriptions(badSessionInd);
end
%Create JSON files:
monkeyNames=[{'Lick'} {'Aston'}];
for sessionInd=1:size(allMetaData,1)
%     if find(emptyDescriptions==sessionInd)
%     if strcmp(allDataSets{sessionInd},'Chris_Klink_RF_mapping')
    newFormatFile=['20',allMetaData{sessionInd,1}(5:6) allMetaData{sessionInd,1}(3:4) allMetaData{sessionInd,1}(1:2) allMetaData{sessionInd,1}(7:end)];
    newFormatDate=['20',allMetaData{sessionInd,1}(5:6) allMetaData{sessionInd,1}(3:4) allMetaData{sessionInd,1}(1:2)];
    textJSON=['{"project":"Nestor3","dataset":"',char(allDataSets{sessionInd}),'","subject":"',char(monkeyNames{monkey}),'","condition":"awake","investigator":"XingChen","stimulus":"NoStim","setup":"MonkeylabXing","date":"',char(newFormatDate),'","version":"1.0","logfile":"',char(monkeyNames{monkey}),'_',char(newFormatFile),'","runstim":"',char(allMetaData{sessionInd,2}),'","dropped_packet_errors":"',char(allMetaData{sessionInd,4}),'","bugs":"',char(allMetaData{sessionInd,5}),'","description":"',char(allMetaData{sessionInd,6}),'","folder_name":"',char(allMetaData{sessionInd,1}),'_aston","analysis_scripts":"',char(allMetaData{sessionInd,7}),'"}'];
    if monkey==1
        rootdir='X:\best';
        folderPath=fullfile(rootdir,allMetaData{sessionInd,1});
    elseif monkey==2
        rootdir='X:\aston';
        folderPath=fullfile(rootdir,[allMetaData{sessionInd,1},'_aston']);
    end
    filePath=fullfile(folderPath,[allMetaData{sessionInd,1},'_session.json']);
    if monkey==1
        if ~exist(folderPath,'dir')
            rootdir='X:\other';%try searching in the 'other' directory if the folder is not present in the 'best' directory
            folderPath=fullfile(rootdir,allMetaData{sessionInd,1});
            filePath=fullfile(folderPath,[allMetaData{sessionInd,1},'_session.json']);
        end
    end
    if exist(folderPath,'dir')
        if exist(filePath,'file')%do not overwrite existing JSON files
            fid=fopen(filePath, 'w');
            if fid==-1
                error('Cannot create JSON file');
            end
            fwrite(fid, textJSON, 'char');
            fclose(fid);
        end
    else
        folderPath%print name of missing folder to screen
    end
%     end
%     end
end
%{"project":"Nestor3","dataset":"RestingState","subject":"Aston","condition":"awake","investigator":"XingChen","stimulus":"NoStim","setup":"MonkeylabXing","date":"20191107","version":"1.0","logfile":"Aston_20191107_000_","comment":"animal performed well"};
%{"project":"Nestor3","dataset":"runstim_checkSNR","subject":"Lick","condition":"awake","investigator":"XingChen","stimulus":"NoStim","setup":"MonkeylabXing","date":"230517","version":"1.0","logfile":"Lick_201705237_B1","runstim":"runstim_checkSNR","dropped_packet_errors":"","bugs":"","dscription":"","analysis_scripts":""}

