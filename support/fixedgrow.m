function [f,happy] = fixedgrow(op,ends)
% FIXEDGROW Grows a "classic" fun, that is, a Zachary Battles' chebfun.
% Given a function handle or an in-line object, creates a FUN 
% rescaled to the interval [a b] with no more than 2^16 Chebyshev points. If
% the function in OP requires more points, a warning message is returned.

% Pachon, Platte, Trefethen, 2007

n = 2;
a = ends(1); b = ends(2);
converged = 0; % force to enter into the loop 
maxn = 2^16;

while  not(converged)
    if n >= maxn, 
        warning(['Function may not converge, using 2^16 points.'...
                 '  Have you tried typing ''spliton''?']);
        return; 
    end
    n = n*2;
    f = fun;
    x = cheb(n,a,b);
    v = op(x);
    f = set(f,'val',v,'n',n);
    c = funpoly(f);
    vs = norm(c,inf);
    % This code segment comes from old support/simplify.m
    epss = 1e-13;
    % condition = max(epss,epss*norm(c,'inf'))*vs;  % simplify this!
    condition = epss*vs;
    firstbig = min(find(abs(c)>= condition));
    converged = 0;
    if firstbig > 3
        c = c(firstbig:end);
        converged = 1;
    end
end
f = fun(c);
happy = 1;
