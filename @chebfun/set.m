function F = set(F,varargin)
% SET Set chebfun properties.
% F = SET(F,PROP,VAL) modifies the property PROP of the chebfun F with
% the value VAL. PROP can be 'funs', 'ends', or 'imps' to modify the cell 
% array of funs, the vector with endpoints or the matrix with Dirac 
% impulses respectively.
%
% F = SET(F,PROP_1,VAL_1,...,PROP_n,VAL_n) modifies more than one property.

% Chebfun Version 2.0

if numel(F)>1
    error('set currently does not work with quasi-matrices')
end

propertyArgIn = varargin;
while length(propertyArgIn) >= 2,
    prop = propertyArgIn{1};
    val = propertyArgIn{2};
    propertyArgIn = propertyArgIn(3:end);
    switch prop
    case 'funs'
        F.funs = val;
        F.nfuns = numel(val);
       % scl = 0;
       % for i = 1:F.nfuns, scl = max(scl,norm(val(i).vals,inf)); end
       % F.scl = scl;
       F = update_vscl(F);
    case 'nfuns'
        F.nfuns = val;    
    case 'ends'
        F.ends = val(:).';
    case 'imps'
        F.imps = val;
    case 'scl'
        F.scl = val;  
    case 'trans'
        F.trans = val;     
    otherwise
        error('chebfun properties: funs, ends and imps')
    end
end

if length(F.ends)~=F.nfuns+1 || size(F.imps,2) ~= length(F.ends)
    error('inconsistent chebfun') 
end
