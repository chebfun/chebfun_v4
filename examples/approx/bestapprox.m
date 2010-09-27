%% BEST APPROXIMATION BY THE REMEZ COMMAND
% Nick Trefethen, 25 September 2010

%%
% (Chebfun example approx/bestapprox.m)

%%
% Chebfun's REMEZ command, written by Ricardo Pachon, can compute
% best (i.e. infinity-norm or minimax)
% approximations  of a real function on a real interval.
% For example, here is an absolute value function on [-1,1]
% and its best approximation by a polynomial of degree 10:

x = chebfun('x');
f = abs(x-0.5);
[p,err] = remez(f,10);
figure, plot(f,'b',p,'r')
title('function and best approximation')

%%
% Here is the error curve, with 12 points of equioscillation:
figure, plot(f-p)
hold on
plot([-1 1],err*[1 1],'--k')
plot([-1 1],-err*[1 1],'--k')
ylim([-.1 .1])
title('error curve')

%%
% At the moment REMEZ only does polynomial approximations, though
% rational approximations are coming.  See also the CF command.
