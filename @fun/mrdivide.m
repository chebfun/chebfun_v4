function F = mrdivide(f,g)
% /	Right scalar divide
% F/C divides the fun F by a scalar C.
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2008 by The Chebfun Team. 

F=f;
if (isa(g,'double'))
    F.vals=f.vals/g;
    F.scl.v=f.scl.v/g;
else
    error('Use ./ to divide a fun into a fun.');
end