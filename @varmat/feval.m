function C = feval(A,n)
% FEVAL  Realize a varmat matrix at given dimension.

% Toby Driscoll, 14 May 2008.
% Copyright 2008.

C = A.defn(n);
if ~isempty(A.rowsel)
  C = C(A.rowsel(n),:);
elseif ~isempty(A.colsel)
  C = C(:,A.colsel(n));
end

end