function varargout = surf(f,varargin)
%SURF, Surf plot of a chebfun2v.
% 
% SURF(F) is the surface plot of sqrt(F.^2)

% Copyright 2013 by The University of Oxford and The Chebfun Developers.
% See http://www.maths.ox.ac.uk/chebfun/ for Chebfun information.

if isempty(f)
   surf([]);
   return; 
end


ish = ishold;

% Just plot the magnitude for now. 
minsample = 200; 
fx = f.xcheb; fy = f.ycheb; 
rect = fx.corners;

x = linspace(rect(1),rect(2),minsample);
y = linspace(rect(3),rect(4),minsample);
[xx,yy] = meshgrid(x,y);

%% 
% Plot using Matlab's surf command. 

if isempty(f.zcheb)
    if ( isempty(varargin) )
        h=surf(xx,yy,sqrt(fx(xx,yy).^2 + fy(xx,yy).^2));
    else
        h=surf(xx,yy,sqrt(fx(xx,yy).^2 + fy(xx,yy).^2),varargin);
    end
else
    fz = f.zcheb;
    if ( isempty(varargin) )
        h=surf(xx,yy,sqrt(fx(xx,yy).^2 + fy(xx,yy).^2 + fz(xx,yy).^2));
    else
        h=surf(xx,yy,sqrt(fx(xx,yy).^2 + fy(xx,yy).^2 + fz(xx,yy).^2),varargin);
    end
end

if ~ish, hold off; end;
if nargout > 0, varargout = {h}; end
end