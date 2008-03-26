function C = mpower(A,m)

if (m > 0) && (m==round(m))
  C = chebop(A.varmat^m, @iteratedop, domain(A) );
  C.difforder = m*A.difforder;
elseif m==0
  C = chebop_eye(domain(A));
else
  error('chebop:mpower:badexponent',...
    'Only nonnegative integer exponents are allowed.')
end

  function u = iteratedop(u) 
    for k=1:m
      u=feval(A.oper,u); 
    end
  end

end

