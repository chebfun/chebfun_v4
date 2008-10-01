function theta = subspace(A,B)
%SUBSPACE Angle between subspaces.
%   SUBSPACE(A,B) finds the angle between two subspaces specified by the
%   column chebfun quasimatrices A and B. 
%
%   If the angle is small, the two spaces are nearly linearly dependent.

%   References:
%   [1] A. Bjorck & G. Golub, Numerical methods for computing
%       angles between linear subspaces, Math. Comp. 27 (1973),
%       pp. 579-594.
%   [2] P.-A. Wedin, On angles between subspaces of a finite
%       dimensional inner product space, in B. Kagstrom & A. Ruhe (Eds.),
%       Matrix Pencils, Lecture Notes in Mathematics 973, Springer, 1983,
%       pp. 263-285.
%
%   See Matlab's subspace function

% Copyright 2002-2008 by The Chebfun Team. See www.comlab.ox.ac.uk/chebfun.

A = orth(A);
B = orth(B);
%Check rank and swap
if size(A,2) < size(B,2)
   tmp = A; A = B; B = tmp;
end
% Compute the projection the most accurate way, according to [1].
for k=1:size(A,2)
   B = B - A(:,k)*(A(:,k)'*B);
end
% Make sure it's magnitude is less than 1.
theta = asin(norm(B));