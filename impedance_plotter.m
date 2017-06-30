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
    
    
    