function [converged,neweps]=convergencetest(c,epstol)
% Test for convergence on the coefficients of a Chebyshev expansion.
% First tests for the relative size of the coeficients,
% if that doesn't indicate convergence, estimates the rate of convergence.
% If the rate of convergence is worst than O(exp(-5e-4 *N)) it stops and 
% resets the tolerace value.
% 
% R.B. Platte, R. Pachon, L.N. Trefethen 2007

   normc=norm(c,'inf');
   neweps=epstol;
   lenc=length(c);
      
   if norm( c(1:min(4,lenc)) ,inf ) < epstol*normc
      converged=1;
   else
      converged=0;

      if lenc>20
         pin=[-0.0250   -0.0214   -0.0179   -0.0143   -0.0107   -0.0071 ...
              -0.0036    0.0000    0.0036    0.0071    0.0107    0.0143 ...
               0.0179    0.0214    0.0250];
        
         slope=pin*log(abs(c(1:15))+epstol)';
         if slope<5e-4 && norm(c(1:15),inf)<1e-9*norm(c,inf)
             converged=1;
             neweps=norm(c(1:5),inf)/normc;
         end
      
      end
   end