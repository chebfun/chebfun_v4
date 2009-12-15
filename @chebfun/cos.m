function Fout = cos(F)
% COS   Cosine of a chebfun.
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2009 by The Chebfun Team.

for k = 1:numel(F)
    if any(get(F(:,k),'exps')<0), error('CHEBFUN:cos:inf',...
        'Cos is not defined for functions which diverge to infinity'); end
end

Fout = comp(F, @(x) cos(x));
for k = 1:numel(F)
    Fout(k).jacobian = anon('@(u) diag(-sin(F))*jacobian(F,u)',{'F'},{F(k)});
    Fout(k).ID = newIDnum();
end