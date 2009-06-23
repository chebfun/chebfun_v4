function g = growfun(op,g,n,pref,g1,g2)
%  GROWFUN samples OP to generate a FUN adaptively
%
% G = GROWFUN(OP,G,N,PREF) returns the fun G representing the function handle OP.
%   N is the maximum number of points allowed in the representation.
%
% G = GROWFUN(OP,G,N,PREF,G1) returns the fun G representing the composition 
%   OP(G1), where G1 is a fun. 
%
% G = GROWFUN(OP,G,N,PREF,G1,G2) returns the fun G representing the composition 
%   OP(G1,G2), where G1 and G2 are funs.
%
% PREF is the chebfun preference structure (see chebfunpref).
%


% Check preferences 
split = pref.splitting;
resample = pref.resampling;

% Set minn 
if nargin == 5
    minn = max(5, g1.n);
elseif nargin == 6
    minn = max([5, g1.n, g2.n]);
else
    minn = pref.minsamples;
end
    
% Sample using powers of 2.
minpower = max(2,ceil(log2(minn-1)));
npower = max(minpower,floor(log2(n-1)));

% Number of nodes to be used 
if resample
  npn = max(min(npower,6),minpower);
  kk = 1 + round(2.^[ (minpower:npn) (2*npn+1:2*npower)/2 ]);
%   if kk(end)~=n,  kk(end+1) = n; end
else
  kk = 2.^(minpower:npower) + 1;
end
    
% ---------------------------------------------------
% composition case, i.e., want gout = op(g) (see FUN/COMP.M)
if nargin > 4
    for k = kk
        v1 = get(prolong(g1,k),'vals');
        if nargin == 6
            v2 = get(prolong(g2,k),'vals');
            v = op(v1,v2);
        else
            v = op(v1);
        end
        g = set(g,'vals', v);
        g = simplify(g,pref.eps);
        if g.n < k, break, end
    end
    return
end
% ---------------------------------------------------

if  ~resample && 2^npower+1 == n && nargin<5
    
    % single sampling
    ind =1;
    x = chebpts(kk(ind));
    v = op(x);
    while kk(ind)<=kk(end)        
        g = set(g,'vals',v);
        [ish, g] = ishappy(op,g,pref);
        if ish || ind==length(kk), break, end        
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
        x = chebpts(k);
        g = set(g,'vals',op(x));   
        [ish, g] = ishappy(op,g,pref);
        if ish, break, end
    end
    
     % Check for NaN's or Inf's    
     if any(isnan(g.vals)) || isinf(g.scl.v)
        error('CHEBFUN:growfun:naneval','Function returned NaN or Inf when evaluated.')
     end
    
end

%-------------------------------------------------------------------------
function  [ish,g] = ishappy(op,g,pref)
% ISHAPPY happyness test for funs
%   [ISH,G2] = ISHAPPY(OP,G,X,PREF) tests if the fun G is a good approximation to
%   the function handle OP. X is the vector of Chebyshev nodes use to
%   generate the values in G. ISH is either true or false. If ISH is true,
%   G2 is the simplified version of G. PREF is the chebfunpref structure.

n = g.n;
g = simplify(g,pref.eps);
ish = g.n < n;

% Antialiasing procedure
if ish && pref.sampletest
    x = chebpts(g.n);
    [mx indx] = max(abs(diff(g.vals))./diff(x));
    xeval = (x(indx+1)+sqrt(2)*x(indx))/(1+sqrt(2));
    v = op([-1;xeval;1]);
    if abs(v(2)-bary(xeval,g.vals)) > 1e4*pref.eps*g.scl.v
        ish =  false;
        return
    end
end
