function out = eq(g1,g2)
% ==	Equal
% G1 == G2 compares funs G1 and G2 and returns one if G1 and G2 are
% equal and zero otherwise. 

if g1.n==g2.n && g1.scl.h == g2.scl.h && ...
        g1.scl.v == g2.scl.v && all(g1.vals==g2.vals)
    out = true;
else
    out = false;
end