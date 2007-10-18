function F = auto(op,f,f2)
% Original private function for fun. Adaptively procedure to compute the 
% Chebyshev coefficients of a chebfun.

if isa(op,'char'), op = inline(op); end %% string -> inline object

maxn = 2^16;
if (isempty(f)), F = fun; return; end
epsauto = 1e-15;
if nargin<3
    n = 4;
    cf = prolong(f,n); % starting degree
    cf.val = op(cf.val);
    c = funpoly(cf);
    [converged,neweps]=convergencetest(c,epsauto);
    while (~converged && n <maxn)
        n = n*2;  % try doubling degree
        cf = prolong(f,n);
        cf.val = feval(op,cf.val);
        c = funpoly(cf);
        [converged,neweps]=convergencetest(c,epsauto);
    end
else
    n = 2*f.n+2*f2.n+4;
    cf = prolong(f,n);
    cf2 = prolong(f2,n);
    cf.val = feval(op,cf.val,cf2.val+eps*(cf2.val==0));
    c = funpoly(cf);
    [converged,neweps]=convergencetest(c,epsauto);
    while (~converged && n<maxn)
        n = n*2;
        cf = prolong(f,n);
        cf2 = prolong(f2,n);
        cf.val = feval(op,cf.val,cf2.val+eps*(cf2.val==0));
        c = funpoly(cf);
        [converged,neweps]=convergencetest(c,epsauto);
    end
end
if (n>=maxn || sum(isnan(cf.val)) || sum(isinf(cf.val)))
    F = cf;
    F = prolong(F,maxn);
    warning('Function may not converge, using 2^16 points.');
else
    if neweps>epsauto
        warning(['Using tolerace ', num2str(neweps),' instead of ', num2str(epsauto)])
    end    
    F = simplify(cf); % discard coeffs. close to zero.
    if (F.val ==0), F.val = 0 ; F.n = 0; end
end

      