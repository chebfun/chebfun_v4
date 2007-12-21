function [f,happy,values] = grow_rodp(op,ends,values,n,mn)
% GROW Grows a fun
% Given a function handle or an in-line object, creates a FUN 
% rescaled to the interval [a b] with no more than 128 Chebyshev points. If
% the function in OP requires more points, the obtained FUN is not happy 
% (that is, HAPPY = 0).

if nargin<4
    n=16; mn=256;
end
vs    = values.vs;
hs    = values.hs;

a = ends(1); b = ends(2);
converged = 0; % force to enter into the loop 

maxn = mn;

if b-a <= 1e-12*hs
    happy=1;
    f=fun;
    f = set(f,'val',op([a (a+b)/2 b]'),'n',2);
    values.vs=max(values.vs,norm(op([a (a+b)/2 b]),inf));
    return
end
    
while  not(converged)
    if n >= maxn, 
        happy = 0; 
        f = fun(c);
        return;
    end
    xch=cos((2*(1:n)-1)*pi/(2*n));
    x = 0.5*b*((1-a/b)*xch+1+a/b);
    v = op(x);
    
     c=fliplr(dct(v)) ;
     c=[c(1:end-1)/sqrt(n/2), c(end)/sqrt(n)];
 
     vs = max(values.vs,norm(v,inf));
     epss = 5e-16;
     condition = epss*vs*sqrt(n)*max(log2(hs*(b-a))^2,1);

     firstbig = find(abs(c)>= condition,1,'first');
    converged = 0;
    if firstbig > 6
        c = c(firstbig:end);
        converged = 1;
    end
    n = n*2;
end
f = fun(c);
happy = 1;
values.vs=vs;