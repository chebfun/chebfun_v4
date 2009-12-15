function C = mpower(A,m)
% ^   Repeated application of a linop.
% For linop A and nonnegative integer M, A^M returns the linop
% representing M-fold application of A.

% See http://www.maths.ox.ac.uk/chebfun.

% Copyright 2008 by Toby Driscoll.
%  Last commit: $Author$: $Rev$:
%  $Date$:

if ~((numel(m)==1)&&(m==round(m))&&(m>=0))
  error('LINOP:mpower:argument','Exponent must be a nonnegative integer.')
end

s = A.blocksize;
if s(1)~=s(2) 
  error('LINOP:mpower:square','Oparray must be square')
end

if (m > 0) 
  C = linop(A.varmat^m, A.oparray^m, A.fundomain );
  C.difforder = m*A.difforder;
  C.blocksize = s;
else
  C = blockeye(A.fundomain,s(1));
end

end

