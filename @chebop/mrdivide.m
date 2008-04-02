function C = mrdivide(A,B)

if isa(B,'chebop')
  error('chebop:mrdivide:noright','Right inverses not implemented.')
elseif numel(B)~=1
  error('chebop:mrdivide:scalaronly','May divide by scalars only.')
end

C = mtimes(1/B,A);

end