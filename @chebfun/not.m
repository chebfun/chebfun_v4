function fout = not(F)
%~ Chebfun NOT
%  Not returns a chebfun which evaluates to zero at all points where f is
%  zero and one otherwise.
%
%   Example:
%       f = ~chebfun(0);
%       g = ~chebfun(@(x) x); g([-1 0 1])
%       
%  See also chebfun/eq.

% Copyright 2011 by The University of Oxford and The Chebfun Developers. 
% See http://www.maths.ox.ac.uk/chebfun/ for Chebfun information.

fout = chebfun;
for k = 1:min(size(F)) % Do it for each column of F1.
      fout = [fout  notcol(F(k))];
end

function fout = notcol(f)
% Not for one single chebfun 

fout = sign(f);
for k = 1:fout.nfuns
    if all(fout.funs(k).vals) == 0
        fout.funs(k) = fun(1);
    else 
        fout.funs(k) = fun(0);
    end
end

fout.imps = ~feval(f,fout.ends(1,:));
