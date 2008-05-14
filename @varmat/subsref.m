function A = subsref(A,s)
% SUBSREF  Row or column reference, or matrix realization.
% V{N} produces the size-N matrix realization of varmat V.
%
% V(I,J) creates a new varmat with selected rows and columns of V. Each
% index I and J can be a ':', one or more fixed numbers, the keyword 'end',
% or a function of N.

% Toby Driscoll, 14 May 2008.
% Copyright 2008.

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
elseif isa(idx,'function_handle')
  sel = idx;
else
  error('varmat:subsref:badindex',...
    'Index must be a :, value, or function handle.')
end

end
