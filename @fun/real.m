function gout = real(g)
% REAL	Complex real part
% REAL(G) is the real part of G.

gvals = real(g.vals);
if all(gvals == 0), 
    gout = fun(0); 
else
    gout = simplify(set(g,'vals',gvals));
end