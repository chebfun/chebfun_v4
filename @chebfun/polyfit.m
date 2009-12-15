function f = polyfit(y,n)  
%POLYFIT Fit polynomial to a chebfun.
%   F = POLYFIT(Y,N) returns a chebfun F corresponding to the
%   polynomial of degree N that fits the chebfun Y in
%   the least-squares sense.
%
%   See http://www.maths.ox.ac.uk/chebfun for chebfun information.

% Copyright 2009 by The Chebfun Team. 
% Nick Hale & Rodrigo Platte,  21/01/2009

if n > length(y) && y.nfuns == 1
    f = y;
else
    [a,b] = domain(y);
    for k = 0:n
       E(:,k+1) = legpoly(k,[a,b],'norm');  % Legendre-Vandermonde matrix
    end
    
    f = E*(E'*y);                          % least squares chebfun
end
