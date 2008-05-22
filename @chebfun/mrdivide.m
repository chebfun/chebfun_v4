function fout = mrdivide(f1,f2)
% /	  Scalar right divide.
% F/C divides the chebfun F by a scalar C.

% Copyright 2002-2008 by The Chebfun Team. See www.comlab.ox.ac.uk/chebfun.

if isa(f2,'double')
    fout = f1*(1/f2);
elseif isa(f1,'double')
    error('currently mrdivide only divides the chebfun by a scalar')
else
    [q,r]=qr(f2,0);
    fout=r\(q'*f1);
end