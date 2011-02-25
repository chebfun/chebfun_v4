function w = bary_weights(xk)
% W = BARY_WEIGHTS(XK)
% Compute the barycentric weights W for the points XK, scaled such that
% norm(W,inf) == 1.

% Copyright 2011 by The University of Oxford and The Chebfun Developers. 
% See http://www.maths.ox.ac.uk/chebfun/ for Chebfun information.

n = length(xk);
if isreal(xk)
    C = 4/(max(xk)-min(xk)); % Capacity of interval
else
    C = 1;  % Scaling by capacity doesn't apply if using complex nodes
end
if n < 300 || ~isreal(xk)       % for small n using matrices is faster
   XK = repmat(xk(:),1,n);
   V = C*(XK-XK.');
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
