function Fout = sin(F)
% SIN   Sine of a chebfun.
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2009 by The Chebfun Team. 

for k = 1:numel(F)
    if any(get(F(:,k),'exps')<0), error('CHEBFUN:sin:inf',...
        'sin is not defined for functions which diverge to infinity'); end
end

Fout = comp(F, @(x) sin(x));
for k = 1:numel(F)
    Fout(k).jacobian = anon('@(u) diag(cos(F))*diff(F,u)',{'F'},{F(k)});
    Fout(k).ID = newIDnum;
end
