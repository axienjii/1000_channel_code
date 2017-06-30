function combine_best_RF_sessions
%Written by Xing 300617 to combine RF data between sessions with different
%sweeping bar stimuli, e.g.:
%260617_B1 arrays [2 3 5:16];%mapped with larger bar
%280617_B1 arrays [1 4];%close to fixation spot, mapped with thin small bar


%array 2:
load('D:\data\260617_B1\RFs_instance1_array2.mat')
channelRFs26=channelRFs;
meanChannelSNR26=meanChannelSNR;
RFs26=RFs;
%array 1:
load('D:\data\280617_B1\RFs_instance1_chs1-32.mat')
channelRFs28_1=channelRFs;
meanChannelSNR28_1=meanChannelSNR;
RFs28_1=RFs;
manualChannels28_1=manualChannels;
load('D:\data\280617_B1\RFs_instance1_chs97-128.mat')
channelRFs28_2=channelRFs;
meanChannelSNR28_2=meanChannelSNR;
RFs28_2=RFs;
manualChannels28_2=manualChannels;
% load('D:\data\280617_B1\RFs_instance1.mat')
% channelRFs28=channelRFs;
% meanChannelSNR28=meanChannelSNR;
% RFs28=RFs;
channelRFs=[channelRFs28_1(1:32,:);channelRFs26(33:96,:);channelRFs28_2(97:128,:)];
meanChannelSNR=[meanChannelSNR28_1(1:32,:);meanChannelSNR26(33:96,:);meanChannelSNR28_2(97:128,:)];
RFs=[RFs28_1(1:32) RFs26(33:96) RFs28_2(97:128)];
manualChannels=[manualChannels28_1;manualChannels28_2];
save('D:\data\best_260617-280617\RFs_instance1.mat','channelRFs','meanChannelSNR','RFs','manualChannels');

%array 3:
load('D:\data\260617_B1\RFs_instance2_array3.mat')
channelRFs26=channelRFs;
meanChannelSNR26=meanChannelSNR;
RFs26=RFs;
%array 4:
load('D:\data\280617_B1\RFs_instance2_chs33-96_allvariables.mat')
channelRFs28=channelRFs;
meanChannelSNR28=meanChannelSNR;
RFs28=RFs;
% load('D:\data\280617_B1\RFs_instance2.mat')
% channelRFs28=channelRFs;
% meanChannelSNR28=meanChannelSNR;
% RFs28=RFs;
channelRFs=[channelRFs26(1:32,:);channelRFs28(33:96,:);channelRFs26(97:128,:)];
meanChannelSNR=[meanChannelSNR26(1:32,:);meanChannelSNR28(33:96,:);meanChannelSNR26(97:128,:)];
RFs=[RFs26(1:32) RFs28(33:96) RFs26(97:128)];
save('D:\data\best_260617-280617\RFs_instance2.mat','channelRFs','meanChannelSNR','RFs','manualChannels');

%array 5:
load('D:\data\260617_B1\RFs_instance3.mat')
channelRFs26=channelRFs;
meanChannelSNR26=meanChannelSNR;
RFs26=RFs;
load('D:\data\260617_B1\RFs_instance3array5_chs1-32_97-128.mat')
channelRFs26_a5=channelRFs;
meanChannelSNR26_a5=meanChannelSNR;
RFs26_a5=RFs;
% load('D:\data\280617_B1\RFs_instance2.mat')
% channelRFs28=channelRFs;
% meanChannelSNR28=meanChannelSNR;
% RFs28=RFs;
channelRFs=[channelRFs26_a5(1:32,:);channelRFs26(33:96,:);channelRFs26_a5(97:128,:)];
meanChannelSNR=[meanChannelSNR26_a5(1:32,:);meanChannelSNR26(33:96,:);meanChannelSNR26_a5(97:128,:)];
RFs=[RFs26_a5(1:32) RFs26(33:96) RFs26_a5(97:128)];
save('D:\data\best_260617-280617\RFs_instance3.mat','channelRFs','meanChannelSNR','RFs','manualChannels');

