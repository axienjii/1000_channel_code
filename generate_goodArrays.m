electrodeNumsAll=load('D:\data\channel_area_mapping.mat','channelNums');
electrodeNumsAll=electrodeNumsAll.channelNums;
arrayNumsAll=load('D:\data\channel_area_mapping.mat','arrayNums');
arrayNumsAll=arrayNumsAll.arrayNums;
goodArrays8to16New=goodArrays8to16;
for i=1:size(goodArrays8to16,1)
    electrode=goodArrays8to16(i,8);
    array=goodArrays8to16(i,7);
    electrodeIndTemp1=find(electrodeNumsAll(:)==electrode);
    electrodeIndTemp2=find(arrayNumsAll(:)==array);
    electrodeInd=intersect(electrodeIndTemp1,electrodeIndTemp2);
    instance=ceil(electrodeInd/128);
    chInd128=mod(electrodeInd,128);
    if chInd128==0
        chInd128=128;
    end
    load(['D:\data\best_260617-280617\RFs_instance',num2str(instance),'.mat'])
    RFx=RFs{chInd128}.centrex;
    RFy=RFs{chInd128}.centrey;
    goodArrays8to16New(i,1)=RFx;
    goodArrays8to16New(i,2)=RFy;
end