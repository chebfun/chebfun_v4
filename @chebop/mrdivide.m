function C = mrdivide(A,B)

if ~isa(A,'chebop')
  error('chebop:mrdivide:badoperand','Unrecognized operand.')
end

switch(class(B))
  case 'double'
    C = chebop;
    C.op = @(n) A.op(n)/B;
  case 'chebop'
    C = chebop;
    C.op = @(n) A.op(n)/B.op(n);
  otherwise
    error('chebop:mrdivide:badoperand','Unrecognized operand.')
end

end