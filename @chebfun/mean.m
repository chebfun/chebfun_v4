function out = mean(f,g)
% MEAN	Average or mean value
% MEAN(F) is the mean value of the chebfun F.
%
% MEAN(F,G) is the average chebfun between chebfuns F and G.

% Ricardo Pachon and Lloyd N. Trefethen, 2007, Chebfun Version 2.0
if nargin == 1
    out = sum(f)/length(domain(f));
else
    out = (f+g)/2;
end
