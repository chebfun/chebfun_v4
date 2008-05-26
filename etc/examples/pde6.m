% pde6.m -- Solve the BVP u''=F(u), u(+-1)=0
% Convergence problem
function u = pde6()

F = @(u) exp(u);  % problem definition

u = chebfun(@(x) x.^2-1);   % initial guess
du = Inf;               % for initial pass

while norm(du) > 1e-12
 plot(u), pause
 du = chebfun( @newtonstep );
 plot(du), pause
 u = u + du;
end

 function v = newtonstep(x)
   N = length(x)-1;
   D = cheb(N); D2 = D^2;
   D2 = D2(2:N,2:N);
   ux = u(x(2:N));
   d2u = diff(u,2);
   rhs = F(ux) - d2u(x(2:N));
   % The next line might be skipped on some iterations with better
   % programming: change only if min(u), max(u) exceed earlier limits.
   df = diff( chebfun(F,[min(u) max(u)]) );     dfux = df(ux);
   v = [0; (D2-diag(dfux))\rhs; 0];
 end  % newtonstep()

end  % pde6()


