function gout = imag(g)
% IMAG	Complex imaginary part
% IMAG(F) is the imaginary part of F.

% Copyright 2002-2008 by The Chebfun Team. See www.comlab.ox.ac.uk/chebfun/

gvals = imag(g.vals);
if all(gvals == 0), 
    gout = fun(0); 
else
    gout = simplify(set(g,'vals',gvals));
end