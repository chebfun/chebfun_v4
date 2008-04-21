function F = norm(f,n)
% NORM	Chebfun norm
%	NORM(F) = NORM(F,2).
%	NORM(F,2) = sqrt(integral from -1 to 1 F^2)).
%	NORM(F,1) = integral from -1 to 1 abs(F).
%	NORM(F,inf) = max(abs(F)).
%	NORM(F,-inf) = min(abs(F)).
%

% Chebfun Version 2.0

if numel(f)>1, error('norm does not handle chebfun quasi-matrices'), end %need to fix this

if (nargin==1), n=2; elseif strcmp(n,'inf'), n=inf; elseif strcmp(n,'-inf'), n=-inf; end

if n==2
    F = sqrt(sum(conj(f).*f));
elseif n==1
    F = sum(abs(f));
elseif n==inf
    F = max(max(f),-min(f));
elseif n==-inf
    F = min(abs(f));
else
    error('Unknown norm');
end
F = real(F);   % discard possible imaginary rounding errors
