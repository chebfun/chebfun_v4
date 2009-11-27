function g = ceil(f)
% CEIL   Pointwise ceiling of a chebfun.
% G = CEIL(F) returns the chebfun G such that G(X) = CEIL(F(X)) for each
% X in the domain of F.
%
% See also CHEBFUN/FLOOR, CHEBFUN/ROUND, CHEBFUN/FIX, CEIL.
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2008 by The Chebfun Team. 

for k = 1:numel(f)
    if any(get(f(:,k),'exps')<0), error('CHEBFUN:ceil:inf',...
        'Ceil is not defined for functions which diverge to infinity'); end
end

g = -floor(-f);
