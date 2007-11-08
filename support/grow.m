function [f,happy,table] = grow(op,ends,table)
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

% if isempty(table)
%     maxn = 128;
% else
%     H = max(abs(table(:,2)));
%     hmax = max(table(find(table(:,1)>=a & table(:,1)<=b),2));
%     hmin = min(table(find(table(:,1)>=a & table(:,1)<=b),2));
%     h = hmax - hmin;
%     if isempty(h), maxn = 128; end
%     maxn = 4 + ceil(log2(1+h/(2*eps*H)));
% end
maxn = 4 + round(128/abs(log2(min(.5,diff(ends)))));

while  not(converged)
    if n >= maxn, happy = 0; return; end
    n = n*2;
    f = fun;
    x = cheb(n,a,b);
    v = op(x);
    f = set(f,'val',v,'n',n);
    c = funpoly(f);
    %display(n)
    [converged,neweps]=convergencetest(op,c,1e-13,a,b);
    [c] = simplify(c);

    %table = unique([table; [x v]],'rows');
end
f = fun(c);
happy = 1;