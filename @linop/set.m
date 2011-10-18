function L = set(L,propName,val)
% Copyright 2011 by The University of Oxford and The Chebfun Developers. 
% See http://www.maths.ox.ac.uk/chebfun/ for Chebfun information.

    switch propName
        case 'varmat'
            L.varmat = val;
        case 'oparray'
            L.oparray = val;
        case 'difforder'
            L.difforder = val;
        case 'fundomain'
            L.fundomain = val;
        case 'lbc'
            L.lbc = val;        
        case 'rbc'
            L.rbc = val;
        case 'numbc'
            L.numbc = val;
        case 'scale'
            L.scale = val;
        case 'blocksize'
            L.blocksize = val;
        case 'ID'
            L.ID = val;
        case 'jumplocs'
            L.jumplocs = val;        
        case 'chebop'
            L.chebop = val;        
        otherwise
            error('CHEBFUN:get:propnam',[propName,' is not a valid chebfun property.'])
    end
end