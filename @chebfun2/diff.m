function f = diff(f,n,dim)
%DIFF Derivative of a chebfun2.
%
% DIFF(F) is the derivative of F along the y direction.
%
% DIFF(F,N) is the Nth derivative of F in the y direction.
%
% DIFF(F,N,DIM) is the Nth derivative of F along the dimension DIM.
%     DIM = 1 (default) is the derivative in the y-direction.
%     DIM = 2 is the derivative in the x-direction.
%
% DIFF(F,[NX NY]) is the partial derivative of NX of F in the first 
% variable, and NY of F in the second derivative. For example, DIFF(F,[1
% 2]) is d^3F/dxd^2y.
%
% See also GRADIENT, SUM, PROD.

% Copyright 2013 by The University of Oxford and The Chebfun Developers.
% See http://www.maths.ox.ac.uk/chebfun/ for Chebfun information.

if ( isempty(f) ) % check for empty chebfun2.
    return;
end

if ( nargin == 1 ) % defaults.
    n = 1;
    dim = 1;
end
if ( nargin == 2 ) 
    if length(n) == 1 % diff in y is default.
        dim = 1;
    elseif length(n) == 2
            rect = f.corners;
            f = diff(chebfun2(diff(f.fun2,n(1),2),rect),n(2),1);
            return;
    else
       error('CHEBFUN2:DIFF','Undetermined direction of differentiation.'); 
    end
end
if ( isempty(n) )  % empty n defaults to y-derivative.
    n = 1;
end

rect = f.corners;
if ( ~( dim == 1 ) && ~( dim == 2) )
    error('CHEBFUN2:DIFF:dim','Can compute derivative in x or y only.');
end

f = chebfun2(diff(f.fun2,n,dim),rect);

end