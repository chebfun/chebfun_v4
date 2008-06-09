function plot3(varargin)
% PLOT3 Plot a chebfun in 3-D space
%    PLOT3(x,y,z), where x,y,z are three chebfuns, plots a curve in 3-space
%    where z=f(x,y).
%
%   PLOT3(X,Y,Z), where X, Y and Z are three chebfun quasimatrices, plots
%   several curves obtained from the columns (or rows) of X, Y, and Z. 
%

% This is a simple implementation that should be replaced soon! 
% Rodp, June 2008.

[a,b] = domain(varargin{1});

t = linspace(a,b,1000)';

for k = 1:nargin
    if isa(varargin{k},'chebfun')
        varargin{k} = feval(varargin{k},t);
    end
end

plot3(varargin{:})
    