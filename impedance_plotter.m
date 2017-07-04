function impedance_plotter
%Written by Xing 29/06/17 to draw plots of impedance values from txt files,
%generated from Central's impedance tester function.
date='260617';
figure
hold on
for instanceInd=1:8
    instanceName=['instance',num2str(instanceInd)];
    instanceImpFileNameHT=['C:\Users\User\Documents\impedance_values\',instanceName,'_',date];%impedance values, hand-tightening
    instanceImpFileNameTW=['C:\Users\User\Documents\impedance_values\',instanceName,'_',date,'_tw'];%impedance values, torque wrench
    impHT=load(instanceImpFileNameHT);
    impTW=load(instanceImpFileNameTW);
    N = fscanf(fid, '%*s %*s %*s\nN=%d\n\n', 1);
    fileID = fopen(instanceImpFileNameHT,'r');
    tab=char(11);
[A,count] = fscanf(fileID, ['elec%d-%d' tab '%d kOhm'])
fclose(fileID);
    subplot(2,4,instanceInd);
end

load('C:\Users\User\Documents\impedance_values\260617\impedanceAllChannels.mat','impedanceAllChannels');
%column 1: impedance with hand-tightening
%column 2: impedance with torque wrench
%column 3: array number
%column 4: electrode number (out of 1024)

figure;hold on
length(find(impedanceAllChannels(:,1)>800))%number of channels with too-high impedances values during hand-tightening, 485
length(find(impedanceAllChannels(:,2)>800))%number of channels with too-high impedances values using a torque wrench, 111
for i=1:size(impedanceAllChannels,1)
    plot([1 2],[impedanceAllChannels(i,1),impedanceAllChannels(i,2)]);
end
set(gca,'XTick',[1 2])
set(gca,'XTickLabel',{'hand-tightening','torque wrench'})
xlim([0.5 2.5]);

figure;hold on
bins=0:50:7000; 
hist(impedanceAllChannels(:,1),bins); 
h = findobj(gca,'Type','patch'); 
set(h,'EdgeColor','none') 
set(h,'FaceColor','r','facealpha',0.5) 
hold on 
hist(impedanceAllChannels(:,2),bins); 
h = findobj(gca,'Type','patch'); 
set(h,'facealpha',0.5,'EdgeColor','none') 
xlim([0 7000]); 
set(gca,'box','off'); 

%zoom in on cluster of lower impedance values
figure;hold on
bins=0:10:7000;
hist(impedanceAllChannels(:,1),bins); 
h = findobj(gca,'Type','patch'); 
set(h,'EdgeColor','none') 
set(h,'FaceColor','r','facealpha',0.5) 
hold on 
hist(impedanceAllChannels(:,2),bins); 
h = findobj(gca,'Type','patch'); 
set(h,'facealpha',0.5,'EdgeColor','none') 
xlim([0 7000]); 
set(gca,'box','off'); 
xlim([0 1400]); 
ylim([0 70]); 

%identify electrodes with lowest impedance values:

