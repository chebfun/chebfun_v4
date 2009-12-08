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

% deal with input arguments
if nargin ==1
    tol = chebfunpref('eps');
    k = [];
elseif nargin == 2
    if min(k) < 1
        tol = max(min(k),eps);
        k = [];
    else
        tol = chebfunpref('eps');
    end
end
if ~isempty(k) && numel(u)>1 && numel(u)~=length(k)
    error('chebfun:simplify:quasimatrices',['For quasimatrices, '...
        'second imput must be a vector with length matching the '...
        'number of columns or rows in the quasimatrix'])
end
kfun = k(:)';

for j = 1:numel(u)
    
    if isempty(k)
        kfun = 1:u(j).nfuns;
    end
    
    for kk = kfun
        u(j).funs(kk) = simplify(u(j).funs(kk),tol);
    end
    
end