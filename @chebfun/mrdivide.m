function Fout = mrdivide(F1,F2)
% /	Right scalar divide
% F/C divides the chebfun F by a scalar C.

% Chebfun Version 2.0

if isa(F2,'double')
    Fout = F1*(1/F2);
else
    error('currently mrdivide only divides the chebfun by a scalar')
end