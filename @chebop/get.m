function val = get(N, propName)
% GET   Get chebop properties.
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2008 by The Chebfun Team.

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
    case 'guess'
        val = N.guess;
    otherwise
        error([propName,' is not a valid nonlinop property'])
end
