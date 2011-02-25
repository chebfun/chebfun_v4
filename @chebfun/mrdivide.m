function fout = mrdivide(f1,f2)
% /	  Scalar right divide.
% F/C divides the chebfun F by a scalar C.

% Copyright 2011 by The University of Oxford and The Chebfun Developers. 
% See http://www.maths.ox.ac.uk/chebfun/ for Chebfun information.

if isa(f2,'double')
    fout = f1*(1/f2);
elseif isa(f1,'double')
    error('CHEBFUN:ldivide:nonscalar','Currently mrdivide only divides the chebfun by a scalar.')
else
    [q,r]=qr(f2,0);
    fout=r\(q'*f1);
end