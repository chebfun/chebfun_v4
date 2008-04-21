function x = chebpts(n)
% This function generates the Chebyshev points.

if n<=0, 
    error('Input should be a positive number');
elseif n==1,
    x=1; 
else
    m = n-1;
    x = sin(pi*(-m:2:m)/(2*m))';
end