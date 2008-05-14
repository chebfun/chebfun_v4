function e = end(A,k,m)
% END  Last row or column of a chebop.
 
% We use a really dirty kludge here. By making the result be imaginary
% infinity, the caller can use a syntax like A(end-2,:) and get the -2 part
% recorded as the result -2+Infi. This can then be parsed by subsref and
% turned into the anonymous function @(n)n-2.

% Toby Driscoll, 15 May 2008.
% Copyright 2008.

if m==2
  e = complex(0,Inf);
else
  error('chebop:end:bad','Bad indexing use of end.')
end