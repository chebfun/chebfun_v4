function y = odesol(sol,m)
%ODESOL  Convert an ODE solution to chebfun.

% ODESOL(SOL,M) converts the solution of an ODE initial-value or 
% boundary-value problem by standard MATLAB methods into a chebfun 
% representation. SOL is the one-output form of any solver such as ODE45,
% ODE15S, BVP5C, etc. M is the piecewise degree of the chebfun
% representation (proper value depends on the solution method).
%
% The result is a piecewise chebfun of low polynomial degree on 
% each piece. 
%
% Examples (using built-in ODE demos):
%
%   y = odesol( ode45(@vdp1,[0 20],[2;0]) );
%   roots( y(:,1)-1 )   % find times when first component is 1
%
%   solinit = bvpinit(linspace(0,4,5),[1 0]);
%   y = odesol( bvp5c(@twoode,@twobc,solinit) );
%   plot(y)
% 

% Copyright 2009 by the Chebfun Team. See www.comlab.ox.ac.uk/chebfun.

cursplit = chebfunpref('splitting');
splitting on
ends = sol.x;
n = length(ends)-1;  % number of time subintervals
y = chebfun;
for j = 1:size(sol.y,1)
  f = repmat( {@(x) deval(sol,x,j)'}, [1 n]);   % evaluation function
  y(:,j) = chebfun(f,ends,m*ones(n,1));
end
chebfunpref('splitting',cursplit)

end