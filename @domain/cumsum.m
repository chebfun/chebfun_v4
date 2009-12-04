function J = cumsum(d,m)
% CUMSUM Indefinite integration operator.
% Q = CUMSUM(D) returns a linop representing indefinite integration (with
% zero endpoint value) on the domain D.
%
% Q = CUMSUM(D,M) returns the linop for M-fold integration. 
%
% See also linop, chebfun.cumsum.
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2008 by The Chebfun Team. 

%  Last commit: $Author$: $Rev$:
%  $Date$:

if isempty(d)
  J = linop;
else
  J = linop( @(n) cumsummat(n)*length(d)/2, @(u) cumsum(u), d, -1 );
  if nargin > 1
    J = mpower(J,m);
  end
end

end