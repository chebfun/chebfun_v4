function out = poly(f,n)
% POLY	Polynomial coefficients.
% POLY(F) returns the polynomial coefficients of the first fun F_1 of the 
% chebfun F so that F_1 = A(1) x^M + ... + A(M) x + 1.
% POLY(F,N) returns the polynomial coefficients of the Nth fun of F.
%
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

if n>nfuns
    error('CHEBFUN:poly:nfuns',['Chebfun only has ',num2str(nfuns),' funs'])
else

    a = f.ends(n); b = f.ends(n+1);
    %x = chebfun(@(x) x,[a,b],f.funs(n).n); % Chebyshev nodes
        
    % Coefficients on the unit interval
    c = fliplr(poly(f.funs(n)));
    
    % Constants for rescaling
    alpha = 2/(b-a); 
    beta = -(b+a)/(b-a);
    
    % Rescale coefficiets to actual interval
    N = f.funs(n).n;              % Degree of polynomial plus 1.
    out = zeros(size(c));         % Preallocate memory
    for j = 0:N-1
        k = j:N-1;
        binom = factorial(k)./(factorial(k-j)*factorial(j));% Binomial coef
        out(j+1) = sum(c(k+1).*binom.*beta.^(k-j).*alpha^(j));
    end
    out = fliplr(out);

end

