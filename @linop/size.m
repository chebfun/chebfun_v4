function varargout = size(A,dim)
% SIZE   Return the block size of a chebop.
% The usual syntax of SIZE applies.
%
% See also size.

% Copyright 2008 by Toby Driscoll.
% See www.comlab.ox.ac.uk/chebfun.

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
