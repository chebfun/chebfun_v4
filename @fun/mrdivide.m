function F = mrdivide(f,g)
% /	Right scalar divide
% F/C divides the fun F by a scalar C.

% Copyright 2003 Zachary Battles, Chebfun Version 1.0
% Modified by Rodrigo Platte, Feb 2008.

F=f;
if (isa(g,'double'))
    F.vals=f.vals/g;
    F.scl.v=f.scl.v/g;
else
    error('Use ./ to divide a fun into a fun.');
end