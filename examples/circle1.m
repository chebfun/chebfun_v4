
%% this example only works with 'splitting on' (yes, i broke it again...)
% splitting on;

%% describe the x-coordinates of the circle and ellipse
xc = chebfun('x',[1 5]);
xe = chebfun('x',[-3,3]);

%% describe the y-coordinates of the cirle and ellipse as a function of
% their x-coordinate (lower and upper arcs only)
yc = -sqrt( 2^2 - (xc - 3).^2 ) + 3;
ye = 2 * sqrt( 1 - xe.^2/9 )

%% plot both objects just to make sure
plot(xc,yc); hold on; plot(xe,ye,'-g'); hold off;

%% where to both intersect?
% we first restrict both functions to the same interval
ycr = yc{1.1,2.9}; yer = ye{1.1,2.9};
xi = roots(ycr-yer);
yi = yc(xi);

%% plot the solutions
plot(xc,yc); hold on; plot(xe,ye,'-g'); plot(xi,yi,'or'); hold off;