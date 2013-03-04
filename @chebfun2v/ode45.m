function [t,y]=ode45(F,tspan,init,varargin)
% ODE45  Solve autonomous systems defined by a Chebfun2v.
% 
%  [T,Y] = ODE45(F,TSPAN,Y0) with TSPAN = [T0 TFINAL] solves the autonomous 
%  system of ODE y = f(y,y'), y'=g(y,y'), where f and g are the first and 
%  second components of F, respectively, from time T0 to TFINAL 
%  with initial conditions Y0. F is a chebfun2v. Y is a complex valued
%  chebfun representing the solution, i.e., Y = y(t) + i*y'(t). 
%  To obtain solutions that interpolate at T0,T1,...,TFINAL use TSPAN = 
%  [T0 T1 ... TFINAL].  

% Copyright 2013 by The University of Oxford and The Chebfun Developers.
% See http://www.maths.ox.ac.uk/chebfun/ for Chebfun information. 


if ~isempty(F.zcheb)
   error('CHEBFUN2V:ODE45:INPUTS','This command only works for chebfun2v objects with two components.') 
end


tol = chebfun2pref('eps');

if ( isa(init,'function_handle') )
    g = @(t,y) feval(F,y(1),y(2));
    L = chebop(@(x,u) diff(u,2)); L.lbc = init; % dummy linear chebop;
    [Wa,ignored,r] = recoverCoeffsBC(L);
    r = Wa \ r;
    if ( nargin == 3 )
        opts = odeset('AbsTol',tol);
        [ts,ys] = ode45(g,tspan,r',opts);
    else
        [ts,ys] = ode45(g,tspan,r',varargin);
    end
else
    g = @(t,y) feval(F,y(1),y(2));
    if ( nargin == 3 )
        opts = odeset('AbsTol',tol);
        [ts,ys] = ode45(g,tspan,init,opts);
    else
        [ts,ys] = ode45(g,tspan,init,varargin);
    end
end

t = chebfun(tspan([1 end]),tspan([1 end]));
if ( any(any(isnan(ys))) )
    error('CHEBFUN2V:ODE45:NaN','IVP returned NaN, try shorter time domain.')
end
% always ensure the result is complex valued. 
y = chebfun(ys(:,1) + 1i*ys(:,2) + eps*1i,tspan);
end
