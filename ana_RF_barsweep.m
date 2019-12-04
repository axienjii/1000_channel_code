function ana_RF_barsweep

%Analyses data from bar sweeps using runstim_RF_barsweep
%Will also work on older files with a bit of tweaking.
%Will concatenate acrsoss tanks/blocks, only concatenate blocks which have
%the same exact stimulus parameters!

%Danique and Matt, march 2015
%Updated Matt 2019

analysedata = 1; %If data already analysed you can skip straight to the graphs
saveout = 1; %Save out the data  at the end?
savename = 'Z:\monkeys\Mappings\Puck\BarMap_Puck_20190904'; %NAme of data file
Tankdir = '\\vcnin\PRP\Puck\'; %Location of the tank
figuredir = 'Z:\monkeys\Mappings\Puck\Figures\'; %Location for the figures
logdir = '\\vcnin\PRP\Puck\Logs\'; %Stimulus logfile location
blockprefix = 'Block-';
chans = 1:192; %Channels to analyse
%Tanks on the server can't be extracted (sometimes). If turned on this will
%copy the tank to a local folder and extract from there
copytolocal = 1;
deletelocal = 1; %If set to 1, this will tidy up at teh end by deleting teh local copy of the tank/block

%Place here the tanks and blocks you want to concatenate over
Tank(1).name = 'Puck_20190903';
Tank(1).block = [5,6];
Tank(2).name = 'Puck_20190904';
Tank(2).block = [1,2,3,4];
Tank(3).name = 'Puck_20190905';
Tank(3).block = [4,5,6];

%Was the TDT project mapped? 1=yes, 0 = no
%If not it will use the standard channel mappings.
mapproject = 1;
%Were the ENV stores split e.g. ENV1 and ENV2 or was there only one store (e.g. ENV1 - use splitstores = 0)?
splitstores = 0;
notch = 1; %Notch out the monitor frequecny?

% To plot dots on top of data:
%USeful fo rtesting potential positions for stimuli
%Set to empty e.g. RFx = []; if you don;t want this
RFx = []; %Duvel
RFy = []; % Duvel

% make figures or not:
%Makes a figure for each RF - lots of figures
fig = 1;

%%%%%%%%%%%%%%%%%%%%%%%%
%Standard array to channel mapping
array = zeros(1,192);
array(1:24) = 1;
array(25:48) = 2;
array(49:72) = 3;
array(73:96) = 4;
array(97:120) = 5;
array(121:144) = 6;
array(145:168) = 7;
array(169:192) = 8;
%Array colors
%Red,green,blue,black,yellow,cyan,magenta,orange
arraycol = [1 0 0;0 1 0;0 0 1;0 0 0;1 1 0;0 1 1;1 0 1;1 0.5 0];

Fs = 762.9395;
SNR=[];

if analysedata
    
    if notch
        mon = 60; %Frequency of minitor
        no = 2;
        wn = [mon-2 mon+2]./(Fs./2);
        [b1,a1] = butter(no,wn,'stop');
        wn = [mon*2-2 mon*2+2]./(Fs./2);
        [b2,a2] = butter(no,wn,'stop');
        wn = [mon*3-2 mon*3+2]./(Fs./2);
        [b3,a3] = butter(no,wn,'stop');
    end
    
    Word = [];
    EnvCat = [];
    for T = 1:length(Tank)
        Tankname = Tank(T).name;
        for B = 1:length(Tank(T).block)
            Blockno = Tank(T).block(B);
            if copytolocal
                localdir = 'D:\buffer\';
                %Copy files from server to local buffer to avoid TDT problems
                localname =  [Tankname,'\',blockprefix,num2str(Blockno)];
                if ~exist([localdir,localname])
                    mkdir(localdir,localname)
                    disp('Copying files...')
                    success = copyfile([Tankdir,Tankname,'\',blockprefix,num2str(Blockno),'\*'],[localdir,localname,'\']);
                    if success
                        disp('Files copied successfully!')
                    else
                        disp('Copy failed!')
                        return
                    end
                end
            end
            
            %Details of mapping: read in from logfile
            logfile = ['RF_barsweep_',Tankname,'_B',num2str(Blockno)];
            load([logdir,logfile])
            speed = LOG.BarSpeed; %this is speed in pixels per second
            bardur = LOG.BarDur; %duration in seconds
            bardist = LOG.BarDist;
            %x/y co-ords of centre-point
            xo = LOG.RFx;
            yo = LOG.RFy;
            %Screen details (just pixperdeg required)
            pixperdeg = LOG.Par.PixPerDeg;
            
            
            if ~mapproject
                %If you use an unmapped TDT project the mapping has to be done here
                chnorder = [45 88 84 80 76 72 68 60 47 6 2 8 86 82 78 64 56 52 41 43 21 23 4 ...
                    66 74 70 71 67 39 37 17 19 7 11 62 50 69 63 35 33 13 15 91 3 54 ...
                    58 65 59 31 29 9 5 87 83 95 57 61 55 25 27 1 93 85 79 75 96 92 53 ...
                    46 48 44 89 81 77 73 94 90 49 42 40 36 32 28 24 20 16 12 51 38 ...
                    34 30 26 22 18 14 10];
                
                chnorder = [chnorder,chnorder+96];
            else
                chnorder = 1:192;
            end
            
            
            %Extract the data from the tank
            blocknames = [blockprefix,num2str(Blockno)];
            clear EVENT
            if copytolocal
                EVENT.Mytank = [localdir,Tankname];
            else
                EVENT.Mytank = [Tankdir,Tankname];
            end
            EVENT.Myblock = blocknames;
            
            %USe the target bit as this gives correctly completed trials
            %If you don;t have this file it is available at:
            %Z:\Shared\MFILES\TDT2ML
            EVENT = Exinf4_targnew(EVENT);
            
            EVENT.Triallngth =  1.4;
            EVENT.Start =      -0.3;
            EVENT.type = 'strms';
            f = find(~isnan(EVENT.Trials.stim_onset));
            Trials = EVENT.Trials.stim_onset(f);

            if splitstores
                env1chns = [1:96];
                env2chns = [1:96];
                %Get ENV1
                EVENT.Myevent = 'ENV1';
                EVENT.CHAN = env1chns;
                Env1 = Exd4(EVENT, Trials);
                
                EVENT.Myevent = 'ENV2';
                EVENT.CHAN = env2chns;
                Env2 = Exd4(EVENT, Trials);
                
                %Now stitch them together
                Env = [Env1;Env2];
            else
                %Get ENV1
                EVENT.Myevent = 'ENV1';
                EVENT.CHAN = 1:192;
                Env = Exd4(EVENT, Trials);
            end
            
            %Concatenate
            EnvCat = cat(2,EnvCat,Env);
            
            
            %Word bit gives trial identity
            Word = [Word;EVENT.Trials.word];
        end
    end
    %RF
    %details%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %Go through trialtypes and get neural data
    px = ((1:(Fs.*EVENT.Triallngth))./Fs)+EVENT.Start;
    nchans = 192;
    ModS = zeros(nchans,4);
    ModM = zeros(nchans,4);
    Ons = zeros(nchans,4);
    Offs = zeros(nchans,4);
    
    if fig
        figure,hold on
        colind = jet(96);
    end
    
    for mapchn = 1:length(chnorder)
        
        MUA = [];
        for B = 1:size(EnvCat,2)
            buf = EnvCat{chnorder(mapchn),B};
            if notch
                %Filter out the monitor frequency
                buf = filtfilt(b1,a1,buf);
                buf = filtfilt(b2,a2,buf);
                buf = filtfilt(b3,a3,buf);
            end
            MUA = [MUA,buf];
        end
        MUA = MUA';
        
        
        for n = 1:4
            %Get trials with this motion direction
            f = find(Word == n);
            
            %Average them
            MUAm(n,:) = nanmean(MUA(f,:));
            MUAs(n,:) = nanstd(MUA(f,:))./sqrt(length(f));
            
            %Get noise levels before smoothing
            BaseT = find(px >-0.3 & px < 0);
            Base = nanmean(MUAm(n,BaseT));
            BaseS = nanstd(MUAm(n,BaseT));
            
            %Smooth it to get a maximum...
            gt = find(px>0 & px<1);
            sm = smooth(MUAm(n,gt),10);
            [mx,mi] = max(sm);
            Scale = mx-Base;
            
%             %Is the max significantly different to the base?
            SigDif(mapchn,n) = mx > (Base+(1.*BaseS));
%             
%             %Now fit a Gaussian to the signal
%             %Starting guesses are based on the location and height of the
%             %maximum value
%             pxs = px(px>0);
%             mua2fit = MUAm(n,px>0)-Base;
%             starting = [px(gt(mi)) 0.2 Scale 0];
%             [y,params] = gaussfit(pxs,mua2fit,starting,0);
            
            
             %Automataic RF fitting%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
             %Fit a guassian to it...
             %Get fitting ranges
             RespT = find(px > 0);
             %time
             td = px(RespT);
             index = 1:5:length(td);
             pxm = td(index);
             sdind = [0.01:0.01:0.2];
             
             z = 0;
             for i = 1:length(pxm)
                 for j = 1:length(sdind)
                     norm = normpdf(td,pxm(i),sdind(j));
                     norm = norm./(max(norm));
                     model = (norm.*Scale)+Base;
                     diff = sum((model-MUAm(n,RespT)).^2);
                     z = z+1;
                     ind(z,:) = [diff,pxm(i),sdind(j)];
                 end
             end
             [x,y] = min(ind(:,1));
             ModM(mapchn,n) = ind(y,2);
             ModS(mapchn,n) = ind(y,3);
             Ons(mapchn,n) = ModM(mapchn,n)-(1.95.*ModS(mapchn,n));
             Offs(mapchn,n) = ModM(mapchn,n)+(1.95.*ModS(mapchn,n));
             %Bet model
               norm = normpdf(td, ModM(mapchn,n), ModS(mapchn,n));
                     norm = norm./(max(norm));
                     bestmodel = (norm.*Scale)+Base;
            
            
            if fig
                subplot(2,2,n),plot(td,MUAm(n,RespT),'b',td,bestmodel,'r')
%                 subplot(2,2,n),plot(pxs,mua2fit,'b',pxs,y,'r')
            end
            
%             %Onset and offset encompass 95% of the Gaussian
%             Ons(mapchn,n) = params(1)-(1.65.*params(2));
%             Offs(mapchn,n) = params(1)+(1.65.*params(2));
            if fig
                h = line([Ons(mapchn,n),Ons(mapchn,n)],get(gca,'YLim'));
                set(h,'Color',[1 0 1])
                h = line([Offs(mapchn,n),Offs(mapchn,n)],get(gca,'YLim'));
                set(h,'Color',[1 0 1])
            end
            
            SNR(mapchn,n)=Scale/BaseS;
        end
        %PAUse here to see each graph
         mapchn
    end
    
    
    if saveout
        save(savename,'Ons','Offs','SigDif','speed','SNR','LOG')
    end
else
    load(savename)
end



%SKIP TO HERE
SNR = mean(SNR,2);
figure
SNRcutoff = 2;
for mapchn = 1:192
    %ONly plot channels where all directon were signifcant and teh SNR is
    %high enough
    if SNR(mapchn)>SNRcutoff%sum(SigDif(mapchn,:)) == 4 && SNR(mapchn)>SNRcutoff
        %Now distance = speed*time
        %This gives distanbce travelled by bar in pixels before the onset and
        %offset
        onsdist = speed.*Ons(mapchn,:);
        offsdist = speed.*Offs(mapchn,:);
        
        %Stimuli 1-4 go
        %1 = horizontal left-to-right (180 deg),
        %2 = bottom to top
        %3 = right to left
        %4 = top to bottom
        angles = [180 270 0 90];
        
        %Get starting position of bars
        sx = LOG.RFx+(LOG.BarDist./2).*cosd(angles);
        sy =LOG.RFy+(LOG.BarDist./2).*sind(angles);
        
        %Angular distance moved
        %(direction is opposite to angle of starting
        %position)
        on_angx = onsdist.*cosd(180-angles);
        on_angy = onsdist.*sind(angles);
        off_angx = offsdist.*cosd(180-angles);
        off_angy = offsdist.*sind(angles);
        
        %So the on and off points are starting position + angular distance...
        onx = sx+on_angx;
        ony = sy-on_angy;
        offx = sx+off_angx;
        offy = sy-off_angy;
        
        %get RF vboundaries
        bottom = (ony(2)+offy(4))./2;
        right = (onx(1)+offx(3))./2;
        top =   (ony(4)+offy(2))./2;
        left =   (onx(3)+offx(1))./2;
        
        RF.centrex(mapchn) = (right+left)./2;
        RF.centrey(mapchn) = (top+bottom)./2;
        
        RF.sz(mapchn) = sqrt(abs(top-bottom).*abs(right-left));
        RF.szdeg(mapchn) = sqrt(abs(top-bottom).*abs(right-left))./pixperdeg;
        
        XVEC1 = [left  right  right  left  left];
        YVEC1 = [bottom bottom  top top  bottom];
        
        RF.XVEC1(mapchn,:) = XVEC1;
        RF.YVEC1(mapchn,:) = YVEC1;
        
        h = line(XVEC1,YVEC1);
        set(h,'Color',arraycol(array(mapchn),:))
        axis square
        hold on
        scatter(0,0,'r','f')
        scatter(RF.centrex(mapchn),RF.centrey(mapchn),36,arraycol(array(mapchn),:),'f')
        axis([-512 512 -384 384])
        hold on,scatter(sx,sy)
        disp(['channel: ' ,num2str(mapchn), ' on array ', num2str(array(mapchn))])
        disp(['centerx = ',num2str(RF.centrex(mapchn))])
        disp(['centrey = ',num2str(RF.centrey(mapchn))])
        %positio0n in degrees
        RF.ang(mapchn)= atand(RF.centrey(mapchn)./RF.centrex(mapchn));
        
        %pix2deg conversion
        RF.ecc(mapchn) = sqrt(RF.centrex(mapchn).^2+RF.centrey(mapchn).^2)./pixperdeg;
        
        % disp(['Angle = ',num2str(RF_ang(mapchn))])
        disp(['Ecc = ',num2str(RF.ecc(mapchn))])
        disp(' ')
        
        text(RF.centrex(mapchn),RF.centrey(mapchn),num2str(mapchn))
        %Save out centx
    else
        %Bad channels get set to NaN
        RF.centrex(mapchn)=NaN;
        RF.centrey(mapchn)=NaN;
        RF.sz(mapchn)=NaN;
        RF.szdeg(mapchn)=NaN;
        RF.XVEC1(mapchn,:)=NaN(1,5);
        RF.YVEC1(mapchn,:)=NaN(1,5);
        RF.ang(mapchn) = NaN;
        RF.ecc(mapchn) = NaN;
    end
end

if ~isempty(RFx)
    %SCatter on markers
    hold on,scatter(RFx,RFy,'MarkerFaceColor',[0.8 0.8 0.8])
    for i = 1:length(RFx)
        text(RFx(i),RFy(i),(['x=' num2str(RFx(i)) ', y=' num2str(RFy(i))]))
    end
end

%Plots for each array separately
figure
for a = 1:8
    subplot(2,4,a),hold on
    for ch = find(array==a)
        h = line(RF.XVEC1(ch,:)./LOG.Par.PixPerDeg,RF.YVEC1(ch,:)./LOG.Par.PixPerDeg);
        set(h,'Color',arraycol(a,:))
        scatter(RF.centrex(ch)./LOG.Par.PixPerDeg,RF.centrey(ch)./LOG.Par.PixPerDeg,36,arraycol(a,:),'f')
        text(RF.centrex(ch)./LOG.Par.PixPerDeg,RF.centrey(ch)./LOG.Par.PixPerDeg,num2str(ch))
    end
    scatter(0,0,'r','f')
    axis square
    axis([-12 3 -12 3])
end

%Save out the data file
if saveout
    save(savename,'RF','Ons','Offs','SigDif','speed','SNR','LOG')
end

if deletelocal
    for T = 1:length(Tank)
        Tankname = Tank(T).name;
        for B = 1:length(Tank(T).block)
            Blockno = Tank(T).block(B);
            
            localdir = 'D:\buffer\';
            %Copy files from server to local buffer to avoid TDT problems
            localname =  [Tankname,'\',blockprefix,num2str(Blockno)];
            %Delete the tdt files
            delete([localdir,localname,'\*'])
            %Delete the local directory of this tank, including all sub-directories
            %(blocks)
            success = rmdir([localdir,localname],'s');
            while ~success
                disp('Directory delete failed. Automatic retry in 5 secs')
                pause(5)
                success = rmdir([bufferdir,Tankname],'s');
            end
            
        end
    end
end