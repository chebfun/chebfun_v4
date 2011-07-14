function val = get(N, propName)
% GET   Get chebop properties.

% Copyright 2011 by The University of Oxford and The Chebfun Developers. 
% See http://www.maths.ox.ac.uk/chebfun/ for Chebfun information.

switch propName
    case 'dom'
        val = N.dom;
    case 'op'
        val = N.op;
    case 'bc'
        val = struct('left',{N.lbcshow},'right',{N.rbcshow});
    case 'lbc'
        val = N.lbc;
    case 'rbc'
        val = N.rbc;
    case {'guess','init'}
        val = N.init;
    case 'dim'
        val = N.dim;
    otherwise
        error('CHEBOP:get:propname',[propName,' is not a valid chebop property.'])
end
