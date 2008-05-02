function F = norm(f,n)
% NORM	Chebfun norm
% For quasi-matrices
%	NORM(A) is the largest singular value of A.
%	NORM(A,2) is the same as NORM(A).
%	NORM(A,1) is the maximum over the 1-norms of the columns of A.
%	NORM(A,'fro') is the Frobenius norm, sqrt(sum(svd(A).^2)).
%   NORM(A,'inf') is the maximum over the 1-norms of the rows of A
%
% For chebfuns
%	NORM(F) = NORM(F,2).
%	NORM(F,2) = sqrt(integral from -1 to 1 F^2)).
%	NORM(F,1) = integral from -1 to 1 abs(F).
%	NORM(F,inf) = max(abs(F)).
%	NORM(F,-inf) = min(abs(F)).
%

% Chebfun Version 2.0

if (nargin==1), n=2; end
if numel(f) == 0
    F = []; return;
elseif numel(f) == 1
    switch n
        case 1
            if f.trans, f = f'; end    % <- transpose to use sum (?)
            F = sum(abs(f));
        case 2
            if f.trans, f = f'; end    % <- transpose to use sum (?)
            F = sqrt(sum(conj(f).*f));
        case {inf,'inf'}
            F = max(max(f),-min(f));
        case {-inf,'-inf'}
            F = min(abs(f));
        otherwise
            error('Unknown norm');
    end
elseif numel(f) > 1
    switch n        
        case 1
            F = 0;
            f = max(sum(abs(f),1));
        case 2
            s = svd(f,0);
            F = s(1);
        case 'fro'
              s=svd(f,0);
              F=sqrt(sum(s(s>0).^2));
        case {'inf',inf}
            f = max(sum(abs(f),2));
        otherwise
            error('Unknown norm')
    end
end
F = real(F);       % discard possible imaginary rounding errors