function g = restrict(g,subint)
% RESTRICT Restrict a fun to a subinterval.
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2009 by The Chebfun Team. 
% Last commit: $Author: rodp $: $Rev: 537 $:
% $Date: 2009-07-17 16:15:29 +0100 (Fri, 17 Jul 2009) $:

ends = g.map.par(1:2);

% Check if subinterval is in the domain of g!
if (subint(1)<ends(1)) || (subint(2)>ends(2)) || (subint(1)>subint(2))
  error('FUN:restrict:badinterval','Not given a valid interval.')
end

if all(subint(:)==ends(:)) % Nothing to do!
  return
end

% unbounded case
if norm(g.map.par(1:2),inf) == inf %&& mappref('adaptinf')
    pref = chebfunpref;
    
    if any(g.exps)
        exps = g.exps;
        if (subint(1) > ends(1)), exps(1) = 0; end  % Left exp has been removed
        if (subint(2) < ends(2)), exps(2) = 0; end  % Right exp has been removed       
        exps(isinf(subint)) = -exps(isinf(subint)); % Exponents are negated for inf intervals 
        pref.exps = exps;
    end
    
    pref.minsamples = g.n;
    g = fun(@(x) feval(g,x), subint, pref, g.scl);

% bounded cases
elseif (subint(1) > ends(1) && g.exps(1)) || (subint(2) < ends(2) && g.exps(2)) || ~strcmp(g.map.name,'linear')
    % exps removed or non-linear map

    if isfield(g.map,'inherited') && g.map.inherited
        pars = g.map.par; pars(1:2) = [];
        map = maps(fun,{g.map.name,pars},subint);
    else
%         map = linear(subint);
        map = maps({mappref('name')},subint);
    end

    exps = g.exps;
    op = @(x) 1+0*x;
    if exps(1) && (subint(1) > ends(1)) % Left exp has been removed
        op = @(x) op(x).*(x-ends(1)).^exps(1);
        exps(1) = 0;
    end
    if exps(2) && (subint(2) < ends(2)) % Right exp has been removed
        op = @(x) op(x).*(ends(2)-x).^exps(2);
        exps(2) = 0;
    end

    scl = (2/diff(ends))^sum(g.exps)./(2/diff(subint))^sum(exps);
    
    xcheb = chebpts(g.n);
    g = scl*fun(@(x) op(x).*bary(x,g.vals,g.map.for(xcheb)), map, chebfunpref, g.scl);
    g.exps = exps;

else % Linear case with no removed exps is simple
    
    exps = g.exps;
    map = linear(subint);
    xcheb = chebpts(g.n);
    g.vals = bary(map.for(xcheb),g.vals,g.map.for(xcheb))./(diff(g.map.par(1:2))./diff(subint))^sum(exps);
    g.map = map;
    g = simplify(g);

end

