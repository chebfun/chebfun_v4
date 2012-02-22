function pass = lebesguetest
% Check behavior of LEBESGE
% Nick Trefethen, February 2012
% A level 0 Chebtest.

% An arbitrary small test:
[L,Lconst] = lebesgue([-1 0 1],[-1,2]);
pass(1) = norm([7 7]-[Lconst max(L)],inf) < 100*chebfunpref('eps');

% % This failed because of a bug in Feb 2012:
% s = linspace(.25,1,17); s = [-s s];
% [L,Lconst] = lebesgue(s);
% pass(2) = min(L.vals)>.999;
