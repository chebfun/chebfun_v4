function x = chebpts(n)
% This function generates the Chebyshev points.

% Copyright 2002-2008 by The Chebfun Team. See www.comlab.ox.ac.uk/chebfun/

if n<=0, 
    error('Input should be a positive number');
elseif n==1,
    x=0; 
else
    m = n-1;
    x = sin(pi*(-m:2:m)/(2*m))';
end