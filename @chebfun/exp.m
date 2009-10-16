function Fout = exp(F)
% EXP Exponential of a chebfun.
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2008 by The Chebfun Team. 

for k = 1:numel(F)
    if any(F(:,k).imps(1,:) == inf), error('CHEBFUN:sin:inf',...
        'chebfun cannot handle exponential blowups'); end
end

Fout = comp(F, @(x) exp(x));