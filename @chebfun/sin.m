function Fout = sin(F)
% SIN   Sine of a chebfun.
%
% See http://www.maths.ox.ac.uk/chebfun for Chebfun information.

% Copyright 2002-2009 by The Chebfun Team. 

for k = 1:numel(F)
    if any(get(F(:,k),'exps')<0), error('CHEBFUN:sin:inf',...
        'SIN is not defined for functions which diverge to infinity'); end
end

Fout = comp(F, @(x) sin(x));
for k = 1:numel(F)
    Fout(k).jacobian = anon(['diag1 = diag(cos(F)); der2 = diff(F,u,''linop'');' ...
        'der = diag1*der2; nonConst = ~der2.iszero;'],{'F'},{F(k)},1);
    Fout(k).ID = newIDnum;
end
