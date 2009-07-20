function plotm(varargin)
% A simple plot to graph a mapped FUN on the interval [-1,1].

% Last commit: $Author$: $Rev$:
% $Date$:

g = varargin{1};
y = linspace(-1,1,1000);
x = g.map.for(y);
plot(y,feval(g,x),varargin{2:end})