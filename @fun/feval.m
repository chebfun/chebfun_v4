function out = feval(g,x)
% Y = FEVAL(G,X)
% Evaluation of a fun G at points X. In the general case, this is done 
% using the barycentric formula in bary.m. However, if X is a vector of Chebyshev 
% nodes of length 2^n+1 then the evaluation could be done using FFTs through
% prolong.m (faster).
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2009 by The Chebfun Team. 
% Last commit: $Author$: $Rev$:
% $Date$:

exps = g.exps;
ends = g.map.par(1:2);

if isfield(g.map,'inv')    
    z = g.map.inv(x);
    
    % Make sure +inf and -inf get mapped to +1 or -1 to avoid NaNs in
    % inverse map
    if any(isinf(g.map.par([1 2])))
        mask = isinf(x); z(mask) = sign(x(mask));
    end
    
    out = bary(z,g.vals);    
else
    n = g.n;
    xk = chebpts(n); 
    out = bary(x,g.vals,g.map.for(xk));
end

if any(g.exps) 
    
    % hack for unbounded functions on infinite intervals
    if any(isinf(ends))
        ends = [-1 1];   x = g.map.inv(x);
    end
    
    rescl = (2/diff(ends))^-sum(exps);
    out = out.*((x-ends(1)).^exps(1).*(ends(2)-x).^exps(2))/rescl;
end