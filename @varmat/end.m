function e = end(A,k,m)
% END  Last row or column of a varmat.

% Copyright 2008 by Toby Driscoll.
% See www.comlab.ox.ac.uk/chebfun.

% We use a really dirty kludge here. By making the result be imaginary
% infinity, the caller can use a syntax like A(end-2,:) and get the -2 part
% recorded as the result -2+Infi. This can then be parsed by subsref into a 
% function like @(n)n-2.

if m==2
  e = complex(0,Inf);
else
  error('VARMAT:end:bad','Bad indexing use of end.')
end