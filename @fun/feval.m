function out = feval(g,x)
% Y = FEVAL(G,X)
% Evaluation of a fun G at points X. In the general case, this is done 
% using the barycentric formula in bary.m. However, if X is a vector of Chebyshev 
% nodes of length 2^n+1 then the evaluation is done using FFTs through
% prolong.m

% Number of points.
npts = length(x);

% Empty case.
if npts == 0
    out = [];
    return
end

% Evaluation at left and right points.
if npts == 1
    if x == 1;
        out = g.vals(end);
        return
    elseif x == -1
        out = g.vals(1);
        return
    end
end

% Evaluation at Chebyshev nodes -> use prolong (npts-1 must be a power of two)·
if npts == 1, power = 0; else power = log2(npts-1); end
if round(power) == power
    if norm(x(:) - chebpts(npts),inf) <= 1e-14*g.scl.h
        g2 = prolong(g,npts);
        out = g2.vals;
        return
    end
end

% All other cases, use Barycentric formula.
out = bary(x,g.vals);