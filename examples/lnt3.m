% lnt3.m  Find total variation of f  -  LNT 12/2005

 x = chebfun('x',[0,2*pi]);
 f = cos(x);
 plot(f)
 total_variation = norm(diff(f),1)