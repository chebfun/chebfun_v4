function C = mrdivide(A,B)
% /  Divide chebop by scalar.
% A/M for chebop A and scalar M returns (1/M)*A. No other syntax is
% supported.

% Toby Driscoll, 14 May 2008.
% Copyright 2008.

if ~isnumeric(B)
  error('chebop:mrdivide:noright','Right inverses not implemented.')
elseif numel(B)~=1
  error('chebop:mrdivide:scalaronly','May divide by scalars only.')
end

C = mtimes(1/B,A);

end