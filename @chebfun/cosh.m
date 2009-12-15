function Fout = cosh(F)
% COSH   Hyperbolic cosine of a chebfun.
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2009 by The Chebfun Team. 

for k = 1:numel(F)
    if any(get(F(:,k),'exps')), error('CHEBFUN:cosh:inf',...
        'chebfun cannot handle exponential blowups'); end
end

Fout = comp(F, @(x) cosh(x));
for k = 1:numel(F)
    Fout(k).jacobian = anon('@(u) diag(sinh(F))*jacobian(F,u)',{'F'},{F(k)});
    Fout(k).ID = newIDnum();
end
