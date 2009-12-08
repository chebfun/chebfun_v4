function pass = bvpsimplifytest

% This test has a purpose: to make sure that the
% nonlinop backslash process succeeds in simplifying
% a solution which is a parabola to a chebfun with
% length 3.   Nick T. & Asgeir B., 4 December 2009.

%%
[d,x,N] = domain(-1,1);
N.bc = 1;
N.op = @(u) diff(u,2);
u1 = N\2;                    % this should be a parabola
pass(1) = (length(u1)==3);

N.op = @(u) diff(u,2) + sin(u-x.^2);
u2 = N\2;                    % this should be a parabola too!
u2 = simplify(u2,1e-10);
pass(2) = (length(u2)==3);
