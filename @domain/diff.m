function D = diff(d,m)
% DIFF Differentiation operator.
% D = DIFF(R) returns a chebop representing differentiation for chebfuns 
% defined on the domain R. 
%
% D = DIFF(R,M) returns the chebop for M-fold differentiation. 
%
% See also CHEBOP, CHEBFUN/DIFF.

% Copyright 2002-2008 by The Chebfun Team. See www.comlab.ox.ac.uk/chebfun.

if isempty(d)
  D = chebop;
else
  D = chebop( @(n) diffmat(n)*2/length(d), @(u) diff(u), d, 1 );
  if nargin > 1
    D = mpower(D,m);
  end
end

end