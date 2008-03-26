function C = feval(A,n)

C = A.defn(n);
if ~isempty(A.rowsel)
  C = C(A.rowsel(n),:);
elseif ~isempty(A.colsel)
  C = C(:,A.colsel(n));
end

end