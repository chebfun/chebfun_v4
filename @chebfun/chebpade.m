function [r p q pk qk] = chebpade(F,m,n) 
%CHEBYSHEV-PADE APPROXIMATION
% [R P Q] = chebpade(F,M,N) constructs R = P/Q, where P and Q are
%   chebfuns corresponding to the [M/N] Chebyshev-Pade approximation 
%   chebfun F.
% [R P Q] = chebpade(A,M,N) construct the [M/N] approximation to
%   the function qith Chebyshev coefficients A.
%
% Nick Hale, 2009

tol = 1e-14; % tolerance for testing singular matrices

if isa(F,'chebfun')
    if numel(F) > 1, error('CHEBPADE does not handle chebfun quasi-matrices'), end
    if F.nfuns > 2
        warning(['Chebfun has more than one fun. Only the Chebyshev-' ...
                 'Pade approximation to the first one is returned.'])
    end
    d = domain(F.ends(1:2));
    a = chebpoly(F,1).';
    a = a(end:-1:1);
end

a = a(:);
lengtha = length(a);
if lengtha < m+2*n+1, 
    warning(['Not enough coefficients given for [',int2str(m),'/',int2str(n),'] approx.', ...])
    ' Assumming remainder are noise']); 
    a = [a ; eps*randn(m + 2*n+1 - lengtha,1)]; % this is more stable than zeros?
end

% denominator
row = (1:n);
col = (m+1:m+n)';
D = a(col(:,ones(n,1))+row(ones(n,1),:)+1)+a(abs(col(:,ones(n,1))-row(ones(n,1),:))+1);
if n > m,  D = D + a(1)*diag(ones(n-m,1),m); end
if rank(D,tol) < min(size(D)) % test for singularity of matrix
    if m > 1
        [r p q pk qk] = chebpade(F,m-1,n);
        warning(['Singular matrix encountered. Computing [',int2str(m-1),',',int2str(n),'] approximant'])
    elseif n > 1
        [r p q pk qk] = chebpade(F,m,n-1);
        warning(['Singular matrix encountered. Computing [',int2str(m),',',int2str(n-1),'] approximant'])
    else
        error('Singular matrix encountered. [1/1] approximation is not computable');
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

% figure
% subplot(1,2,1)
% xx = linspace(d(1),d(2),10000);
% % fp_minus_q = norm(p(xx)-q(xx).*F(xx),inf)
% % f_minus_pq = norm(p(xx)./q(xx)-F(xx),inf)
% semilogy(xx,abs(p(xx)-q(xx).*F(xx))); hold on
% semilogy(xx,abs(p(xx)./q(xx)-F(xx)),'r'); hold off
% title('error of fp-q');
% legend('qF-p','F-p/q');
% 
% subplot(1,2,2)
% err = chebfun(@(x) 1+p(x)-q(x).*F(x),d);
% errk = (chebpoly(err).');    errk(end) = 0;
% errk = errk(end:-1:1);
% errk = [errk ; eps*ones(length(a)-length(errk),1)];
% semilogy(abs(a),'r');  hold on
% semilogy(abs(errk));    hold off
% title('coefficients of fp-q');
% legend('F','fp-q');

