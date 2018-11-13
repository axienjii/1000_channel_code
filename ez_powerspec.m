function ez_powerspec(y,Fs,col,hld)

%ez_powerspec(y,Fs,col,hld)
%y = neural signal (row or column vector)
%Fs = sample frequency in Hertz
%col = color of graph e.g. 'b' for blue
%hld = hold on options (see below)
%This is just for visualisation of the power/amplitude spectrum, at the
%moment I have it set up to plot
%the AMPLITUDE not the power, if you want power you have to use abs(Y).^2
%You may provide color and hold on options to plot.
%hld = 0, open a figure and plot into it
%hld = 1 means it plots over an already open graph

%M.W.Self 2013

%Nyquist limit is half the sampling frequency
Nyq = Fs/2; 
%Length of time-series (in secs)
L = length(y)./Fs;
%Number of samples
N = length(y);

%Make samples
smps = 0:1:(N-1);

%FFT ANALYSIS%%%%%%%%%%%%%%%%%%
%First do fft, remember to scale by N.
Y = fft(y)/N;
%the resulting frequencies will be in cycles/timeseries
%starting with a frequency of 0 (DC) going upto frequencies that are equal to the length of the time-series-1.
%So the 2nd pos in the vector contains a frequency of 1 cycle/timeseries which has a
%frequency of 1/L;  This will continue upto Nyquist limit.
%So we can now make our frequency x-axis by dividing the number of samples by the length of the time-series;
f = smps/L;
%Plot, use 2xamplitude as half of the amplitude will appear above Nyquist.
if nargin < 3
    figure,plot(f,abs(Y).^2);
elseif nargin == 3
    figure,plot(f,abs(Y).^2,col);
elseif nargin == 4
    if hld == 1
        hold on
        plot(f,abs(Y).^2,col);
    else
        figure,plot(f,abs(Y).^2,col); 
    end
end
ylabel('Power'),xlabel('Frequency (Hz)')
%Limit this at Nyquist
xlim([0 Nyq])
title('FFT of signal')

return