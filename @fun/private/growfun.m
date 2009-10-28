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

% Set minn 
if nargin == 4
    minn = max(5, g1.n);
elseif nargin == 5
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
  kk = kk + 1 - mod(kk,2);
else
  kk = 2.^(minpower:npower) + 1;
end

if kk(end)~=n, kk(end+1) = n; resample = true; end

% Store scale in case not happy
old_scl = g.scl;

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
        g = simplify(g, pref.eps);
        if g.n < k, break, end
    end
    return
end
% ---------------------------------------------------

% End points: make sure the function gets evaluated at those:
a = g.map.par(1); b = g.map.par(2);

% --------------------------------------------------

if  ~resample && 2^npower+1 == n && nargin<5
        
    % single sampling
    ind =1;
    xvals = g.map.for(chebpts(kk(ind))); xvals(1) = a; xvals(end) = b;
    v = op(xvals);

    while kk(ind)<=kk(end) 
        
        % Experimental feature for avoiding NaNs.
        nans = isnan(v);
        if any(nans)
            ends = g.map.par(1:2);
            xvals = xvals(nans); % Sample around NaN and extrapolate.
            for j = 1:length(xvals)
                xnans = repmat(xvals(j),6,1) + [0 -2 -1 1  2 0]'*1e-14*g.scl.h;
                % Need to make sure all evaluation points are within interval
                if any(xnans < ends(1)), 
                    vnans = op(xnans([1 4:6]));
                    v(nans) = 2*vnans(3)-vnans(2);
                elseif any(xnans > ends(2)), 
                    vnans = op(xnans([1:3 6]));
                    v(nans) = 2*vnans(2)-vnans(3);
                else % Use double sided extrapolation if we can              
                    vnans = op(xnans);
                    v(nans) = .5*(2*vnans(2)-vnans(3) + 2*vnans(5)-vnans(4));
                end
            end
        end
        
        g.vals = v;  g.n = length(v); 
        g.scl.v = max(g.scl.v,norm(g.vals,inf));
        [ish, g] = ishappy(op,g,pref);
        if ish || ind==length(kk), break, end        
        ind =ind+1;
        x = chebpts(kk(ind));
        v(1:2:kk(ind)) = v; 
        
        % In splitting on mode, consider endpoints (see getfun.m)
        if split
            newv = op([a; g.map.for(x(2:2:end-1)); b]); 
            v(2:2:end-1) = newv(2:end-1);
        else
            v(2:2:end-1) = op(g.map.for(x(2:2:end-1)));
        end
    end

else
    
    % double sampling (This is the standard way of growing a fun)
    
    if ~any(isinf(g.map.par(1:2)))
        
        for k = kk
            xvals = g.map.for(chebpts(k)); xvals(1) = a; xvals(end) = b;
            g.vals = op(xvals); g.n = k;
            
            % Experimental feature for avoiding NaNs.
            nans = isnan(g.vals);
            if any(nans)
                ends = g.map.par(1:2);
                xvals = xvals(nans); % Sample around NaN and extrapolate.
                for j = 1:length(xvals)
                    xnans = repmat(xvals(j),6,1) + [0 -2 -1 1  2 0]'*1e-14*g.scl.h;
                    % Need to make sure all evaluation points are within interval
                    if any(xnans < ends(1)), 
                        vnans = op(xnans([1 4:6]))
                        g.vals(nans) = 2*vnans(3)-vnans(2);
                    elseif any(xnans > ends(2)), 
                        vnans = op(xnans([1:3 6]));
                        g.vals(nans) = 2*vnans(2)-vnans(3);
                    else % Use double sided extrapolation if we can              
                        vnans = op(xnans);
                        g.vals(nans) = .5*(2*vnans(2)-vnans(3) + 2*vnans(5)-vnans(4));
                    end
                end
            end
            
            g.scl.v = max(g.scl.v,norm(g.vals,inf));
            [ish, g] = ishappy(op,g,pref);
            if ish, break, end
        end
        
    else
        
        adapt = mappref('adaptinf');
        
        % if unbouded intervals, catch horizontal scale
        if ~adapt
            if g.map.par(1) == -inf && g.map.par(2) == inf
                g.scl.h = max(abs(diff(g.map.par(3:4))),abs(sum(g.map.par(3:4))));
            elseif g.map.par(1) == -inf
                g.scl.h = max(abs(g.map.par(2)), abs(g.map.par(2)-g.map.par(3)));
            else
                g.scl.h = max(abs(g.map.par(1)), abs(g.map.par(1)+g.map.par(3)));
            end
        end
        for k = kk
            if adapt
                [map,v,hscl] = unbounded(g.map.par, op, k);
                g.vals = v; g.map = map; g.n = k; 
                g.scl.v = max(g.scl.v,norm(v,inf));
                g.scl.h = hscl;
            else
                
                xvals = g.map.for(chebpts(k));
                g.vals = op(xvals); g.n = k;              
                
                % Experimental feature for avoiding NaNs.
                nans = isnan(g.vals);
                if any(nans)
                    xvals = xvals(nans); % Sample around NaN and extrapolate.
                    for j = 1:length(xvals)
                        xnans = repmat(xvals(j),1,6) + [0 -2 -1 1  2 0]*1e-14*g.scl.h;
                        vnans = op(xnans.');
                        g.vals(nans) = .5*(2*vnans(2)-vnans(3) + 2*vnans(5)-vnans(4));
                    end
                end
                
                g.scl.v = max(g.scl.v,norm(g.vals,inf));
            end
            [ish, g] = ishappy(op,g,pref);
            if ish, break, end
        end
        
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
g = simplify(g,pref.eps);
ish = g.n < n;

% Antialiasing procedure
if ish && pref.sampletest
    x = chebpts(g.n);
    [mx indx] = max(abs(diff(g.vals))./diff(x));
    xeval = (x(indx+1)+sqrt(2)*x(indx))/(1+sqrt(2));
    v = op(g.map.for([-1;xeval;1]));
    if abs(v(2)-bary(xeval,g.vals,x)) > 1e4*pref.eps*g.scl.v
        ish =  false;
        return
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