function pass = barymatp_test

% Nick Hale, Aug 2010

% input type 1
Nx = [9 16 37 17 45];
dx = [-1 -.3 0.1 .3  .6 1];
x = chebpts(Nx,dx);

Ny = [15 22 15 9];
dy = [-1 -.3 0 .6 1];
y = chebpts(Ny,dy);

P1 = barymatp(Ny,dy,Nx,dx);
P2 = barymatp(y,x);


f = @(x) exp(x);
fx = f(x);
fy = f(y);

err(1) = norm(P1*fx-fy,inf);
err(2) = norm(P2*fx-fy,inf);

pass = err < 1e-12;

if nargout == 0, close all, spy(P1), figure, spy(P2), end
