%% Best approximation with the Remez command
% Nick Trefethen, September 2010

%%
% (Chebfun example approx/BestApprox.m)

%%
% Chebfun's REMEZ command, written by Ricardo Pachon, can compute
% best (i.e. infinity-norm or minimax)
% approximations  of a real function on a real interval.
% For example, here is an absolute value function on [-1,1]
% and its best approximation by a polynomial of degree 10:

x = chebfun('x');
f = abs(x-0.5);
[p,err] = remez(f,10);
LW = 'linewidth'; FS = 'fontsize';
figure, plot(f,'b',p,'r',LW,1.6)
title('Function and best approximation',FS,16)

%%
% Here is the error curve, with 12 points of equioscillation:
figure, plot(f-p,LW,1.6)
hold on
plot([-1 1],err*[1 1],'--k',LW,1)
plot([-1 1],-err*[1 1],'--k',LW,1)
ylim([-.1 .1])
title('Error curve',FS,16)

%%
% In Chebfun Version 3, REMEZ could only compute polynomial approximations, but
% Version 4 has some capabilities with rational approximations
% too.  An often more robust alternative for rational approximations
% is CF approximation; see the CF command.

%%
% References:
%
% R. Pachon and L. N. Trefethen, Barycentric-Remez algorithms
% for best polynomial approximation in Chebfun,
% BIT Numerical Mathematics 49 (2009), 721-741.
%
% J. van Deun and L. N. Trefethen, A robust implementation of
% the Caratheodory-Fejer method, submitted, 2010.
%
% L. N. Trefethen, Approximation Theory and Approximation Practice,
% draft book available at http://www.maths.ox.ac.uk/chebfun/ATAP/.
