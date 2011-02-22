function N = nargin(L)
% Number of input arguments to a linop.
%  N = nargin(L) returns the number of input arguments of L, i.e., L.blocksize(2);   

N = L.blocksize(2);