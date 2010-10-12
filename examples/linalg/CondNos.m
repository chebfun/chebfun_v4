%% CONDITION NUMBERS OF VARIOUS BASES
% Nick Trefethen, 27 September 2010

%%
% (Chebfun example linalg/CondNos.m)

%%
% Chebfun can compute the condition number of a
% set of functions on an interval.  That's a condition
% number for continuous functions, not discrete approximations.

%%
% For example, here we take the first 9 Chebyshev polynomials
% on [-1,1]:
tic
N = 8;
A = chebpoly(0:N);
disp(' ')
disp('Condition numbers of various sets of nine functions on [-1,1]')
disp(' ')
fprintf('          Chebyshev polynomials: %8.3f\n',cond(A))

%%
% Legendre polynomials are not much different:
A = legpoly(0:N);
fprintf('           Legendre polynomials: %8.3f\n',cond(A))

%%
% Here are the Legendre polynomials normalized by having unit norm
% rather than by taking the value 1 at x=1.  Since the
% functions are orthonormal, the condition number is 1.
A = legpoly(0:N,'norm');
fprintf('Normalized Legendre polynomials: %8.3f\n',cond(A))

%%
% All of these condition numbers are fine for numerical work.
% Monomials, by contrast, are exponentially ill-conditioned:
x = chebfun('x');
A = [1 x];
for j = 2:N
  A = [A x.^j];
end
fprintf('                      Monomials: %8.3f\n',cond(A))

%%
% These experiments take a surprisingly long time, which is
% why we've looked at sets of only nine functions:
disp(' ')
fprintf('Total time: %5.2f        (too long!)\n', toc)
disp(' ')

%%
% Unfortunately Chebfun's QR command, though very robust
% due to the use of continuous Householder reflectors, is slow.

%%
% Reference:
%
% L. N. Trefethen, Householder triangularization of a quasimatrix,
% IMA Journal of Numerical Analysis, 2009.
 

