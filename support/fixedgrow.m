function [f,happy] = fixedgrow(op,ends)
% FIXEDGROW Grows a "classic" fun, that is, a Zachary Battles' chebfun.
% Given a function handle or an in-line object, creates a FUN 
% rescaled to the interval [a b] with no more than 2^16 Chebyshev points. If
% the function in OP requires more points, a warning message is returned.

% Pachon, Platte, Trefethen, 2007

% Debugging controls: ---------------------------------------------------
deb1 = 1;
% ---------------------------------------------------------------------

n = 2;
a = ends(1); b = ends(2);
converged = 0; % force to enter into the loop 
maxn = getpref('chebfun_defaults','maxn');

while  not(converged)
    if n >= maxn, 
        warning(['Function may not converge, using 2^16 points.'...
                 '  Have you tried typing ''split on''?']);
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
    vs = norm(c,inf);
    epss = 1e-15;
    condition = epss*vs;
    %------------------------------------------------------
    % for this:
    % vs = norm(v,inf);
    % epss = 3e-16;
    % condition = epss*vs*sqrt(n);
    %------------------------------------------------------ 
    firstbig = min(find(abs(c)>= condition));
    converged = 0;
    if deb1
        semilogy(abs(c(end:-1:1))), drawnow;
        pause(.1)
    end
    if firstbig > 3 
        if deb1
            semilogy(abs(c(end:-1:firstbig))), drawnow;
        end
        c = c(firstbig:end);
        converged = 1;
    end
end
f = fun(c);
happy = 1;
