function g = extrapolate(g,pref,x)
% Extrapolate at endpoints if needed using "Fejer's 2nd rule" type of
% barycentric formula. Also updates the vertical scale of g.

g.scl.v = max(g.scl.v,norm(g.vals(2:end-1),inf));

if pref.splitting || any(g.exps) || any(isnan(g.vals([1 end]))) || any(isinf(g.vals([1 end])))
    
    if nargin < 3
        x = chebpts(g.n);
    end
    
    vends = g.vals([1 end]);
    xi = x(2:end-1);
    w = (1+xi); w(2:2:end) = -w(2:2:end);
    g.vals(end) = sum(w.*g.vals(2:end-1))/sum(w);
    w = (1-xi); w(2:2:end) = -w(2:2:end);
    g.vals(1) = sum(w.*g.vals(2:end-1))/sum(w);
    
    if ~isnan(vends(1)) && abs(g.vals(1)-vends(1)) < 1e4*pref.eps*g.scl.v && ~g.exps(1) && ~isinf(g.map.par(1))
        g.vals(1) = vends(1);
    end
    if ~isnan(vends(2)) && abs(g.vals(end)-vends(2)) < 1e4*pref.eps*g.scl.v && ~g.exps(2) && ~isinf(g.map.par(2))
        g.vals(end) = vends(end);
    end
    
end

g.scl.v = max(g.scl.v,norm(g.vals([1 end]),inf));