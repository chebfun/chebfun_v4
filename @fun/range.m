function r = range(g)
% Range of a fun, i.e. max(g) - min(g)
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

%  Copyright 2002-2009 by The Chebfun Team. 
%  Last commit: $Author$: $Rev$:
%  $Date$:

if ~isreal(g)
    r = range(abs(chebfun(g)));
    return
end

r = diff(minandmax(g));
