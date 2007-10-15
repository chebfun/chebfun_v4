% rpc11 compute the curvature and torsion of a twisted cubic

t = chebfun(@(t) t, [0 .5]);
x = t;
y = t.^2;
z = t.^3;
plot(curvature({x;y;z}),'LineWidth',2)
hold on
plot(torsion(x,y,z),'r','LineWidth',2)
hold off