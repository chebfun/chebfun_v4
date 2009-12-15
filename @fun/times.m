function g1 = times(g1,g2)
% .*	Fun multiplication
% G1.*G2 multiplies funs G1 and G2 or a fun by a scalar if either G1 or G2 is
% a scalar.
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2009 by The Chebfun Team. 
% Last commit: $Author: rodp $: $Rev: 537 $:
% $Date: 2009-07-17 16:15:29 +0100 (Fri, 17 Jul 2009) $:

if (isempty(g1) || isempty(g2)), g1=fun; return; end

% Deal with scalars
if (isa(g1,'double') || isa(g2,'double'))
  g1 = mtimes(g1,g2);
  return;
end  

% Deal with scalar funs
if length(g1.vals) == 1 && ~any(g1.exps)
    g1 = mtimes(g1.vals,g2); return, 
end
if length(g2.vals) == 1 && ~any(g2.exps)
    g1 = mtimes(g1,g2.vals); return
end

% Deal with exps 
if any(g2.exps<0), g1 = extract_roots(g1); end
if any(g1.exps<0), g2 = extract_roots(g2); end
exps = sum([g1.exps ; g2.exps]); % (just have to add!)
 
% Deal with maps
% If two maps are different, call constructor.
if ~samemap(g1,g2)
    x1 = g1.map.for(chebpts(g1.n));
    x2 = g2.map.for(chebpts(g2.n));
    g1 = fun(@(x) bary(x,g1.vals,x1).*bary(x,g2.vals,x2),g1.map.par(1:2));
    
    g1.exps = exps;
    return
end

% The map is the same, so the length of the product is known.
temp = prolong(g1,g1.n+g2.n-1); 
if isequal(g1,g2)
   vals = temp.vals.^2;          
elseif isequal(conj(g1),g2)
   vals = conj(temp.vals).*temp.vals;
else
   temp2 = prolong(g2,g1.n+g2.n-1); 
   vals = temp.vals.*temp2.vals;
end

% Deal with scales:
scl.h = max(g1.scl.h,g2.scl.h);
%scl.v = norm([g1.scl.v; g2.scl.v; vals],inf);
scl.v = norm(vals,inf);
g1.scl = scl;

% Simplify:
g1.vals = vals; g1.n = length(vals); g1.exps = exps;
g1 = simplify(g1); 
