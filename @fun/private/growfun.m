function g = growfun(op,g,n,g1,g2)
% G = GROWFUN(OP,G,N,G1,G2)
%
% G = GROWFUN(OP,G,N) returns the fun G representing the function handle OP.
%   N is the maximum number of points allowed in the representation.
%
% G = GROWFUN(OP,G,N,G1) returns the fun G representing the composition 
%   OP(G1), where G1 is a fun. 
%
% G = GROWFUN(OP,G,N,G1,G2) returns the fun G representing the composition 
%   OP(G1,G2), where G1 and G2 are funs.
%

% Copyright 2002-2008 by The Chebfun Team. See www.comlab.ox.ac.uk/chebfun/

% Check preferences 
split = chebfunpref('splitting');
resample = chebfunpref('resampling');

% Set minn 
if nargin == 4
    minn = max(5, g1.n);
elseif nargin == 5
    minn = max([5, g1.n, g2.n]);
else
    minn = chebfunpref('minsamples');
end
    
% Sample using powers of 2.
npower = floor(log2(n-1));
minpower = max(2,ceil(log2(minn-1)));

% Number of nodes to be used 
if 2^npower+1 ~= n
    kk = [2.^(minpower:npower)+1 n];
else
    kk = 2.^(minpower:npower) + 1;
end

% ---------------------------------------------------
% composition case, i.e., want gout = op(g) (see FUN/COMP.M)
if nargin > 3
    for k = kk
        v1 = get(prolong(g1,k),'vals');
        if nargin == 5
            v2 = get(prolong(g2,k),'vals');
            v = op(v1,v2);
        else
            v = op(v1);
        end
        g = set(g,'vals', v);
        g = simplify(g);
        if g.n < k, break, end
    end
    return
end
% ---------------------------------------------------

if  ~resample && 2^npower+1 == n && nargin<4
    
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
    
     % Check for NaN's or Inf's    
     if any(isnan(g.vals)) || isinf(g.scl.v)
        error('CHEBFUN:growfun:naneval','Function returned NaN or Inf when evaluated.')
     end
    
end
