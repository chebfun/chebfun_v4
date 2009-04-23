function F = conj(F)
% CONJ	 Complex conjugate.
% CONJ(F) is the complex conjugate  of F.
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2008 by The Chebfun Team. 

for k = 1:numel(F)
    funs = F(k).funs;
    for j = 1:numel(funs)
        funs(j) = conj(funs(j));
    end
    F(k).funs = funs;
end
