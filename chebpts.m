function x = chebpts(n)
%CHEBPTS  Chebyshev points in [-1,1].
%   CHEBPTS(N) returns N Chebyshev points in [-1,1].
%
%   See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2008 by The Chebfun Team. 

if n<=0, 
    error('Input should be a positive number');
elseif n==1,
    x=0; 
else
    m = n-1;
    x = sin(pi*(-m:2:m)/(2*m))';
end
