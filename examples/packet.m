% packet.m  A resonance problem with a variable coefficient
%           Lu = h^2 u" + hu' + 3xu -iau, Dirichlet BCs on [0,pi]

[d,x] = domain([0,pi]);
X = diag(x); D = diff(d); D2 = diff(d,2);
h = .08; L = @(a) h^2*D2 + h*D + 3*X - 1i*a & 'dirichlet';
f = exp(x);
for a = 0:.05:4
   u = L(a)\f; plot(real(u),'k','linewidth',2)
   maxu = max(abs(u(.1:.1:pi))); axis([0 pi 1.2*maxu*[-1 1]])
   title(['a = ' sprintf('%4.2f',a)],'fontsize',16), drawnow
end

