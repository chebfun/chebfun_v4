function A = subsref(A,s)

valid = false;
switch s(1).type
  case '()'
    t = s(1).subs;
    if length(t)==1 && isnumeric(t{1})
      n = t{1};
      L = A.op(n);
      if ~isempty(A.rowidx)
        L = L(A.rowidx(n),:);
      end
      A = L;
      valid = true;
    elseif length(t)==2 && isequal(t{2},':')
      if isequal(t{1},':')
        A.rowidx = [];
      else
        idx = t{1};
        if isnumeric(idx)
          A.rowidx = @(n) idx;
        else
          A.rowidx = idx;
        end
      end
      valid = true;
    end
end

if ~valid
  error('chebop:subsref:invalid','Invalid reference syntax.')
end
