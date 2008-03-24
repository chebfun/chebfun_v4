function e = end(A,k,m)

if k==1 && m==2
  e = @(n) n;
else
  error('chebop:end:bad','Bad indexing use of end.')
end