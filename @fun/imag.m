function gout = imag(g)
% IMAG	Complex imaginary part
% IMAG(F) is the imaginary part of F.

gvals = imag(g.vals);
if all(gvals == 0), 
    gout = fun(0); 
else
    gout = simplify(set(g,'vals',gvals));
end