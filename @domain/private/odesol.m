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

% Note: Remove m from input and correct help comments.

% Current tolerance used by user
usertol = chebfunpref('tol');

ends = sol.x;
scl = max(abs(sol.y),[],2); % Vertical scale (needed for RelTol)
opt = sol.extdata.options;
ncols = size(sol.y,1);

% Find relative tolerances used in computations
% start with odeset default values
RelTol = 1e-3*ones(ncols,1);           % Relative
AbsTol = 1e-6*ones(ncols,1);           % Absolute
% update if user used different tolerances
if ~isempty(opt)
    if ~isempty(opt.RelTol) % Relative tolerance given by user
        RelTol = opt.RelTol*ones(ncols,1);
    end
    if ~isempty(opt.AbsTol) % Absolute tolerance given by user
        if length(opt.AbsTol) == 1 % AbsTol might be vector or scalar
            AbsTol = opt.AbsTol*ones(ncols,1);
        else
            AbsTol = opt.AbsTol;
        end
    end   
end
% Turn AbsTol into RelTol using scale
RelTol = max(RelTol(:),AbsTol(:)./scl(:));

y = chebfun;
for j = 1:ncols
  chebfunpref('tol', RelTol(j))
  y(:,j) = chebfun(@(x) deval(sol,x,j)', [ends(1) ends(end)]);
end

% Return to user tolerance
chebfunpref('tol',usertol)

end