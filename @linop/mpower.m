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
  
  % Find the zeros
  isz = ~double(~A.iszero)^m;
  
  % Get the difforder
  difforder = A.difforder;
  for j = 2:m
      [jj kk] = meshgrid(1:s(1),1:s(2));
      order = zeros(numel(jj),s(2));
      for l = 1:size(A,2)
          order(:,l) = difforder(jj,l)+A.difforder(l,kk)';
      end
      order = max(order,[],2);
      difforder = reshape(order,s(1),s(2));
  end
%   difforder = m*A.difforder;
  difforder(isz) = 0;

 
  C.difforder = difforder;
  C.blocksize = s;
  C.iszero = isz;
else
  C = blockeye(A.fundomain,s(1));
end

end

