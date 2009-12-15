function out = jacpoly(f,a,b,n)
% JACPOLY   Jacboi polynomial coefficients.
% A = JACPOLY(F,ALPHA,BETA) returns the coefficients such that
% F_1 = A(1) P_N(x) + ... + A(N) P_1(x) + A(N+1) P_0(x) where P_N(x) denotes 
% the N-th Jacobi polynomial with parameters ALPHA and BETA and F_1 denotes 
% the first fun of chebfun F.
%
% A = JACPOLY(F,ALPHA,BETA,I) returns the coefficients for the I-th fun.
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

% Copyright 2009 by The Chebfun Team. 
 
if numel(f) > 1, error('CHEBFUN:jacpoly:quasi','JACPOLY does not handle chebfun quasi-matrices'), end

if nargin < 3, error('CHEBFUN:jacpoly:numin','JACPOLY requires 3 inputs: F, ALPHA, and BETA.'), end
 
% Select fun!
if nargin == 3
    if f.nfuns>1
        warning('CHEBFUN:jacpoly:nfuns',['Chebfun has more than one fun. Only the Chebyshev' ...
                 ' coefficients of the first one are returned.' ...
                 ' Use JACPOLY(F,1) to suppress this warning.'])
    end
    out = jacpoly(f.funs(1),a,b);
else
    if n>f.nfuns
        error('CHEBFUN:jacpoly:nfuns',['Chebfun only has ',num2str(f.nfuns),' funs'])
    else
        out = jacpoly(f.funs(n),a,b);
    end
end
