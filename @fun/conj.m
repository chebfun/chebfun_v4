function gout = conj(g)
% CONJ	Complex conjugate
% CONJ(F) is the complex conjugate of F.

gout = g;
gout.vals = conj(gout.vals);