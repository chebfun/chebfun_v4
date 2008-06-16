function C = mpower(A,m)
% ^   Repeated application of a chebop.
% For chebop A and nonnegative integer M, A^M returns the chebop
% representing M-fold application of A.

% Copyright 2008 by Toby Driscoll.
% See www.comlab.ox.ac.uk/chebfun.

if ~((numel(m)==1)&&(m==round(m))&&(m>=0))
  error('oparray:mpower:argument','Exponent must be a nonnegative integer.')
end

s = A.blocksize;
if s(1)~=s(2) 
  error('oparray:mpower:square','Oparray must be square')
end

if (m > 0) 
  C = chebop(A.varmat^m, A.oparray^m, A.fundomain );
  C.difforder = m*A.difforder;
  C.blocksize = s;
else
  C = blockeye(A.fundomain,s(1));
end

end

