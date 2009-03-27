function w = bary_weights(xk)
n = length(xk);
w = ones(n,1);
for i = 1:n
    v = 2*(xk(i)-xk);
    vv = exp(sum(log(abs(v(find(v))))));    
    w(i) = 1./(prod(sign(v(find(v))))*vv);
end
