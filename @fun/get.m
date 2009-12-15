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
            val = bary(chebpts(g.n,1), g.vals); % is this right for general maps?
        else
            val = g.vals;
        end
    case 'points'
        % Returns mapped Chebyshev points (consistent with vals)
        if kind == 1
             val = g.map.for(chebpts(g.n,1));
        else
            val = g.map.for(chebpts(g.n));
        end
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
            val = inf*sign(g.vals(1));
        elseif g.exps(1) > 0, val = 0;
        else
            %rescl = (2/diff(g.map.par(1:2)))^-g.exps(2); % scale (see feval)
            %val = g.vals(1).*diff(g.map.par(1:2)).^g.exps(2)/rescl;
            val = g.vals(1)*2^g.exps(2);
        end
    case 'rval' % value at right endpoint 
        if g.exps(2) < 0  % inf case, need to check sign
            val = inf*sign(g.vals(end));
        elseif g.exps(2) > 0, val = 0;
        else          
           % rescl = (2/diff(g.map.par(1:2)))^-g.exps(1); % scale (see feval) 
           % val = g.vals(end)*diff(g.map.par(1:2)).^g.exps(1)/rescl;
            val = g.vals(end)*2^g.exps(1);
        end
    otherwise
        error('FUN:get:propname',[propName,' Is not a valid fun property'])
end