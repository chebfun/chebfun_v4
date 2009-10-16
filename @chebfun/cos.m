function Fout = cos(F)
% COS   Cosine of a chebfun.
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2008 by The Chebfun Team.

for k = 1:numel(F)
    if any(get(F(:,k),'exps')), error('CHEBFUN:cos:inf',...
        'Cos is not defined for functions which diverge to infinity'); end
end

Fout = comp(F, @(x) cos(x));
