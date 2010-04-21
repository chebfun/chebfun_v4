function out = chebpoly(f,ii,N)
% CHEBPOLY   Chebyshev polynomial coefficients.
% A = CHEBPOLY(F) returns the vector of coefficients such that
% F_1 = A(1) T_M(x) + ... + A(M) T_1(x) + A(M+1) T_0(x), where T_M(x) denotes 
% the M-th Chebyshev polynomial and F_1 denotes the first fun of chebfun F.
%
% A = CHEBPOLY(F,I) returns the coefficients for the I-th fun.
%
% A = CHEBPOLY(F,I,N) truncates or pads the vector A so that N coefficients 
% of the fun F_I are returned. However, if I is 0 then the global coefficients 
% of the *chebfun* F are returned (by computing relevent inner products with 
% Chebyshev polynomials).
%
% There is also a CHEBPOLY command in the chebfun trunk directory, which
% computes the chebfun corresponding to the Chebyshev polynomial T_n.
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2009 by The Chebfun Team. 
 
if numel(f) > 1, 
    error('CHEBFUN:chebpoly:quasi','CHEBPOLY does not handle chebfun quasi-matrices')
end
if nargin < 2,  
    if f.nfuns > 1
        warning('CHEBFUN:chebpoly:nfuns1',['Chebfun has more than one fun. Only the Chebyshev' ...
                 ' coefficients of the first one are returned.' ...
                 ' Use CHEBPOLY(F,1) to suppress this warning.']);
    end
    ii = 1; 
end
if ii > f.nfuns
    error('CHEBFUN:chebpoly:nfuns2',['Chebfun only has ',num2str(f.nfuns),' funs']);
end
if nargin < 3, N = []; end
if ii == 0 && isempty(N)
    error('CHEBFUN:chebpoly:inputs','Input N must not be empty if I is zero.');
end

% No truncating or padding. So just default behavior.
if isempty(N)
    out = chebpoly(f.funs(ii)).';
    return
end

% Truncating or padding of a fun. Also deals with simple, linear chebfun case.
if ii > 0 || (f.nfuns == 1 && ~any(f.funs(1).exps) && strcmp(f.funs(1).map.name,'linear'))
    if ii == 0, ii = 1; end
    c = chebpoly(f.funs(ii)).';
    c = [zeros(1,N-length(c)) c];
    out = c(end-(N-1):end);
    return
end

% Compute coefficients via inner products.
[d x] = domain(f.ends(1),f.ends(end));

if any(isinf(d))
    error('CHEBFUN:chebpoly:infint','Infinite intervals are not supported here.');
else
    w = 1./sqrt((x-d(1)).*(d(2)-x));
    out = zeros(1,N);
    for k = 1:N
        T = chebpoly(k-1,d);
        I = (f.*T).*w;
        out(N-k+1) = 2*sum(I)/pi;
    end
    out(N) = out(N)/2;
end

