function val = get(cg, propName,propName2)
% GET   Get chebgui properties.

% Copyright 2011 by The University of Oxford and The Chebfun Developers. 
% See http://www.maths.ox.ac.uk/chebfun/ for Chebfun information.

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
    case 'init'
        val = cg.init;
    case 'sigma'
        val = cg.sigma;        
    case 'options'
        if isempty(propName2)
            val = cg.options;
        else
            switch lower(propName2)
                case 'damping'
                    val = cg.options.damping;
                case 'plotting'
                    val = cg.options.plotting;
                case 'grid'
                    val = cg.options.grid;
                case 'pdeholdplot'
                    val = cg.options.pdeholdplot;
                case 'fixn'
                    val = cg.options.fixN;
                case 'fixyaxislower'
                    val = cg.options.fixYaxisLower;
                case 'fixyaxisupper'
                    val = cg.options.fixYaxisUpper;
                case 'numeigs'
                    val = cg.options.fixYaxisUpper;                    
                otherwise
                    error('CHEBOP:get:options:propname',[propName2,' is not a valid chebgui option.'])
            end
        end
    otherwise
        error('CHEBOP:get:propname',[propName,' is not a valid chebgui property'])
end
