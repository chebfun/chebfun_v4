function r = introots(f)
% INTROOTS	Roots in the interval [-1,1]
% INTROOTS(F) returns the roots of F in the interval [-1,1].

% Copyright 2003 Zachary Battles, Chebfun Version 1.0
if (f.n<100)
  r=roots(f);
  r=r(abs(imag(r))<eps);
  r=sort(r(abs(r)<=1-1e-11)); % Modified, used to be 1+1e-10
else
  c=rand(1,1)*.2-.1;
  g=cheb(f.n);
  f1=simplify(fun('',bary(-1+.5*(g+1)*(1+c),f.val)));
  f2=simplify(fun('',bary(c+.5*(g+1)*(1-c),f.val)));
  r=[-1+(introots(f1)+1)*.5*(1+c);c+(introots(f2)+1)*.5*(1-c)];
end