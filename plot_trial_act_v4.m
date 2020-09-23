function plot_trial_act_v4(v4trialActExample,Rmax,UniCurrentLevels)

figure
hold on
colorspacer = 5;
NumCurrentLevels=length(UniCurrentLevels);
colors = brewermap(NumCurrentLevels+colorspacer,'Spectral');
colors = colors([1:NumCurrentLevels/2,NumCurrentLevels/2+colorspacer:NumCurrentLevels+colorspacer],:);
for thisCurrentLevel = 1:NumCurrentLevels
    xdata=v4trialActExample{thisCurrentLevel}(1,:);
    ydata=v4trialActExample{thisCurrentLevel}(2,:)';
    plot(xdata,ydata,'color',colors(thisCurrentLevel,:),'linewidth',1.5)
end
box off
plot([0 0], [-0.1 Rmax*1.05],'k--')
plot([0.1 0.1], [-0.1 Rmax*1.05],'k--')
legend({'7uA','9uA','12uA','14uA','18uA','23uA'})
xlabel('Time from stimulation onset (s)')
ylabel('Z-scored MUA (a.u.)')
xlim([-0.1 0.25])
ylim([-0.1 Rmax*1.05])
set(gcf,'color','w');