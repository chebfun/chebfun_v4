function [f,happy,values] = grow_rodp(op,ends,values,n,mn)
% GROW Grows a fun
% Given a function handle or an in-line object, creates a FUN 
% rescaled to the interval [a b] with no more than 128 Chebyshev points. If
% the function in OP requires more points, the obtained FUN is not happy 
% (that is, HAPPY = 0).

if nargin<4
    n=8; mn=256;
end
vs = values.vs;
hs = values.hs;

a = ends(1); b = ends(2);
converged = 0; 

maxn = mn;
f=fun;

htol=1e-15*hs;
a=a+htol;
b=b-htol;

if b-a <= htol
    happy=1;
    f = set(f,'val',op([a (a+b)/2 b]'),'n',2);
    values.vs=max(values.vs,norm(op([a (a+b)/2 b]),inf));
    return
end

x = .5*((b-a)*cos((0:n)'*(pi/n))+(b+a));
v = op(x);
     
while  not(converged)
    
    n = n*2;
    if n >= maxn, 
        happy = 0; 
        f = fun(c);
        return;
    end

    xnew = .5*((b-a)*cos((1:2:n-1)'*(pi/n))+(b+a));
    v(1:2:n+1)=v; v(2:2:n) = op(xnew);
    x(1:2:n+1)=x; x(2:2:n) = xnew;

    f = set(f,'val',v,'n',n);
    c = funpoly(f);
 
    vs = max(values.vs,norm(v,inf));
    condition =2^-52*vs*max(max((hs/vs)*abs(diff(v)./diff(x))),1);
    
    firstbig = find(abs(c)>= condition,1,'first');
    converged = 0;
    if firstbig > 6
        c = c(firstbig:end);
        converged = 1;
    end
    
end

f = fun(c);
happy = 1;
values.vs=vs;