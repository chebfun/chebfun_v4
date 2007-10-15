
% pde11.m -- Solve a BVP using Green's function from pde10
%   TAD, 22 Jan 2007

function u = pde11(p,q,f)

if isa(f,'function_handle')
  f = chebfun(f);
end
G = pde10(p,q);
u = chebfun(@solution);

  function u = solution(x)
    u = zeros(size(x));
    for j = 1:length(x)
      u(j) = sum( G(x(j)).*f );
    end
  end

end

