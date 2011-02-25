function f = flipud(f)
% FLIPUD Flip/reverse a fun.
%
% G = FLIPUD(F) returns a fun G such that G(x)=F(-x) for all x.

% Copyright 2011 by The University of Oxford and The Chebfun Developers. 
% See http://www.maths.ox.ac.uk/chebfun/ for Chebfun information.

ends = f.map.par(1:2);
if isinf(ends(1)) ||isinf(ends(2))
    error('FUN:flipud:unbounded','FLIPUD cannot be used on unbounded domanins');
end
f.vals = flipud(f.vals);
f.exps = fliplr(f.exps);


