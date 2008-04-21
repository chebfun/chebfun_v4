function [out,idx] = max(g)
% MAX	Global maximum on [-1,1]
% MAX(G) is the global maximum of the fun G on [-1,1].
% [Y,X] = MAX(G) returns the value X such that Y = G(X), Y the global maximum.

r = roots(diff(g));
r = [-1;r;1];
[out,idx]=max(bary(r,g.vals));
idx = r(idx);