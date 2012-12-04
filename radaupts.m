function [x, w, v] = radaupts(n)
%RADAUPTS  Gauss-Legendre-Radau Quadrature Nodes and Weights.
%  RADAUPTS(N) returns N Legendre-Radau points X in (-1,1).
%
%  [X,W] = RADAUPTS(N) returns also a row vector W of weights for
%  Gauss-Legendre-Lobatto quadrature.
%
%  [X,W,V] = RADAUPTS(N) returns additionally a column vector V of weights
%  in the barycentric formula corresponding to the points X. The weights
%  are scaled so that max(abs(V)) = 1.
%
%  [X,W] = RADAUPTS(N,METHOD) allows the user to select which method to
%  use.
%    METHOD = 'REC' uses the recurrence relation for the Legendre 
%       polynomials and their derivatives to perform Newton iteration 
%       on the WKB approximation to the roots. Default for N < 100.
%    METHOD = 'ASY' uses the Hale-Townsend fast algorithm based up
%       asymptotic formulae, which is fast and accurate. Default for 
%       N >= 100.
%    METHOD = 'GLR' uses the Glaser-Liu-Rokhlin fast algorithm [2], which
%       is fast and can give better relative accuracy for the -.5<x<.5
%       than 'ASY' (although the accuracy of the weights is usually worse).
%    METHOD = 'GW' will use the traditional Golub-Welsch eigenvalue method, 
%       which is maintained mostly for historical reasons.
%
%  See also chebpts, legpts, jacpts, legpoly, lobpts.

%% Nodes
[x, ignored, v] = jacpts(n-1,0,1);
x = [-1 ; x];

if nargout < 2, return, end

%% Quadrature weights

% Initialise
Pm2 = 1; Pm1 = x;  PPm2 = 0; PPm1 = 1;
% Use recurrence relation
for k = 1:n-1, 
    P = ((2*k+1)*Pm1.*x-k*Pm2)/(k+1);           Pm2 = Pm1; Pm1 = P; 
    PP = ((2*k+1)*(Pm2+x.*PPm1)-k*PPm2)/(k+1);  PPm2 = PPm1; PPm1 = PP;  
end   
w = 1./((1-x).*PP.^2);
w(1) = 2/n^2;

if nargout < 3, return, end

%% Barycentric weights
vv = bary_weights(x);
v = v./(1+x(2:end));
v = v/max(abs(v));
v = [vv(1) ; v];

