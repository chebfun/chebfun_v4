function A = vander(f,n)
%VANDER Vandermonde chebfun quasimatrix.
%   A = VANDER(f,n) returns the Vandermonde quasimatrix whose n columns are 
%   powers of the chebfun f, that is A(:,j) = f.^(n-j), j=0...n-1.
%

% Copyright 2002-2008 by The Chebfun Team. See www.comlab.ox.ac.uk/chebfun.

if f(1).trans || min(size(f))>1
    error('input must be a column chebfun')
end

A = ones(domain(f),n);
for j = n-1:-1:1
    A(:,j) = f.*A(:,j+1);
end