function g = growfun(op,g,n)
% Generates a fun with at most n points.
% A fun is happy if the simplify command returns a shorter fun. 

% Check preferences 
split = chebfunpref('splitting');
resample = chebfunpref('resample');
minn = chebfunpref('minn');

% Sample using powers of 2.
npower = floor(log2(n-1));
minpower = max(1,floor(log2(minn-1)));

% Number of nodes to be used 
if 2^npower+1 ~= n
    kk = [2.^(minpower:npower)+1 n];
else
    kk = 2.^(minpower:npower) + 1;
end

if ~resample && 2^npower+1 == n
    
    % single sampling
    ind =1;
    v = op(chebpts(kk(ind)));
    while kk(ind)<=kk(end)        
        g = set(g,'vals',v);
        g = simplify(g);
        if g.n < kk(ind) || ind==length(kk), break, end        
        ind =ind+1;
        x = chebpts(kk(ind));
        v(1:2:kk(ind)) = v; 
        
        % In splitting on mode, consider endpoints (see getfun.m)
        if split
            newv = op([-1;x(2:2:end-1);1]); 
            v(2:2:end-1) = newv(2:end-1);
        else
            v(2:2:end-1) = op(x(2:2:end-1));
        end
    end

else
    
    % double sampling (This is the standard way of growing a fun)
    for k = kk
        g = set(g,'vals',op(chebpts(k)));
        g = simplify(g);
        if g.n < k, break, end
    end
    
end
