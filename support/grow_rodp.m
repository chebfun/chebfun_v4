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
    n = n*2;
    x = cheb(n,a,b); 
    v = op(x);
    
% ------------------------------------------    
    %f = fun;
    %f = set(f,'val',v,'n',n);%%%%%
    %c = funpoly(f);
    c=[v;v(end-1:-1:2,:)]; 
    if (isreal(v))
      c = real(fft(c))/(2*n);
    elseif (isreal(1i*v))
      c = 1i*imag(fft(c))/(2*n);
    else
      c = fft(c)/(2*n);
    end
    c=(c(n+1:-1:1,:));
    if (n>1), c(2:end-1,:)=2*c(2:end-1,:); end
    c=c.';
% -----------------------------------------------

    % Rodrigo's suggestion--------------------------------
    % change this:
%      vs = max(vs,norm(c,inf));
%      epss = 1e-13;
%      condition = epss*vs;
    %------------------------------------------------------
    % for this:
     vs = max(values.vs,norm(v,inf));
     epss = 5e-15;
     condition = epss*vs*sqrt(n);
    %----------------------------------------------------
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