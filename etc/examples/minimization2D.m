function [xmin,ymin,umin]=minimization2D(u)
% find the global minimum of a 2D function.
%
% example:
%   u=@(x,y) abs(x-pi/5)+abs(sin(5*x))+abs(sin(5*y.^2)+x-pi/7);
%   [xmin,ymin,umin]=minimization2D(u)

uy=chebfun(@(y) minvals(u,y)); 
[umin,ymin]=min(uy);
[umin,xmin]=min(chebfun(@(x) u(x,ymin)));

function minvals=minvals(u,y)
minvals = 0*y;
for i = 1:length(y)
    ux=chebfun(@(x) u(x,y(i)));
    minvals(i)=min(ux);
end
