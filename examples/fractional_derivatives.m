% This is a first attempt at doing fractional derivatives using chebfun


%% simple example

clc, clear, close all

s = chebfun('s',[-1 1]);
u = s+1

v = fracint(u,.5)
plot(u,'b',v,'r'), drawnow

w = diff(u,.5)
plot(u,'b',v,'r',w,'m'), drawnow

plot(u,'b',v,'r',w,'m',cumsum(u),'--r',diff(u),'--m'), drawnow

%% Quasimatrices
clc, clear, close all

alpha = .5;
u = chebfun('s',[0 2]);
v = diff([u u.^2 u.^3],alpha);
plot(v), drawnow


%% simple
clc, clear, close all

n = 1; % integer
u = chebfun(@(x) x.^n,[0 pi]);
k = 1;
for alpha = 0.1:.1:1   
    k = k + 1;
    u(:,k) = diff(u(:,1),alpha);
    plot(u), drawnow
end
u

%% trig functions

clc, clear, close all

u = chebfun('sin(pi*x)',[-1 1]);
k = 1;
for alpha = 0.1:.1:1
    k = k + 1;
    u(:,k) = diff(u(:,1),alpha);
    plot(u), drawnow
end
u


%% exponential

clc, clear, close all

u = chebfun('exp(2*x)-1',[0 1]);
k = 1;
for alpha = 0.1:.1:1
    k = k + 1;
    u(:,k) = diff(u(:,1),alpha);
    plot(u), drawnow
end
u

%% exponential exact

clc, clear, close all                                                                                                                                                                                                                                           

u = chebfun('exp(x)',[0 1]);
w = diff(u,.5);

x = linspace(0,1,10001);
v = erf(sqrt(x)).*exp(x);

plot(w,'b');hold on
plot(x,v,'--r'); hold off

norm(w(x)-v,inf)

%%

% %% singularities at right endpoint (not working)
% 
% clc, clear, close all
% 
% s = chebfun('s',[0 1]);
% u = 1./(1-s)
% v = diff(u,.5)
% 
% 
% 
% %% piecewise?  (not working)
% 
% clc, clear, close all
% 
% u = chebfun('abs(s)-1',[-1 0 1]);
% u = cumsum(u); % piecewise cts
% 
% plot(u), drawnow, hold on
% v = fracint(u,.5)
% plot(u,'b',v,'r'), drawnow
 





