function [f,happy,values] = grow(op,ends,values)
% GROW Grows a fun
% Given a function handle or an in-line object, creates a FUN 
% rescaled to the interval [a b] with no more than 128 Chebyshev points. If
% the function in OP requires more points, the obtained FUN is not happy 
% (that is, HAPPY = 0).

% Debugging controls: ---------------------------------------------------
deb1 = 0;
% ---------------------------------------------------------------------
vs    = values.vs;
hs    = values.hs;
n = 2;
a = ends(1); b = ends(2);
converged = 0; % force to enter into the loop 
mn = getpref('chebfun_defaults','maxn');
switch getpref('chebfun_defaults','degree_mode')
     case 0,
         maxn = mn;
     case 1,
         table = values.table;
         if isempty(table)
             maxn = mn;
         else
             hmax = max(table(find(table(:,1)>=a & table(:,1)<=b),2));
             hmin = min(table(find(table(:,1)>=a & table(:,1)<=b),2));
             range = hmax-hmin;
             maxn = 4 + round((mn-4)/abs(log2(min(.5,diff(range)/vs))));
         end
     case 2
         maxn = 4 + round((mn-4)/abs(log2(min(.5,diff(ends)/hs))));
 end
%display(['    maxn -> ',num2str(maxn)])
while  not(converged)
    if n >= maxn, 
        happy = 0; 
        if getpref('chebfun_defaults','degree_mode') == 2
            values.table = unique([values.table; [x v]],'rows');
        end
        return;
    end
    n = n*2;
    f = fun;
    x = cheb(n,a,b);
    v = op(x);
    f = set(f,'val',v,'n',n);
    c = funpoly(f);
    
    % Rodrigo's suggestion--------------------------------
    % change this:
     vs = max(vs,norm(c,inf));
     epss = 1e-15;
     condition = epss*vs;
    %------------------------------------------------------
    % for this:
    %vs = norm(v,inf);
    %epss = 3e-16;
    %condition = epss*vs*sqrt(n);
    %------------------------------------------------------
    firstbig = min(find(abs(c)>= condition));
    converged = 0;
    if deb1
        c(find(c==0))=1e-25;
        semilogy(abs(c(end:-1:1))), drawnow;
        pause(.5)
    end
    if firstbig > 3
        if deb1
            c(find(c==0))=1e-25;
            semilogy(abs(c(end:-1:1))), drawnow;
            pause(.5)
        end
        c = c(firstbig:end);
        converged = 1;
    end
end
f = fun(c);
happy = 1;