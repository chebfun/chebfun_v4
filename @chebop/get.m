function val = get(N, propName)
% GET   Get chebop properties.
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2009 by The Chebfun Team.

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
        val = N.guess;
    otherwise
        error('CHEBOP:get:propname',[propName,' is not a valid chebop property'])
end
