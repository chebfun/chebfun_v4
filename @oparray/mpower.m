function M = mpower(A,m)
% ^   Repeated application of oparray.

assert( (numel(m)==1)&&(m==round(m))&&(m>=0), ...
  'oparray:mpower:argument','Exponent must be a nonnegative integer.');

s = size(A.op);
assert( s(1)==s(2), 'oparray:mpower:square', 'Oparray must be square');

if m==0
  op = repmat( {@(u) 0*u}, s );
  for i = 1:s(1), op{i,i} = @(u) u; end
  M = oparray(op);
else
   M = A;
  for i = 1:m-1, M = M*A; end
end

end