function varargout = plot3(varargin)
% PLOT3 Plot a chebfun in 3-D space
%    PLOT3(x,y,z), where x,y,z are three chebfuns, plots a curve in 3-space
%    where z=f(x,y).
%
%   PLOT3(X,Y,Z), where X, Y and Z are three chebfun quasimatrices, plots
%   several curves obtained from the columns (or rows) of X, Y, and Z. 
%
%   See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

%  Copyright 2002-2009 by The Chebfun Team. 
%  Last commit: $Author$: $Rev$:
%  $Date$:

% This is a simple implementation that should be replaced soon! 
% Rodp, June 2008.

[a,b] = domain(varargin{1});

t = linspace(a,b,1000)';

for k = 1:nargin
    if isa(varargin{k},'chebfun')
        varargin{k} = feval(varargin{k},t);
    end
end

h = plot3(varargin{:});

if nargout > 0 
    varargout = h;
end
    