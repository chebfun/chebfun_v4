function out = poly(f)
% POLY	Polynomial coefficients of a fun.
% POLY(F) returns the polynomial coefficients of F.
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2008 by The Chebfun Team. 

v=chebpoly(f);
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
end
