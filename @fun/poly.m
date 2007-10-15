function out = poly(f)
% POLY	Polynomial coefficients
% POLY(F) returns the polynomial coefficients of F.

% Copyright 2003 Zachary Battles, Chebfun Version 1.0
v=funpoly(f);
n=length(v);
tnold2=1;
tnold1=[0 1];
if (n==1)
  out = tnold2*v;
elseif (n==2)
  out = [0 v(2)*tnold2]+v(1)*tnold1(end:-1:1);
else
  temp = [0 v(end)*tnold2]+v(end-1)*tnold1(end:-1:1);
  for i=3:n
    tn=zeros(1,length(tnold1)+1);
    tn(2:end)=2*tnold1;
    tn=tn-[tnold2 0 0];
    out=v(end-i+1)*tn(end:-1:1);
    out=out+[0 temp];
    temp=out;
    tnold2=tnold1;
    tnold1=tn;
  end
%  out = tn(end:-1:1);
end
