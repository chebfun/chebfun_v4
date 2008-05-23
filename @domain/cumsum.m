function J = cumsum(d,m)
% CUMSUM Indefinite integration operator.
% Q = CUMSUM(D) returns a chebop representing indefinite integration (with
% zero endpoint value) on the domain D.
%
% Q = CUMSUM(D,M) returns the chebop for M-fold integration. 
%
% See also CHEBOP, CHEBFUN/CUMSUM.

% Copyright 2002-2008 by The Chebfun Team. See www.comlab.ox.ac.uk/chebfun.

if isempty(d)
  J = chebop;
else
  J = chebop( @(n) cumsummat(n)*length(d)/2, @(u) cumsum(u), d, -1 );
  if nargin > 1
    J = mpower(J,m);
  end
end

end