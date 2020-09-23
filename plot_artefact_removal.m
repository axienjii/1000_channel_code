function plot_artefact_removal(figuredata)

% create figure
figure('position',[300 100 600 800]);

% plot broadband activity
subplot(4,3,1)
hold on
for i = 1:5
    plot(figuredata.V4broadbandTiming,ones(size(figuredata.V4broadbandTiming))*i-1,'black');
    plot(figuredata.V4broadbandTiming,figuredata.V4broadbandSignal(:,i)+ i-1)
end
set(gca,'Color','none','YColor','none');
xlabel('Time (s)')
xlim([-0.1 0.25])
ylim([0 5])

% plot interpolated activity
subplot(4,3,2)
hold on
for i = 1:5
    plot(figuredata.V4interpolatedTiming,ones(size(figuredata.V4interpolatedTiming))*i-1,'black');
    plot(figuredata.V4interpolatedTiming,figuredata.V4interpolatedSignal(:,i)+ i-1)
end
set(gca,'Color','none','YColor','none');
xlabel('Time (s)')
xlim([-0.1 0.25])
ylim([0 5])

% plot activity after SALPA
subplot(4,3,3)
hold on
for i = 1:5
    plot(figuredata.ARdataTime,ones(size(figuredata.ARdataTime))*i-1,'black');
    plot(figuredata.ARdataTime,figuredata.ARdata(:,i)+ i-1)
end
set(gca,'Color','none','YColor','none');
xlabel('Time (s)')
xlim([-0.1 0.25])
ylim([0 5])

% plot average artefacts and after interpolation
subplot(4,3,4)
hold on
plot(figuredata.AverageArtefactsBeforeXdata,figuredata.AverageArtefactsBefore)
plot(figuredata.AverageArtefactsAfterInterpolationXdata,figuredata.AverageArtefactsAfterInterpolation)
plot(figuredata.AverageArtefactsAfterSalpaXdata,figuredata.AverageArtefactsAfterSalpa)
xlim([0 91])
xlabel('Sample points')
ylabel('Potential')

% plot example artefact
subplot(4,3,5)
hold on
plot(figuredata.ExampleArtefactXdata,figuredata.ExampleArtefact)
plot(figuredata.ExampleArtefactSalpafitXdata,figuredata.ExampleArtefactSalpafit)
plot(figuredata.ExampleArtefactDiffXdata,figuredata.ExampleArtefactDiff)
xlim([-24 78])
xlabel('Sample points')
ylabel('Potential')

% plot power spectrum
subplot(4,3,6)
hold on
plot(figuredata.powerspectrumBeforeXdata,figuredata.powerspectrumBefore)
plot(figuredata.powerspectrumAfterXdata,figuredata.powerspectrumAfter)
xlim([200 2800])
ylim([-15 25])
xlabel('Frequency')
ylabel('Power')

% plot bandpassed data
subplot(4,3,7)
hold on
for i = 1:5
    plot(figuredata.BandpassDataTime,ones(size(figuredata.BandpassDataTime))*i-1,'black');
    plot(figuredata.BandpassDataTime,figuredata.BandpassData(:,i)+ i-1)
end
set(gca,'Color','none','YColor','none');
xlabel('Time (s)')
xlim([-0.1 0.25])
ylim([0 5])

% plot V4 MUA
subplot(4,3,8)
hold on
for i = 1:5
    plot(figuredata.StimMUAeTime,ones(size(figuredata.StimMUAeTime))*i-1,'black');
    plot(figuredata.StimMUAeTime,figuredata.StimMUAe(:,i)+ i-1,'linewidth',1.5)
end
set(gca,'Color','none','YColor','none');
xlabel('Time (s)')
xlim([-0.1 0.25])
ylim([0 5])

% plot V1 MUA
subplot(4,3,9)
hold on
for i = 1:5
    plot(figuredata.V1ARdataTime,ones(size(figuredata.V1ARdataTime))*i-1,'black');
    plot(figuredata.V1ARdataTime,figuredata.V1ARdata(:,i)+ i-1,'linewidth',1.5)
end
set(gca,'Color','none','YColor','none');
xlabel('Time (s)')
xlim([-0.1 0.25])
ylim([0 5])

% plot V4 visually evoked MUA example
subplot(4,3,10)
hold on
for i = 1:5
    plot(figuredata.V4visualTime,ones(size(figuredata.V4visualTime))*i-1,'black');
    plot(figuredata.V4visualTime,figuredata.V4visualMUA(:,i)+i-1,'linewidth',1.5)
end
set(gca,'Color','none','YColor','none');
xlabel('Time (s)')
xlim([-0.1 0.5])
ylim([0 5])

% plot V4 visually evoked MUA (artefact removed example)
subplot(4,3,11)
hold on
for i = 1:5
    plot(figuredata.V4visualTimeAR,ones(size(figuredata.V4visualTimeAR))*i-1,'black');
    plot(figuredata.V4visualTimeAR,figuredata.V4visualMUAAR(:,i)+i-1,'linewidth',1.5)
end
set(gca,'Color','none','YColor','none');
xlabel('Time (s)')
xlim([-0.1 0.5])
ylim([0 5])

% plot V4 visually evoked MUA vs artefact-removed visually evoked MUA average
subplot(4,3,12)
hold on
for i = 1:5
    plot(figuredata.meanV4visualTime,ones(size(figuredata.meanV4visualTime))*i-1,'black');
    plot(figuredata.meanV4visualTime,figuredata.meanV4visualMUA(:,i)+i-1,'linewidth',1.5)
    plot(figuredata.meanV4visualTime,figuredata.meanV4visualMUAAR(:,i)+i-1,'linewidth',1.0)
end
set(gca,'Color','none','YColor','none');
xlabel('Time (s)')
xlim([-0.1 0.5])
ylim([0 5])
set(gcf,'color','w');            