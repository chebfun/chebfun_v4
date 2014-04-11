%% Impact Event
% Hadrien Montanelli, 13th November 2013
% (Chebfun example calc/ImpactEvent.m)

%%
% Problem: An asteroid follows a hyperbolic path which has the Sun as one of its foci. This path can be described by the equation $C_a$:
% $$ C_a\,:\,x^2 - y^2 - 1 = 0. $$
% This asteroid gets dangerously close to the Earth which follows an elliptic orbit around the Sun described by the equation $C_b$:
% $$ C_b\,:\,0.2\,x^2 + y^2 - 1 = 0. $$
% What are the intersection points of $C_a$ and $C_b$ ? Moreover, given a set of ellipses given by the equations:
% $$ C_{\lambda,\beta}\,:\,\frac{x^2}{\lambda^2} + \frac{y^2}{\beta^2} - 1 = 0, $$
% for which pair ($\lambda,\beta$) does $C_{\lambda,\beta}$ intersect $C_a$ at the same points as $C_b$?

format long 
FS = 'FontSize'; FW = 'FontWeight'; MS = 'MarkerSize'; 

%% Intersection of $C_a$ and $C_b$
% Let us first use the the MATLAB command EZPLOT to plot the two curves $C_a$ and $C_b$.

figure
Ca = ezplot('x^2-y^2-1=0')    ; 
set(Ca,'Color','r')           ;         
hold on 
Cb = ezplot('0.2*x^2+y^2-1=0'); 
set(Cb,'Color','b')           ;
title('Impact event : intersection points of a hyperbola and an ellipse.',FS, 14, FW,'bold');
hold on, plot(2,0,'y.', MS, 40)
hold on, plot(0,1,'b.', MS, 30)
hold on, plot(4,sqrt(15),'r.', MS, 30)

%%
% The red curve is the hyperbole and the blue one is the ellipse. The Earth
% is represetend by a blue disk, the Sun by the yellow one and the asteroid by the red one.
% One way to solve this problem is to compute a cost function $J(x,y)$ defined as:
% $$ J(x,y)=\Big(x^2 - y^2 - 1\Big)^2 + \Big(0.2\,x^2 + y^2 - 1\Big)^2. $$
% This function has 0 as its minimum and reaches its minimum for points $(x,y)$ which belong to both $C_a$ and $C_b$. 
% Let us define $J$ as a chebfun2 and plot $-J$ and the contours of $-J$.

J = chebfun2(@(x,y) (x^2 - y^2 - 1)^2 + (0.2*x^2 + y^2 - 1)^2,[-2 2 -2 2],'vectorize');
figure 
subplot(1,2,1)
plot(-J)
subplot(1,2,2)
contour(-J), axis square, colorbar

%%
% We can then compute the roots of the gradient of $J$ and evaluate $J$ in these points to see if these critical points are minima. 
r = roots(gradient(J));
[r J(r)]
%%
% Only two points are minimas with positive real parts. Let us add them to the plot of $J$.
X1 = r(8,:); X2 = r(7,:); X=[X1;X2];
[X J(X)]
subplot(1,2,1)
hold on
plot3(X(:,1),X(:,2),J(X(:,1),X(:,2)),'k.', MS, 20)
subplot(1,2,2)
hold on
plot(X(1:2,1),X(1:2,2),'k.', MS, 20)


%%
% Let us add them to the plot of $C_a$ and $C_b$ too.
figure
Ca = ezplot('x^2-y^2-1=0')    ; 
set(Ca,'Color','r')           ;         
hold on 
Cb = ezplot('0.2*x^2+y^2-1=0'); 
set(Cb,'Color','b')           ;
title('Intersection points X_1 and X_2 of C_a and C_b.', FS, 16, FW,'bold');
hold on, plot(2,0,'y.', MS, 40)
hold on, plot(0,1,'b.', MS, 30)
hold on, plot(4,sqrt(15),'r.', MS, 30)
hold on, plot(X1(1),X1(2),'k.', MS, 20)
hold on, plot(X2(1),X2(2),'k.', MS, 20)

%%
% Another way to solve this problem is to parametrize $C_a$ and $C_b$ and define them as complex chebfuns. 
% Let us denote by $C_{b}(t)$ the parametrization of $C_b$, by $C_{a1}(t)$ the parametrization of the right branch 
% of $C_a$ with positive imaginary partand by $C_{a2}(t)$ the parametrization of the right branch of $C_a$ with 
% negative imaginary part. We have:
% $C_{a1}(t)=\cosh(2\pi t)+i\sinh(2\pi t),\;\forall t\in[0,1],$
% $C_{a2}(t)=\cosh(2\pi t)-i\sinh(2\pi t),\;\forall t\in[0,1],$
% $C_{b}(t)=\frac{1}{\sqrt{2}}\cos(2\pi t)+i\sin(2\pi t),\;\forall t\in[0,1].$
% We create complex chebfuns.
t = chebfun('t',[0,1]);
Ca1 = cosh(2*pi*t)+1i*sinh(2*pi*t);
Ca2 = cosh(2*pi*t)-1i*sinh(2*pi*t);
Cb = 1/sqrt(0.2)*cos(2*pi*t)+1i*sin(2*pi*t);
%%
% Let us plot them and verify we get the same curves.
figure
plot(Ca1, 'r')
hold on, plot(Ca2, 'r')
hold on, plot(Cb,'b'), xlim([-6 6]), ylim([-6 6])
hold on, plot(2,0,'y.', MS, 40)
hold on, plot(0,1,'b.', MS, 30)
hold on, plot(4,sqrt(15),'r.', MS, 30)
%%
% We now define two chebfun2 objects $f_1$ and $f_2$ as follows.
f1 = chebfun2(@(u,v) Ca1(v) - Cb(u),[0 1 0 1]); 
f2 = chebfun2(@(u,v) Ca2(v) - Cb(u),[0 1 0 1]); 
r1 = roots(real(f1),imag(f1));                
r2 = roots(real(f1),imag(f1));      
%%
% We can compute the roots of $f_1$ and $f_2$ and evaluate $C_{a1}$ and $C_{a1}$ 
% to obtain the intersection points $Y_1$ and $Y_2$.
Y1 = [real(Ca1(r1(:,2))),imag(Ca1(r1(:,2)))]
Y2 = [real(Ca1(r1(:,2))),imag(Ca2(r1(:,2)))]
%%
% Let us check we obtained the same points.
[X1-Y1;X2-Y2]
%%
% Finally, let us add the points to the plot.
hold on, plot(Y1(1),Y1(2),'.k',MS,20)
hold on, plot(Y2(1),Y2(2),'.k',MS,20)
%% Intersection of $C_a$ and $C_{\lambda,\beta}$
% Let us now consider the set of ellipses $C_{\lambda,\beta}$ of equations:
% $$C_{\lambda,\beta}\,:\,\frac{x^2}{\lambda^2} + \frac{y^2}{\beta^2} - 1 = 0.$$
% If an ellipse $C_{\lambda,\beta}$ crosses $C_a$ at the point $Y_1$ then, for symmetry reasons, 
% $C_{\lambda,\beta}$ crosses $C_a$ at $Y_2$ too : let us focus then on $Y_1$. We are looking for the roots of the following function:
% $H(\lambda,\beta)=\frac{X_1(1)^2}{\lambda^2}+\frac{X_1(2)^2}{\beta^2}-1.$
% Let us define $H$ as a chebfun2.
H = chebfun2(@(lambda,beta) X1(1)^2/lambda^2 + X1(2)^2/beta^2 - 1, [0.5 5 0.5 5], 'vectorize');
%%
% We can plot the contour of $H$ and its roots. 
% The red point corresponds to the pair $(\lambda=1/\sqrt{2},\beta=1)$ which corresponds to $C_b$.
figure
subplot(1,2,1)
contour(H), axis square, colorbar
r = roots(H)
subplot(1,2,2)
plot(r)
hold on
plot(1/sqrt(0.2),1,'.r')

%%
% We finally can plot a few ellipses and check visually the intersections with $C_a$.
figure
axes1=axes();
plot(Ca1, 'r')
hold on, plot(Ca2, 'r')
hold on, plot(Cb,'b'), xlim([-6 6]), ylim([-6 6])
for k=-1:0.1:1
    lambda=real(r(k));
    beta=imag(r(k));
    Cb = lambda*cos(2*pi*t)+beta*1i*sin(2*pi*t);
    hold on, plot(Cb,'b')
end
title('A set of ellipses C_{\lambda,\beta} which cross C_a at X_1 and X_2.', FS, 16, FW, 'bold')