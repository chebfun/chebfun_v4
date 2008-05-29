function fout = mldivide(f1,f2)
% \   Scalar left divide.
% C\F divides the chebfun F by a scalar C.

% Copyright 2002-2008 by The Chebfun Team. See www.comlab.ox.ac.uk/chebfun.

if isa(f1,'double')
    fout = (1/f1) * f2;
elseif isa(f2,'double')
    error('currently mrdivide only divides the chebfun by a scalar')
else
    [q,r]=qr(f1,0);
    fout=r\(q'*f2);
end