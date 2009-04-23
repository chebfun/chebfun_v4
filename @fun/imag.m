function gout = imag(g)
% IMAG	Complex imaginary part
% IMAG(F) is the imaginary part of F.
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2008 by The Chebfun Team. 

gvals = imag(g.vals);
if all(gvals == 0), 
    gout = fun(0); 
else
    gout = simplify(set(g,'vals',gvals));
end