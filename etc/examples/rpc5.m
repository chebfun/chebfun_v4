% rpc5 Compute the curvature and perimeter of an 8-shaped curve

t = chebfun(@(t) t, [0 2*pi]);
x = sin(t);
y = sin(t).*cos(t);
subplot(2,1,1)
plot(x,y,'linewidth',2); 
% compute the curvature
k = curvature({x;y});
subplot(2,1,2)
plot(k,'linewidth',2); axis tight;
% compute the length of the curve
arc_length = norm(sqrt(diff(x).^2+diff(y).^2),1)