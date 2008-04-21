function g = set(g,varargin)
% SET Set fun properties.
% G = SET(G,PROP,VAL) modifies the property PROP of the fun G with
% the value VAL. PROP can be 'vals', 'n', 'scl', 'scl.h', or 'scl.v'.
%
% G = SET(G,PROP_1,VAL_1,...,PROP_n,VAL_n) modifies more than one property.

propertyArgIn = varargin;
while length(propertyArgIn) >= 2,
    prop = propertyArgIn{1};
    val = propertyArgIn{2};
    propertyArgIn = propertyArgIn(3:end);
    switch prop
        case 'vals'
            g.vals = val;
            g.n = length(val);
            g.scl.v = max( g.scl.v, norm(val, inf) );
        case 'n'
            g.n = val;
        case 'scl'
            g.scl = val;
        case 'scl.h'
            g.scl.h = val;
        case 'scl.v'
            for k=1:numel(g)
                gk=g(k);
                gk.scl.v = val;
            end
        otherwise
            error('fun properties: val, n, or scl')
    end
end

%if length(g.vals)~=g.n
%    error('Inconsistent fun: length(g.vals) ~= g.n')
%end