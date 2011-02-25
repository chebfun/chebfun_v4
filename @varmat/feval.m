function C = feval(A,n)
% FEVAL  Realize a varmat matrix at given dimension.

% Copyright 2011 by The University of Oxford and The Chebfun Developers. 
% See http://www.maths.ox.ac.uk/chebfun/ for Chebfun information.

C = A.defn(n);
if ~isempty(A.rowsel)
  C = C(A.rowsel(n),:);
elseif ~isempty(A.colsel)
  C = C(:,A.colsel(n));
end

end