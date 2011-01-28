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
        if ~strcmpi(vin,'bvp') && ~strcmpi(vin,'pde')
            error('CHEBGUI:set:type',[propName,' is not a valid type of problem.'])
        elseif strcmpi(vin,'ivp')
            warning('CHEBGUI:set:type Type of problem changed from IVP to BVP');
            cg.type = 'bvp';
        else
            cg.type = vin;
        end
    case 'domleft'
        cg.DomLeft = vin;
    case 'domright'
        cg.DomRight = vin;
    case 'timedomain'
        cg.timedomain = vin;
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
    case 'pause'
        cg.tol = vin;
    case 'damping'
        cg.damping = vin;
    case 'plotting'
        cg.plotting = vin;
    case 'guess'
        cg.guess= vin;        
    otherwise
        error('CHEBGUI:set:propname',[propName,' is not a valid chebgui property'])
end
