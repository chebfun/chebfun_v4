function edge = detectedge(f,a,b,hs,vs)
% EDGE = DETECTEDGE(F,A,B,HS,VS)
% Edge detection code used in auto.m 
%
% Detects a blowup in first, second, third, or fourth derivatives of 
% F in [A,B].
% HS is the horizontal scale and VS is the vertical scale.
% If no edge is detected, EDGE=[] is returned.
%

% Rodrigo Platte, 2007.

edge = [];

shift = eps*hs;

Nmax = 50;  
nder = 4;
N = round( min(Nmax, max(3*nder, Nmax+(Nmax-3*nder)*log10(b-a)/16) ) );
a=a+shift; 
b=b-shift;

[na,nb,maxd] = maxder(f,a,b,nder,N); maxd1=maxd;
ends = [na(nder) nb(nder)]; endsold=ends+1;

cont=1;
while maxd(nder)~=inf && ~isnan(maxd(nder)) && any(endsold~=ends)
    cont = cont +1;
    N = round(min(Nmax, max(3*nder, Nmax+(Nmax-3*nder)*log10(b-a)/16)));
    maxd1 = maxd(1:nder);
    [na,nb,maxd] = maxder(f, ends(1), ends(2), nder, N);
    if cont<4, nder = find( maxd > sqrt(N)*maxd1, 1, 'first' ); end
    if isempty(nder) || nder == 1, break, end;
    endsold = ends;
    ends = [na(nder) nb(nder)];
end
if nder == 1
    edge = findjump(f, a ,b, hs, vs);
elseif any(maxd1 > 1e+6*vs./hs.^(1:length(maxd1))')
    edge = mean(ends);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function edge = findjump(f, a, b, hs, vs)

edge = [];
ya=f(a); yb=f(b); 
dx=b-a; maxd=abs(ya-yb)/dx;
maxd1 = maxd/2;
e1=(b+a)/2;
e0=e1+1;
while (maxd>maxd1*(1.1) || maxd==inf) && e0~=e1
    c=(a+b)/2; yc=f(c); dx=dx/2;
    dy1=abs(yc-ya); dy2=abs(yb-yc);
    maxd1=maxd;
    if dy1>dy2
       b=c; yb=yc;
       maxd=dy1/dx;
    else
       a=c; ya=yc;
       maxd=dy2/dx;
    end 
    e0=e1;
    e1=(a+b)/2;
end
[na,nb,maxd] = maxder(f,a,b,2,4);
if maxd(end) > 1e+13*vs/hs^2
   yaleft=f(a-eps(a));
   if abs(yaleft-ya)>eps(a)*10*norm([yaleft,ya,yb],inf)
       edge = a;
   else
       edge = b;
   end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [na,nb,maxd] = maxder(f,a,b,nder,N)

maxd = zeros(nder,1);
na = a*ones(nder,1); nb = b*ones(nder,1);

dx = (b-a)/(N-1); 
x = [a+(0:N-2)*dx b];  
dy = f(x);

for j = 1:nder
    dy = diff(dy);
    x = (x(1:end-1)+x(2:end))/2;    
    [maxd(j),ind] = max(abs(dy));
    if ind>2,            na(j) = x(ind-1); end
    if ind<length(x)-2,  nb(j) = x(ind+1); end
end
if dx^nder <= eps(0), maxd= inf+maxd;
else maxd = maxd./dx.^(1:nder)';
end