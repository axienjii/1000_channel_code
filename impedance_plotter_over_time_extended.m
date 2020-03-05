function impedance_plotter_over_time_extended
%Written by Xing 20/12/19 to read impedance values from mat files and draw
%box plots of impedance values over time. 
colind = hsv(16);
colindImp = hsv(1000);%colour-code impedances
impedanceAllChannelsSessions=[];
figure
hold on
dates=[{'260617'} {'110717'} {'170717'} {'200717'} {'080817'} {'100817'} {'180817'} {'200917'} {'061017'} {'091017'} {'131017'} {'201017'} {'020218'} {'280218'} {'080618'} {'070818'} {'191018'} {'181218'} {'270219'} {'170419'}];
dateCount=1;
for dateInd=3:20%dates before 17/7/17 use torque wrench
    date=dates{dateInd};
    load(['C:\Users\User\Documents\impedance_values\',date,'\impedanceAllChannels.mat']);
    removeOutliers=0;
    if removeOutliers==0
        impedanceAllChannelsSessions=[impedanceAllChannelsSessions impedanceAllChannels(:,1)];
        formatIn = 'ddmmyy';
        xval(dateCount)=datenum(date,formatIn);
        %     subplot(1,15,dateInd);
        dateCount=dateCount+1;    
    elseif removeOutliers==1
        cutoff=2000;
        removeOutliersInd=find(impedanceAllChannels(:,1)<cutoff);
        impedanceAllChannelsRemoveOutliers=impedanceAllChannels(removeOutliersInd,1);
        impedanceAllChannelsSessions(1:length(impedanceAllChannelsRemoveOutliers),dateCount)=impedanceAllChannelsRemoveOutliers;
        formatIn = 'ddmmyy';
        xval(dateCount)=datenum(date,formatIn);
        %     subplot(1,15,dateInd);
        dateCount=dateCount+1;
    end
end
% save('D:\data\signal_quality\impedance_170419.mat','impedanceAllChannelsSessions','xval');
% xval(4)=xval(4)+1;
% xval(5)=xval(5)-2;
% xval(9)=xval(9)-1;
% boxplot(impedanceAllChannelsSessions,'positions',xval,'boxstyle','filled','labels',dates(3:16));
boxplot(impedanceAllChannelsSessions,'positions',xval,'boxstyle','filled','labels',dates(3:20),'whisker',1000);
set(gca, 'FontSize', 8)
set(gca,'XTickLabelRotation',60)
xlabel('date')
ylabel('impedance (kOhms)');
surgery=datenum('200417',formatIn);
xlim([surgery-5 xval(end)+5]);
plot([surgery surgery],[0 1500],'r');
ylim([0 1500])
lines = findobj(gcf, 'type', 'line', 'Tag', 'Median');
set(lines, 'Color', 'r','LineWidth',5);

figure;hold on
surgery=datenum('200417',formatIn);
xvals=repmat(xval-surgery,[1024 1]);
scatter(xvals(:),impedanceAllChannelsSessions(:),1,[0.5 0.5 0.5]);
meanImp=nanmean(impedanceAllChannelsSessions,1);
hold on
plot(xval-surgery,meanImp,'k-');
mdl = fitlm(xval-surgery,meanImp);
xVals=0:xval(end)-surgery;
yVals=xVals*-0.154804977981788+2.834187859653726e+02;%as calculated and returned in dlm.Coefficients
plot(xVals,yVals,'b-');
xlabel('Days after implantation')
ylabel('Impedance (kOhm)');

numSessionsPerGroup=2;
earlySessions=impedanceAllChannelsSessions(:,1:numSessionsPerGroup);
lateSessions=impedanceAllChannelsSessions(:,end-numSessionsPerGroup+1:end);
% [h p ci stats]=ttest(earlySessions,lateSessions);
% sprintf(['t(',num2str(stats.df),') = ',num2str(stats.tstat),', p = %.4f'],p)
groupAssignment=[earlySessions*0+1 lateSessions*0+2];
formattedGroupAssignment=groupAssignment(:);
earlyLateSessions=[earlySessions lateSessions];
formattedSessions=earlyLateSessions(:);
% [h p ci stats]=anovan(formattedSessions,formattedGroupAssignment);
[p table stats]=anova1(formattedSessions,formattedGroupAssignment);
dfBetween=table{2,3};
dfWithin=table{3,3};
Fstat=table{2,5};
sprintf(['F(',num2str(dfBetween),',',num2str(dfWithin),') = ',num2str(Fstat),', p = %.4f'],p)%F(1,4094) = 36.6482, p = 0.0000
[c,~,~,gnames] = multcompare(stats);
figure;
boxplot([earlySessions(:) lateSessions(:)]);

%exclude outliers above 3000 kOhms:
cutoff=3000;
earlySessionsVector=earlySessions(:);
lateSessionsVector=lateSessions(:);
excludeEarly=find(earlySessionsVector>cutoff);
excludeLate=find(lateSessionsVector>cutoff);
if numSessionsPerGroup==1
    length(excludeEarly)
    length(excludeLate)
    intersectEarlyLate=intersect(excludeEarly,excludeLate);
    length(intersectEarlyLate)%3 chs
end
earlySessionsVector(excludeEarly)=[];
lateSessionsVector(excludeLate)=[];
groupAssignmentEarly=earlySessionsVector*0+1;
groupAssignmentLate=lateSessionsVector*0+2;
groupAssignment=[groupAssignmentEarly;groupAssignmentLate];
formattedGroupAssignment=groupAssignment(:);
earlyLateSessions=[earlySessionsVector;lateSessionsVector];
formattedSessions=earlyLateSessions(:);
% [h p ci stats]=anovan(formattedSessions,formattedGroupAssignment);
[p table stats]=anova1(formattedSessions,formattedGroupAssignment);
dfBetween=table{2,3};
dfWithin=table{3,3};
Fstat=table{2,5};
sprintf(['F(',num2str(dfBetween),',',num2str(dfWithin),') = ',num2str(Fstat),', p = %.4f'],p)%F(1,3919) = 146.8608, p = 0.0000
[c,~,~,gnames] = multcompare(stats);

pause
