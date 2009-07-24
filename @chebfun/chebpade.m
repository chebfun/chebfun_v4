function [r p q] = chebpade(F,m,n) 
%CHEBYSHEV-PADE APPROXIMATION
% [R P Q] = CHEBPADE(F,M,N) constructs R = P/Q, where P and Q are
%   chebfuns corresponding to the [M/N] Chebyshev-Pade approximation 
%   chebfun F.
% [R P Q] = CHEBPADE(A,M,N) construct the [M/N] approximation to
%   the function with Chebyshev coefficients A.
%
% If F is a quasimatrix then so are the outputs P & Q, and R is a 
% cell array of function handles.
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

%  Copyright 2002-2009 by The Chebfun Team. 
%  Last commit: $Author: nich $: $Rev: 493 $:
%  $Date: 2009-06-05 15:56:23 +0100 (Fri, 05 Jun 2009) $:

tol = 1e-14; % tolerance for testing singular matrices

if numel(F) > 1, % Deal with quasimatrices    
    trans = false;
    if get(F,'trans')
        F = F.';        trans = true;
    end
    
    r = cell(1,numel(F)); p = chebfun; q = chebfun;
    % loop over chebfuns
    for k = 1:numel(F)
        [r{k} p(:,k) q(:,k)] = chebpade(F(:,k),m,n);
    end
   
    if trans
        r = r.'; p = p.'; q = q.';
    end
    
    return
end

d = domain(F.ends(1:2));
a = chebpoly(F,1).';
a = a(end:-1:1);

if length(F) < m+2*n+1, 
    warning('chebfun:chebpade:coeffs', ...
        ['Not enough coefficients given for [',int2str(m),'/',int2str(n),'] approx.', ...])
        ' Assumming remainder are noise.']); 
    a = [a ; eps*randn(m + 2*n+1 - length(F),1)]; % this is more stable than zeros?
end

% denominator
row = (1:n);
col = (m+1:m+n)';
D = a(col(:,ones(n,1))+row(ones(n,1),:)+1)+a(abs(col(:,ones(n,1))-row(ones(n,1),:))+1);
if n > m,  D = D + a(1)*diag(ones(n-m,1),m); end
if rank(D,tol) < min(size(D)) % test for singularity of matrix
    if m > 1
        [r p q] = chebpade(F,m-1,n);
        warning('chebfun:chebpade:singular_goingleft', ...
            ['Singular matrix encountered. Computing [',int2str(m-1),',',int2str(n),'] approximant.'])
    elseif n > 1
        [r p q] = chebpade(F,m,n-1);
        warning('chebfun:chebpade:singlar_goingup', ...
            ['Singular matrix encountered. Computing [',int2str(m),',',int2str(n-1),'] approximant.'])
    else
        error('chebfun:chebpade:singlar_fail', ...
            'Singular matrix encountered. [1/1] approximation is not computable.');
    end
    return
else 
    qk = [1; -D\(2*a(m+2:m+n+1))];
end

% numerator
col = (1:m)';
B = a(col(:,ones(n,1))+row(ones(m,1),:)+1)+a(abs(col(:,ones(n,1))-row(ones(m,1),:))+1);
mask = 1:(m+1):min(m,n)*(m+1);
B(mask) = B(mask) + a(1);
if m == 1, B = B.'; end
B = [a(2:n+1).' ;  B];
pk = .5*B*qk(2:n+1)+qk(1)*a(1:m+1);

% p, q and r
p = chebfun(chebpolyval(flipud(pk)),d);
q = chebfun(chebpolyval(flipud(qk)),d);
r = @(x) p(x)./q(x);
