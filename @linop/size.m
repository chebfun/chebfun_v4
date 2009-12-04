function varargout = size(A,dim)
% SIZE   Return the block size of a linop.
% The usual syntax of SIZE applies.
%
% See also size, linop/blkdiag.
% See http://www.maths.ox.ac.uk/chebfun.

% Copyright 2008 by Toby Driscoll.

%  Last commit: $Author$: $Rev$:
%  $Date$:

bs = A.blocksize;
if nargin > 1
  bs = bs(dim);
end
if nargout>1
  varargout = num2cell(bs);
else
  varargout = { bs };
end

end
