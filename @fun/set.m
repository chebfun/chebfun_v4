function a = set(a,varargin)
% SET Set fun properties.
% F = SET(F,PROP,VAL) modifies the property PROP of the chebfun F with
% the value VAL. PROP can be 'val', 'n', 'trans' or 'td'.
%
% F = SET(F,PROP_1,VAL_1,...,PROP_n,VAL_n) modifies more than one property.
%
% Ricardo Pachon and Lloyd N. Trefethen, 2007, Chebfun Version 2.0
propertyArgIn = varargin;
while length(propertyArgIn) >= 2,
    prop = propertyArgIn{1};
    val = propertyArgIn{2};
    propertyArgIn = propertyArgIn(3:end);
    switch prop
    case 'val'
        a.val = val;
    case 'n'
        a.n = val;
    case 'trans'
        a.trans = val;
    case 'td'
        a.td = val;        
    otherwise
        error('fun properties: val, n, trans or td')
    end
end