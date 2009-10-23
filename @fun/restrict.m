function g = restrict(g,subint)
% RESTRICT Restrict a fun to a subinterval.
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2008 by The Chebfun Team. 
% Last commit: $Author: rodp $: $Rev: 537 $:
% $Date: 2009-07-17 16:15:29 +0100 (Fri, 17 Jul 2009) $:

ends = g.map.par(1:2);

% Check if subinterval is in the domain of g!
if (subint(1)<ends(1)) || (subint(2)>ends(2)) || (subint(1)>subint(2))
  error('fun:restrict:badinterval','Not given a valid interval.')
end

% unbounded case
if norm(g.map.par(1:2),inf) == inf %&& mappref('adaptinf')
    % adaptive
    if any(g.exps), error('chebfun:fun:restruct:infmark1','Markfuns not supported on infinite intervals'); end
    pref = chebfunpref;
    pref.minsamples = g.n;
    g = fun(@(x) feval(g,x), subint, pref, g.scl);
    
% bounded cases
elseif (subint(1) > ends(1) && g.exps(1)) || (subint(2) < ends(2) && g.exps(2)) || ~strcmp(g.map.name,'linear')
    % exps removed or non-linear map
    
    op = @(x) 1+0*x;
    if g.exps(1) && (subint(1) > ends(1)) % Left exp has been removed
        op = @(x) op(x).*(x-ends(1)).^(g.exps(1));
        g.exps(1) = 0;
    end
    if g.exps(2) && (subint(2) < ends(2)) % Right exp has been removed
        op = @(x) op(x).*(ends(2)-x).^(g.exps(2));
        g.exps(2) = 0; 
    end
    exps = g.exps;

    xcheb = chebpts(g.n);
    g = fun(@(x) op(x).*bary(x,g.vals,g.map.for(xcheb)), subint, chebfunpref, g.scl);
    g.exps = exps;

else % Linear case with no removed exps is simple
    
    map = linear(subint);
    xcheb = chebpts(g.n);
    g.vals = bary(map.for(xcheb),g.vals,g.map.for(xcheb));
    g.map = map;
    g = simplify(g);
    
end

% --- removed by NicH
% % split this in two cases:
% % 1) bounded 
% if norm(g.map.par(1:2),inf) <inf && 
%         (~strcmp(mappref('name'),g.map.name) || mappref('adapt')) 
%     % adaptive
%     g = fun(@(x) feval(g,x), subint, chebfunpref, g.scl);
% % 2) unbounded
% elseif norm(g.map.par(1:2),inf) == inf %&& mappref('adaptinf')
%     % adaptive
%     if any(g.exps), error('chebfun:fun:restruct:infmark1','Markfuns not supported on infinite intervals'); end
%     pref = chebfunpref;
%     pref.minsamples = g.n;
%     g = fun(@(x) feval(g,x), subint, pref, g.scl);
% else
%     % non adaptive
%     % This needs more thinking (& with markfuns)
%     scl = g.scl;
%     g = fun(@(x) feval(g,x), subint, g.n);
%     g.scl = scl;
%     g = simplify(g);
% end

