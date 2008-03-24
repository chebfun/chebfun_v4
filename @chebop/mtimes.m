function C = mtimes(A,B)

if isa(A,'double')
  C=A; A=B; B=C;    % swap to make A a chebop
end

switch(class(B))
  case 'double'
    C = chebop( @(n) B*feval(A,n) );
  case 'chebop'
    C = chebop( @(n) feval(A,n) * feval(B,n) );
  case 'chebfun'
    % Requires some scale or refinement control.
    C = chebfun( @(x) value(x), domain(B) );
  otherwise
    error('chebop:mtimes:badoperand','Unrecognized operand.')
end

  % NB: We are assuming x(1)=-1, but using old chebfuns for now.
  function v = value(x)
    N = length(x);
    v = flipud(A.op(N)*B(flipud(x)));
    v = filter(v,1e-8);
  end

  function v = limitedvalue(x,Nmax)
    % Use band-limited kludge to avoid large N in adaptive refinement.
    N = length(x)-1;
    if N<=Nmax
      v = value(x);
    else
      xx = cos(-pi*(0:Nmax)'/Nmax);
      vv = value(xx);
      p = cd2cp(flipud(vv));
      v = chebeval(p,x);
    end
  end

end