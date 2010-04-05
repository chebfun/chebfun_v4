%% The Cash problems
% The Jeff Cash problems solved with nonlinops.
% See http://www2.imperial.ac.uk/~jcash/

% Set up for plotting. Throughout this script, the variable probCounter is
% used to set up subplots etc.
cheboppref('factory'), cheboppref('damped','on'), cheboppref('display','iter')
time = zeros(35,1);
iter = zeros(35,1);
figure;
plotOn = 1;
titleOn  = 0;
%% Problem #01
eps = 0.1;
[d,x,N] = domain(0,1);
N.op = @(u) eps*diff(u,2) - u;
N.lbc = 1;
N.rbc = 0;
tic
[u nrmduvec] = N\0;
probCounter = 1;
time(probCounter) = toc;
iter(probCounter) = length(nrmduvec);
if plotOn, 
    subplot(7,5,probCounter),plot(u),drawnow
    if titleOn, title(['Problem ', num2str(probCounter)]), end
end

%% Problem #02
eps = 1;
[d,x,N] = domain(-1,1);
N.op = @(u) eps*diff(u,2) + (2+cos(pi*x)).*diff(u,1) - u;
N.lbc = -1;
N.rbc = -1;
probCounter = 2;
tic
[u nrmduvec] = N\(-(1+eps+pi^2)*cos(pi*x)-pi*(2+cos(pi*x)).*sin(pi*x));
time(probCounter) = toc;
iter(probCounter) = length(nrmduvec);
if plotOn, 
    subplot(7,5,probCounter),plot(u),drawnow
    if titleOn, title(['Problem ', num2str(probCounter)]), end
end
%% Problem #03
eps = 0.1;
[d,x,N] = domain(0,1);
N.op = @(u) eps*diff(u,2) - diff(u,1);
N.lbc = 1;
N.rbc = 0;
tic
[u nrmduvec] = N\0;
probCounter = 3;
time(probCounter) = toc;
iter(probCounter) = length(nrmduvec);
if plotOn, 
    subplot(7,5,probCounter),plot(u),drawnow
    if titleOn, title(['Problem ', num2str(probCounter)]), end
end
%% Problem #04
[d,x,N] = domain(-1,1);
eps = 0.5;
N.op = @(u) eps*diff(u,2) + diff(u,1) - (1+eps)*u;
N.lbc = 1-exp(-2);
N.rbc = 1- exp(-2*(1+eps)/eps);
tic
[u nrmduvec] = N\0;
probCounter = 4;
time(probCounter) = toc;
iter(probCounter) = length(nrmduvec);
if plotOn, 
    subplot(7,5,probCounter),plot(u),drawnow
    if titleOn, title(['Problem ', num2str(probCounter)]), end
end

%% Problem #05
eps = 1;
[d,x,N] = domain(-1,1);
N.op = @(u) eps*diff(u,2) + x.*diff(u,1) - u;
N.lbc = -1;
N.rbc = -1;
probCounter = 5;
tic
[u nrmduvec] = N\(-(1+eps+pi^2)*cos(pi*x)-pi*x.*sin(pi*x));
time(probCounter) = toc;
iter(probCounter) = length(nrmduvec);
if plotOn, 
    subplot(7,5,probCounter),plot(u),drawnow
    if titleOn, title(['Problem ', num2str(probCounter)]), end
end

figure(gcf)
%% Problem #06
eps = 0.005;
[d,x,N] = domain(-1,1);
N.op = @(u) eps*diff(u,2) + diag(x)*diff(u,1) + eps*pi*pi*cos(pi*x) + pi*diag(x)*sin(pi*x);
N.lbc = -2;
N.rbc = 0;
tic
[u nrmduvec] = N\0;
probCounter = 6;
time(probCounter) = toc;
iter(probCounter) = length(nrmduvec);
if plotOn, 
    subplot(7,5,probCounter),plot(u),drawnow
    if titleOn, title(['Problem ', num2str(probCounter)]), end
end

%% Problem #07
eps = 0.21;
[d,x,N] = domain(-1,1);
N.op = @(u) eps*diff(u,2) + x.*diff(u,1) - u;
N.lbc = -1;
N.rbc = 1;
probCounter = 7;
tic
[u nrmduvec] = N\-((1+eps*pi^2)*cos(pi*x)+pi*x.*sin(pi*x));
time(probCounter) = toc;
iter(probCounter) = length(nrmduvec);
if plotOn, 
    subplot(7,5,probCounter),plot(u),drawnow
    if titleOn, title(['Problem ', num2str(probCounter)]), end
end

%% Problem #08
eps = 0.046;
[d,x,N] = domain(0,1);
N.op = @(u) eps*diff(u,2) + diff(u,1);
N.lbc = 1;
N.rbc = 2;
probCounter = 8;
tic
[u nrmduvec] = N\0;
time(probCounter) = toc;
iter(probCounter) = length(nrmduvec);
if plotOn, 
    subplot(7,5,probCounter),plot(u),drawnow
    if titleOn, title(['Problem ', num2str(probCounter)]), end
end
%% Problem #09
eps = 0.4;
[d,x,N] = domain(-1,1);
N.op = @(u) (eps+diag(x.^2))*diff(u,2) + 4*diag(x)*diff(u,1) + 2*u;
N.lbc = 1/(1+eps);
N.rbc = 1/(1+eps);
probCounter = 9;
tic
[u nrmduvec] = N\0;
time(probCounter) = toc;
iter(probCounter) = length(nrmduvec);
if plotOn, 
    subplot(7,5,probCounter),plot(u),drawnow
    if titleOn, title(['Problem ', num2str(probCounter)]), end
end
%% Problem #10
eps = 0.03;
[d,x,N] = domain(-1,1);
N.op = @(u) eps*diff(u,2) +diag(x)*diff(u,1);
N.lbc = 0;
N.rbc = 2;
probCounter = 10;
tic
[u nrmduvec] = N\0;
time(probCounter) = toc;
iter(probCounter) = length(nrmduvec);
if plotOn, 
    subplot(7,5,probCounter),plot(u),drawnow
    if titleOn, title(['Problem ', num2str(probCounter)]), end
end
figure(gcf)
%% Problem #11
eps = 1;
[d,x,N] = domain(-1,1);
N.op = @(u) eps*diff(u,2)  - u + (1+eps+pi^2)*cos(pi*x);
N.lbc = -1;
N.rbc = -1 ;
probCounter = 11;
tic
[u nrmduvec] = N\0;
time(probCounter) = toc;
iter(probCounter) = length(nrmduvec);
if plotOn, 
    subplot(7,5,probCounter),plot(u),drawnow
    if titleOn, title(['Problem ', num2str(probCounter)]), end
end
%% Problem #12
eps = 0.5;
[d,x,N] = domain(-1,1);
N.op = @(u) eps*diff(u,2)  - u;
N.lbc = -1;
N.rbc = 0;
probCounter = 12;
tic
[u nrmduvec] = N\(-(1+eps+pi^2)*cos(pi*x));
time(probCounter) = toc;
iter(probCounter) = length(nrmduvec);
if plotOn, 
    subplot(7,5,probCounter),plot(u),drawnow
    if titleOn, title(['Problem ', num2str(probCounter)]), end
end
%% Problem #13
eps = 0.5;
[d,x,N] = domain(-1,1);
N.op = @(u) eps*diff(u,2)  - u;
N.lbc = 0;
N.rbc = -1;
probCounter = 13;
tic
[u nrmduvec] = N\(-(1+eps+pi^2)*cos(pi*x));
time(probCounter) = toc;
iter(probCounter) = length(nrmduvec);
if plotOn, 
    subplot(7,5,probCounter),plot(u),drawnow
    if titleOn, title(['Problem ', num2str(probCounter)]), end
end
%% Problem #14
eps = 1;
[d,x,N] = domain(-1,1);
N.op = @(u) eps*diff(u,2)  - u;
N.lbc = @(u) u ;
N.rbc = @(u) u  ;
probCounter = 14;
tic
[u nrmduvec] = N\(-(1+eps+pi^2)*cos(pi*x));
time(probCounter) = toc;
iter(probCounter) = length(nrmduvec);
if plotOn, 
    subplot(7,5,probCounter),plot(u),drawnow
    if titleOn, title(['Problem ', num2str(probCounter)]), end
end
%% Problem #15
eps = 0.005;
[d,x,N] = domain(-1,1);
N.op = @(u) eps*diff(u,2)  - diag(x)*u;
N.lbc = 1;
N.rbc = 1;
probCounter = 15;
tic
[u nrmduvec] = N\0;
time(probCounter) = toc;
iter(probCounter) = length(nrmduvec);
if plotOn, 
    subplot(7,5,probCounter),plot(u),drawnow
    if titleOn, title(['Problem ', num2str(probCounter)]), end
end
figure(gcf)
%% Problem #16
eps = 0.15;
[d,x,N] = domain(0,1);
N.op = @(u) eps^2*diff(u,2) + pi^2/4*u;
N.lbc = 0;
N.rbc = sin(pi/(2*eps));
probCounter = 16;
tic
[u nrmduvec] = N\0;
time(probCounter) = toc;
iter(probCounter) = length(nrmduvec);
if plotOn, 
    subplot(7,5,probCounter),plot(u),drawnow
    if titleOn, title(['Problem ', num2str(probCounter)]), end
end
%% Problem #17
eps = 0.05;
[d,x,N] = domain(-0.1,0.1);
N.op = @(u) diff(u,2) + 3*eps*u./((eps+x.^2).^2);
N.lbc = - 0.1/sqrt(eps+0.01);
N.rbc = 0.1/sqrt(eps+0.01);
probCounter = 17;
tic
[u nrmduvec] = N\0;
time(probCounter) = toc;
iter(probCounter) = length(nrmduvec);
if plotOn, 
    subplot(7,5,probCounter),plot(u),drawnow
    if titleOn, title(['Problem ', num2str(probCounter)]), end
end
%% Problem #18
eps = 0.05;
[d,x,N] = domain(0,1);
N.op = @(u) eps*diff(u,2) + diff(u,1);
N.lbc = 1;
N.rbc = exp(-1/eps);
probCounter = 18;
tic
[u nrmduvec] = N\0;
time(probCounter) = toc;
iter(probCounter) = length(nrmduvec);
if plotOn, 
    subplot(7,5,probCounter),plot(u),drawnow
    if titleOn, title(['Problem ', num2str(probCounter)]), end
end
%% Problem #19
eps = 0.05;
[d,x,N] = domain(0,1);
N.op = @(u)eps*diff(u,2) + exp(u).*diff(u,1) - pi/2*diag(sin(pi*x/2))*exp(2*u);
N.lbc = 0;
N.rbc = 0;
probCounter = 19;
tic
[u nrmduvec] = N\0;
time(probCounter) = toc;
iter(probCounter) = length(nrmduvec);
if plotOn, 
    subplot(7,5,probCounter),plot(u),drawnow
    if titleOn, title(['Problem ', num2str(probCounter)]), end
end
%% Problem #20
eps = 0.05;
[d,x,N] = domain(0,1);
N.op = @(u) eps*diff(u,2) + diff(u,1).*diff(u,1) - 1;
N.lbc = 1 + eps*log(cosh(-0.745/eps));
N.rbc = 1 + eps*log(cosh(-0.255/eps));
tic
[u nrmduvec] = N\1;
probCounter = 20;
time(probCounter) = toc;
iter(probCounter) = length(nrmduvec);
if plotOn, 
    subplot(7,5,probCounter),plot(u),drawnow
    if titleOn, title(['Problem ', num2str(probCounter)]), end
end
figure(gcf)

%% Problem #21
eps = 0.0008;
[d,x,N] = domain(0,1);
N.op = @(u) eps*diff(u,2) - u - u.^2;
N.lbc = 1;
N.rbc = exp(-1/sqrt(eps));
tic
[u nrmduvec] = N\-exp(-2*x/sqrt(eps));
probCounter = 21;
time(probCounter) = toc;
iter(probCounter) = length(nrmduvec);
if plotOn, 
    subplot(7,5,probCounter),plot(u),drawnow
    if titleOn, title(['Problem ', num2str(probCounter)]), end
end
%% Problem #22
eps = 0.025;
[d,x,N] = domain(0,1);
N.op = @(u) eps*diff(u,2) + diff(u) + u.^2;
N.lbc = 0;
N.rbc = 1/2;
tic
[u nrmduvec] = N\0;
probCounter = 22;
time(probCounter) = toc;
iter(probCounter) = length(nrmduvec);
if plotOn, 
    subplot(7,5,probCounter),plot(u),drawnow
    if titleOn, title(['Problem ', num2str(probCounter)]), end
end
%% Problem #22
eps = 0.025;
[d,x,N] = domain(0,1);
N.op = @(u) eps*diff(u,2) + diff(u) + u.^2;
N.lbc = 0;
N.rbc = 1/2;
tic
[u nrmduvec] = N\0;
probCounter = 22;
time(probCounter) = toc;
iter(probCounter) = length(nrmduvec);
if plotOn, 
    subplot(7,5,probCounter),plot(u),drawnow
    if titleOn, title(['Problem ', num2str(probCounter)]), end
end
%% Problem #23
eps = 8;
[d,x,N] = domain(0,1);
N.op = @(u) diff(u,2) - eps*sinh(eps*u);
N.lbc = 0;
N.rbc = 1;
tic
[u nrmduvec] = N\0;
probCounter = 23;
time(probCounter) = toc;
iter(probCounter) = length(nrmduvec);
if plotOn, 
    subplot(7,5,probCounter),plot(u),drawnow
    if titleOn, title(['Problem ', num2str(probCounter)]), end
end
%% Problem #24
eps = 0.21;
A = @(x) 1 + x.^2; Ap = @(x) 2*x; gamma = 1.4;
[d,x,N] = domain(0,1);
N.op = @(u) eps*diag(1+x.^2)*(diff(u,2).*u) - ((1+gamma)/2-eps*diag(Ap(x)))*(u.*diff(u,1)) + diff(u,1)./u + diag(Ap(x)./A(x))*(1-(gamma-1)/2*u.^2);
N.lbc = 0.9129;
N.rbc = 0.375;
N.guess = chebfun([0.9129 0.375],d);
tic
[u nrmduvec] = N\0;
probCounter = 24;
time(probCounter) = toc;
iter(probCounter) = length(nrmduvec);
if plotOn, 
    subplot(7,5,probCounter),plot(u),drawnow
    if titleOn, title(['Problem ', num2str(probCounter)]), end
end
%% Problem #25
eps = 0.01;
[d,x,N] = domain(0,1);
N.op = @(u) eps*diff(u,2) + u.*diff(u,1) - u;
N.lbc = -1/3 ;
N.rbc = 1/3;
tic
[u nrmduvec] = N\0;
probCounter = 25;
time(probCounter) = toc;
iter(probCounter) = length(nrmduvec);
if plotOn, 
    subplot(7,5,probCounter),plot(u),drawnow
    if titleOn, title(['Problem ', num2str(probCounter)]), end
end
figure(gcf)
%% Problem #26
eps = 0.03;
[d,x,N] = domain(0,1);
N.op = @(u) eps*diff(u,2) + u.*diff(u,1) - u;
N.lbc = 1;
N.rbc = -1/3;
tic
[u nrmduvec] = N\0;
probCounter = 26;
time(probCounter) = toc;
iter(probCounter) = length(nrmduvec);
if plotOn, 
    subplot(7,5,probCounter),plot(u),drawnow
    if titleOn, title(['Problem ', num2str(probCounter)]), end
end
%% Problem #27
eps = 0.03;
[d,x,N] = domain(0,1);
N.op = @(u) eps*diff(u,2) + u.*diff(u,1) - u;
N.lbc = 1;
N.rbc = 1/3;
tic
[u nrmduvec] = N\0;
probCounter = 27;
time(probCounter) = toc;
iter(probCounter) = length(nrmduvec);
if plotOn, 
    subplot(7,5,probCounter),plot(u),drawnow
    if titleOn, title(['Problem ', num2str(probCounter)]), end
end
%% Problem #28
eps = 0.01;
[d,x,N] = domain(0,1);
N.op = @(u) eps*diff(u,2) + u.*diff(u,1) - u;
N.lbc = 1 ;
N.rbc = 3/2;
tic
[u nrmduvec] = N\0;
probCounter = 28;
time(probCounter) = toc;
iter(probCounter) = length(nrmduvec);
if plotOn, 
    subplot(7,5,probCounter),plot(u),drawnow
    if titleOn, title(['Problem ', num2str(probCounter)]), end
end
%% Problem #29
eps = 0.01;
[d,x,N] = domain(0,1);
N.op = @(u) eps*diff(u,2) + u.*diff(u,1) - u;
N.lbc = 0;
N.rbc = 3/2;
tic
[u nrmduvec] = N\0;
probCounter = 29;
time(probCounter) = toc;
iter(probCounter) = length(nrmduvec);
if plotOn, 
    subplot(7,5,probCounter),plot(u),drawnow
    if titleOn, title(['Problem ', num2str(probCounter)]), end
end
%% Problem #30
eps = 0.01;
[d,x,N] = domain(0,1);
N.op = @(u) eps*diff(u,2) + u.*diff(u,1) - u;
N.lbc = -7/6;
N.rbc = 3/2;
tic
[u nrmduvec] = N\0;
probCounter = 30;
time(probCounter) = toc;
iter(probCounter) = length(nrmduvec);
if plotOn, 
    subplot(7,5,probCounter),plot(u),drawnow
    if titleOn, title(['Problem ', num2str(probCounter)]), end
end
figure(gcf)
%% Problem #31
eps = 0.05;
[d,x,N] = domain(0,1);
N.op = @(u) [diff(u(:,1)) - sin(u(:,2)), diff(u(:,2)) - u(:,3), ...
    eps*diff(u(:,3))+u(:,4), eps*diff(u(:,4)) - (u(:,1)-1).*cos(u(:,2)) + u(:,3).*(sec(u(:,2))+eps*u(:,4).*tan(u(:,2)))];
N.lbc = @(u)[ u(:,1),  u(:,3) ];
N.rbc = @(u)[ u(:,1), u(:,3) ];
N.guess = [0*x,0*x,0*x,0*x];
tic
[u nrmduvec] = N\0;
probCounter = 31;
time(probCounter) = toc;
iter(probCounter) = length(nrmduvec);
if plotOn, 
    subplot(7,5,probCounter),plot(u(:,3)),drawnow
    if titleOn, title(['Problem ', num2str(probCounter)]), end
end

%% Problem #32
eps = 100;
[d,x,N] = domain(0,1);
N.op = @(u) diff(u,4) - eps*(diff(u).*diff(u,2)-u.*diff(u,3));
N.lbc = @(u)[ u,  diff(u) ];
N.rbc = @(u)[ u-1, diff(u) ];
tic
[u nrmduvec] = N\0;
probCounter = 32;
time(probCounter) = toc;
iter(probCounter) = length(nrmduvec);
if plotOn, 
    subplot(7,5,probCounter),plot(diff(u)),drawnow
    if titleOn, title(['Problem ', num2str(probCounter)]), end
end

%% Problem #33
% Pure Newton iteration has been found to work better for this problem
cheboppref('damped','off')
eps = 0.01;
[d,x,N] = domain(0,1);
N.op = @(u) [eps*diff(u(:,2),4) + u(:,2).*diff(u(:,2),3)+u(:,1).*diff(u(:,1)), ...
   eps*diff(u(:,1),2) - u(:,1).*diff(u(:,2),1)+u(:,2).*diff(u(:,1))];
N.lbc = @(u)[ u(:,1)+1,  u(:,2), diff(u(:,2),1) ];
N.rbc = @(u)[ u(:,1) - 1, u(:,2), diff(u(:,2),1)];
N.guess = [0*x+1,0*x+1];
tic
[u nrmduvec] = N\0;
probCounter = 33;
time(probCounter) = toc;
iter(probCounter) = length(nrmduvec);
if plotOn, 
    subplot(7,5,probCounter),plot(u(:,2)),drawnow
    if titleOn, title(['Problem ', num2str(probCounter)]), end
end
cheboppref('damped','on')
%% Problem #34
eps = 3.5;
[d,x,N] = domain(0,1);
N.op = @(u) diff(u,2) + eps*exp(u);
N.lbc = 0;
N.rbc = 0;
tic
[u nrmduvec] = N\0;
probCounter = 34;
time(probCounter) = toc;
iter(probCounter) = length(nrmduvec);
if plotOn, 
    subplot(7,5,probCounter),plot(u),drawnow
    if titleOn, title(['Problem ', num2str(probCounter)]), end
end
%% Problem #35
eps = 0.03;
[d,x,N] = domain(-1,1);
N.op = @(u) eps*diff(u,2) - diag(x)*diff(u,1) + u;
N.lbc = 1 ;
N.rbc = 2;
tic
[u nrmduvec] = N\0;
probCounter = 35;
time(probCounter) = toc;
iter(probCounter) = length(nrmduvec);
if plotOn, 
    subplot(7,5,probCounter),plot(u),drawnow
    if titleOn, title(['Problem ', num2str(probCounter)]), end
end
%%
figure;plot(time,':*')
title('Solution time for BVPs'); xlabel('Problem number'), ylabel('Solution time [sec]')
box on, grid on
figure;plot(iter,':*')
title('Number of iterations for needed for solving BVPs'); xlabel('Problem number'), ylabel('Number of iterations needed for convergence')
box on, grid on
