fig1=openfig('D:\data\Lick3BinsDraft1.fig');
subplot(1,3,1)
xlim([0 100])
set(gca,'XTick',[0 50 100])
set(gca,'YTick',[0 0.5 1])
xlabel('')
ylabel('')
axis square

subplot(1,3,2)
xlim([0 100])
ylim([0 0.6])
set(gca,'XTick',[0 50 100])
set(gca,'YTick',[0 0.3 0.6])
plot(23.9,0.6,'b.')
plot(36.3,0.6,'r.')
plot(73.8,0.6,'g.')
xlabel('')
ylabel('')
axis square

subplot(1,3,3)
xlim([0 100])
set(gca,'XTick',[0 50 100])
set(gca,'YTick',[1 2 3])
plot(23.9,2.5,'b.')
plot(36.3,2.5,'r.')
plot(73.8,2.5,'g.')
xlabel('')
ylabel('')
axis square
hFig=findall(0,'type','figure');
hLeg=findobj(hFig(1,1),'type','legend');
set(hLeg,'visible','off')
hgsave(fig1,'D:\data\lick_v4_1.fig') 

fig2=openfig('D:\aston_data\Aston2BinsDraft1.fig');
subplot(1,3,1)
xlim([0 100])
set(gca,'XTick',[0 50 100])
set(gca,'YTick',[0 0.5 1])
xlabel('')
ylabel('')
axis square

subplot(1,3,2)
xlim([0 100])
ylim([0 0.6])
set(gca,'XTick',[0 50 100])
set(gca,'YTick',[0 0.3 0.6])
plot(48.6,0.6,'b.')
plot(62.5,0.6,'r.')
xlabel('')
ylabel('')
axis square

subplot(1,3,3)
xlim([0 100])
set(gca,'XTick',[0 50 100])
set(gca,'YTick',[1 2 3])
plot(48.6,3.5,'b.')
plot(62.4,3.5,'r.')
xlabel('')
ylabel('')
axis square
hFig=findall(0,'type','figure');
hLeg=findobj(hFig(1,1),'type','legend');
set(hLeg,'visible','off')
hgsave(fig2,'D:\aston_data\aston_v4_1.fig')


%Rearrange subplots:
fig1_2=figure;
a1 = subplot(1,2,1); 
a2 = subplot(1,2,2); 
% Identify axes to be copied 
axes_to_be_copied = findobj(fig1,'type','axes'); 
% Identify the children of this axes 
chilred_to_be_copied = get(axes_to_be_copied,'children'); 
% Identify orientation of the axes 
[az,el] = view; 
% Copy the children of the axes 
copyobj(chilred_to_be_copied{1},a1); 

fig2_2=figure;
a1 = subplot(1,2,1); 
a2 = subplot(1,2,2); 
% Copy the children of the axes 
copyobj(chilred_to_be_copied{2},a1); 
% Set the limits and orientation of the subplot as the original figure 

fig3_2=figure;
a1 = subplot(1,2,1); 
a2 = subplot(1,2,2); 
% Copy the children of the axes 
copyobj(chilred_to_be_copied{3},a1); 
% Set the limits and orientation of the subplot as the original figure 

figure(fig1_2);
a1 = subplot(1,2,1); 
a2 = subplot(1,2,2); 
% Identify axes to be copied 
axes_to_be_copied = findobj(fig2,'type','axes'); 
% Identify the children of this axes 
chilred_to_be_copied = get(axes_to_be_copied,'children'); 
% Identify orientation of the axes 
[az,el] = view; 
% Copy the children of the axes 
copyobj(chilred_to_be_copied{1},a2); 

figure(fig2_2)
a1 = subplot(1,2,1); 
a2 = subplot(1,2,2); 
% Copy the children of the axes 
copyobj(chilred_to_be_copied{2},a2); 
% Set the limits and orientation of the subplot as the original figure 

figure(fig3_2)
a1 = subplot(1,2,1); 
a2 = subplot(1,2,2); 
% Copy the children of the axes 
copyobj(chilred_to_be_copied{3},a2); 
% Set the limits and orientation of the subplot as the original figure 

figure(fig1_2)
subplot(1,2,1)
xlim([0 100])
ylim([0 1.1])
set(gca,'XTick',[0 50 100])
set(gca,'YTick',[0 0.5 1])
xlabel('')
ylabel('')
axis square

figure(fig2_2)
subplot(1,2,1)
xlim([0 120])
ylim([0.8 2.5])
set(gca,'XTick',[0 50 100])
set(gca,'YTick',[1 2 3])
xlabel('')
ylabel('')
axis square

figure(fig3_2)
subplot(1,2,1)
xlim([0 120])
ylim([0 0.6])
set(gca,'XTick',[0 50 100])
set(gca,'YTick',[0. 0.3 0.6])
xlabel('')
ylabel('')
axis square

figure(fig1_2)
subplot(1,2,2)
xlim([0 100])
ylim([0 1.1])
set(gca,'XTick',[0 50 100])
set(gca,'YTick',[0 0.5 1])
xlabel('')
ylabel('')
axis square

figure(fig2_2)
subplot(1,2,2)
xlim([0 100])
ylim([0.8 3.5])
set(gca,'XTick',[0 50 100])
set(gca,'YTick',[1 2 3])
xlabel('')
ylabel('')
axis square

figure(fig3_2)
subplot(1,2,2)
xlim([0 100])
ylim([0 0.6])
set(gca,'XTick',[0 50 100])
set(gca,'YTick',[0. 0.3 0.6])
xlabel('')
ylabel('')
axis square