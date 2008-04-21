function gout = uminus(g)
% -	Unary minus
% -G negates the fun G.

gout = g; gout.vals = -g.vals;