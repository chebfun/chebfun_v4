function u = simplify(u,k,tol)
% SIMPLIFY a chebfun
%   U = SIMPLIFY(U,TOL) removes leading Chebyshev coefficients of the 
%   chebfun U that are below epsilon, relative to the verical scale 
%   stored in U.scl.v. TOL is the tolerance used in this process. 
%   IF TOL is not provided, it is retrived from CHEBFUNPREF.
%
%   U = SIMPLIFY(U,K,TOL) simplifies only the funs of U given by the 
%   entries of the integer vector K.
%
%   See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

%   Copyright 2002-2009 by The Chebfun Team. 
%   Last commit: $Author$: $Rev$:
%   $Date$:

if nargin == 1, 
    k = 1:u.nfuns;
end

if nargin < 3, 
    tol = chebfunpref('eps');
end

if any(k < 1)
    tol = k;
    k = 1:u.nfuns;
end

for kk = k
    u.funs(kk) = simplify(u.funs(kk),tol);
end
