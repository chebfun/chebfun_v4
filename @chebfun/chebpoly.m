function out = chebpoly(f,n)
% CHEBPOLY	Chebyshev polynomial coefficients
% A = CHEBPOLY(F) returns the coefficients such that
% F_1 = a_N T_N(x)+...+a_1 T_1(x)+a_0 T_0(x) where T_N(x) denotes the N-th
% Chebyshev polynomial and F_1 denotes the first fun of chebfun F.
%
% A = CHEBPOLY(F,i) returns the same coefficients for the i-th fun.
 
% Ricardo Pachon and Lloyd N. Trefethen, 2007, Chebfun Version 2.0
nfuns = length(f.funs);
if nargin == 1
    if nfuns>1
        warning('Chebfun has more than one fun. Only the Chebyshev coefficients of the first one are returned');
    end
    out = funpoly(f.funs{1});
else
    if n>nfuns
        error(['Chebfun only has ',num2str(nfuns),' funs'])
    else
        out = funpoly(f.funs{n});
    end
end
