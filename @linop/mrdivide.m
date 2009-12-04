function C = mrdivide(A,B)
% /  Divide linop by scalar.
% A/M for linop A and scalar M returns (1/M)*A. No other syntax is
% supported.

% See www.maths.ox.ac.uk/chebfun.

% Copyright 2008 by Toby Driscoll.
%  Last commit: $Author$: $Rev$:
%  $Date$:

if ~isnumeric(B)
  error('linop:mrdivide:noright','Right inverses not implemented.')
elseif numel(B)~=1
  error('linop:mrdivide:scalaronly','May divide by scalars only.')
end

C = mtimes(1/B,A);

end