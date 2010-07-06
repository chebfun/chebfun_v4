function D = diffmat(N)
% DIFFMAT  Chebyshev differentiation matrix.
% D = DIFFMAT(N) is the matrix that maps function values at N Chebyshev
% points to values of the derivative of the interpolating polynomial at
% those points. 
%
% Ref: Spectral Methods in MATLAB, L. N. Trefethen. See also Baltensperger
% and Trummer, DOI:10.1137/S1064827501388182.

% $Author$: $Date$:
% $Id$: 
% Copyright 2008-2010 by The Chebfun Team.

persistent cache    % stores computed values for fast return
if isempty(cache), cache = {}; end    % first call

if length(cache) >= N && ~isempty(cache{N})
  D = cache{N};
  return
end

N1 = N-1;  % to be compatible with SMiM definitions
if N1==0, D=0; return, end
x = sin(pi*(N1:-2:-N1)/(2*N1))';
c = [2 ; ones(N1,1)];  c(2:2:end) = -1; c(end) = 2*c(end);
dX = bsxfun(@minus,x,x');              % all pairwise differences
dX(1:N1+2:end) = dX(1:N1+2:end) + 1;   % add eye(N1+1)
D = bsxfun(@rdivide,-c,c.') ./ dX;
s = sum(D,2).';
D(1:N1+2:end) = D(1:N1+2:end) - s;     % negative sum trick

if N < 2^11+2
  siz = whos('cache'); 
  if siz.bytes > cheboppref('maxstorage')
    cache = {};
  end
  cache{N} = D;
end  

% Here is the 'original version', more true to the code in SMiM. But it's
% much slower due to tricks used above. 
% N = N-1;  % to be compatible with SMM definitions
% if N==0, D=0; return, end
% x = sin(pi*(N:-2:-N)/(2*N))';
% c = [2 ; ones(N,1)];  c(2:2:end) = -1; c(end) = 2*c(end);
% X = repmat( x, [1,N+1] ); 
% dX = X-X.';               % all pairwise differences
% D = (c*(1./c)') ./ (dX+eye(N+1));
% D = D - diag(sum(D.'));   % "negative sum trick" 
% D = -D;                   % left->right ordering, unlike SMiM

