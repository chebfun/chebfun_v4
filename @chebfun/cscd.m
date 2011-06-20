function Fout = cscd(F)
% CSCD   Cosecant of a chebfun with argument in degrees.

% Copyright 2011 by The University of Oxford and The Chebfun Developers. 
% See http://www.maths.ox.ac.uk/chebfun/ for Chebfun information.

for k = 1:numel(F)
    if any(get(F(:,k),'exps')<0), error('CHEBFUN:cscd:inf',...
        'CSCD is not defined for functions which diverge to infinity'); end
end

Fout = comp(F, @(x) cscd(x));
for k = 1:numel(F)
    Fout(k).jacobian = anon('diag1 = diag(-(pi/180)*cot((pi/180)*F).*cscd(F)); der2 = diff(F,u,''linop''); der = diag1*der2; nonConst = ~der2.iszero;',{'F'},{F(k)},1);
    Fout(k).ID = newIDnum();
end