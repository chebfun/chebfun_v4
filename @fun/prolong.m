function gout = prolong(g,nout)
% This function allows one to manually adjust the number of points.
% The output gout has length(gout) = nout (number of points).

m = nout - g.n;

% Trivial case
if m == 0
    gout = g;
    return
end
% Constant case
if g.n ==1
    gout = set(g,'vals', g.vals*ones(nout,1));
    return
end

if  (m<0 && nout<129 && g.n<1000)% Use barycentric to prolong
    gout = set(g,'vals',bary(chebpts(nout),g.vals));
else % Use FFTs to prolong
    c = chebpoly(g);  
    if m>=0
        % Simple case, add zeros as coeffs.
        gout = set(g,'vals',chebpolyval( [zeros(m,1); c] )); 
    else
        % To shorten a fun, we need to consider aliasing
        c = flipud(c);
        calias = zeros(nout,1);
        nn = 2*nout-2;
        calias(1) = sum(c(1:nn:end));        
        for k = 2:nout-1
            calias(k) = sum(c(k:nn:end))+sum(c(nn-k+2:nn:end));
        end
        calias(nout) = sum(c(nout:nn:end));
        calias = flipud(calias);
        gout = set(g,'vals',chebpolyval(calias)); 
    end
end