function Fout = airy(K,F)
% AIRY   Airy functino of a chebfun.
% AIRY(F) returns the Airy function of a chebfun F. 
% AIRY(K,F) uses the parameter K as in the standard MATLAB command AIRY to 
% compute different results based on the Airy function
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2009 by The Chebfun Team. 

if nargin == 1, 
    F = K;
    K = 0;
end

Fout = comp(F, @(x) real(airy(K,x)));  
for k = 1:numel(F)
    Fout(k).jacobian = anon('@(u) diag(airy(K+1,F))*jacobian(F,u)',{'F' 'K'},{F(k) K});
    Fout(k).ID = newIDnum();
end
