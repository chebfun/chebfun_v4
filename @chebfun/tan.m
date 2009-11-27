function Fout = tan(F)
% TAN   Tangent of a chebfun.
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2008 by The Chebfun Team. 

for k = 1:numel(F)
    if any(get(F(:,k),'exps')<0), error('CHEBFUN:tan:inf',...
        'Tan is not defined for functions which diverge to infinity'); end
end

Fout = comp(F, @(x) tan(x));
for k = 1:numel(F)
    Fout(k).jacobian = anon('@(u) diag(sec(F).^2)*jacobian(F,u)',{'F'},{F(k)});
    Fout(k).ID = newIDnum;
end
    