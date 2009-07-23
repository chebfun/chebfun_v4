function w = bary_weights(xk)
% W = BARY_WEIGHTS(XK)
% Compute the barycentric weights W for the points XK, scaled such that
% norm(W,inf) == 1.
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

%  Copyright 2002-2009 by The Chebfun Team. 
%  Last commit: $Author: nich $: $Rev: 458 $:
%  $Date: 2009-05-10 20:51:03 +0100 (Sun, 10 May 2009) $:

n = length(xk);
C = 4/(max(xk)-min(xk)); % Capacity of interval
if n < 300          % for small n using matrices is faster
   XK = repmat(xk(:),1,n);
   V = C*(XK-XK');
   V(logical(eye(n))) = 1;
   VV = exp(sum(log(abs(V))));
   w = 1./(prod(sign(V)).*VV).';
else               % for large n use a loop
   w = ones(n,1);
   for j = 1:n
       v = C*(xk(j)-xk);
       v = v(logical(v));
       vv = exp(sum(log(abs(v))));           
       w(j) = 1./(prod(sign(v))*vv);
   end
end
% Scaling
w = w./max(abs(w));
