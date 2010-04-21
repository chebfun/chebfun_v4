function out = isinf(d)
% ISINF   True for unbounded domains.
%  ISINF(D) returns a 2x1 array which is true if that end of the domain is 
%  infinite, and false if not.
out = isinf(d.ends);