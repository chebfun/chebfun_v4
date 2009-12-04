function pass = bvpsimplifytest

% This test has a purpose: to make sure that the
% nonlinop backslash process succeeds in simplifying
% a solution which is a parabola to a chebfun with
% length 3.   Nick T. & Asgeir B., 4 December 2009.

[d,x,N] = domain(-1,1);
N.bc = 1;
N.op = @(u) diff(u,2);
u = N\2;                    % this should be a parabola
pass(1) = (length(u)==3);

N.op = @(u) diff(u,2) + sin(u-x.^2);
u = N\2;                    % this should be a parabola too!
pass(2) = (length(u)==3);



