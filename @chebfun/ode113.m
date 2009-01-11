function y = ode113(varargin)
%ODE113  Represent initial-value problem solution using chebfuns.
%
% Y = ODE113(ODEFUN,D,...) applies the standard ODE113 method to solve an
% initial-value problem on the domain D. The result is then converted to a
% piecewise-defined chebfun or quasimatrix with one column per solution 
% component.
%
% Example:
%   y = ode113(@vdp1,domain(0,20),[2;0]); % solve Van der Pol problem
%   roots( y(:,1)-1 )   % find times when first component is 1
%
% See also ode113, odeset, domain/ode15s, domain/ode45

% Copyright 2009 by The Chebfun Team. See www.comlab.ox.ac.uk/chebfun.

% This is a dummy function. The actual code is under @domain