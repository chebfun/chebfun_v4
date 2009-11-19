% resonance.m - response of ODE BVP for various parameters a
%               Lu = u'' + ua, Dirichlet BCs on [0,pi]

splitting off, [d,x] = domain([0,pi]);
L = @(a) diff(d,2) + a & 'dirichlet';
f = exp(x);
for a = 10.1:.2:63.9
   u = L(a)\f; plot(u,'m','linewidth',4), axis([0 pi -40 40])
   grid on, title(['a = ' num2str(a)],'fontsize',16), drawnow
end
