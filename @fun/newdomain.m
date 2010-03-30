function g = newdomain(g,ends)
% NEWDOMAIN fun change of doamin
% NEWDOMAIN(G,ENDS) returns a fun with a domain defined by ENDS. This is 
% done with a linear map. 

% Copyright 2009 by The Chebfun Team. 
% Last commit: $Author$: $Rev$:
% $Date$:

map = g.map;

% endpoints!
a = map.par(1); b = map.par(2); c = ends(1); d = ends(2);

if any(isinf(ends))
%     error('FUN:newdomain:infint','Newdomain does not support infinite intervals');
    return
end

if strcmp(map.name,'linear')
    % The composition of linear maps is linear! (because they're, er... linear!)
    map = linear(ends);
else
    % linear map from [a b] to [c d]
    linfor = @(y) ((d-c)*y+c*(b-a)-a*(d-c))/(b-a);
    lininv = @(x) ((b-a)*x+a*(d-c)-c*(b-a))/(d-c);
    der = (d-c)/(b-a);

    % New composed map!
    map.for = @(y) linfor(map.for(y));
    map.inv = @(x) map.inv(lininv(x));
    map.der = @(y) der*map.der(y);
    map.par(1:2) = ends;
end

% update fun!
g.map = map;
g.scl.h = max(g.scl.h,norm(ends,inf));