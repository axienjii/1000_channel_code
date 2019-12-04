function calculate_eye_movement_current_thresholding
%Written by Xing 1/4/19 to calculate the time at which the monkey initiated
%an eye movement during a current thresholding task.

% analyse_microstim_saccade_current_thresholding('041017_B6',1)
% analyse_microstim_saccade_current_thresholding('041017_B7',1)
% analyse_microstim_saccade_current_thresholding('041017_B8',1)
% analyse_microstim_saccade_current_thresholding('041017_B9',1)
% analyse_microstim_saccade_current_thresholding('041017_B10',1)
% analyse_microstim_saccade_current_thresholding('041017_B13',1)%no sync pulse, checked on analog input ch 11 (expected) and 10
% analyse_microstim_saccade_current_thresholding('041017_B18',1)
% analyse_microstim_saccade_current_thresholding('041017_B19',1)
% % analyse_microstim_saccade_current_thresholding('051017_B1',1)
% analyse_microstim_saccade_current_thresholding('051017_B4',1)
% analyse_microstim_saccade_current_thresholding('051017_B6',1)
% analyse_microstim_saccade_current_thresholding('051017_B7',1)

dates=[{'051017_B9'};{'051017_B10'};{'051017_B15'};{'051017_B16'};{'051017_B17'};{'051017_B18'};{'051017_B19'};{'051017_B20'};{'051017_B21'};{'051017_B22'};{'051017_B23'};{'051017_B24'};{'051017_B25'};{'051017_B27'};{'051017_B28'}];
errorMessages=[];%keep a list of any errors
for dateInd=1:length(dates)
    try
        date=dates{dateInd};
        analyse_microstim_saccade_current_thresholding(date,1)
    catch ME
        disp(ME);%print the error message to screen
        for i=1:length(ME.stack);
            errorMessages=[errorMessages;date {ME}];%append the error message to a list
        end
    end
end
if ~isempty(errorMessages)
    for i=1:size(errorMessages,1)
        fprintf('\nError at session %d\n',errorMessages{i,1});%print problematic session number to screen
        errorMessages{i,2}.message%display error message
        errorMessages{i,2}.stack%print function and line number at which error occurred
    end
end

% analyse_microstim_saccade_current_thresholding('051017_B9',1)
% analyse_microstim_saccade_current_thresholding('051017_B10',1)
% analyse_microstim_saccade_current_thresholding('051017_B15',1)
% analyse_microstim_saccade_current_thresholding('051017_B16',1)
% analyse_microstim_saccade_current_thresholding('051017_B17',1)
% analyse_microstim_saccade_current_thresholding('051017_B18',1)
% analyse_microstim_saccade_current_thresholding('051017_B19',1)
% analyse_microstim_saccade_current_thresholding('051017_B20',1)
% analyse_microstim_saccade_current_thresholding('051017_B21',1)
% analyse_microstim_saccade_current_thresholding('051017_B22',1)
% analyse_microstim_saccade_current_thresholding('051017_B23',1)
% analyse_microstim_saccade_current_thresholding('051017_B24',1)
% analyse_microstim_saccade_current_thresholding('051017_B25',1)
% analyse_microstim_saccade_current_thresholding('051017_B27',1)
% analyse_microstim_saccade_current_thresholding('051017_B28',1)