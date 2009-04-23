%ODE113  Represent initial-value problem solution using chebfuns.
%
% Y = ODE113(ODEFUN,D,...) applies the standard ODE113 method to solve an
% initial-value problem on the domain D. The result is then converted to a
% piecewise-defined chebfun or quasimatrix with one column per solution 
% component.
%
% One can also write [T,Y] = ODE113(...).
%
% CHEBFUN/ODE113 has the same calling sequence as Matlab's standard ODE113, 
% except that instead of a TSPAN vector like  [T0 TFINAL], it takes a TSPAN
% domain like domain(T0,TFINAL). The presence of this argument from the 
% domain class signals Matlab to use the chebfun version of ODE113 rather 
% than the standard version.
%
% Example:
%   y = ode113(@vdp1,domain(0,20),[2;0]); % solve Van der Pol problem
%   roots( y(:,1)-1 )   % find times when first component is 1
%
% See also ode113, odeset, domain/ode15s, domain/ode45
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2009 by The Chebfun Team. 

% This is a dummy file. The actual code is under @domain.
