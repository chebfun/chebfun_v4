function varargout = plot(varargin)
% A simple plot to graph a mapped FUN on the interval [-1,1].

% Last commit: $Author$: $Rev$:
% $Date$:

g = varargin{1};
g.exps = [0 0];
y = linspace(-1,1,2001);
x = g.map.for(y);
h = plot(y,feval(g,x),varargin{2:end});

if nargout > 0,
    varargout = h;
end