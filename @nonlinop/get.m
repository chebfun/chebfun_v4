function val = get(f, propName)
% GET   Get nonlinop properties.
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2008 by The Chebfun Team.

switch propName
    case 'dom'
        val = f.dom;
    case 'op'
        val = f.op;
    case 'bc'
        val = f.bc;
    case 'guess'
        val = f.guess;
    otherwise
        error([propName,' is not a valid chebbvp property'])
end