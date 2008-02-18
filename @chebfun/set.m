function a = set(a,varargin)
% SET Set chebfun properties.
% F = SET(F,PROP,VAL) modifies the property PROP of the chebfun F with
% the value VAL. PROP can be 'funs', 'ends', or 'imps' to modify the cell 
% array of funs, the vector with endpoints or the matrix with Dirac 
% impulses respectively.
%
% F = SET(F,PROP_1,VAL_1,...,PROP_n,VAL_n) modifies more than one property.

% Ricardo Pachon and Lloyd N. Trefethen, 2007, Chebfun Version 2.0
propertyArgIn = varargin;
while length(propertyArgIn) >= 2,
    prop = propertyArgIn{1};
    val = propertyArgIn{2};
    propertyArgIn = propertyArgIn(3:end);
    switch prop
    case 'funs'
        a.funs = val;
    case 'ends'
        a.ends = val;
    case 'imps'
        a.imps = val;
    otherwise
        error('chebfun properties: funs, ends and imps')
    end
end
