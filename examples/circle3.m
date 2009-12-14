
%% describe the circle in the complex plane in terms of some coordinate tc
tc = chebfun('x',[0,2*pi]);
zc = 2*cos(tc) + 3 + 1i*(2*sin(tc) + 3);

%% describe the ellipse in terms of some coordinate te
te = chebfun('x',[0,2*pi]);
ze = 3*cos(tc) + 1i*(2*sin(tc));

%% plot both
plot([zc,ze]);

%% where to they intersect?
% get the gradients
dzc = diff(zc); dze = diff(ze);
% initial solution
ti = -2 + 1i;
% main loop
while true
    err = zc(real(ti)) - ze(imag(ti));
    h = err / (dzc(real(ti)) + 1i*dze(imag(ti)));
    ti = ti - h
    if abs(h) < 1e-5, break; end;
    plot([zc,ze]); hold on; plot([zc(real(ti)),ze(imag(ti))],'or'); hold off;
    pause(.1)
end;
