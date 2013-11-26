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
[x, w, v] = jacpts(n-1,0,1);
x = [-1 ; x];

%% Quadrature weights
w = [2/n^2, w./(1+x(2:end).')];

%% Barycentric weights
v = v./(1+x(2:end));
v = v/max(abs(v));
v1 = -abs(sum(x(2:end).*v));
v = [v1 ; v];

end

