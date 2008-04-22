function comet(f,varargin)
% COMET Two-dimensional comet plot.
% A comet graph is an animated graph in which a circle (the comet head) 
% traces the data points on the screen. Notice that the chebfun comet does
% not leave a trail, as it is the case of the standard comet.
%
% comet(F) displays a comet graph of the chebfun F, comet(F,G) displays a
% comet of the chebfun F versus the chebfun G and comet(F,G,H) displays a
% comet in 3D-space using the three chebfuns as coordinates.

% Chebfun Version 2.0

ho=ishold;
if ~ho, hold on; end

if nargin==1
    [x0,x1] = domain(f);
    x = linspace(x0,x1,300); x(end) = [];
    ydata = feval(f,x);
    hh = plot(x(1),ydata(1),'.r','markersize',25);
    for j = 2:length(x)
         set(hh,'xdata',x(j),'ydata',ydata(j));
         drawnow, %pause(.005)
    end
end

if nargin==2
    g = varargin{1};
    [x0,x1] = domain(f); [y0,y1] = domain(g);
    hs = max(abs([x0 x1 y0 y1]));
    if (abs(x0-y0)>1e-12*hs) | (abs(x1-y1)>1e-12*hs)
        disp('f and g must be defined on the same interval')
        return
    end
    x = linspace(x0,x1,300);
    xdata = feval(f,x);
    ydata = feval(g,x);
    hh = plot(xdata(1),ydata(1),'.r','markersize',25);
    for j = 2:length(x)
        set(hh,'xdata',xdata(j),'ydata',ydata(j));
        drawnow, %pause(.005)
    end
end

if nargin==3
    g = varargin{1}; h = varargin{2};
    [x0,x1] = domain(f); [y0,y1] = domain(g); [z0,z1] = domain(h);
    hs = max(abs([x0 x1 y0 y1 z0 z1]));
    if (std([x0 y0 z0])>1e-12*hs) | (std([x1 y1 z1])>1e-12*hs)
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