function circles
% Circles
%   Compute the intersection of a circle and an ellipse using chebfuns in
%   three different ways:
%
%       1) finding the roots of a single non-linear equation,
%       2) soling a system of coupled non-linear equations using Newton's
%          method,
%       3) solving a complex-valued non-linear equation using Newton's
%          method.

%% fist try, using a single non-linear equation.
disp('Solving as a single non-linear equation...');

% this example only works with 'splitting on' (yes, i broke it again...)
splitting on;

% describe the x-coordinates of the circle and ellipse
xc = chebfun('x',[1 5]);
xe = chebfun('x',[-3,3]);

% describe the y-coordinates of the cirle and ellipse as a function of
% their x-coordinate (lower and upper arcs only)
yc = -sqrt( 2^2 - (xc - 3).^2 ) + 3;
ye = 2 * sqrt( 1 - xe.^2/9 );

% plot both objects just to make sure
plot(xc,yc); hold on; plot(xe,ye,'-g'); hold off;

%%where to both intersect?
% we first restrict both functions to the same interval
ycr = restrict(yc,[1,3]); yer = restrict(ye,[1,3]);
xi = roots(ycr-yer);
yi = yc(xi);

% plot the solutions
plot(xc,yc); hold on; plot(xe,ye,'-g'); plot(xi,yi,'or'); hold off;

% wait for the user...
disp('Hit enter to continue...'); pause;

%% second try, using a system of non-linear equations
disp('Solving as a system of non-linear equations...');

% describe the circle in terms of some coordinate tc
tc = chebfun('x',[0,2*pi]);
xc = 2*cos(tc) + 3;
yc = 2*sin(tc) + 3;

% describe the ellipse in terms of some coordinate te
te = chebfun('x',[0,2*pi]);
xe = 3*cos(tc);
ye = 2*sin(tc);

% plot both
plot(xc,yc); hold on; plot(xe,ye,'-g'); hold off;

% find te and tc using Newton's method
% the equations
fx = xc - xe; fy = yc - ye;
% the derivatives
dfxdtc = diff(xc); dfxdte = diff(-xe);
dfydtc = diff(yc); dfydte = diff(-ye);
% initial values
ti = [ -2 ; 0.1 ];
% main loop
it = 1;
while true
    % create the jacobian
    J = [ dfxdtc(ti(1)) , dfxdte(ti(2)) ;
          dfydtc(ti(1)) , dfydte(ti(2)) ];
    % compute the step
    h = J \ [ xc(ti(1)) - xe(ti(2)) ;
              yc(ti(1)) - ye(ti(2)) ];
    % need we continue?
    if norm(h) < 1.0e-6, break; end;
    % adjust ti
    ti = ti - h
    plot(xc,yc); hold on; plot(xe,ye,'-g'); plot([xc(ti(1)),xe(ti(2))],[yc(ti(1)),ye(ti(2))],'or'); hold off;
    disp(sprintf('iteration %i, hit enter to continue...',it)); pause;
    it = it + 1;
end;

% wait for the user...
disp('Hit enter to continue...'); pause;

%% third try, describe the figures as curves in the complex plane
disp('Solving as a complex non-linear equation...');

% describe the circle in the complex plane in terms of some coordinate tc
tc = chebfun('x',[0,2*pi]);
zc = 2*cos(tc) + 3 + 1i*(2*sin(tc) + 3);

% describe the ellipse in terms of some coordinate te
te = chebfun('x',[0,2*pi]);
ze = 3*cos(tc) + 1i*(2*sin(tc));

% plot both
plot([zc,ze]);

% where to they intersect?
% get the gradients
dzc = diff(zc); dze = diff(ze);
% initial solution
ti = -2 + 1i;
% main loop
it = 1;
while true
    err = zc(real(ti)) - ze(imag(ti));
    h = err / (dzc(real(ti)) + 1i*dze(imag(ti)));
    ti = ti - h
    if abs(h) < 1e-5, break; end;
    plot([zc,ze]); hold on; plot([zc(real(ti)),ze(imag(ti))],'or'); hold off;
    disp(sprintf('iteration %i, hit enter to continue...',it)); it = it+1;
    pause
end;

%% plot the roots
plot([zc,ze]); hold on; plot([zc(real(ti)),ze(imag(ti))],'or'); hold off
