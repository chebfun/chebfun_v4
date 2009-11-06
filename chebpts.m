function x = chebpts(n,d)
%CHEBPTS  Chebyshev points in [-1,1].
%   CHEBPTS(N) returns N Chebyshev points in [-1,1].
%
%   CHEBPTS(N,D) scales the nodes and weights for the domain D. D can be
%   either a domain object or a vector with two components. If the interval
%   is infinite, the map is chosen to be the default unbounded map with
%   mappref('parinf') = [1 0], and mappref('adaptinf') = 0.
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

% rescale x if d is provided:
if nargin > 1
    d = domain(d);
    ab = d.ends;
    
    if ~any(isinf(ab))
        x = (x+1)/2*(ab(end)-ab(1)) + ab(1); 
        
    else
        m = maps({'unbounded'},ab);
        x = m.for(x);
        x([1 end]) = ab([1 end]);
    end
        
end
