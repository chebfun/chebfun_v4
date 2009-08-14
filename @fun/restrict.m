function g = restrict(g,subint)
% RESTRICT Restrict a fun to a subinterval.
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2008 by The Chebfun Team. 
% Last commit: $Author: rodp $: $Rev: 537 $:
% $Date: 2009-07-17 16:15:29 +0100 (Fri, 17 Jul 2009) $:

if strcmp(g.map.name,'linear') % simplest case
    map = linear(subint);
    g.vals = feval(g,map.for(chebpts(g.n)));
    g.map = map;
    g = simplify(g);
    return
end

ends = g.map.par(1:2);

% Check if subinterval is in the domain of g!
if (subint(1)<ends(1)) || (subint(2)>ends(2)) || (subint(1)>subint(2))
  error('fun:restrict:badinterval','Not given a valid interval.')
end

% split this in two cases:
% 1) bounded 
if norm(g.map.par(1:2),inf) <inf && ... 
        (~strcmp(mappref('name'),g.map.name) || mappref('adapt')) 
    % adaptive
    g = fun(@(x) feval(g,x), subint, chebfunpref, g.scl);
% 2) unbounded
elseif norm(g.map.par(1:2),inf) == inf %&& mappref('adaptinf')
    % adaptive
    pref = chebfunpref;
    pref.minsamples = g.n;
    g = fun(@(x) feval(g,x), subint, pref, g.scl);
else
    % non adaptive
    % This needs more thinking 
    scl = g.scl;
    g = fun(@(x) feval(g,x), subint, g.n);
    g.scl = scl;
    g = simplify(g);
end