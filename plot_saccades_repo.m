function plot_saccades_repo(monkey,channelRFsX,channelRFsY,allPolarAngleSacs,allEccentricitySacs,allPolarAngleRFs,allEccentricityRFs,saccArrayList)
%Written by Xing 19/8/20
%Plots mean saccade end points (averaged across trials for each channel),
%and compares ecentricity and polar angle between mean saccade end point
%and RF for a given channel.

%Polar angle
figure;
scatter(-rad2deg(allPolarAngleRFs),-rad2deg(allPolarAngleSacs),2,'ko');
hold on;
axis equal;
axis square;
xlabel('RF polar angle (deg)');
ylabel('Saccade polar angle (deg)');
ax=gca;
ax.XTick=[0 50 100];
ax.XTickLabel={'0','50','100'};
ax.YTick=[0 50 100];
ax.YTickLabel={'0','50','100'};
dlm = fitlm(-rad2deg(allPolarAngleRFs),-rad2deg(allPolarAngleSacs),'Intercept',false);
xVals=0:100;
yVals=xVals*dlm.Coefficients.Estimate;%as calculated and returned in dlm.Coefficients
plot(xVals,yVals,'r-');
plot([0 100],[0 100],'k:');
if monkey=='L'
    xlim([0 100]);
    ylim([0 100]);
elseif monkey=='A'
    ylim([-20 100]);
    xlim([-20 100]);
end
title(['Monkey ',monkey]);

[rhoPA,pPA]=corrcoef([-rad2deg(allPolarAngleRFs'),-rad2deg(allPolarAngleSacs')],'rows','pairwise')%r=0.72; p<0.01
[rhoEc,pEc]=corrcoef([allEccentricityRFs',allEccentricitySacs'],'rows','pairwise')%r=0.81; p<.001
Rvalue=rhoPA(2);
pval=pPA(2);
df=length(allPolarAngleRFs)-2;
sprintf(['Monkey ',monkey,', polar angle: r(',num2str(df),') = ',num2str(Rvalue),', p = %.4f'],pval)

%Eccentricity
figure;
scatter(allEccentricityRFs,allEccentricitySacs,2,'ko');hold on
axis equal;
axis square;
xlabel('RF eccentricity (dva)');
ylabel('Saccade eccentricity (dva)');
ax=gca;
ax.XTick=[0 5 10];
ax.XTickLabel={'0','5','10'};
ax.YTick=[0 5 10];
ax.YTickLabel={'0','5','10'};
dlm = fitlm(allEccentricityRFs,allEccentricitySacs,'Intercept',false);
xVals=0:10;
yVals=xVals*dlm.Coefficients.Estimate;%as calculated and returned in dlm.Coefficients
plot(xVals,yVals,'r-');
plot([0 10],[0 10],'k:');
if monkey=='L'
    xlim([0 10]);
    ylim([0 10]);
elseif monkey=='A'
    xlim([0 6]);
    ylim([0 6]);
end
title(['Monkey ',monkey]);

Rvalue=rhoEc(2);
pval=pEc(2);
df=length(allEccentricityRFs)-2;
sprintf(['Monkey ',monkey,', eccentricity: r(',num2str(df),') = ',num2str(Rvalue),', p = %.4f'],pval)
%compare RF vs saccade eccentricity with paired t-test
[h,p,ci,stats]=ttest(allEccentricityRFs,allEccentricitySacs);
sprintf(['Monkey ',monkey,', undershoot stats: t(',num2str(stats.df),') = ',num2str(stats.tstat),', p = %.4f'],p)

%plot figure of mean saccade end points, with same colour scheme as RF maps
figure;
hold on;
if monkey=='L'
    colind = hsv(16);
    colind(8,:)=[139/255 69/255 19/255];
elseif monkey=='A'
    colind = hsv(16);
    colind(8,:)=[139/255 69/255 19/255];
    colind=colind([1 2 4 5 3 6 7 8 9 10 12 13 14 15 16 11],:);%rearrange to match locations of arrays of Monkey L
    colind(16,:)=[0 0 0];
end
for i=1:length(channelRFsX)
    plot(channelRFsX(i),-channelRFsY(i),'MarkerEdgeColor',colind(saccArrayList(i),:),'Marker','o','MarkerFaceCol',colind(saccArrayList(i),:),'MarkerSize',3);
end
scatter(0,0,'r','o','filled');%fix spot
plot([0 0],[-250 200],'k:');
plot([-200 300],[0 0],'k:');
plot([-200 300],[200 -300],'k:');
pixPerDeg=26;
ellipse(2*pixPerDeg,2*pixPerDeg,0,0,[0.1 0.1 0.1]);
ellipse(4*pixPerDeg,4*pixPerDeg,0,0,[0.1 0.1 0.1]);
ellipse(6*pixPerDeg,6*pixPerDeg,0,0,[0.1 0.1 0.1]);
ellipse(8*pixPerDeg,8*pixPerDeg,0,0,[0.1 0.1 0.1]);
axis equal;
if monkey=='L'
    xlim([-10 200]);
    ylim([-120 10]);
elseif monkey=='A'
    xlim([-10 130]);
    ylim([-80 30]);
end
set(gca,'XTick',[0 2*pixPerDeg 4*pixPerDeg 6*pixPerDeg 8*pixPerDeg 10*pixPerDeg]);
set(gca,'XTickLabel',{'0','2','4','6','8','10'});
set(gca,'YTick',[-6*pixPerDeg -4*pixPerDeg -2*pixPerDeg 0]);
set(gca,'YTickLabel',{'-6','-4','-2','0'});
axis on;
title(['Monkey ',monkey]);
