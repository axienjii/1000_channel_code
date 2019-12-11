function plot_instance_RFs_exhaustive
%Written by Xing 3/12/19. Reads in RF data generated using Matt's
%'exhaustive search' method, in which the goodness of fit of a Gaussian is
%calculated for many possible combinations of midpoint and SD, and the best
%is selected (instead of using a minimalisation function, as was previously
%done to generate my RF data).

instanceInd=8;
load(['T:\best\260617_B1\RFs_instance',num2str(instanceInd),'exhaustive.mat'])
oddFig=figure;hold on
evenFig=figure;hold on
for channelInd=1:128
    [channelNum,arrayNum,area]=electrode_mapping(instanceInd,channelInd)
    if mod(arrayNum,2)==1%odd-numbered array
        figure(oddFig);
    elseif mod(arrayNum,2)==0%even-numbered array
        figure(evenFig);
    end
    scatter(channelRFs(channelInd,1),channelRFs(channelInd,2))
    text(channelRFs(channelInd,1),channelRFs(channelInd,2),num2str(channelNum));
end