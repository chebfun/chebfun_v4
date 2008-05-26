function C = feval(A,n)
% FEVAL  Realize a varmat matrix at given dimension.

% Copyright 2008 by Toby Driscoll.
% See www.comlab.ox.ac.uk/chebfun.

C = A.defn(n);
if ~isempty(A.rowsel)
  C = C(A.rowsel(n),:);
elseif ~isempty(A.colsel)
  C = C(:,A.colsel(n));
end

end