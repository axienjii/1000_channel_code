function check_MUA_processing_steps
%Written by Xing 11/7/19.
%Plots signal during each step of MUA generation (not including
%down-sampling and line-noise removal), for visual inspection. Used in
%combination with e.g. analyse_CheckSNR2('110717_B3'), in which break point
%is inserted right after the signal has been low-pass filtered.
duration=0.1;%in s
startTime=0.4;
figure;
subplot(4,1,1)
plot(S(Fs*startTime+1:Fs*(startTime+duration)));%raw data
subplot(4,1,2)
plot(dum1(Fs*startTime+1:Fs*(startTime+duration)));%band-pass-filtered data
subplot(4,1,3)
plot(dum2(Fs*startTime+1:Fs*(startTime+duration)));%rectified, band-pass-filtered data
ylim([-40 40])
subplot(4,1,4)
plot(dum2(Fs*startTime+1:Fs*(startTime+duration)));%low-pass filtered, rectified, band-pass-filtered data
hold on
plot(muafilt(Fs*startTime+1:Fs*(startTime+duration)));