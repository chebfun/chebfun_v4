function Fout = atand(F)
% ATAND    Inverse tangent of a chebfun, result in degrees.

% Copyright 2011 by The University of Oxford and The Chebfun Developers. 
% See http://www.maths.ox.ac.uk/chebfun/ for Chebfun information.

Fout = comp(F, @(x) atand(x));
for k = 1:numel(F)
    Fout(k).jacobian = anon('diag1 = diag((180/pi)./(1+F.^2)); der2 = diff(F,u,''linop''); der = diag1*der2; nonConst = ~der2.iszero;',{'F'},{F(k)},1,'atand');
    Fout(k).ID = newIDnum();
end
