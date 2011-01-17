function val = get(cg, propName)
% GET   Get chebgui properties.
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2009 by The Chebfun Team.

switch lower(propName)
    case 'type'
        val = cg.type;
    case 'domleft'
        val = cg.DomLeft;
    case 'domright'
        val = cg.DomRight;
    case 'de'
        val = cg.DE;
    case 'derhs'
        val = cg.DErhs;
    case 'lbc'
        val = cg.LBC;
    case 'lbcrhs'
        val = cg.LBCrhs;
    case 'rbc'
        val = cg.RBC;
    case 'rbcrhs'
        val = cg.RBCrhs;
    case 'tol'
        val = cg.tol;      
    otherwise
        error('CHEBOP:get:propname',[propName,' is not a valid chebgui property'])
end
