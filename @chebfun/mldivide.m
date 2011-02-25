function fout = mldivide(f1,f2)
% \   Scalar left divide.
% C\F divides the chebfun F by a scalar C.

% Copyright 2011 by The University of Oxford and The Chebfun Developers. 
% See http://www.maths.ox.ac.uk/chebfun/ for Chebfun information.

if isa(f1,'double')
    fout = (1/f1) * f2;
elseif isa(f2,'double')
    error('CHEBFUN:rdivide:nonscalar','currently mrdivide only divides the chebfun by a scalar')
else
    [q,r]=qr(f1,0);
    fout=r\(q'*f2);
end