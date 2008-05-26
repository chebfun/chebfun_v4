function rpc20()
% rpc20  Global optimization for simple functions.
x = 0:.1:4; y = x;
[xx,yy] = meshgrid(x,y);
subplot(2,1,1)
mesh(xx,yy,xx.^3+yy.^2);
f = chebfun(@minf_on_fixed_x,[0 2]);
subplot(2,1,2)
plot(f)
minimum = min(f);
display(minimum)
    function fx = minf_on_fixed_x(y)
        x = chebfun(@(x) x,[0 2]);
        n = length(y);
        fx = zeros(length(y),1);
        for i = 1:n
            fx(i) = min(x.^2+y(i)^2);
        end
    end
end