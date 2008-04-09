function X = hscale(f)
% HSCALE Find the horizontal scale of chebfun F

% Pachon, Platte, Trefethen, 2007, Chebfun Version 2.0

[a,b] = domain(f);
X = max(abs([a b]));

