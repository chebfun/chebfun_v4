function X = hscale(f)
% HSCALE Find the horizontal scale of chebfun F
%
% Pachon, Platte, Trefethen, 2007, Chebfun Version 2.0
X = max(abs(domain(f)));
