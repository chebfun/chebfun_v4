% zeta - crude approximate evaluation of Riemann zeta
%        function using a bunch of terms of the series

 function zeta = zeta(z)
 nterms = 10000;
 zeta = zeros(size(z));
 for k = 1:nterms
   zeta = zeta + k.^(-z);
 end

