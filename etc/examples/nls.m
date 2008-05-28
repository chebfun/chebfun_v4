% Nonlinear Schrodinger equation by 2nd order IMEX time stepping and chebops

% Uses an IMEX scheme derived from BD2, combining
%
%  1.5u{n+1} - 2u{n} + 0.5u{n-1} = dt*f{n+1}  implicit
%                             = dt/3*(8f{n} - 7f{n-1} + 2f{n-2})  explicit
%
% Explicit part seems to have same stability region as AB3, including the
% imaginary axis.

% TAD

dom = domain(-4,4);
u = chebfun('exp(2i*x).*sech(4*x)*4',dom);  % soliton initial cond.
u = u - u(dom(1));  % exactly zero at boundary
bc = 'dirichlet';

T = 6;
dt = 0.005;

D = diff(dom);
G = @(u) 1i*u.*(u.*conj(u));   % nonlinear part of du/dt
L = 0.5i*D^2;                  % linear part of du/dt

figure('doublebuf','on')
plot(real(u))
xlabel x, ylabel('real(u)')
ylim([-1 1]*6), drawnow
hold on

% Two steps of BE/FE to get started.
A = (1 - dt*L) & bc;
Gu = zeros(dom,1);

for n = 1:2
  Gu(:,n) = G(u(:,n));
  f = u(:,n) + dt*Gu(:,n);
  u(:,n+1) = (A\f);
  cla, plot(real(u(:,n+1)),'.-')
  title(sprintf('time = %.3f, length = %i',n*dt,length(u(:,n+1)))), drawnow
end

% Rest of the time steps at 2nd order.
A = (1.5 - dt*L) & bc;
for n = 3:ceil(T/dt)
  Gu(:,3) = G(u(:,n));
  f = u(:,n-1:n)*[-0.5;2] + Gu*([2;-7;8]*dt/3);
  u(:,n+1) = A\f;
  Gu(:,1) = Gu(:,2);   Gu(:,2) = Gu(:,3);
  cla, plot(real(u(:,n+1)),'.-')
  title(sprintf('time = %.3f, length = %i',n*dt,length(u(:,n+1)))), drawnow
end
  
% pause(0.1)
% clf
% x = chebfun('x',dom);  one = chebfun(1,dom);
% x = linspace(dom(1),dom(2),250);  one = ones(250,1);
% for n=1:max(4,ceil(length(u)/50)):length(u)
%   abu = real( u{n}.*conj(u{n}) );
%   plot3(x,(n-1)*dt*one,abu(x)), hold on
%   plot3(-1.2, (n-1)*dt, length(u{n})/10, 'k*' )
% end
% xlabel x
% ylabel t
% zlabel('|u|^2')
% set(gcf,'render','opengl')

xx = linspace(dom,120);
tt = dt*(0:16:1200);
uu = u(xx,1:16:1201);
waterfall(xx,tt,abs(uu)')
set(gcf,'render','opengl')


