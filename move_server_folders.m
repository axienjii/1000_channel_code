function move_server_folders
%Written by Xing 7/8/19
%Moves chosen folders to a separate folder ('delete_from_server'), to make
%it easier to copy that folder to an external HD and delete the data from
%the server. List of deleted folders also marked in purple in 'deletable'
%tab of 'Lick & Aston prardigms' Google spreadsheet.

load('D:\data\deleteFolders.mat')
rootdir='X:\best\';
HDdir=':\\';
folderSize=zeros(length(deleteFolders),1);
counterExist=0;
for folderInd=1:length(deleteFolders)
    folderName=char(fullfile(rootdir,deleteFolders(folderInd)));
    if exist(folderName,'dir')
        counterExist=counterExist+1;
        listing = dir(folderName);
        for i=1:length(listing)
            fileSizes(i)=listing(i).bytes;
            fileNames{i}=listing(i).name;
        end
        folderSize(folderInd)=sum(fileSizes);
        newFolderName=char(fullfile(rootdir,'delete_from_server',deleteFolders(folderInd)));
%         movefile(folderName,newFolderName);
    end    
    %     copyfile([rootdir,'\',deleteFolders(folderInd)],[HDdir,'\delete_from_server\',deleteFolders(folderInd)]);
end
totalSizeBytes=sum(folderSize)
totalSizeMB=sum(folderSize)/1000000
totalSizeGB=sum(folderSize)/1000000000
totalSizeTB=sum(folderSize)/1000000000000
cumulativeFolderSize=folderSize;
for ind=2:length(cumulativeFolderSize)
    cumulativeFolderSize(ind)=cumulativeFolderSize(ind)+cumulativeFolderSize(ind-1);
end
cumulativeFolderSize(end)

