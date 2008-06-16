function C = mtimes(A,B)
% *  Matrix multiplication of varmats, with scalar expansion.

% Copyright 2008 by Toby Driscoll.
% See www.comlab.ox.ac.uk/chebfun.

if isnumeric(B)
  n = size(B,1);
  C = feval(A,n)*B;
else
  C = op_scalar_expand(@mtimes,A,B);
end

end
  