function Fout = sin(F)
% SIN   Sine of a chebfun.
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2008 by The Chebfun Team. 

for k = 1:numel(F)
    if any(get(F(:,k),'exps')), error('CHEBFUN:sin:inf',...
        'Sin is not defined for functions which diverge to infinity'); end
end

Fout = comp(F, @(x) sin(x));
for k = 1:numel(F)
    Fout(k).jacobian = anon('@(u) diag(cos(F))*jacobian(F,u)',{'F'},{F});
    Fout(k).ID = newIDnum;
end
