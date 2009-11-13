function val = get(g, propName)
% GET Get asset properties from the specified object
% and return the value
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2008 by The Chebfun Team.
% Last commit: $Author$: $Rev$:
% $Date$:

switch propName
    case 'vals'
        val = g.vals;
    case 'points'
        % Returns mapped Chebyshev points (consistent with vals)
        val = g.map.for(chebpts(g.n));
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
            if g.n > 1
                val = inf*sign(g.vals(2));
            else
                val = inf*sign(g.vals(1));
            end
        elseif g.exps(1) > 0, val = 0;
        else
%            rescl = (2/diff(g.map.par(1:2)))^-g.exps(2); % scale (see feval)
%            val = g.vals(1).*diff(g.map.par(1:2)).^g.exps(2)/rescl;
            val = g.vals(1)*2^g.exps(2);
        end
    case 'rval' % value at right endpoint 
        if g.exps(2) < 0  % inf case, need to check sign
            if g.n > 1
                val = inf*sign(g.vals(end-1));
            else
                val = inf*sign(g.vals(1));
            end
        elseif g.exps(2) > 0, val = 0;
        else          
            %rescl = (2/diff(g.map.par(1:2)))^-g.exps(1); % scale (see feval) 
            %val = g.vals(end)*diff(g.map.par(1:2)).^g.exps(1)/rescl;
            val = g.vals(end)*2^g.exps(1);
        end
    otherwise
        error([propName,' Is not a valid fun property'])
end