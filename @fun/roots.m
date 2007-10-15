function r = roots(f)
% ROOTS	Find polynomial roots
% ROOTS(F) finds the polynomial roots of F.

% Copyright 2003 Zachary Battles, Chebfun Version 1.0
f=simplify(f);
c=funpoly(f);
if (f.n<2)
  r=roots(funpoly(f));
else
  c=.5*c(end:-1:2)/-c(1);
  c(end-1)=c(end-1)+.5;
  oh=.5*ones(length(c)-1,1);
  A=diag(oh,1)+diag(oh,-1);
  A(1,2)=1;
  A(end,:)=c;
  r=eig(A);
  i=find(abs(imag(r))<1e-14);
  r(i)=real(r(i));
end