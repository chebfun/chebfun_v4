function out = poly(f,n)
% POLY	Polynomial coefficients.
% POLY(F) returns the polynomial coefficients of the first fun of F. 
% POLY(F,N) returns the polynomial coefficients of the Nth fun of F.
% For numerical work, the Chebyshev polynomial coefficients returned
% by CHEBPOLY are more useful.
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2009 by The Chebfun Team. 

nfuns = f.nfuns;
if nargin == 1
    if nfuns>1
        warning('CHEBFUN:poly', ...
            'Chebfun has more than one fun. Only the polynomial coefficients of the first one are returned');
    end
    n = 1;
end

if n > nfuns
    error('CHEBFUN:poly:nfuns',['Chebfun only has ',num2str(nfuns),' funs'])
else
    % Call fun/poly.m
    out = poly(f.funs(n));
end

