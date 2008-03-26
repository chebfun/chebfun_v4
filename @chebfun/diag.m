function A = diag(f)

mat = @(n) spdiags( feval( f, scaledpts(n,domain(f)) ) ,0,n,n);
oper = @(u) times(f,u);
A = chebop( mat, oper, domain(f)  );

  function x = scaledpts(n,dom)
    x = scale( -cos(pi*(0:n-1)'/(n-1)), dom(1), dom(2) );
  end

end