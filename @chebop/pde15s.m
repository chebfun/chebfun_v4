function u = pde15s(N, t, opt)
%PDE15S for chebops.
% PDE15S(N, T) solves the PDE u_t = N.op(u,t,x) where N is a nonlinop 
% with the initial condition given by N.guess.
%
% PDE15S(N, T, OPTS) allows extra input options defined by OPTS = PDESET
%
% Example 1: Nonlinear Advection
%   [d,x,N] = domain(-1,1);
%   N.op = @(u,t,x,D) -(1+0.6*sin(pi*x)).*D(u);
%   N.guess = exp(3*sin(pi*x));
%   N.bc = 'periodic';
%   u = pde15s(N,0:.05:3);
%   surf(u,0:.05:3)
%
% Example 2: Kuramoto-Sivashinsky
%   [d,x,N] = domain(-1,1);
%   I = eye(d); D = diff(d);
%   N.op = @(u,D) u.*D(u)-D(u,2)-0.006*D(u,4);
%   N.guess = 1 + 0.5*exp(-40*x.^2);
%   N.lbc = struct('op',{I,D},'val',{1,2});
%   N.rbc = struct('op',{I,D},'val',{1,2});  
%   u = pde15s(N,0:.01:.5);
%   surf(u,0:.01:.5)
%
% See also chebfun/pde15s, pdeset

pdefun = N.op;
u0 = N.guess;

if strcmpi(N.lbc,'periodic') || strcmpi(N.rbc,'periodic'), 
    bc = 'periodic';
else
    if strcmpi(N.lbcshow,'dirichlet') || strcmpi(N.lbcshow,'neumann')
        N.lbc = struct('op',N.lbcshow,'val',0);
    end
    bc.left = N.lbc;
    if strcmpi(N.rbcshow,'dirichlet') || strcmpi(N.rbcshow,'neumann')
        N.rbc = struct('op',N.rbcshow,'val',0);
    end
    bc.right = N.rbc;
end

if nargin < 3, opt = []; end

u = pde15s( pdefun, t, u0, bc, opt);