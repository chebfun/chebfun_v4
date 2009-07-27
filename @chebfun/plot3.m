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

k = 1;

while k < nargin
    if isa(varargin{k}, 'chebfun')
        % Replace chebfun with vectors (evaluation at 1000 points)
        [lines, marks] = plotdata(varargin{k:k+2},1000);
        varargin{k} = lines{1};
        varargin{k+1} = lines{2};
        varargin{k+2} = lines{3};
        k = k+3;
    else
        k = k+1;
    end
end

h = plot3(varargin{:});
hold on
plot3(marks{:},'.')
hold off
if nargout > 0 
    varargout = {h};
end
    