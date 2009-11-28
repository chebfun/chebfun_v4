function [g,ish] = growfun(op,g,pref,g1,g2)
% G = GROWFUN(OP,G,PREF,G1,G2)
%
% G = GROWFUN(OP,G,PREF) returns the fun G representing the function handle OP.
%   PREF is the chebfunpref structure.
%
% G = GROWFUN(OP,G,PREF,G1) returns the fun G representing the composition
%   OP(G1), where G1 is a fun.
%
% G = GROWFUN(OP,G,PREF,G1,G2) returns the fun G representing the composition
%   OP(G1,G2), where G1 and G2 are funs.
%

% Copyright 2002-2008 by The Chebfun Team. See www.comlab.ox.ac.uk/chebfun/
% Last commit: $Author$: $Rev$:
% $Date$:

% Check preferences
split = pref.splitting;
resample = pref.resampling;
if split
    n = pref.splitdegree + 1;
else
    n = pref.maxdegree + 1;
end

% If maxdegree is ot a power of 2, we over sample and then trim
% back to maxdegree
l2n = log2(n-1);
maxdegflag = 0;
if ~resample && l2n ~= round(l2n)
    maxdegflag = 1;
    maxdeg = n;
    n = 2.^ceil(l2n)+1;
end

% Set minn
if nargin == 4
    minn = max(9, g1.n);
elseif nargin == 5
    minn = max([9, g1.n, g2.n]);
else
    minn = pref.minsamples;
end

% Sample using powers of 2.
minpower = max(2,ceil(log2(minn-1)));
npower = max(minpower,floor(log2(n-1)));

% Number of nodes to be used
if resample   
    if pref.chebkind == 2
        npn = max(min(npower,6),minpower);
        kk = 1 + round(2.^[ (minpower:npn) (2*npn+1:2*npower)/2 ]);
        kk = kk + 1 - mod(kk,2);
    else
        kk = 2.^(minpower:npower);
    end
else
    if pref.chebkind == 1        
        pref.chebkind = 2;
        warning('chebfun:resampling_kind','In RESAMPLING OFF mode, Chebyshev points of 2nd kind are used')        
    end
    kk = 2.^(minpower:npower) + 1;
end

if kk(end)~=n, kk(end+1) = n; end


% Store scale in case not happy
old_scl = g.scl;

% ---------------------------------------------------
% composition case, i.e., want gout = op(g) (see FUN/COMP.M)
if nargin > 3
    % This uses chebpts of 2nd kind!
    for k = kk
        v1 = get(prolong(g1,k),'vals');
        if nargin == 5
            v2 = get(prolong(g2,k),'vals');
            v = op(v1,v2);
        else
            v = op(v1);
        end
        g = set(g,'vals', v);
        g = extrapolate(g,pref);        
        g = simplify(g, pref.eps);
        if g.n < k, break, end
    end
    return
end
% ---------------------------------------------------
% End points: make sure the function gets evaluated at those:
a = g.map.par(1); b = g.map.par(2);

% ---------------------------------------------------
% if unbouded intervals, catch horizontal scale
adapt = false;
if any(isinf([a b]))
    adapt = mappref('adaptinf');
    if ~adapt
        if a == -inf && b == inf
            g.scl.h = max(abs(diff(g.map.par(3:4))),abs(sum(g.map.par(3:4))));
        elseif g.map.par(1) == -inf
            g.scl.h = max(abs(g.map.par(2)), abs(g.map.par(2)-g.map.par(3)));
        else
            g.scl.h = max(abs(g.map.par(1)), abs(g.map.par(1)+g.map.par(3)));
        end
    end
end

% --------------------------------------------------
if ~resample && ~adapt && 2^npower+1 == n && nargin < 5
    %error('resampling off has been desabled for now')
    % single sampling  (This is the standard way of growing a fun)
    
    % finite & infinite intervals
    ind = 1;
    x = chebpts(kk(ind),2);
    xvals = g.map.for(x);        
    vnew = op(xvals); v = [];
    
    while kk(ind)<=kk(end)
        
        % update v
        if isempty(v)
            v = vnew;
        else
            v(1:2:kk(ind)) = v;
            v([1,2:2:end-1,end]) = vnew;
        end
        
        %update g
        g.vals = v;  g.n = length(v);
        g = extrapolate(g,pref,x); 
        [ish, g] = ishappy(op,g,pref);
        if ish || ind == length(kk), break, end
        ind = ind+1;
        
        % new points
        x = chebpts(kk(ind),pref.chebkind);
        xvals = g.map.for(x([1,2:2:end-1,end]));
        vnew = op(xvals);            
        
    end   
    
    % a maximum degree was specified which wasn't a power of 2
    if maxdegflag && g.n > maxdeg
        g = prolong(g,maxdeg);
        ish = false;
    end
    
else % double sampling
    
    for k = kk
  
        if adapt % adaptive infinite intervals
            pref.kind = 1; % Foce 1st kind for now.
            [map,v,hscl] = unbounded(g.map.par, op, k);
            g.vals = v; g.map = map; g.n = k;
            g = extrapolate(g,pref);
            g.scl.h = hscl;
        else
            
            x = chebpts(k,pref.chebkind);
            xvals = g.map.for(x);
            g.vals = op(xvals); g.n = k;
            
            % Deal with endpoint values
            g = extrapolate(g,pref,x);
        end
        [ish, g] = ishappy(op,g,pref);
        if ish, break, end
    end
    
end

% Check for Inf's
if isinf(g.scl.v)
    if ~pref.blowup
        error('CHEBFUN:growfun:inf_blowup',['Function returned Inf when evaluated. ', ...
            'Have you tried ''blowup on''?'])
    elseif ~split
        error('CHEBFUN:growfun:inf_split',['Function returned Inf when evaluated. ', ...
            'Have you tried ''splitting on''?'])
    else
        ish = false;
        g.scl = old_scl;
        return
    end
    
end

% Check for NaN's or Inf's
if any(isnan(g.vals))
    error('CHEBFUN:growfun:naneval','Function returned NaN when evaluated.')
end

% if unhappy, change map and try again
if ~ish && strcmp(g.map.name,'linear') && singmap
    % Check singular ends and pick a map ---------------
    %     if g.scl.v == 0
    %         g.scl.v = norm(op(linspace(a,b,10).'),inf);
    %     end
    isl = issing(op,a+eps(a),a+0.001*g.scl.h,g.scl.v);
    isr = issing(op,b-0.001*g.scl.h,b-eps(b),g.scl.v);
    if ~(isl || isr)
        return;
    elseif isl && isr
        g.map = sing([a,b,0]);
    elseif isl
        g.map = sing([a,b,-1]);
    elseif isr
        g.map = sing([a,b,1]);
    end
    if isl || isr
        pref.sampletest = false;
    end
    [gnew,ish] = growfun(@(x) op(max(a,min(x,b))),g,pref);
    if ish
        g = gnew;
    end
end

if ~ish && pref.blowup % If not happy, then we revert the scale (as the respresentation my change by using markfins
    g.scl = old_scl;
end

%-------------------------------------------------------------------------
function  [ish,g] = ishappy(op,g,pref)
% ISHAPPY happyness test for funs
%   [ISH,G2] = ISHAPPY(OP,G,X,PREF) tests if the fun G is a good approximation to
%   the function handle OP. X is the vector of Chebyshev nodes use to
%   generate the values in G. ISH is either true or false. If ISH is true,
%   G2 is the simplified version of G. PREF is the chebfunpref structure.

n = g.n;
g = simplify(g,pref.eps,pref.chebkind);
ish = g.n < n;

% Antialiasing procedure
if ish && pref.sampletest
    x = chebpts(g.n); % points of second kind (as simplify returns second kind "point values")
    [mx indx] = max(abs(diff(g.vals))./diff(x));
    xeval = (x(indx+1)+1.41*x(indx))/(2.41);
    xvals = [-1+1e-4;xeval;1-1e-4];
    v = op(g.map.for(xvals));    
    if norm(v-bary(xvals,g.vals,x),inf) > max(pref.eps,1e3*eps)*g.n*g.scl.v
        ish =  false;
    end
end


% -------------------------------------------------------------------------
function iss = issing(op,e1,e2,vs)
% Tests for singular end points. The decision is based on whether
% polynomials are good local approximations to the function near
% endspoints.

x = chebpts(10);
A = cos(acos(x)*(0:4));
xx = [e1; e2*(x+1)/2+e1*(1-x)/2; e2];
v = op(xx); v = v(2:end-1);
iss = norm(v-A*(A\v),inf)./vs > 1e-9;