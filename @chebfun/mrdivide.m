function fout = mrdivide(f1,f2)
% /	Right scalar divide
% F/C divides the chebfun F by a scalar C.

% Chebfun Version 2.0

if isa(f2,'double')
    fout = f1*(1/f2);
elseif isa(f1,'double')
    error('currently mrdivide only divides the chebfun by a scalar')
else
    [q,r]=qr(f2,0);
    fout=r\(q'*f1);
end