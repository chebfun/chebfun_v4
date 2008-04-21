function out = poly(f,n)
% POLY	Polynomial coefficients
% POLY(F) returns the polynomial coefficients of the first fun of F. 
% POLY(F,N) returns the polynomial coefficients of the Nth fun of F.

% Chebfun Version 2.0

nfuns = f.nfuns;
if nargin == 1
    if nfuns>1
        warning('Chebfun has more than one fun. Only the polynomial coefficients of the first one are returned');
    end
    a = f.ends(1); b = f.ends(2);
    out = scale(polyfun(f.funs(1)),a,b);
else
    if n>nfuns
        error(['Chebfun only has ',num2str(nfuns),' funs'])
    else
        a = f.ends(n); b = f.ends(n+1);
        out = scale(polyfun(f.funs(n)),a,b);
    end
end

%% old fun/poly    
function out = polyfun(f)
% POLY	Polynomial coefficients
% POLY(F) returns the polynomial coefficients of F.

% Copyright 2003 Zachary Battles, Chebfun Version 1.0
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
%  out = tn(end:-1:1);
end
