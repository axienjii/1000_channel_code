function plot_low_med_high_thresh(ResponseDB,allV4Threshold,allBehaviorThreshold)

responsewindow = [0.01 0.1];
blankwindow = [-0.00 0.01];
NumBins = 3;
NumSigElec = 1;
R2threshold = 0.7;
NumAvgBins = 15;
 
figure
for thisMonkey = 1:2
    numV1elec = numel(ResponseDB(thisMonkey).V1ElecID);
    
    V1elecID = [];
    threshold = [];
    for thisV1elec = 1:numV1elec
        TestH = find(ResponseDB(thisMonkey).TestH{thisV1elec});
        if numel(TestH) >= NumSigElec
            V1elecID = [V1elecID, thisV1elec];
            threshold = [threshold, ResponseDB(thisMonkey).Behavior(thisV1elec).threshold{2}(2)];
        end
    end
    %
    [SortedThreshold,idx]=sort(threshold,'ascend');
    V1elecID = V1elecID(idx);
    
    a = 0;
    SurvivedThreshold = [];
    SurvivedV1elecID = [];
    for i = 1:numel(V1elecID)
        thisV1elec = V1elecID(i);
        uniCurrentLevel = ResponseDB(thisMonkey).Behavior(thisV1elec).uniCurrentLevel{2};
        thisThreshold = ResponseDB(thisMonkey).Behavior(thisV1elec).threshold{2}(2);
        response = ResponseDB(thisMonkey).ResponseData{thisV1elec};
        TestH = find(ResponseDB(thisMonkey).TestH2{thisV1elec});
        
        
        SigResponse = response(:,TestH,:);
        timepoint = linspace(-0.4,0.7,size(response,1));
        timeIdx = timepoint >= blankwindow(1) & timepoint <= blankwindow(2);
        hitrate = ResponseDB(thisMonkey).Behavior(thisV1elec).hitrate{2};
        for thisElec = 1:numel(TestH)
            blankR = mean(squeeze(mean(SigResponse(timeIdx,thisElec,:),1)));
            SigResponse(:,thisElec,:) = SigResponse(:,thisElec,:) - blankR;
        end
        
        timeIdx = timepoint > responsewindow(1) & timepoint < responsewindow(2);
        meanResponse = squeeze(mean(mean(SigResponse(timeIdx,:,:),2),1));
        [coef,S] = polyfit(hitrate',meanResponse,1);
        minResponse = coef(1) * 0 + coef(2);
        maxResponse = coef(1) * 1 + coef(2);
        ExplainedError = sum((meanResponse - (coef(1) .* hitrate' + coef(2))).^2);
        TotalError = sum((meanResponse - mean(meanResponse)).^2);
        Rsquared = 1 - ExplainedError/TotalError;
        if Rsquared > R2threshold
            a = a + 1;
            NormalizedResponse = (meanResponse-minResponse)/(maxResponse-minResponse);
            
            SurvivedThreshold(a) = thisThreshold;
            SurvivedV1elecID(a) = thisV1elec;
        end
    end
 
 
    binIdxWidth = floor(numel(SurvivedThreshold) / NumBins);
    
    binThresholdBoundary(1) = min(SurvivedThreshold);
    
    for i = 1:(NumBins-1)
        binThresholdBoundary(i+1) = SurvivedThreshold(binIdxWidth*i);
    end
    binThresholdBoundary(NumBins+1) = max(SurvivedThreshold) + 1;
    
    curvecolors = lines(NumBins);
 
    AllNormalizedResponse = cell(NumBins,1);
    AllRelativeCurrentLevel = cell(NumBins,1);
    AllHitrate = cell(NumBins,1);
    AllThreshold = cell(NumBins,1);
    for i = 1:numel(SurvivedV1elecID)
        thisV1elec = SurvivedV1elecID(i);
        uniCurrentLevel = ResponseDB(thisMonkey).Behavior(thisV1elec).uniCurrentLevel{2};
        
        thisThreshold = ResponseDB(thisMonkey).Behavior(thisV1elec).threshold{2}(2);
        response = ResponseDB(thisMonkey).ResponseData{thisV1elec};
        TestH = find(ResponseDB(thisMonkey).TestP{thisV1elec}<0.01);
 
        
        SigResponse = response(:,TestH,:);
        timepoint = linspace(-0.4,0.7,size(response,1));
        timeIdx = timepoint >= blankwindow(1) & timepoint <= blankwindow(2);
        hitrate = ResponseDB(thisMonkey).Behavior(thisV1elec).hitrate{2};
        for thisElec = 1:numel(TestH)
            blankR = mean(squeeze(mean(SigResponse(timeIdx,thisElec,:),1)));
            SigResponse(:,thisElec,:) = SigResponse(:,thisElec,:) - blankR;
        end
        
        timeIdx = timepoint > responsewindow(1) & timepoint < responsewindow(2);
        meanResponse = squeeze(mean(mean(SigResponse(timeIdx,:,:),2),1));
        [coef,S] = polyfit(hitrate',meanResponse,1);
        minResponse = coef(1) * 0 + coef(2);
        maxResponse = coef(1) * 1 + coef(2);
        
        [~,thisBin] = histc(thisThreshold,binThresholdBoundary);
        relativeCurrentLevel = uniCurrentLevel/thisThreshold*100;
        
        NormalizedResponse = (meanResponse-minResponse)/(maxResponse-minResponse);
        
        AllThreshold{thisBin} = [AllThreshold{thisBin};thisThreshold];
        AllRelativeCurrentLevel{thisBin} = [AllRelativeCurrentLevel{thisBin};relativeCurrentLevel];
        AllHitrate{thisBin} = [AllHitrate{thisBin};hitrate'];
        AllNormalizedResponse{thisBin} = [AllNormalizedResponse{thisBin};NormalizedResponse];
        
    end
    for thisBin = 1:NumBins
        UniRelativeCurrentLevel{thisBin} = unique(AllRelativeCurrentLevel{thisBin});
        AverageBinHitRate{thisBin} = zeros(numel(UniRelativeCurrentLevel{thisBin}),1);
        AverageResponse{thisBin} = zeros(numel(UniRelativeCurrentLevel{thisBin}),1);
        for i = 1:numel(UniRelativeCurrentLevel{thisBin})
            idx = AllRelativeCurrentLevel{thisBin} == UniRelativeCurrentLevel{thisBin}(i);
            hitrate = AllHitrate{thisBin}(idx);
            response = AllNormalizedResponse{thisBin}(idx);
            AverageBinHitRate{thisBin}(i) = mean(hitrate);
            AverageResponse{thisBin}(i) = mean(response);
        end
    end
 
    for thisBin = 1:NumBins
        edge = linspace(min(UniRelativeCurrentLevel{thisBin}),max(UniRelativeCurrentLevel{thisBin}+1),NumAvgBins+1);
        [~,idx] = histc(UniRelativeCurrentLevel{thisBin},edge);
        idx(idx == NumAvgBins+1) = NumAvgBins;
        RelativeCurrentLevel = zeros(NumAvgBins,1);
        HitRate = zeros(NumAvgBins,1);
        Response = zeros(NumAvgBins,1);
        for i = 1:NumAvgBins
            RelativeCurrentLevel(i) = mean(UniRelativeCurrentLevel{thisBin}(idx == i));
            HitRate(i) = mean(AverageBinHitRate{thisBin}(idx == i));
            Response(i) = mean(AverageResponse{thisBin}(idx == i));
        end
        
        idx = ~isnan(RelativeCurrentLevel);
        RelativeCurrentLevel = RelativeCurrentLevel(idx);
        HitRate = HitRate(idx);
        Response = Response(idx);
    end
 
    for thisBin = 1:NumBins
        UniRelativeCurrentLevel{thisBin} = unique(AllRelativeCurrentLevel{thisBin});
        AverageBinHitRate{thisBin} = zeros(numel(UniRelativeCurrentLevel{thisBin}),1);
        AverageResponse{thisBin} = zeros(numel(UniRelativeCurrentLevel{thisBin}),1);
        for i = 1:numel(UniRelativeCurrentLevel{thisBin})
            idx = AllRelativeCurrentLevel{thisBin} == UniRelativeCurrentLevel{thisBin}(i);
            hitrate = AllHitrate{thisBin}(idx);
            response = AllNormalizedResponse{thisBin}(idx);
            AverageBinHitRate{thisBin}(i) = mean(hitrate);
            AverageResponse{thisBin}(i) = mean(response);
        end
    end
    
    for thisBin = 1:NumBins
        subplot(2,2,thisMonkey)
        hold on
        if thisMonkey == 1
            title('Monkey L')
        elseif thisMonkey == 2
            title('Monkey A')
        end
        xlabel('Current level (uA)')
        ylabel('Hit rate')
        if thisMonkey == 1
            xlim([0 140])
        elseif thisMonkey == 2
            xlim([0 210])
        end
        edge = linspace(min(UniRelativeCurrentLevel{thisBin}),max(UniRelativeCurrentLevel{thisBin}),NumAvgBins+1);
        [~,idx] = histc(UniRelativeCurrentLevel{thisBin},edge);
        idx(idx == NumAvgBins+1) = NumAvgBins;
        UniIdx = unique(idx);
        
        RelativeCurrentLevel = zeros(numel(UniIdx),1);
        RelativeCurrentLevelSEM = RelativeCurrentLevel;
        HitRate = zeros(numel(UniIdx),1);
        HitRateSEM = HitRate;
        Response = zeros(numel(UniIdx),1);
        ResponseSEM = Response;
        for i = 1:numel(UniIdx)
            RelativeCurrentLevel(i) = mean(UniRelativeCurrentLevel{thisBin}(idx == UniIdx(i)));
            HitRate(i) = mean(AverageBinHitRate{thisBin}(idx == UniIdx(i)));
            Response(i) = mean(AverageResponse{thisBin}(idx == UniIdx(i)));
            RelativeCurrentLevelSEM(i) = std(UniRelativeCurrentLevel{thisBin}(idx == UniIdx(i)))/sqrt(sum(idx == UniIdx(i)));
            HitRateSEM(i) = std(AverageBinHitRate{thisBin}(idx == UniIdx(i)))/sqrt(sum(idx == UniIdx(i)));
            ResponseSEM(i) = std(AverageResponse{thisBin}(idx == UniIdx(i)))/sqrt(sum(idx == UniIdx(i)));
        end
        
        idx = ~isnan(RelativeCurrentLevel);
        RelativeCurrentLevel = RelativeCurrentLevel(idx);
        HitRate = HitRate(idx);
        Response = Response(idx);
        RelativeCurrentLevelSEM = RelativeCurrentLevelSEM(idx);
        HitRateSEM = HitRateSEM(idx);
        ResponseSEM = ResponseSEM(idx);
        
        BinAvgThreshold = mean(AllThreshold{thisBin});
        absoluteCurrentLevel = BinAvgThreshold * RelativeCurrentLevel / 100;
        absoluteCurrentLevelSEM = RelativeCurrentLevelSEM.*absoluteCurrentLevel/100;
        e1=errorbar(absoluteCurrentLevel,HitRate,-HitRateSEM,HitRateSEM);
%         e1=errorbar(absoluteCurrentLevel,HitRate,-HitRateSEM,HitRateSEM,-absoluteCurrentLevelSEM,absoluteCurrentLevelSEM,'Marker','.');
        e1.LineWidth = 1.0;
        e1.MarkerSize = 12;
 
        subplot(2,2,2+thisMonkey)
        hold on
        e2=errorbar(absoluteCurrentLevel,Response,-ResponseSEM,ResponseSEM);
%         e2=errorbar(absoluteCurrentLevel,Response,-ResponseSEM,ResponseSEM,-absoluteCurrentLevelSEM,absoluteCurrentLevelSEM,'Marker','.');
        e2.LineWidth = 1.0;
        e2.MarkerSize = 12;
        
        if thisMonkey == 1
            yl = ylim;
        elseif thisMonkey == 2
            ylim(yl)
        end
        xlabel('Current level (uA)')
        ylabel('Normalized V4 MUA')
    end
    
end
set(gcf,'color','w');
 
figure
for thisMonkey = 1:2
    subplot(1,2,thisMonkey)
    hold on
    plot(allV4Threshold{thisMonkey},allBehaviorThreshold{thisMonkey},'k.')
    xlabel('V4 threshold')
    ylabel('Behavior threshold')
    xlim([0 210])
    ylim([0 210])
    
    xdata = allV4Threshold{thisMonkey};
    ydata = allBehaviorThreshold{thisMonkey};
    
    [rho,pval] = corr(xdata',ydata');
    
    text(20, 200, ['rho=', num2str(rho)]);
    text(20, 180, ['p=', num2str(pval)]);
    
    [p,gof]= fit(xdata',ydata','poly1');
    
    plot([0 210],[p(0),p(210)])
end
