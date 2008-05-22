function [X,I] = rescale(x,ends)
% RESCALE Rescale values from [-1,1].
% RESCALE(X,ENDS), where ENDS is a vector with increasing values, 
% rescales X from the interval [ENDS(i) ENDS(i+1)] where it is contained to
% the interval [-1 1]. In case that X is a matrix, each element of X is 
% rescaled using the appropriate interval of ENDS where it is contained.
%
% [Y,I] = RESCALE(X,ENDS) returns the rescaled values Y and the index i
% of the vector ENDS used to rescale X.
%

% Copyright 2002-2008 by The Chebfun Team. See www.comlab.ox.ac.uk/chebfun/

nchebs = length(ends)-1;
X = zeros(size(x));
I = zeros(size(x));

% Outliers at the left of the domain are computed with the leftmost
% fun.
pos = find((x<ends(1)));
a = ends(1); b = ends(2);
X(pos) = (x(pos)-b)/(b-a) + (x(pos)-a)/(b-a);
I(pos) = 1;
% Points in the domain are computed with the corresponding fun
for i = 1:nchebs
    a = ends(i); b = ends(i+1);
    pos = find((x>=a)&(x<b));
    X(pos) = (x(pos)-b)/(b-a) + (x(pos)-a)/(b-a);
    I(pos) = i;
end
% Outliers at the right of the domain are computed with the rightmost
% fun.
pos = find((x>=ends(end)));
a = ends(end-1); b = ends(end);
X(pos) = (x(pos)-b)/(b-a) + (x(pos)-a)/(b-a);
I(pos) = nchebs;
