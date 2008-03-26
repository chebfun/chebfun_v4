function e = end(A,k,m)

% We use a really dirty kludge here. By making the result be imaginary
% infinity, the caller can use a syntax like A(end-2,:) and get the -2 part
% recorded as the result -2+Infi. This can then be parsed by subsref.

if m==2
  e = complex(0,Inf);
else
  error('varmat:end:bad','Bad indexing use of end.')
end