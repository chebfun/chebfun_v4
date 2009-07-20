function g1 = times(g1,g2)
% .*	Chebfun multiplication
% G1.*G2 multiplies funs G1 and G2 or a fun by a scalar if either G1 or G2 is
% a scalar.
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2008 by The Chebfun Team. 
% Last commit: $Author: rodp $: $Rev: 537 $:
% $Date: 2009-07-17 16:15:29 +0100 (Fri, 17 Jul 2009) $:

if (isempty(g1) || isempty(g2)), g1=fun; return; end
if (isa(g1,'double') || isa(g2,'double'))
  g1 = mtimes(g1,g2);
  return;
end  

% Deal with maps
% If two maps are different, call constructor.
if ~samemap(g1,g2)
    g1 = fun(@(x) feval(g1,x).*feval(g2,x),g1.map.par(1:2));
    return
end

temp=prolong(g1,g1.n+g2.n-1); 
if isequal(g1,g2)
   vals=temp.vals.^2;          
elseif isequal(conj(g1),g2)
   vals=conj(temp.vals).*temp.vals;
else
   temp2=prolong(g2,g1.n+g2.n-1); 
   vals=temp.vals.*temp2.vals;
end

% Deal with scales:
scl.h = max(g1.scl.h,g2.scl.h);
scl.v = norm([g1.scl.v; g2.scl.v; vals],inf);
g1.scl = scl;

% Simplify:
g1.vals = vals; g1.n = length(vals);
g1 = simplify(g1); 
