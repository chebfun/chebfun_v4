function A = subsref(A,s)

valid = false;
switch s(1).type
  case '{}'
    t = s(1).subs;
    if length(t)==1 && isnumeric(t{1})  % return a realization (matrix)
      n = t{1};
      A = feval(A,n);
      valid = true;
    end
  case '()'
    t = s(1).subs;
    if length(t)==2                 % define a slice
      A.rowsel = parseidx(t{1});
      A.colsel = parseidx(t{2});
      valid = true;
    end
end

if ~valid
  error('varmat:subsref:invalid','Invalid reference syntax.')
end

end

function sel = parseidx(idx)

if isequal(idx,':')
  sel = [];
elseif isnumeric(idx)
  if ~isinf(idx)
    sel = @(n) idx;
  else                          % "end" kludge
    sel = @(n) n+real(idx);
  end
else                            % assume function handle
  sel = idx;
end

end
