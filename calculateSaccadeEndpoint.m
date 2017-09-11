function [b1 b2]=calculateSaccadeEndpoint(x,y)
%Written by Xing 11/9/17
%Takes in histogram values of either the X or Y coordinates of the saccadic
%movement as second input arg, and the bin number as the first input arg.
%Fits a bimodal Gaussian to the data, and returns the midpoints (along the
%X axis) of the two peaks.

% figure
f =@(A,m,s,x) A(1) * exp(-((x-m(1))/s(1)).^2) + A(2) * exp(-((x-m(2))/s(2)).^2);
% g =@(x) f([5, 10], [1, 10], [3, 5], x);
% x = (-20:0.01:20)';
% y = g(x) + 0.25*(rand(size(x)) - 0.5);
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
[fitresult gof output] = fit( x, y, 'gauss2', opts );
% plot( fitresult, x, y );
b1=fitresult.b1;
b2=fitresult.b2;