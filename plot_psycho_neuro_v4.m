function plot_psycho_neuro_v4(HitrateCurve,UniCurrentLevels,hitrate,SEMhitrate,MUAcurve,Rstim,SEMstim,HitrateThreshold,MUAthreshold)

% figure 2, panel b and f
 
% plot hit rate vs current level
colorspacer = 5;
NumCurrentLevels=length(UniCurrentLevels);
colors = brewermap(NumCurrentLevels+colorspacer,'Spectral');
colors = colors([1:NumCurrentLevels/2,NumCurrentLevels/2+colorspacer:NumCurrentLevels+colorspacer],:);
fig = figure;
subplot(2,1,1)
plot([HitrateThreshold HitrateThreshold],[0 1]*100,'k--')
hold on
plot(HitrateCurve(:,1),HitrateCurve(:,2)*100,'color',[0 0 0])
for thisCurrentLevel = 1:NumCurrentLevels
    errorbar(UniCurrentLevels(thisCurrentLevel),hitrate(thisCurrentLevel),SEMhitrate(thisCurrentLevel)*100,'.','markersize',16,'color',colors(thisCurrentLevel,:))
end
 
xlabel('Current level (uA)')
ylabel('Hit rate (%)')
box off
axis square
 
% plot MUA vs current level
subplot(2,1,2)
hold on
plot([MUAthreshold MUAthreshold],[min(Rstim-SEMstim) max(Rstim+SEMstim)],'k--')
plot(MUAcurve(:,1),MUAcurve(:,2)*(max(Rstim)-min(Rstim)) + min(Rstim),'color',[0 0 0])
for thisCurrentLevel = 1:NumCurrentLevels
    errorbar(UniCurrentLevels(thisCurrentLevel),Rstim(thisCurrentLevel),SEMstim(thisCurrentLevel),'d','color',colors(thisCurrentLevel,:))
end
xlabel('Current level (uA)')
ylabel('Average MUA')
ylim([min(Rstim-SEMstim), max(Rstim+SEMstim)])
box off
axis square
set(gcf,'color','w');

