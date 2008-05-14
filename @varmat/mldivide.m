function C = mldivide(A,B)
%MLDIVIDE Backslash for two varmats.

% Toby Driscoll, 14 May 2008.
% Copyright 2008.

C = varmat( @(n) feval(A,n) \ feval(B,n) );

end
  