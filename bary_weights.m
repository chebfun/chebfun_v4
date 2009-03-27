function w = bary_weights(xk)
% W = BARY_WEIGHTS(XK)
% Compute the barycentric weights W for the points XK
% Ricardo Pachon 2008; Nick Hale 2009
n = length(xk);
if n < 300          % for small n using matrices is faster
   XK = repmat(xk(:),1,n);
   V = 2*(XK-XK');
   V(logical(eye(n))) = 1;
   VV = exp(sum(log(abs(V))));
   w = 1./(prod(sign(V)).*VV).';
else               % for large n use a loop
   w = ones(n,1);
   for j = 1:n
       v = 2*(xk(j)-xk);
       v = v(logical(v));
       vv = exp(sum(log(abs(v))));           w(j) = 1./(prod(sign(v))*vv);
   end
end
