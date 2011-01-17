function cg = set(cg, propName,vin)
% GET   Get chebgui properties.
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2009 by The Chebfun Team.

% Avoid storing {''} in fields, rather store ''
if iscell(vin) && isempty(vin{1})
    vin = '';
end

switch lower(propName)
    case 'type'
        cg.type = vin;
    case 'domleft'
        cg.DomLeft = vin;
    case 'domright'
        cg.DomRight = vin;
    case 'de'
        cg.DE = vin;
    case 'derhs'
        cg.DErhs = vin;          
    case 'lbc'
        cg.LBC = vin;
    case 'lbcrhs'
        cg.LBCrhs = vin;
    case 'rbc'
        cg.RBC = vin;
    case 'rbcrhs'
        cg.RBCrhs = vin;
    case 'tol'
        cg.tol = vin;
    otherwise
        error('CHEBGUI:get:propname',[propName,' is not a valid chebgui property'])
end
