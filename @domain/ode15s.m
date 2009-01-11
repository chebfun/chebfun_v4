function y = ode15s(varargin)
%ODE15S  Represent initial-value problem solution using chebfuns.
%
% Y = ODE15S(ODEFUN,D,...) applies the standard ODE15S method to solve an
% initial-value problem on the domain D. The result is then converted to a
% piecewise-defined chebfun or quasimatrix with one column per solution 
% component.
%
% Example:
%   y = ode15s(@vdp1000,domain(0,3000),[2;0]); % solve Van der Pol problem
%   roots( y(:,1)-1 );   % find times when first component is 1
%
% See also ode15s, odeset, domain/ode113, domain/ode45

% Copyright 2009 by The Chebfun Team. See www.comlab.ox.ac.uk/chebfun.

% Convert domain to 2-vector of endpoints.
j = find( cellfun('isclass',varargin,'domain') );
varargin{j} = varargin{j}.ends;

y = odesol( ode15s(varargin{:}) ); 

end