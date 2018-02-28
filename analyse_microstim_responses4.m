function analyse_microstim_responses4
%Written by Xing 05/12/17 to calculate hits, misses, false alarms, and
%correct rejections during new version of microstim task.
%Load in .mat file recorded on stimulus
%presentation computer, from server. Edit further to ensure unique
%electrode identities.

close all
localDisk=1;
if localDisk==1
    rootdir='D:\data\';
elseif localDisk==0
    rootdir='X:\best\';
end

% arrayNums=[8 10 10 10 10 10 10 10 10 10 10 11 11 11 12 12 12 12 12 12 12 12 12 13 13 13 13 13 13 13 13 14 14 14 15 16 16];
% electrodeNums=[40 40 35 46 57 55 58 37 62 59 20 55 24 18 61 40 50 28 10 34 29 41 20 35 48 47 53 55 38 56 32 43 12 30 49 21 39];
% date='051217_T4';
% date='051217_B2';
% date='051217_B3';
% arrayNums=arrayNums(6:end);
% electrodeNums=electrodeNums(6:end);
% date='051217_B4';
% arrayNums=arrayNums(1:5);
% electrodeNums=electrodeNums(1:5);
% date='051217_B5';
% arrayNums=[10 13];
% electrodeNums=[20 48];
% date='051217_B6';
% arrayNums=[13];
% electrodeNums=[53];
% date='051217_B11';
% arrayNums=[14];
% electrodeNums=[13];
% date='061217_B1';
% arrayNums=[9 9];
% electrodeNums=[17 19];
% date='061217_B3';
% arrayNums=[10 10 10 10 10 10 10 10 10 10 11 11 11 12 12 12 12 12 12 12 12 12 13 13 13 13 13 13 13 13 14 14 14 15 16 16];
% electrodeNums=[40 35 46 57 55 58 37 62 59 20 55 24 18 61 40 50 28 10 34 29 41 20 35 48 47 53 55 38 56 32 43 12 30 49 21 39];
% arrayNums=arrayNums(1:21);
% electrodeNums=electrodeNums(1:21);
% date='061217_B4';
% arrayNums=[10 10 10 10 10 10 10 10 10 10 11 11 11 12 12 12 12 12 12 12 12 12 13 13 13 13 13 13 13 13 14 14 14 15 16 16];
% electrodeNums=[40 35 46 57 55 58 37 62 59 20 55 24 18 61 40 50 28 10 34 29 41 20 35 48 47 53 55 38 56 32 43 12 30 49 21 39];
% arrayNums=arrayNums(22:end);
% electrodeNums=electrodeNums(22:end);
% date='061217_B5';
% arrayNums=[9];
% electrodeNums=[44];
% date='061217_B6';
% arrayNums=[10 11 12 12];
% electrodeNums=[59 18 40 34];
% date='061217_B7';
% arrayNums=49;
% electrodeNums=15;
% date='071217_B1';
% arrayNums=[8 8 9 9 9 12 12 12 12 12 12 12 12 13 13 13 14 14 14 14 15 15 15 16 16 16 16 16 16 16 16 16];
% electrodeNums=[43 19 27 44 26 35 12 2 57 41 22 30 29 47 61 53 39 58 43 29 48 55 46 38 47 40 50 64 61 15 12 7];
% arrayNums=arrayNums(1:10);
% electrodeNums=electrodeNums(1:10);
% date='071217_B2';
% arrayNums=[8 8 9 9 9 12 12 12 12 12 12 12 12 13 13 13 14 14 14 14 15 15 15 16 16 16 16 16 16 16 16 16];
% electrodeNums=[43 19 27 44 26 35 12 2 57 41 22 30 29 47 61 53 39 58 43 29 48 55 46 38 47 40 50 64 61 15 12 7];
% arrayNums=arrayNums(11:end);
% electrodeNums=electrodeNums(11:end);
% date='071217_B3';
% arrayNums=[8 8 9 9 9 12 12 12 12 12 12 12 12 13 13 13 14 14 14 14 15 15 15 16 16 16 16 16 16 16 16 16];
% electrodeNums=[43 19 27 44 26 35 12 2 57 41 22 30 29 47 61 53 39 58 43 29 48 55 46 38 47 40 50 64 61 15 12 7];
% arrayNums=arrayNums(1:10);
% electrodeNums=electrodeNums(1:10);
% date='071217_B4';
% arrayNums=[8 8 9 9 9 12 12 12 12 12 12 12 12 13 13 13 14 14 14 14 15 15 15 16 16 16 16 16 16 16 16 16];
% electrodeNums=[43 19 27 44 26 35 12 2 57 41 22 30 29 47 61 53 39 58 43 29 48 55 46 38 47 40 50 64 61 15 12 7];
% arrayNums=arrayNums(11:20);
% electrodeNums=electrodeNums(11:20);
% date='071217_B5';
% arrayNums=[8 8 9 9 9 12 12 12 12 12 12 12 12 13 13 13 14 8 14 14 15 15 15 16 16 16 16 16 16 16 16 16];
% electrodeNums=[43 19 27 44 26 35 12 2 57 41 22 30 29 47 61 53 39 58 43 29 48 55 46 38 47 40 50 64 61 15 12 7];
% arrayNums=arrayNums(18:end);
% electrodeNums=electrodeNums(18:end);
% date='071217_B6';
% arrayNums=[8 8 9 9 9 12 12 12 12 12 12 12 12 13 13 13 14 14 14 14 15 15 15 16 16 16 16 16 16 16 16 16];
% electrodeNums=[43 19 27 44 26 35 12 2 57 41 22 30 29 47 61 53 39 58 43 29 48 55 46 38 47 40 50 64 61 15 12 7];
% arrayNums=arrayNums(19:end);
% electrodeNums=electrodeNums(19:end);
% date='071217_B7';
% arrayNums=[8 8 9 9 9 12 12 12 12 12 12 12 12 13 13 13 14 14 14 14 15 15 15 16 16 16 16 16 16 16 16 16];
% electrodeNums=[43 19 27 44 26 35 12 2 57 41 22 30 29 47 61 53 39 58 13 29 48 55 46 38 47 40 50 64 61 15 12 7];
% arrayNums=arrayNums(19:end);
% electrodeNums=electrodeNums(19:end);
% date='071217_B8';
% arrayNums=[9 9 12];
% electrodeNums=[27 26 41];
% date='071217_B10';
% electrodeNums=[30 13 61 53 39 55 46 40 64 61 12];
% arrayNums=[12 14 13 13 14 15 15 16 16 16 16];
% date='071217_B12';
% electrodeNums=[30 58 55 46 40];
% arrayNums=[12 14 15 15 16];
% date='071217_B13';
% electrodeNums=58;
% arrayNums=14;
% date='071217_B14';
% electrodeNums=55;
% arrayNums=15;
% date='081217_B1';
% electrodeNums=[35 39 33];
% arrayNums=[16 12 12];
% date='081217_B3';
% electrodeNums=[35 39 33 64 9 45 30 16 23 37 22 27 43 21 61 45 44 50 15 7 41 49 51 55 22 52 28 34 35 55];
% arrayNums=[16 12 12 9 9 8 16 14 12 12 16 16 14 12 12 8 8 8 15 15 13 13 13 11 11 12 12 13 13 13];%electrodes 37 and 38 (indices 12 & 13, respectively) on array 13
% arrayNums=arrayNums(6:12);
% electrodeNums=electrodeNums(6:12);
% date='081217_B4';
% electrodeNums=[35 39 33 64 9 45 30 16 23 37 22 27 43 21 61 45 44 50 15 7 41 49 51 55 22 52 28 34 35 55];
% arrayNums=[16 12 12 9 9 8 16 14 12 12 16 16 14 12 12 8 8 8 15 15 13 13 13 11 11 12 12 13 13 13];%electrodes 37 and 38 (indices 12 & 13, respectively) on array 13
% arrayNums=arrayNums(21:end);
% electrodeNums=electrodeNums(21:end);
% date='081217_B5';
% electrodeNums=[35 39 33 64 9 45 30 16 23 37 22 27 43 21 61 45 44 50 15 7 41 49 51 55 22 52 28 34 35 55];
% arrayNums=[16 12 12 9 9 8 16 14 12 12 16 16 14 12 12 8 8 8 15 15 13 13 13 11 11 12 12 13 13 13];%electrodes 37 and 38 (indices 12 & 13, respectively) on array 13
% arrayNums=arrayNums(22:end);
% electrodeNums=electrodeNums(22:end);
% date='081217_B6';
% electrodeNums=[41 64 9];
% arrayNums=[13 9 9];
% date='081217_B7';
% electrodeNums=15;
% arrayNums=15;
% date='121217_B1';
% electrodeNums=[35 39 33 64 9 22 27 13 21 61 45 44 50 15 7 41 49 51 55 22];
% arrayNums=[16 12 12 9 9 16 16 14 12 12 8 8 8 15 15 13 13 13 11 11];
% date='121217_B2';
% electrodeNums=[50 22 55 21 39 41 49 27 44];
% arrayNums=[8 11 11 12 12 13 13 16 8];
% date='121217_B3';
% electrodeNums=33;
% arrayNums=13;
% date='131217_B3';
% electrodeNums=[45 30 16];
% arrayNums=[8 16 14];
% date='131217_B5';
% electrodeNums=[23 37 22 27 13 21 61 38 47 39 35 27 52 28];
% arrayNums=[12 12 16 16 14 12 12 16 16 14 12 9 12 12];
% date='131217_B6';
% electrodeNums=[45 30 16 23 37 22 27 13 21 61 38 47 39 35 27 52 28 34 35 55 2 57 47 61 53 40 7 43 48 55];
% arrayNums=[8 16 14 12 12 16 16 14 12 12 16 16 14 12 9 12 12 13 13 13 12 12 13 13 13 16 16 8 15 15];
% electrodeNums=electrodeNums(18:end);
% arrayNums=arrayNums(18:end);
% date='131217_B8';
% electrodeNums=[48 55 16];
% arrayNums=[15 15 14];
% date='131217_B9';
% electrodeNums=[23 27 34];
% arrayNums=[12 16 13];
% date='131217_B11';
% electrodeNums=[34];
% arrayNums=[13];
% date='141217_B1';
% electrodeNums=[45 30 28 20 23 37 22 27 13 21 61 38 47 39 35 27 52 28 34 35 55 2 57 47 61 53 40 7 43 48 55];
% arrayNums=[8 16 14 14 12 12 16 16 14 12 12 16 16 14 12 9 12 12 13 13 13 12 12 13 13 13 16 16 8 15 15];
% date='141217_B3';
% electrodeNums=[20];
% arrayNums=[14];
% date='151217_B1';
% electrodeNums=[40 50 12 44 26 40 64 22 19 62 7 64 61 58 2 50 61 21 27 46 40 21 13 20 61 39 47 16 32 49 50 36 28 35 55 63 48 26 40 35 44 19 27 32 28 45 44 50 15 7];
% arrayNums=[16 16 12 9 9 16 16 16 8 15 16 16 16 14 12 16 16 16 8 15 8 16 14 12 12 12 14 14 14 15 12 12 12 13 11 15 13 13 10 10 8 8 8 14 12 8 8 8 15 15];
% arrayNums=arrayNums(1:end-12);
% electrodeNums=electrodeNums(1:end-12);
% date='151217_B2';
% electrodeNums=[40 50 12 44 26 40 64 22 19 62 7 64 61 58 2 50 61 21 27 46 40 21 13 20 61 39 47 16 32 49 50 36 28 35 55 63 48 26 40 35 44 19 27 32 28 45 44 50 15 7];
% arrayNums=[16 16 12 9 9 16 16 16 8 15 16 16 16 14 12 16 16 16 8 15 8 16 14 12 12 12 14 14 14 15 12 12 12 13 11 15 13 13 10 10 8 8 8 14 12 8 8 8 15 15];
% arrayNums=arrayNums(end-11:end);
% electrodeNums=electrodeNums(end-11:end);
% date='151217_B3';
% arrayNums=[14 16];
% electrodeNums=[32 64];
% date='181217_B2';
% electrodeNums=[40 50 12 44 26 40 64 22 19 62 7 64 61 58 2 50 61 21 27 46 40 21 13 20 61 39 47 16 32 49 50 36 28 35 55 63 48 26 40 35 44 19 27 32 28 45 44 50 15 7];
% arrayNums=[16 16 12 9 9 16 16 16 8 15 16 16 16 14 12 16 16 16 8 15 8 16 14 12 12 12 14 14 14 15 12 12 12 13 11 15 13 13 10 10 8 8 8 14 12 8 8 8 15 15];
% date='181217_B5';
% arrayNums=[15 15];
% electrodeNums=[7 46];
% date='181217_B6';
% arrayNums=[15];
% electrodeNums=[7];
% date='191217_B3';
% electrodeNums=[10 28 47 34 55 33 5 23 29 56 59 29 24 30 31 33 41 49 51 55 46 32 15 22 3 15 12 15 29 58 37 39 33 64 9 49 31 52 46 51 32 53 47 58 59 56 51 39 43 36];
% arrayNums=[12 12 13 13 13 12 12 12 12 13 14 14 12 12 13 13 13 13 13 11 10 10 10 10 11 16 16 14 14 12 16 12 12 9 9 15 13 13 10 10 13 13 10 10 10 13 13 10 10 10];
% date='191217_B5';
% electrodeNums=[15 30 38 58 13];
% arrayNums=[10 12 13 13 13];
% date='191217_B6';
% electrodeNums=[39 51 31 41 55];
% arrayNums=[10 10 13 13 13];
% date='191217_B7';
% electrodeNums=[15];
% arrayNums=[10];
% date='191217_B9';
% electrodeNums=[27];
% arrayNums=[12];
% date='201217_B1';
% electrodeNums=[40 44 12 28 31 63 61 47 58 43 39 45 47 54 32 15 53 12 29 59 17 58 13 20 30 22 63 13 21 44 39 63 30 40 63 50 27 32 29 33 21 29 48 22 38 20 63 22 20 52];
% arrayNums=[12 14 14 14 14 16 16 14 14 12 12 14 14 14 14 16 14 14 14 12 9 14 14 14 14 16 14 14 12 12 16 16 16 15 15 8 8 14 12 13 12 12 13 13 13 16 14 12 12 12];
% date='201217_B3';
% electrodeNums=[44 28 31 54 63];
% arrayNums=[12 12 14 14 14];
% date='211217_B1';
% electrodeNums=[40 44 12 28 31];
% arrayNums=[12 14 14 14 14];
% date='211217_B2';
% electrodeNums=[40 44 12 28 31 63 61 47 58 43 39 45 47 54 32 15 53 12 29 59 17 58 13 20 30 22 63 13 21 44 39 63 30 40 63 50 27 32 29 33 21 29 48 22 38 20 63 22 20 52];
% arrayNums=[12 14 14 14 14 16 16 14 14 12 12 14 14 14 14 16 14 14 14 12 9 14 14 14 14 16 14 14 12 12 16 16 16 15 15 8 8 14 12 13 12 12 13 13 13 16 14 12 12 12];
% date='211217_B5';
% electrodeNums=[31 15];
% arrayNums=[14 16];
% date='221217_B1';
% electrodeNums=[10 28 47 34 55 33 5 23 29 56 59 29 24 30 31 33 41 49 51 55 46 32 15 22 3 15 12 15 29 58 37 39 33 64 9 49 31 52 46 51 32 53 47 58 59 56 51 39 43 36];
% arrayNums=[12 12 13 13 13 12 12 12 12 13 14 14 12 12 13 13 13 13 13 11 10 10 10 10 11 16 16 14 14 12 16 12 12 9 9 15 13 13 10 10 13 13 10 10 10 13 13 10 10 10];
% date='221217_B4';
% date='221217_B5';
% date='221217_B6';
% electrodeNums=[55 13 38 27];
% arrayNums=[13 13 13 12];
% date='030118_B2';
% electrodeNums=[40 50 12 44 26 40 64 22 19 62 7 64 61 58 2 50 61 21 27 46 40 21 13 20 61 39 47 16 32 49 50 36 28 35 55 63 48 26 40 35 44 19 27 32 28 45 44 50 15 7];
% arrayNums=[16 16 12 9 9 16 16 16 8 15 16 16 16 14 12 16 16 16 8 15 8 16 14 12 12 12 14 14 14 15 12 12 12 13 11 15 13 13 10 10 8 8 8 14 12 8 8 8 15 15];
% uniqueInd=unique([electrodeNums' arrayNums'],'rows','stable');
% electrodeNums=uniqueInd(:,1);
% arrayNums=uniqueInd(:,2);
% date='030118_B3';
% electrodeNums=64;
% arrayNums=16;
% date='040118_B1';
% electrodeNums=[45 30 28 23 37 22 27 13 21 61 38 47 39 35 27 52 28 34 35 55 2 57 47 61 53 40 7 43 48 55 40 47 56 24 21 43 62 21 20 18 38 55 56 62 34 22 52 38 29 57];
% arrayNums=[8 16 14 12 12 16 16 14 12 12 16 16 14 12 9 12 12 13 13 13 12 12 13 13 13 16 16 8 15 15 10 10 10 10 11 10 10 10 10 11 13 10 10 10 11 13 13 10 10 10];
% uniqueInd=unique([electrodeNums' arrayNums'],'rows','stable');
% electrodeNums=uniqueInd(:,1);
% arrayNums=uniqueInd(:,2);
% date='040118_B2';
% electrodeNums=[38 56 34 38 47];
% arrayNums=[10 10 11 16 16];
% date='040118_B3';
% electrodeNums=[47];
% arrayNums=[16];
% date='120118_B1';
% electrodeNums=[52 28 35 55 45 30 23 37 40 7 48 55 38 47 35 27 40 47 24 21 22 52 29 57];
% arrayNums=[12 12 13 13 8 16 12 12 16 16 15 15 16 16 12 9 10 10 10 11 13 13 10 10];
% date='120118_B3';
% electrodeNums=[45 27 23 30 38];
% arrayNums=[8 9 12 16 16];
% date='150118_B1';
% electrodeNums=[40 44 28 31 63 61 58 43 39 45 54 32 15 53 29 59 17 58 20 30 22 63 21 44 39 63 40 63 50 27 29 33 21 29 22 38 20 63 20 52];
% arrayNums=[12 14 14 14 16 16 14 12 12 14 14 14 16 14 14 12 9 14 14 14 16 14 12 12 16 16 15 15 8 8 12 13 12 12 13 13 16 14 12 12];
% date='160118_B1';
% electrodeNums=[33 5 29];
% arrayNums=[12 12 12];
% date='160118_B2';
% electrodeNums=[33 5 29 56 37 39 64 9 59 29 31 38 15 12 29 58 10 28 34 13 56 51 43 36 27 33 51 55 49 31 46 51 46 32 22 3 32 53 58 59];
% arrayNums=[12 12 12 13 16 12 9 9 14 14 13 13 16 16 14 12 12 12 13 13 13 13 10 10 12 13 13 11 15 13 10 10 10 10 10 11 13 13 10 10];
% date='160118_B3';
% electrodeNums=[56 51];
% arrayNums=[13 13];
% date='160118_B4';
% electrodeNums=[33 5 29 56 37 39 64 9 59 29 31 38 15 12 29 58 10 28 34 13 56 51 43 36 27 33 51 55 49 31 46 51 46 32 22 3 32 53 58 59];
% arrayNums=[12 12 12 13 16 12 9 9 14 14 13 13 16 16 14 12 12 12 13 13 13 13 10 10 12 13 13 11 15 13 10 10 10 10 10 11 13 13 10 10];
% electrodeNums=electrodeNums(23:end);
% arrayNums=arrayNums(23:end);
% date='180118_B5';
% electrodeNums=[40 64 22 19 62 40 50 12 44 26 50 61 21 27 46 7 64 61 58 2 39 47 16 32 49 40 21 13 20 61 50 36 28 35 55 63 48 26 40 35 45 44 50 15 7 44 19 27 32 28];
% arrayNums=[16 16 16 8 15 16 16 12 9 9 16 16 16 8 15 16 16 16 14 12 12 14 14 14 15 8 16 14 12 12 12 12 12 13 11 15 13 13 10 10 8 8 8 15 15 8 8 8 14 12];
% uniqueInd=unique([electrodeNums' arrayNums'],'rows','stable');
% electrodeNums=uniqueInd(:,1);
% arrayNums=uniqueInd(:,2);
% date='180118_B6';
% electrodeNums=[40 64 22 19 62 40 50 12 44 26 50 61 21 27 46 7 64 61 58 2 39 47 16 32 49 40 21 13 20 61 50 36 28 35 55 63 48 26 40 35 45 44 50 15 7 44 19 27 32 28];
% arrayNums=[16 16 16 8 15 16 16 12 9 9 16 16 16 8 15 16 16 16 14 12 12 14 14 14 15 8 16 14 12 12 12 12 12 13 11 15 13 13 10 10 8 8 8 15 15 8 8 8 14 12];
% uniqueInd=unique([electrodeNums' arrayNums'],'rows','stable');
% electrodeNums=uniqueInd(:,1);
% arrayNums=uniqueInd(:,2);
% electrodeNums=electrodeNums(34:end);
% arrayNums=arrayNums(34:end);
% date='180118_B7';
% electrodeNums=[32 47 21 61];
% arrayNums=[14 14 16 16];
% date='190118_B1';
% electrodeNums=[2 57 61 53 22 27 21];
% arrayNums=[12 12 13 13 16 16 12];
% uniqueInd=unique([electrodeNums' arrayNums'],'rows','stable');
% electrodeNums=uniqueInd(:,1);
% arrayNums=uniqueInd(:,2);
% date='190118_B2';
% electrodeNums=[61];
% arrayNums=[12];
% date='190118_B3';
% electrodeNums=[2 57 61 53 22 27 21 61 43 62 20 18 38 55 62 34 35 34 47 1 41 13 30 12 57 43 58 6 1 34 42 41 60 12 38 29 57 42 45 20 18];
% arrayNums=[12 12 13 13 16 16 12 1 10 10 10 11 13 10 10 11 16 12 9 9 12 12 12 13 16 16 16 12 12 12 12 13 13 13 10 10 10 10 10 10 11];
% uniqueInd=unique([electrodeNums' arrayNums'],'rows','stable');
% electrodeNums=uniqueInd(:,1);
% arrayNums=uniqueInd(:,2);
% electrodeNums=electrodeNums(9:end);
% arrayNums=arrayNums(9:end);
% date='190118_B6';
% electrodeNums=[47 20 43];
% arrayNums=[9 10 16];
% date='190118_B7';
% electrodeNums=[41 58];
% arrayNums=[13 13];
% date='190118_B4';
% electrodeNums=[27 35 43 20];
% arrayNums=[16 16 16 16];
% date='260118_B1';
% electrodeNums=[3 4 11 24 30 40 59 60];
% arrayNums=[12 12 12 12 12 12 12 12];
% date='260118_B3';
% electrodeNums=[21 22 23 37 39];
% arrayNums=[12 12 12 12 12];
% date='260118_B6';
% electrodeNums=36;
% arrayNums=12;
% date='260118_B7';
% electrodeNums=30;
% arrayNums=12;
% date='260118_B8';
% electrodeNums=37;
% arrayNums=12;
% date='260118_B9';
% electrodeNums=30;
% arrayNums=12;
% date='290118_B1';
% electrodeNums=[27 17];
% arrayNums=[8 9];
% date='290118_B2';
% electrodeNums=[43 18 24 12];
% arrayNums=10:13;
% date='290118_B5';
% electrodeNums=[30 63 57];
% arrayNums=14:16;
% date='300118_B2';
% electrodeNums=[27 17 43 18 24 12 30 63 57];
% arrayNums=8:16;
% date='310118_B2';
% electrodeNums=[27 17];
% arrayNums=8:9;
% date='310118_B3';
% electrodeNums=[43 18 24 12 30 63 57];
% arrayNums=10:16;
% date='310118_B5';
% electrodeNums=[27 17 43 18 24 12 30 63 57];
% arrayNums=8:16;
% date='310118_B6';
% electrodeNums=30;
% arrayNums=14;
% date='010218_B1';
% electrodeNums=[20 45 12 21 27 37 38 44 46];
% arrayNums=ones(1,9)*16;
% date='010218_B2';
% electrodeNums=[20 45 12 21 27 37 38 44 46];
% arrayNums=ones(1,9)*16;
% date='010218_B3';
% electrodeNums=27;
% arrayNums=16;
% date='010218_B4';
% electrodeNums=20;
% arrayNums=16;
% date='010218_B5';
% electrodeNums=37;
% arrayNums=14;
% date='010218_B6';
% electrodeNums=36;
% arrayNums=14;
% date='010218_B7';
% electrodeNums=38;
% arrayNums=16;
% date='010218_B8';
% electrodeNums=46;
% arrayNums=16;
% date='010218_B9';
% electrodeNums=[39 47];
% arrayNums=16;
% date='010218_B11';
% electrodeNums=[39];
% arrayNums=16;
% date='010218_B12';
% electrodeNums=[47];
% arrayNums=16;
% date='060218_B1';
% electrodeNums=[40 64 19 62 40 50 44 26 33 5 29 56 37 39 64 9 39 63 40 63 50 27 29 33 21 29 48 22 38 20 63 22 20 52];
% arrayNums=[16 16 8 15 16 16 9 9 12 12 12 13 16 12 9 9 16 16 15 15 8 8 12 13 12 12 13 13 13 16 14 12 12 12];
% date='060218_B2';
% electrodeNums=[27 26 22 52 38 48 56 40 20 37 50];
% arrayNums=[8 9 12 12 13 13 13 15 16 16 16];
% date='060218_B3';
% electrodeNums=[20 50];
% arrayNums=[16 16];
% date='070218_B1';
% electrodeNums=[52 28 35 55 45 30 23 37 40 47 24 21 22 52 29 57 39 45 54 32 15 53 29 59 59 29 31 38 15 12 29 58];
% arrayNums=[12 12 13 13 8 16 12 12 10 10 10 11 13 13 10 10 12 14 14 14 16 14 14 12 14 14 13 13 16 16 14 12];
% uniqueInd=unique([electrodeNums' arrayNums'],'rows','stable');
% electrodeNums=uniqueInd(:,1);
% arrayNums=uniqueInd(:,2);
% date='070218_B2';
% electrodeNums=[45 21 37 39 52 59 35 45 53 12];
% arrayNums=[8 11 12 12 12 12 13 14 14 16];
% date='080218_B1';
% electrodeNums=[10 28 34 13 56 51 43 36 46 32 22 3 32 53 58 59 39 47 32 49 40 21 20 61 50 36 35 55 63 48 40 35];
% arrayNums=[12 12 13 13 13 13 10 10 10 10 10 11 13 13 10 10 12 14 14 15 8 16 12 12 12 12 13 11 15 13 10 10];
% date='080218_B2';
% electrodeNums=[40 59 28 36 35 51 32 49 21];
% arrayNums=[10 10 12 12 13 13 14 15 16];
% date='090218_B1';
% electrodeNums=[45 44 15 7 44 19 32 28 42 45 20 18 12 38 29 57 50 36 35 55 63 48 40 35];
% arrayNums=[8 8 15 15 8 8 14 12 10 10 10 11 13 10 10 10 12 12 13 11 15 13 10 10];
% date='090218_B2';
% electrodeNums=[42 45 20 18 12 38 29 57 50 36 35 55 63 48 40 35];
% arrayNums=[10 10 10 11 13 10 10 10 12 12 13 11 15 13 10 10];
% date='090218_B3';
% electrodeNums=45;
% arrayNums=10;
% date='140218_B1';
% electrodeNums=[40 64 19 62 40 50 44 26 33 5 29 56 37 39 64 9 39 63 40 63 50 27 29 33 21 29 48 22 38 20 63 22 20 52];
% arrayNums=[16 16 8 15 16 16 9 9 12 12 12 13 16 12 9 9 16 16 15 15 8 8 12 13 12 12 13 13 13 16 14 12 12 12];
% date='140218_B2';
% electrodeNums=[9 22 64 19];
% arrayNums=[9 12 16 8];
% date='140218_B3';
% electrodeNums=50;
% arrayNums=16;
% date='160218_B1';
% electrodeNums=[62 37 46];
% arrayNums=[14 14 14];
% date='160218_B2';
% electrodeNums=[39 47];
% arrayNums=[16 16];
% date='160218_B3';
% electrodeNums=[40 64 22 19 62 40 50 12 44 26 39 47 16 32 49 40 21 13 20 61];
% arrayNums=[16 16 16 8 15 16 16 12 9 9 12 14 14 14 15 8 16 14 12 12];
% date='190218_B1';
% electrodeNums=[2 57 47 61 53 22 27 13 21 61 52 28 34 35 55 45 30 28 23 37 40 7 43 48 55 38 47 39 35 27 50 61 21 27 46 7 64 61 58 2];
% arrayNums=[12 12 13 13 13 16 16 14 12 12 12 12 13 13 13 8 16 14 12 12 16 16 8 15 15 16 16 14 12 9 16 16 16 8 15 16 16 16 14 12];
% date='190218_B2';
% electrodeNums=2;
% arrayNums=12;
% date='200218_B1';
% electrodeNums=[50 36 28 35 55 63 48 26 40 35 45 44 50 15 7 44 19 27 32 28 33 5 23 29 56 37 39 33 64 9 59 29 24 31 38 15 12 15 29 58];
% arrayNums=[12 12 12 13 11 15 13 13 10 10 8 8 8 15 15 8 8 8 14 12 12 12 12 12 13 16 12 12 9 9 14 14 12 13 13 16 16 14 14 12];
% date='200218_B2';
% electrodeNums=[55 26];
% arrayNums=[11 13];
% date='200218_B3';
% electrodeNums=[26];
% arrayNums=[13];
% date='210218_B1';
% electrodeNums=[10 28 47 34 13 56 51 39 43 36 27 33 49 51 55 49 31 52 46 51 46 32 15 22 3 32 53 47 58 59 40 44 12 28 31 63 61 47 58 43];
% arrayNums=[12 12 13 13 13 13 13 10 10 10 12 13 13 13 11 15 13 13 10 10 10 10 10 10 11 13 13 10 10 10 12 14 14 14 14 16 16 14 14 12];
% date='210218_B2';
% electrodeNums=[3 27 40 13 33 63];
% arrayNums=[11 12 12 13 13 16];
% date='220218_B1';
% electrodeNums=[39 45 47 54 32 15 53 12 29 59 17 58 13 20 30 22 63 13 21 44 39 63 30 40 63 50 27 32 29 33 21 29 48 22 38 20 63 22 20 52];
% arrayNums=[12 14 14 14 14 16 14 14 14 12 9 14 14 14 14 16 14 14 12 12 16 16 16 15 15 8 8 14 12 13 12 12 13 13 13 16 14 12 12 12];
% date='220218_B2';
% electrodeNums=[27 21 59 38 48 32 20 30 39];
% arrayNums=[8 12 12 13 13 14 16 16 16];
% date='220218_B11';
% electrodeNums=[12 13 14 20 22 28 29 30];
% arrayNums=[12 12 12 12 12 12 12 12];
% date='230218_B1';
% electrodeNums=[40 47 56 24 21 22 52 38 29 57 43 62 21 20 18 38 55 56 62 34 41 13 22 30 12 35 34 48 47 1 34 42 46 41 60 57 43 40 6 1];
% arrayNums=[10 10 10 10 11 13 13 10 10 10 10 10 10 10 11 13 10 10 10 11 12 12 12 12 13 16 12 9 9 9 12 12 12 13 13 16 16 14 12 12];
% date='230218_B2';
% electrodeNums=[41 60 57 43 40 6 1];
% arrayNums=[13 13 16 16 14 12 12];
% date='230218_B3';
% electrodeNums=[26 24 40 43 55 62 21 13 22 42 22 38];
% arrayNums=[12 10 10 10 10 10 11 12 12 12 13 13];
% date='260218_B1';
% electrodeNums=[41 13 22 30 12 35 34 48 47 1 34 42 26 41 60 57 43 40 6 1 23 58];
% arrayNums=[12 12 12 12 13 16 12 9 9 9 12 12 12 13 13 16 16 14 12 12 12 13];
% date='260218_B2';
% electrodeNums=[26 41 60 57 43 40 6 1 23 58];
% arrayNums=[12 13 13 16 16 14 12 12 12 13];
% date='260218_B3';
% electrodeNums=[48 22 34 12];
% arrayNums=[9 12 12 13];
% date='260218_B4';
% electrodeNums=[6 58 57];
% arrayNums=[12 13 16];
% date='260218_B11';
% electrodeNums=[21 22 14];
% arrayNums=[12 12 12];
% date='260218_B13';
% electrodeNums=21;
% arrayNums=12;
% date='260218_B14';
% electrodeNums=14;
% arrayNums=12;
% date='260218_B15';
% electrodeNums=[13 22];
% arrayNums=[12 12];
% date='260218_B16';
% electrodeNums=13;
% arrayNums=12;
% date='260218_B17';
% electrodeNums=22;
% arrayNums=12;
% date='260218_B18';
% electrodeNums=13;
% arrayNums=12;
% date='260218_B19';
% electrodeNums=21;
% arrayNums=12;
% date='260218_B20';
% electrodeNums=14;
% arrayNums=12;
% date='270218_B1';
% electrodeNums=[4 62 37 36 46];
% arrayNums=[14 14 14 14 14];
% date='270218_B2';
% electrodeNums=[45 46];
% arrayNums=[16 16];
% date='270218_B3';
% electrodeNums=[39 38 39 45 47];
% arrayNums=[16 16 16 16 16];
date='270218_B5';
electrodeNums=46;
arrayNums=16;
% date='270218_B6';
% electrodeNums=39;
% arrayNums=16;
% date='270218_B7';
% electrodeNums=[30 40 46 47];
% arrayNums=[16 16 16 16];
date='280218_B2';
electrodeNums=[61 62 53 59 63 57 58 10 22 60 1 52 9 11];
arrayNums=8*ones(1,length(electrodeNums));
% date='280218_B3';
% electrodeNums=[5 38 8 28 13 56 36 45 21 25];
% arrayNums=9*ones(1,length(electrodeNums));
% date='280218_B3';
% electrodeNums=[15 50 49 4];
% arrayNums=[10*ones(1,4)];
% date='010318_B';
% electrodeNums=[4 64 5 25 1 9 60 17 41 25 8 6 16 61 32 48 64 60 62 8 64 31 7 63 16 15 9 17 56 32 19 27 20 18 57 14 28 46 24 10 54 30 36 60 7 48 49 24 64 6 4 1 41 8 29 28 5 37 7 61 58 40 38 44 63 39 30 15 57 35 43 46 47 50 64 22 28 56 16 23 13 19 24 32 53 59 48 11 4 6 2 60 31 62 55 36 9 3 5 10 25 34];
% arrayNums=[10*ones(1,9) 11*ones(1,10) 12*ones(1,11) 13*ones(1,13) 14*ones(1,7) 15*ones(1,8) 16*ones(1,44)];

finalCurrentValsFile=7;

% copyfile(['Y:\Xing\',date(1:6),'_data'],[rootdir,date,'\',date,'_data']);
% copyfile(['D:\data\',date(1:6),'_data'],[rootdir,date,'\',date,'_data']);
copyfile(['X:\best\',date(1:6),'_data'],[rootdir,date,'\',date,'_data']);
load([rootdir,date,'\',date,'_data\microstim_saccade_',date,'.mat'])
microstimAllHitTrials=intersect(find(allCurrentLevel>0),find(performance==1));
microstimAllMissTrials=intersect(find(allCurrentLevel>0),find(performance==-1));
catchAllCRTrials=intersect(find(allCurrentLevel==0),find(performance==1));%correct rejections
catchAllFATrials=find(allFalseAlarms==1);%false alarms
currentAmpTrials=find(allCurrentLevel==0);
correctRejections=length(intersect(catchAllCRTrials,currentAmpTrials));
falseAlarms=length(intersect(catchAllFATrials,currentAmpTrials));
setFalseAlarmZero=1;
if setFalseAlarmZero==1
    falseAlarms=0;
end
allElectrodeNums=cell2mat(allElectrodeNum);
allArrayNums=cell2mat(allArrayNum);
for uniqueElectrode=1:length(electrodeNums)
    array=arrayNums(uniqueElectrode);
    electrode=electrodeNums(uniqueElectrode);
    temp1=find(allElectrodeNums==electrode);
    temp2=find(allArrayNums==array);
    uniqueElectrodeTrials=intersect(temp1,temp2);
    if finalCurrentValsFile==2%staircase procedure was used, finalCurrentVals3.mat
        load([rootdir,date,'\',date,'_data\finalCurrentVals3.mat'])
    elseif finalCurrentValsFile==3%staircase procedure was used, finalCurrentVals4.mat
        load([rootdir,date,'\',date,'_data\finalCurrentVals4.mat'])
    elseif finalCurrentValsFile==4%staircase procedure was used, finalCurrentVals4.mat
        load([rootdir,date,'\',date,'_data\finalCurrentVals5.mat'])
    elseif finalCurrentValsFile==5%staircase procedure was used, finalCurrentVals4.mat
        load([rootdir,date,'\',date,'_data\finalCurrentVals6.mat'])
    elseif finalCurrentValsFile==6%staircase procedure was used, finalCurrentVals4.mat
        load([rootdir,date,'\',date,'_data\finalCurrentVals7.mat'])
    elseif finalCurrentValsFile==7%staircase procedure was used, finalCurrentVals4.mat
        load([rootdir,date,'\',date,'_data\finalCurrentVals8.mat'])
    end
    currentAmplitudes=[];
    hits=[];
    misses=[];    
    currentAmpTrials=allCurrentLevel(uniqueElectrodeTrials);
    uniqueCurrentAmp=unique(currentAmpTrials);
    for currentAmpCond=1:length(uniqueCurrentAmp)
        currentAmplitude=uniqueCurrentAmp(currentAmpCond);
        currentAmpTrials=find(allCurrentLevel==currentAmplitude);
        if ~isempty(currentAmpTrials)
            temp3=intersect(microstimAllHitTrials,currentAmpTrials);
            temp4=intersect(temp3,uniqueElectrodeTrials);
            hits=[hits length(temp4)];
            temp5=intersect(microstimAllMissTrials,currentAmpTrials);
            temp6=intersect(temp5,uniqueElectrodeTrials);
            misses=[misses length(temp6)];
            currentAmplitudes=[currentAmplitudes currentAmplitude];
        end
    end
    hits./misses;
    for Weibull=0:1% set to 1 to get the Weibull fit, 0 for a sigmoid fit
        [theta threshold]=analyse_current_thresholds_Plot_Psy_Fie(currentAmplitudes,hits,misses,falseAlarms,correctRejections,Weibull);
        hold on
        yLimits=get(gca,'ylim');
        plot([threshold threshold],yLimits,'r:')
        plot([theta theta],yLimits,'k:')
        %     text(threshold-10,yLimits(2)-0.05,['threshold = ',num2str(round(threshold)),' uA'],'FontSize',12,'Color','k');
        text(threshold,yLimits(2)-0.05,['threshold = ',num2str(round(threshold)),' uA'],'FontSize',12,'Color','k');
        ylabel('proportion of trials');
        xlabel('current amplitude (uA)');
        if Weibull==1
            title(['Psychometric function for array',num2str(array),' electrode',num2str(electrode),', Weibull fit.'])
            pathname=fullfile('D:\data',date,['array',num2str(array),'_electrode',num2str(electrode),'_current_amplitudes_weibull']);
        elseif Weibull==0
            title(['Psychometric function for array',num2str(array),' electrode',num2str(electrode),', sigmoid fit.'])
            pathname=fullfile('D:\data',date,['array',num2str(array),'_electrode',num2str(electrode),'_current_amplitudes_sigmoid']);
        end
        set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
        print(pathname,'-dtiff');
        thresholds(uniqueElectrode,Weibull+1)=threshold;
        thresholds(uniqueElectrode,Weibull+2)=electrode;
        thresholds(uniqueElectrode,Weibull+3)=array;
    end
end
save(['D:\data\',date,'\',date,'_thresholds.mat'],'thresholds');