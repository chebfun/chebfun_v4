
%% describe the circle in terms of some coordinate tc
tc = chebfun('x',[0,2*pi]);
xc = 2*cos(tc) + 3;
yc = 2*sin(tc) + 3;

%% describe the ellipse in terms of some coordinate te
te = chebfun('x',[0,2*pi]);
xe = 3*cos(tc);
ye = 2*sin(tc);

%% plot both
plot(xc,yc); hold on; plot(xe,ye,'-g'); hold off;

%% find te and tc using Newton's method
% the equations
fx = xc - xe; fy = yc - ye;
% the derivatives
dfxdtc = diff(xc); dfxdte = diff(-xe);
dfydtc = diff(yc); dfydte = diff(-ye);
% initial values
ti = [ -2 ; 0.1 ];
% main loop
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
    h
    plot(xc,yc); hold on; plot(xe,ye,'-g'); plot([xc(ti(1)),xe(ti(2))],[yc(ti(1)),ye(ti(2))],'or'); hold off;
    pause;
end;