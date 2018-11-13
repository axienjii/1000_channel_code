figure
channelRFs=array10;
scatter(channelRFs(:,1),channelRFs(:,2))
hold on
for chInd=1:64
    text(channelRFs(chInd,1),channelRFs(chInd,2),num2str(channelRFs(chInd,8)));
end