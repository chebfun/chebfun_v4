%% Spike integral
% Nick Hale, October 2010

%%
% (Chebfun example quad/SpikeIntegral.m)

%%
% We demonstrate the adaptive capabilities of Chebfun 
% by integrating the 'spike' function
%
%    sech(10*(x-0.2))^2 + sech(100*(x-0.4))^4 + ...
%    sech(1000*(x-0.6))^6 + sech(1000*(x-0.8)).^8
%
% (which appears as F21F in [1]) over [0 1].

%%
% Define the anonymous function:
f = @(x) sech(10*(x-0.2)).^2 + sech(100*(x-0.4)).^4 + ...
         sech(1000*(x-0.6)).^6 + sech(1000*(x-0.8)).^8;

%%
% Create a Chebfun representation:
ff = chebfun(f,[0 1], 'splitting','on','minsamples',129);

%%
% Here 'minsamples' was increased so that the spikes 
% are not missed by an overly coarse initial sample.

%%
% Plot the function:
plot(ff,'b','linewidth',1.6,'numpts',1e5)
title('The ''Spike'' function','FontSize',16)

%% 
% Compute the integral:
sum(ff)

%%
% References:
%
% [1] D. K. Kahaner, "Comparison of numerical quadrature formulas", in 
% J. R. Rice, ed., Mathematical Software, Academic Press, 1971, 229-259.
