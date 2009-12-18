function comet(f,varargin)
% COMET   Two-dimensional comet plot.
% A comet graph is an animated graph in which a thick dot (the comet head) 
% traces the data points on the screen. Notice that unlike the standard
% Matlab comet command, the chebfun comet does not leave a trail.
%
% comet(F) displays a comet graph of the chebfun F, comet(F,G) displays a
% comet of the chebfun F versus the chebfun G, and comet(F,G,H) displays a
% comet in 3D-space using the three chebfuns as coordinates.
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2009 by The Chebfun Team. 

ho=ishold;
if ~ho, hold on; end

if norm(f.ends([1,end]),inf) == inf
    error('CHEBFUN:comet:restrict','comet requires a bounded interval, please use restrict')
end

p = 0;
for k = 1:numel(varargin)
    if isnumeric(varargin{k}), p = varargin{k}; break, end
end

if nargin==1 && isreal(f)
    [x0,x1] = domain(f);
    x = linspace(x0,x1,300); x(end) = [];
    ydata = feval(f,x);
    hh = plot(x(1),ydata(1),'.r','markersize',25);
    for j = 2:length(x)
         set(hh,'xdata',x(j),'ydata',ydata(j));
         drawnow, pause(p)
    end
end

if nargin==2 || ~isreal(f)
    if isreal(f)
        g = varargin{1};
    else
        g = imag(f);
        f = real(f);
    end
    [x0,x1] = domain(f); [y0,y1] = domain(g);
    hs = max(hscale(f),hscale(g));
    if (abs(x0-y0)>1e-12*hs) || (abs(x1-y1)>1e-12*hs)
        disp('f and g must be defined on the same interval')
        return
    end
    x = linspace(x0,x1,300);
    xdata = feval(f,x);
    ydata = feval(g,x);
    hh = plot(xdata(1),ydata(1),'.r','markersize',25);
    for j = 2:length(x)
        set(hh,'xdata',xdata(j),'ydata',ydata(j));
        drawnow, pause(p)
    end
end

if nargin==3
    g = varargin{1}; h = varargin{2};
    [x0,x1] = domain(f); [y0,y1] = domain(g); [z0,z1] = domain(h);
    hs = max([hscale(f) hscale(g) hscale(h)]);
    if (std([x0 y0 z0])>1e-12*hs) || (std([x1 y1 z1])>1e-12*hs)
        disp('f, g and h must be defined on the same interval')
        return
    end
    x = linspace(x0,x1,300);
    xdata = feval(f,x);
    ydata = feval(g,x);
    zdata = feval(h,x);
    hh = plot3(xdata(1),ydata(1),zdata(1),'.r','markersize',25);
    for j = 2:length(x)
        set(hh,'xdata',xdata(j),'ydata',ydata(j),'zdata',zdata(j));
        drawnow, pause(.005)
    end
end
delete(hh);

if ho, hold on; else hold off; end
