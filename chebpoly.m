function f = chebpoly(n,d)
% CHEBPOLY   Chebyshev polynomial of degree n.
% F = CHEBPOLY(N) returns the chebfun corresponding to the Chebyshev
% polynomials T_N(x) on [-1,1], where N may be a vector of positive integers.
%
% F = CHEBPOLY(N,d), where d is an interval or a domain, gives the same 
% result scaled accordingly.
%
% See also chebfun/chebpoly and legpoly.
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2008 by The Chebfun Team. 

if nargin == 1
    d = domain(chebfunpref('domain'));  
end

ln = length(n);
f = chebfun;
for k = 1:ln
    %vk = ones(1,n(k)+1); vk(end-1:-2:1) = -1;
    vk = cos(n(k)*acos(chebpts(n(k)+1)));
    g = chebfun(vk,d);
    f(:,k) = chebfun(vk,d);
end

if size(n,1) > 1, f = f.'; end

