function [f,happy] = grow(op,ends)
% GROW Grows a fun
% Given a function handle or an in-line object, creates a FUN 
% rescaled to the interval [a b] with no more than 128 Chebyshev points. If
% the function in OP requires more points, the obtained FUN is not happy 
% (that is, HAPPY = 0).
%
% Ricardo Pachon
n = 2;
a = ends(1); b = ends(2);
converged = 0; % force to enter into the loop 
maxn = 4 + round(128/abs(log2(min(.5,diff(ends)))));
while  not(converged)
    if n >= maxn, happy = 0; return; end
    n = n*2;
    f = fun;
    f = set(f,'val',op(cheb(n,a,b)),'n',n);
    c = funpoly(f);
    %display(n)
    [c,converged] = simplify(c);
end
f = fun(c);
happy = 1;