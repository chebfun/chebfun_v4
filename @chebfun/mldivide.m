function fout = mldivide(f1,f2)
% \ Left scalar divide
% C\F divides the chebfun F by a scalar C.

% Chebfun Version 2.0

if isa(f1,'double')
    fout = (1/f1) * f2;
elseif isa(f2,'double')
    error('currently mrdivide only divides the chebfun by a scalar')
else
    [q,r]=qr(f1,0);
    fout=r\(q'*f2);
end