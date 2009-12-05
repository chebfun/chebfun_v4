function C = mpower(A,m)
% ^   Repeated composition of a chebop.
% For chebop A and nonnegative integer M, A^M returns the linop
% representing M-fold application of A.

% See http://www.maths.ox.ac.uk/chebfun.

% Copyright 2009 by Toby Driscoll.
%  Last commit: $Author$: $Rev$:
%  $Date$:

if ~((numel(m)==1)&&(m==round(m))&&(m>=0))
  error('chebop:mpower:argument','Exponent must be a nonnegative integer.')
end

if (m > 0) 
  C = A;  % change if ID's are added!
  for k = 1:m-1
    C = A*C;
  end
else
  C = eye(A.dom);
end

end

