function f = cumsum2(f)
%CUMSUM2 Double indefinite integral of a chebfun2.
%
% F = CUMSUM2(F) returns the double indefinite integral of a chebfun2. That
% is,
%                  y  x
%                 /  /
%  CUMSUM2(F) =  |  |   f(x,y) dx dy   for  (x,y) in [a,b]x[c,d],
%                /  /
%               c  a
%
%  where [a,b]x[c,d] is the domain of f. 
% 
% Also see CUMSUM, SUM, SUM2.

% Copyright 2013 by The University of Oxford and The Chebfun Developers.
% See http://www.maths.ox.ac.uk/chebfun/ for Chebfun information.

fun = f.fun2;
if ( isempty(f) ) % check for empty chebfun2.
    f = 0;
    return;
end

% cumsum along the columns.
fun.C = cumsum(fun.C);
% cumsum along the rows.
fun.R = cumsum(fun.R);
f.fun2 = fun;

end