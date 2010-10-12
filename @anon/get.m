function val = get(a, propName)
% GET   Get anon properties.
% P = GET(F,PROP) returns the property P specified in the string PROP from
% the anon A.
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2009 by The Chebfun Team. 

switch propName
    case 'function'
        val = a.function;
    case 'variablesName'
        val = a.variablesName;
    case 'workspace'
        val = a.workspace;
    case 'depth'
        val = a.depth;
    otherwise
        error('ANON:get:propnam',[propName,' is not a valid anon property.'])
end
