function C = times(A,B)

if isa(A,'double')
  C=A; A=B; B=C;    % swap to make A a chebop
end

switch(class(B))
  case 'double'
    C = chebop( @(n) B.*feval(A,n) );
  case 'chebop'
    C = chebop( @(n) feval(A,n) .* feval(B,n) );
  otherwise
    error('chebop:times:badoperand','Unrecognized operand.')
end

end