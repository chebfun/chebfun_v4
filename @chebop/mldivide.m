function C = mldivide(A,B)

% Possible uses (A and B are chebops, f is a chebfun):
%  A\f

switch(class(B))
%  case 'chebop'
%    C = chebop;
%    C.op = @(n) A.op(n) \ B.op(n);
  case 'chebfun'
    [L,rowrep] = feval(A,8);
    if length(rowrep)~=A.difforder
      warning('chebop:mldivide:bcnum',...
        'Operator may not have the correct number of boundary conditions.')
    end
    if isa(A.scale,'chebfun') || isa(A.scale,'function_handle')
      C = chebfun( @(x) A.scale(x)+value(x), domain(B) ) - A.scale;
    else
      C = chebfun( @(x) A.scale+value(x), domain(B) ) - A.scale;
    end
  otherwise
    error('chebop:mtimes:badoperand','Unrecognized operand.')
end

  % NB: flipud() needed for compatability with old chebfuns.
  function v = value(x)
    N = length(x);
    if N > 1025
      error('failure to converge')
    end
    L = feval(A,N);  % includes row replacements
    f = B(flipud(x));
    for k = 1:length(A.lbc)
      if ~isempty(A.lbc(k).val)
        f(k) = A.lbc(k).val;
      end
    end      
    for k = 1:length(A.rbc)
      if ~isempty(A.rbc(k).val)
        f(N+1-k) = A.rbc(k).val;
      end
    end      
    v = L\f;
    v = filter(flipud(v),1e-8);
  end

end