function val = get(g, propName, kind)
% GET Get asset properties from the specified object
% and return the value
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2009 by The Chebfun Team.
% Last commit: $Author$: $Rev$:
% $Date$:

if nargin < 3
    kind = 2;
end

switch propName
    case 'vals'
        if kind == 1
            val = bary(chebpts(g.n,1), g.vals, g.map.for(chebpts(g.n,[-1 1])));
        else
            val = g.vals;
        end
    case {'points','pts'}
        % Returns mapped Chebyshev points (consistent with vals)
        val = g.map.for(chebpts(g.n,[-1 1],kind));
    case 'n'
        val = g.n;
    case 'scl'
        val = g.scl;
    case 'scl.v'
        val = g.scl.v;
    case 'scl.h'
        val = g.scl.h;
    case 'map'
        val = g.map;
    case 'exps'
        val = g.exps;
    case 'lval'  % value at left endpoint
        if g.exps(1) < 0  % inf case, need to check sign
            if g.n > 5
                val = inf*sign(mean(g.vals(1:2))+g.vals(1));
            else
                val = inf*sign(g.vals(1));
            end
        elseif g.exps(1) > 0
            val = 0;
        else
            if isempty(g.vals)
                val = NaN;
            elseif all(isfinite(g.map.par(1:2)))
                if ~g.exps(2), val = g.vals(1);
                else           val = g.vals(1)*2^g.exps(2); 
                end
            else
                val = feval(g,g.map.par(1));
            end
        end
    case 'rval' % value at right endpoint 
        if g.exps(2) < 0  % inf case, need to check sign
            if g.n > 5
                val = inf*sign(mean(g.vals(end-1:end))+g.vals(end));
            else
                val = inf*sign(g.vals(end));
            end
        elseif g.exps(2) > 0
            val = 0;
        else          
            if isempty(g.vals)
                val = NaN;
            elseif all(isfinite(g.map.par(1:2)))
                if ~g.exps(1), val = g.vals(end);
                else           val = g.vals(end)*2^g.exps(1); 
                end
            else
                val = feval(g,g.map.par(2));
            end
        end
    otherwise
        error('FUN:get:propname',[propName,' is not a valid fun property.'])
end