function C = mldivide(A,B)

% Possible uses (A and B are chebops, f is a chebfun):
%  A\f
%  A\B

switch(class(B))
  case 'chebop'
    C = chebop;
    C.op = @(n) A.op(n) \ B.op(n);
  case 'chebfun'
    cons = A.constraint;  % to shorten the names below
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
    L = feval(A,N);
    f = B(flipud(x));
    for k = 1:length(cons)
      L(cons(k).idx(N),:) = cons(k).row(N);
      f(cons(k).idx(N)) = cons(k).val;
    end      
    v = flipud(L\f);
    v = filter(v,1e-8);
  end

end