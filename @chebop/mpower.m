function C = mpower(A,m)
% ^   Power of a chebop.
% For chebop A and nonnegative integer M, A^M returns the chebop
% representing M-fold application of A.

% Toby Driscoll, 14 May 2008.
% Copyright 2008.

if (m > 0) && (m==round(m))
  C = chebop(A.varmat^m, @iteratedop, A.fundomain );
  C.difforder = m*A.difforder;
elseif m==0
  C = eye(A.fundomain);
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

