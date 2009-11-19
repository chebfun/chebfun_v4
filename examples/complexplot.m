% complexplot.m  Show image of unit square under complex functions
  x = chebfun('x'); S = chebfun;      
  for d = -1:.2:1, S = [S d+1i*x 1i*d+x]; end
  while true
    s = input('function of z to plot? (in quotes) ');
    f = inline(s);
    plot(f(S),'b'), shg, axis equal
  end
