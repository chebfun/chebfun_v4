function cg = set(cg, propName,propName2,vin)
% SET   Set chebgui properties.

% Copyright 2011 by The University of Oxford and The Chebfun Developers. 
% See http://www.maths.ox.ac.uk/chebfun/ for Chebfun information.

% Avoid storing {''} in fields, rather store ''
if iscell(vin) && isempty(vin{1})
    vin = '';
end

switch lower(propName)
    case 'type'
        if ~strcmpi(vin,'bvp') && ~strcmpi(vin,'ivp') && ~strcmpi(vin,'pde') && ~strcmpi(vin,'eig')
            error('CHEBGUI:set:type',[vin,' is not a valid type of problem.'])
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
    case 'lbc'
        cg.LBC = vin;
    case 'rbc'
        cg.RBC = vin;
    case 'tol'
        cg.tol = vin;
    case 'init'
        cg.init= vin;
    case 'sigma'
        cg.sigma= vin;        
    case 'options'
        if isempty(propName2)
            cg.options = vin;
        else
            switch lower(propName2)
                case 'damping'
                    cg.options.damping = vin;
                case 'plotting'
                    if isnumeric(vin)
                        vin = num2str(vin);
                    end
                    cg.options.plotting = vin;
                case 'grid'
                    cg.options.grid = vin;
                case 'pdeholdplot'
                    cg.options.pdeholdplot = vin;
                case 'fixn'
                    cg.options.fixN = vin;
                case 'fixyaxislower'
                    cg.options.fixYaxisLower = vin;
                case 'fixyaxisupper'
                    cg.options.fixYaxisUpper = vin;
                case 'numeigs'
                    cg.options.numeigs = vin;
                otherwise
                    error('CHEBGUI:set:options:propanem',...
                        [propName2,' is not a valid chebgui option.'])
            end
        end
    otherwise
        error('CHEBGUI:set:propname',[propName,' is not a valid chebgui property'])
end
