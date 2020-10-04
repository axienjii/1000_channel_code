function analyse_CheckSNR2_batch
%Written by Xing 6/7/20. Runs batch file on SNR data, using corrected SNR
%code (calculate SD of baseline using MUA, not using mean MUA).

for sessionInd=[9 12 13]%[1:8 10 11 14:38]%1:38
    switch sessionInd
        case 1
            date='040717_B2'
            whichDir=2;
            best=0;
        case 2
            date='050717_B3'
            whichDir=2;
        case 3
            date='060717_B2'
            whichDir=2;
        case 4
            date='110717_B3'
            whichDir=1;
            best=1;
        case 5
            date='180717_B1'
            whichDir=1;
            best=1;
        case 6
            date='200717_B7'
            whichDir=2;
            best=1;
        case 7
            date='210717_B4'%forgot to turn off impedance mode on CerePlex Ms connected to instance 1
            whichDir=1;
            best=1;
        case 8
            date='240717_B2'%strange noise on most instances
            whichDir=1;
            best=1;
        case 9
            date='250717_B2'
            whichDir=2;
            best=1;
        case 10
            date='260717_B3'
            whichDir=2;
            best=1;
        case 11
            date='080817_B7'
            whichDir=2;
            best=1;
        case 12
            date='090817_B8'
            whichDir=2;
            best=1;
        case 13
            date='100817_B2'
            whichDir=2;
            best=1;
        case 14
            date='180817_B10'
            whichDir=2;
            best=1;
        case 15
            date='230817_B20'
            whichDir=2;
        case 16
            date='240817_B39'
            whichDir=2;
        case 17
            date='290817_B48'
            whichDir=2;
            best=1;
        case 18
            date='200917_B2'
            whichDir=2;
            best=1;
        case 19
            date='061017_B6'
            whichDir=1;
            best=1;
        case 20
            date='091017_B2'
            whichDir=1;
            best=1;
        case 21
            date='201017_B32'
            whichDir=1;
            best=1;
        case 22
            date='240118_B2'
            whichDir=2;
            best=1;
        case 23
            date='250118_B1'
            whichDir=2;
            best=1;
        case 24
            date='260118_B10'
            whichDir=2;
            best=1;
        case 25
            date='280218_B1'
            whichDir=2;
            best=1;
        case 26
            date='080618_B1'
            whichDir=2;
            best=1;
        case 27
            date='020818_B1'
            whichDir=2;
            best=1;
        case 28
            date='070818_B1'
            whichDir=2;
            best=1;
        case 29
            date='280918_B4'
            whichDir=1;
            best=1;
        case 30
            date='191018_B1'
            whichDir=2;
            best=1;
        case 31
            date='061118_B1'
            whichDir=2;
            best=1;
        case 32
            date='071118_B1'
            whichDir=2;
            best=1;
        case 33
            date='071118_B2'%simple fixation task, not checkSNR
            whichDir=1;
            best=1;
        case 34
            date='181218_B4'
            whichDir=1;
            best=1;
        case 35
            date='270219_B1'
            whichDir=1;
            best=1;
        case 36
            date='170419_B1'
            whichDir=2;
            best=1;
            notRisingEdge=1;
        case 37
            date='170419_B1'
            whichDir=1;
            best=1;
        case 38
            date='260419_B1'%checkSNR
            whichDir=1;
            best=1;
    end
    analyse_CheckSNR2(date)
end