function analyse_RF_barsweep_visual_response2(realtime,slowedDownFactor)
%5/9/18
%Written by Xing to visualise responses to bar sweeps using 1000-channel data- new version.

SNRthreshold=1;

pixperdeg = 25.8601;
bardur = 1000; %duration in miliseconds

direct{1} = 'L to R';
direct{2} = 'D to U';
direct{3} = 'R to L';
direct{4} = 'U to D';

sampFreq=30000;
stimDurms=1000;%in ms
stimDur=stimDurms/1000;%in seconds
preStimDur=300/1000;%length of pre-stimulus-onset period, in s
postStimDur=300/1000;%length of post-stimulus-offset period, in s
downsampleFreq=30;

date='260617_B1';
switch(date)%x & y co-ordinates of centre-point
    case '060617_B2'
        x0 = 70;
        y0 = -70;
        speed = 250/1000; %this is speed in pixels per ms
    case '060617_B4'
        x0 = 100;
        y0 = -100;
        speed = 250/1000; 
    case '260617_B1'
        x0 = 70;
        y0 = -70;
        speed = 500/1000; 
    case '280617_B1'
        x0 = 30;
        y0 = -30;
        speed = 100/1000; 
end
bardist = speed*bardur;

manualChannels=[];
doManualChecks=0;

colInd=jet(128);
normalisedResponse=cell(1,4);
processRaw=0;
if processRaw==1
    for instanceInd=1:8
        instanceName=['instance',num2str(instanceInd)];
        Ons = zeros(1,4);
        Offs = zeros(1,4);
        for stimCond = 1:4
            %Get trials with this motion direction
            fileName=fullfile('X:\best',date,['mean_MUA_',instanceName,'cond',num2str(stimCond)','.mat']);
            load(fileName)
            meanChannelMUAconds{stimCond}=meanChannelMUA;
        end
        stimCondCol='rgbk';
        SigDif=[];
        channelSNR=[];
        for channelInd=1:128
            MUAmAllConds=[];
            for stimCond = 1:4
                MUAm=meanChannelMUAconds{stimCond}(channelInd,:);%each value corresponds to 1 ms
                %Get noise levels before smoothing
                BaseT = 1:sampFreq*preStimDur/downsampleFreq;
                Base = nanmean(MUAm(BaseT));
                BaseS = nanstd(MUAm(BaseT));
                
                %Smooth it to get a maximum...
                sm = smooth(MUAm,20);
                [mx,mi] = max(sm);
                Scale = mx-Base;
                
                %Now fit a Gaussian to the signal
                %Starting guesses are based on the location and height of the
                %maximum value
                mua2fit = MUAm-Base;
                normalisedResponse{stimCond}=[normalisedResponse{stimCond};mua2fit/(max(mua2fit))];%each cell contains channels in rows and time in columns, for entire trial
            end
        end
    end
    fileName=fullfile('X:\best',date,['normalised_visual_response_all_conds','.mat']);
    save(fileName,'normalisedResponse')
end

drawFrames=0;
if drawFrames==1
    fileName=fullfile('X:\best',date,['normalised_visual_response_all_conds','.mat']);
    load(fileName,'normalisedResponse')
    %combine RF data across the instances:
    allChannelRFs=[];
    for instanceInd=1:8
        loadDate='best_260617-280617';
        fileName=['X:\best\',loadDate,'\RFs_instance',num2str(instanceInd),'.mat'];
        load(fileName)
        allChannelRFs=[allChannelRFs;channelRFs];
    end
    for stimCond=1:4
        frameNo=1;
        for timePoint=1:1599%size(normalisedResponse{stimCond},2)
            figure;hold on
            set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
            set(gca,'Color',[0.7 0.7 0.7]);
            s=scatter(0,0,'r','o','filled');%fix spot
            s.SizeData=150;
            %draw dotted lines indicating [0,0]
            %         ellipse(50,50,0,0,[1 1 1]);
            %         ellipse(100,100,0,0,[1 1 1]);
            %         ellipse(150,150,0,0,[1 1 1]);
            %         ellipse(200,200,0,0,[1 1 1]);
            %         text(sqrt(1000),-sqrt(1000),'2','FontSize',14,'Color',[0.5 0.5 0.5]);
            %         text(sqrt(4000),-sqrt(4000),'4','FontSize',14,'Color',[0.5 0.5 0.5]);
            %         text(sqrt(10000),-sqrt(10000),'6','FontSize',14,'Color',[0.5 0.5 0.5]);
            %         text(sqrt(18000),-sqrt(18000),'8','FontSize',14,'Color',[0.5 0.5 0.5]);
            
            col=normalisedResponse{stimCond}(:,timePoint);
            scatter(allChannelRFs(:,1),allChannelRFs(:,2),[],col,'filled');
            %         scatter(allChannelRFs(:,1),allChannelRFs(:,2),[],col);
            
            %Draw bar            
            barStartX=x0-(speed*1000)/2;
            barEndX=x0+(speed*1000)/2;
            barStartY=y0-(speed*1000)/2;
            barEndY=y0+(speed*1000)/2;

            if timePoint>preStimDur*1000&&timePoint<=preStimDur*1000+stimDurms
                barWidth=6;
                barLength=20*pixperdeg;
                if stimCond==1
                    rectangle('Position',[barStartX-barWidth/2+(timePoint-preStimDur*1000)*speed barStartY barWidth barLength],'FaceColor',[0.9 0.9 0.9],'EdgeColor','none');
                    %                 plot([x0-(speed*1000)/2+timePoint-preStimDur*1000 x0-(speed*1000)/2+timePoint-preStimDur*1000],[y0-(speed*1000)/2 y0+(speed*1000)/2],'r-')
                elseif stimCond==2
                    rectangle('Position',[barStartX barStartY-barWidth/2+(timePoint-preStimDur*1000)*speed barLength barWidth],'FaceColor',[0.9 0.9 0.9],'EdgeColor','none');
                    %                 plot([x0-(speed*1000)/2 x0+(speed*1000)/2],[y0-(speed*1000)/2+timePoint-preStimDur*1000 y0-(speed*1000)/2+timePoint-preStimDur*1000],'r-')
                elseif stimCond==3
                    rectangle('Position',[barEndX-barWidth/2-(timePoint-preStimDur*1000)*speed barStartY barWidth barLength],'FaceColor',[0.9 0.9 0.9],'EdgeColor','none');
                    %                 plot([x0+(speed*1000)/2-timePoint+preStimDur*1000 x0+(speed*1000)/2-timePoint+preStimDur*1000],[y0-(speed*1000)/2 y0+(speed*1000)/2],'r-')
                elseif stimCond==4
                    rectangle('Position',[barStartX barEndY-barWidth/2-(timePoint-preStimDur*1000)*speed barLength barWidth],'FaceColor',[0.9 0.9 0.9],'EdgeColor','none');
                    %                 plot([x0-(speed*1000)/2 x0+(speed*1000)/2],[y0+(speed*1000)/2-timePoint+preStimDur*1000 y0+(speed*1000)/2-timePoint+preStimDur*1000],'r-')
                end
            end
            axis equal
            xlim([-20 200]);
            %         xlim([-100 280]);
            ylim([-180 40]);
            %         ylim([-260 120]);
            plot([10; 35], [-135; -135], '-k', 'LineWidth', 2)
            text(23,-140, '1 dva', 'HorizontalAlignment','center','FontSize',14)
            %         plot([10; 10], [-150; -125], '-k',  [10; 35], [-150; -150], '-k', 'LineWidth', 2)
            %         text(7,-138, '1 dva', 'HorizontalAlignment','right')
            %         text(23,-153, '1 dva', 'HorizontalAlignment','center')
            
            set(gca,'xtick',[])
            set(gca,'ytick',[])
            set(gca,'xticklabel',[])
%             set(gca,'visible','off')
            %         title(['visual responses to bar sweeping ',direct{stimCond}]);
            framesResponse(frameNo)=getframe;
            frameNo=frameNo+1;
            close all
        end
        pathname=fullfile('X:\best',date,['1024-channel responses to bar sweeping ',direct{stimCond},'.mat']);
        save(pathname,'framesResponse','-v7.3')
    end
end

makeIndividualMovies=0;
if makeIndividualMovies==1
    for stimCond=1:4
        pathname=fullfile('X:\best',date,['1024-channel responses to bar sweeping ',direct{stimCond},'.mat']);
        load(pathname)
        
        moviename=fullfile('X:\best',date,['1024-channel responses to  bar sweeping ',direct{stimCond},'2.avi']);
        v = VideoWriter(moviename);
        v.Quality=100;
        v.FrameRate=500;%has to be a factor of the number of frames, otherwise part of data will not be written. I.e. for 1500-frame movie, cannot set frame rate to be 1000
        open(v)
        for timePoint=1:length(framesResponse)-100
            if size(framesResponse(timePoint).cdata,1)~=771||size(framesResponse(timePoint).cdata,2)~=995
                framesResponse(timePoint).cdata=framesResponse(timePoint-1).cdata;
                timePoint
            end
            writeVideo(v,framesResponse(timePoint))
        end
        close(v)
        
        moviename=fullfile('X:\best',date,['1024-channel responses to  bar sweeping ',direct{stimCond}]);
        v = VideoWriter(moviename,'MPEG-4');
        v.Quality=100;
        v.FrameRate=50;%has to be a factor of the number of frames, otherwise part of data will not be written. I.e. for 1500-frame movie, cannot set frame rate to be 1000
        sampleFactor=1600/v.FrameRate;
        open(v)
        for timePoint=1:ceil((length(framesResponse)-100)/sampleFactor)
            if size(framesResponse(timePoint*sampleFactor).cdata,1)~=771||size(framesResponse(timePoint*sampleFactor).cdata,2)~=995
                framesResponse(timePoint*sampleFactor).cdata=framesResponse(timePoint*sampleFactor-1).cdata;
                timePoint
            end
            writeVideo(v,framesResponse(timePoint*sampleFactor))
        end
    end
end

% %create combined MP4 video across conditions:
% moviename=fullfile('X:\best',date,['1024-channel responses to sweeping bar']);
% v = VideoWriter(moviename,'MPEG-4');
% v.Quality=100;
% v.FrameRate=50;%has to be a factor of the number of frames, otherwise part of data will not be written. I.e. for 1500-frame movie, cannot set frame rate to be 1000
% sampleFactor=1600/v.FrameRate;
% open(v)
% for stimCond=1:4
%     pathname=fullfile('X:\best',date,['1024-channel responses to bar sweeping ',direct{stimCond},'.mat']);
%     load(pathname)
%     
%     for timePoint=1:ceil((length(framesResponse)-100)/sampleFactor)
%         if size(framesResponse(timePoint*sampleFactor).cdata,1)~=771||size(framesResponse(timePoint*sampleFactor).cdata,2)~=995
%             framesResponse(timePoint*sampleFactor).cdata=framesResponse(timePoint*sampleFactor-1).cdata;
%             timePoint
%         end
%         writeVideo(v,framesResponse(timePoint*sampleFactor))
%     end
% end
% close(v)

%create combined MP4 video across conditions and monkeys:
% realtime=1;%set to 1 to run movie at real time. set to 0 to slow it down
% moviename=fullfile('X:\aston','280818_B2_aston',['1024-channel responses to sweeping bar_both_monkeys']);
moviename=fullfile('D:\aston_data','barsweep_video_in_setup',['1024-channel responses to sweeping bar_both_monkeys']);
if realtime==0
%     slowedDownFactor=2;%2: 50% speed; 4: 25%; 5: 20%; 10: 10%
    moviename=[moviename,'_slowed_',num2str(slowedDownFactor),'x'];
end
v = VideoWriter(moviename,'MPEG-4');
v.Quality=100;
v.FrameRate=50;%has to be a factor of the number of frames, otherwise part of data will not be written. I.e. for 1500-frame movie, cannot set frame rate to be 1000
sampleFactor=1600/v.FrameRate;
if realtime==0
    v.FrameRate=v.FrameRate/slowedDownFactor;
end
open(v)
figure;hold on
set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
set(gca,'Color',[0.7 0.7 0.7]);
set(gca,'xtick',[])
set(gca,'ytick',[])
text(0.4,0.5,'Monkey L','FontSize',40,'FontName','Calibri','FontWeight','bold');
if realtime==0
    text(0.405,0.4,['Speed: 1/',num2str(slowedDownFactor),' x'],'FontSize',30,'FontName','Calibri','FontWeight','bold');
end
framesResponse(1)=getframe;
for i=1:v.FrameRate%set to 1 second
    writeVideo(v,framesResponse(1))
end
for stimCond=1:4
    pathname=fullfile('X:\best',date,['1024-channel responses to bar sweeping ',direct{stimCond},'.mat']);
    load(pathname)
    
    for timePoint=1:ceil((length(framesResponse)-100)/sampleFactor)
        if size(framesResponse(timePoint*sampleFactor).cdata,1)~=771||size(framesResponse(timePoint*sampleFactor).cdata,2)~=995
            framesResponse(timePoint*sampleFactor).cdata=framesResponse(timePoint*sampleFactor-1).cdata;
            timePoint
        end
        writeVideo(v,framesResponse(timePoint*sampleFactor))
    end
end
date='280818_B2_aston';
figure;hold on
set(gcf,'PaperPositionMode','auto','Position',get(0,'Screensize'))
set(gca,'Color',[0.7 0.7 0.7]);
set(gca,'xtick',[])
set(gca,'ytick',[])
text(0.4,0.5,'Monkey A','FontSize',40,'FontName','Calibri','FontWeight','bold');
if realtime==0
    text(0.405,0.4,['Speed: 1/',num2str(slowedDownFactor),' x'],'FontSize',30,'FontName','Calibri','FontWeight','bold');
end
clear framesResponse
framesResponse(1)=getframe;
for i=1:v.FrameRate%set to 1 second
    writeVideo(v,framesResponse(1))
end
for stimCond=1:4
    pathname=fullfile('X:\aston',date,['1024-channel responses to bar sweeping ',direct{stimCond},'.mat']);
    load(pathname)
    
    for timePoint=1:ceil((length(framesResponse)-100)/sampleFactor)
        if size(framesResponse(timePoint*sampleFactor).cdata,1)~=771||size(framesResponse(timePoint*sampleFactor).cdata,2)~=995
            framesResponse(timePoint*sampleFactor).cdata=framesResponse(timePoint*sampleFactor-1).cdata;
            timePoint
        end
        writeVideo(v,framesResponse(timePoint*sampleFactor))
    end
end
close(v)