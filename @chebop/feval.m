function M = feval(A,n)

if length(A.realization)>=n && ~isempty(A.realization{n})
  M = A.realization{n};
else
  M = A.op(n);
end
