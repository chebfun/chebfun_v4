function Fout = sinh(F)
% SINH   Hyperbolic sine of a chebfun.
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2008 by The Chebfun Team.

for k = 1:numel(F)
    if any(get(F(:,k),'exps')), error('CHEBFUN:sin:inf',...
        'chebfun cannot handle exponential blowups'); end
end

Fout = comp(F, @(x) sinh(x));
for k = 1:numel(F)
    Fout(k).jacobian = anon('@(u) diag(cosh(F))*jacobian(F,u)',{'F'},{F(k)});
    Fout(k).ID = newIDnum;
end