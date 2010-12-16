function F = conj(F)
% CONJ	 Complex conjugate.
% CONJ(F) is the complex conjugate of F.
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2009 by The Chebfun Team. 

for k = 1:numel(F)
    funs = F(k).funs;
    for j = 1:numel(funs)
        funs(j) = conj(funs(j));
    end
    F(k).funs = funs;
    F(k).imps = conj(F(k).imps);
    
    F(k).jacobian = anon('diag1 = diag(conj(F)); der2 = diff(F,u); der = diag1*der2; nonConst = ~der2.iszero;',{'F'},{F(k)},1);
    F(k).ID = newIDnum();
end
