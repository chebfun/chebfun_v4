function fout = mldivide(f1,f2)
% \   Scalar left divide.
% C\F divides the chebfun F by a scalar C.
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2008 by The Chebfun Team. 

if isa(f1,'double')
    fout = (1/f1) * f2;
elseif isa(f2,'double')
    error('currently mrdivide only divides the chebfun by a scalar')
else
    [q,r]=qr(f1,0);
    fout=r\(q'*f2);
end