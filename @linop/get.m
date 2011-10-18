function val = get(L,propName)

% Copyright 2011 by The University of Oxford and The Chebfun Developers. 
% See http://www.maths.ox.ac.uk/chebfun/ for Chebfun information.

switch propName
    case 'varmat'
        val = L.varmat;
    case 'oparray'
        val = L.oparray;
    case 'difforder'
        val = L.difforder;
    case 'fundomain'
        val = L.fundomain;
    case 'lbc'
        val = L.lbc;        
    case 'rbc'
        val = L.rbc;
    case 'numbc'
        val = L.numbc;
    case 'scale'
        val = L.scale;
    case 'blocksize'
        val = L.blocksize;
    case 'ID'
        val = L.ID;
    case 'jumplocs'
        val = L.jumplocs;
    case 'chebop'
        val = L.chebop;        
    otherwise
        error('CHEBFUN:get:propnam',[propName,' is not a valid chebfun property.'])
end