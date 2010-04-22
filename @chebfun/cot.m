function Fout = cot(F)
% COT   Cotangent of a chebfun.
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2009 by The Chebfun Team. 

for k = 1:numel(F)
    if any(get(F(:,k),'exps')<0), error('CHEBFUN:cot:inf',...
        'Cot is not defined for functions which diverge to infinity'); end
end

Fout = comp(F, @(x) cot(x));
for k = 1:numel(F)
    Fout(k).jacobian = anon('@(u) -diag(csc(F).^2)*diff(F,u)',{'F'},{F(k)});
    Fout(k).ID = newIDnum();
end