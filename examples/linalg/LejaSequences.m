%% Leja sequences and the LU factorization of a quasimatrix
% Alex Townsend, 11th April 2014. 

%%  
% (Chebfun Example linalg/LejaSequences.m) 
% [Tags: #linearalgebra, #quasimatrix, #ludecomposition, #LejaPoints]

FS = 'fontsize'; fs = 16; 
LW = 'linewidth'; lw = 2; 
MS = 'markersize'; ms = 20; 

%% Leja sequences in [-1,1]
% A Leja sequence $x_1,x_2,\ldots,$ in $[-1,1]$ is defined recursively as 
% follows: Pick any $x_1\in[-1,1]$, define $x_2$ to be the maximum of $|x-x_1|$
% in $[-1,1]$, $x_3$ to be the maximum of $|(x-x_1)(x-x_2)|$ in $[-1,1]$,
% and so on. This generates a sequence of distinct points in $[-1,1]$ that are 
% called a Leja sequence [1,2]. The first N in this sequence 
% $x_1,\ldots, x_N$ are also referred to as N Leja points. The set of points 
% are not unique as there choices in arbitrarily breaking ties. Throughout this 
% Example we take $x_1 = -1$. Here is a way to calculate 10 Leja points:

leja = -1;
for j = 2 : 10
   f = chebfun(@(x) prod( x - leja ), 'vectorize' );  % product to maximize
   [ignored, loc] = max( abs( f ) );                  % abs max of product
   leja( j ) = loc;                                   % add to sequence
end
leja_points = sort( leja.' )                          % first 10 Leja points

%% LU factorization of a quasimatrix 
% Given a quasimatrix $A$ of size $[a,b]\times k$, i.e., a matrix with $k$ 
% columns where each column is a function defined on $[a,b]$, the LU factorization 
% expresses $A$ as a product of a $[a,b]\times k$ unit lower-triangular 
% quasimatrix, L, and a $k\times k$ upper-triangular matrix, U. The matrix U 
% is upper-triangular in the standard matrix sense, and the quasimatrix
% L is lower-triangular in the sense that there is a sequence $y_1,\ldots,y_k$ 
% such that the second column of L is zero at $y_1$, the third at $y_1,y_2$, the
% fourth at $y_1,y_2,y_3$, and so on. L is unit lower-triangular in the sense 
% that the first column of L is 1 at $y_1$, the second is 1 at $y_2$, and so on. 
% This definition of triangular quasimatrix is proving to be very useful for 
% generalizing many standard matrix factorizations to continuous settings [3]. 
% It turns out, as we will see, if $A$ is a Vandermonde-like quasimatrix the 
% sequence $y_1,\ldots,y_k$ are a Leja sequence.

%% 
% There is a command in Chebfun that computes the LU factorization of a
% quasimatrix by Gaussian elimination with partial pivoting. For example: 

x = chebfun('x');
A = [cos(x) sin(2*x) cos(3*x) sin(4*x) cos(5*x) sin(6*x)] + 2;% quasimatrix 
[L, U] = lu( A );                                             % LU factorization

%% 
% One can check that it is a decomposition of A,
norm( A - L * U )

%% 
% that U is an upper-triangular matrix,
spy( U )
title('Upper-triangular matrix', FS, fs)

%% 
% and that L is a lower-triangular quasimatrix by using the spy command in 
% Chebfun. The red dots show the zeros of the columns and demostrate 
% the nested structure of them.
spy(L, '.-r', 'markersize', 20)
title('Nested zeros of a lower-triangular quasimatrix', FS, fs)

%% Pivoting
% The LU factorization of a quasimatrix is computed by Gaussian elimination with
% partial pivoting. At each step the absolute maximum entry of a column is 
% selected and a continuous analogue of Gaussian elimination is performed.
% For more information about this see [3]. 

%% Gaussian elimination pivots at a Leja sequence
% Take the quasimatrix $A = [1,x,x^2,\cdots,x^k]$ (any Vandermonde quasimatrix 
% will do) and start performing Gaussian elimination (GE) with partial pivoting 
% on $A$ with the first pivot $y_1 = -1$. The first step of GE uses row $y_1$ 
% to place zeros in column 1 and row $y_1$ of A: 

x = -chebfun('x');
A = [1 x x.^2 x.^3];
A = A - A(:,1) * A(-1,:) / A(-1,1);     % First step of GE

%%
% In this case, the first step is algebraically: 
%
%  \[ 
%   \begin{bmatrix}0&x-1&x^2-1&x^3-1\end{bmatrix} = \begin{bmatrix}1&x&x^2&x^3\end{bmatrix} - 1 \times 1 / 1 
%  \]

%%
% The second step finds $y_2\in[-1,1]$ to maximize the absolute value of the 
% second column (equivalent to maximizing $|x - y_1|$), and then GE uses row 
% $y_2$ to place zeros in column 2 and row $y_2$ of A, and so on. The kth step 
% finds the location of the absolute maximum of the kth column, which is, after 
% k steps of GE, monic, of degree $k-1$, and zero at $y_1,\ldots,y_{k-1}$, i.e.,
% it is the polynomial $(x-y_1)\cdots(x-y_{k-1})$. The next pivot $y_k\in[-1,1]$ 
% is chosen to be the maximum of $|(x-y_1)\cdots(x-y_{k-1})|$. The process 
% continues and by construction the pivoting locations is a Leja sequence.

%% 
% For example, here is the LU way to construct Leja points (the third output 
% argument to the command LU() returns the pivoting locations): 

N = 9; 
x = chebfun('x'); 
[L, U, p] = lu( x.^(0:N) );        % pivoting locations are Leja points
leja_points = sort( p )            % Same as before

%% 
% These Leja points are minus the previous ones because there was a tie in 
% the fourth step of GE.

%% 
% Leja points can be constructed from GE on any Vandermonde quasimatrix:

[L, U, p] = lu( chebpoly(0:N) );   % pivoting locations are Leja points
leja_points = sort( p )            % Same as before

%% Lebesgue constants
% Leja sequences are interesting because they can be used for Newton interpolation 
% and have Lebesgue constants that increase subexponentially [2]. That is, 
% if $\Lambda_N$ is the Lebesgue constant of N Leja points, then 
% $\Lambda_N^{1/N} \rightarrow 1$. We can check this numerically using GE: 

N = 100; 
A = chebpoly( 0:N ); 
[L, U, p] = lu( A );

k = 1; 
for j = 3:N
    [ignored, c] = lebesgue( sort( p(1:j) ) );
    leb_const(k) = c; k = k + 1; 
end

plot( leb_const .^ (1 ./ ( 1:(N-2) )) , LW, lw)
title('Subexponential growth of Lebesgue constant', FS, fs)
xlabel('N', FS, fs), ylabel('\Lambda_N^{1/N}', FS, fs)
set(gca, FS, fs)

%% 
% References:
%% 
% [1] F. Leja, Sur certaines suits liees aux ensemble plan et leur application a
% la representation conforme, Ann. Polon. Math., 4 (1957), pp. 8--13. 
%% 
% [2] R. Taylor, Lagrange interpolation on Leja points, PhD thesis, University 
% of South Florida, 2008.
%% 
% [3] A. Townsend and L. N. Trefethen, Continuous analogues of matrix
% factorizations, submitted. 