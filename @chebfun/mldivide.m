function Fout = mldivide(F1,F2)
% \ Left scalar divide
% C\F divides the chebfun F by a scalar C.

% Chebfun Version 2.0

if isa(F1,'double')
    Fout = (1/F1) * F2;
else
    error('currently mrdivide only divides the chebfun by a scalar')
end