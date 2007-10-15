function comet(f,varargin)

% This entertaining M-file plots a moving red
% dot to show off the chebfun f

ho=ishold;
if ~ho, hold on; end

 if nargin==1
   I = get(f,'ends'); x0 = I(1); x1 = I(end);  % must improve this!
   x = linspace(x0,x1,300);
   hh = plot(x(1),f(x(1)),'.r','markersize',25);
   for j = 2:length(x)
     set(hh,'xdata',x(j),'ydata',f(x(j)));
     drawnow
   end
 end

 if nargin==2
   g = varargin{1};
   I = get(f,'ends'); x0 = I(1); x1 = I(end);
   I = get(g,'ends'); y0 = I(1); y1 = I(end);
   if (abs(x0-y0)>1e-12) | (abs(x1-y1)>1e-12)
     disp('f and g must be defined on the same interval')
     return
   end
   x = linspace(x0,x1,300);
   hh = plot(f(x(1)),g(x(1)),'.r','markersize',25);
   for j = 2:length(x)
     set(hh,'xdata',f(x(j)),'ydata',g(x(j)));
     drawnow
   end
 end

 if nargin==3
   g = varargin{1}; h = varargin{2};
   I = get(f,'ends'); x0 = I(1); x1 = I(end);
   I = get(g,'ends'); y0 = I(1); y1 = I(end);
   I = get(h,'ends'); z0 = I(1); z1 = I(end);
   if (std([x0 y0 z0])>1e-12) | (std([x1 y1 z1])>1e-12)
     disp('f, g and h must be defined on the same interval')
     return
   end
   x = linspace(x0,x1,300);
   hh = plot3(f(x(1)),g(x(1)),h(x(1)),'.r','markersize',25);
   for j = 2:length(x)
     set(hh,'xdata',f(x(j)),'ydata',g(x(j)),'zdata',h(x(j)));
     drawnow
   end
 end
 delete(hh);
 
 if ho, hold on; else hold off; end