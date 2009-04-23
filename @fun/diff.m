function gout = diff(g,k)
% DIFF	Differentiation
% DIFF(G) is the derivative of the fun G.  
%
% DIFF(G,K) is the K-th derivative of G.
% If the fun G of length n is represented as
%
%       SUM_{r=0}^{n-1} C_r T_r(x)
%
% its derivative is represented with a fun of length n-1 given by
%
%       SUM_{r=0}^{n-2} c_r T_r (x)
% 
% where c_0 is determined by
% 
%       c_0 = c_2/2 + C_1;
%
% and for r > 0,
%
%       c_r = c_{r+2} + 2*(r+1)*C_{r+1}, 
%
% with c_{n} = c_{n+1} = 0.
%
% See "Chebyshev Polynomials" by Mason ad Handscomb, CRC 2002, pg 34.
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2008 by The Chebfun Team. 

if isempty(g), gout = g; return, end
if (nargin==1), k=1; end                
c = chebpoly(g);                        % obtain Cheb coeffs {C_r}
n = g.n;
for i = 1:k                             % loop for higher derivatives
    if n == 1, gout = fun(0); return, end  % derivative of constant is zero 
    cout = zeros(n+1,1);                % initialize vector {c_r}
    v = [0; 0; 2*(n-1:-1:1)'.*c(1:end-1)]; % temporal vector
    cout(1:2:end) = cumsum(v(1:2:end)); % compute c_{n-2}, c_{n-4},...
    cout(2:2:end) = cumsum(v(2:2:end)); % compute c_{n-3}, c_{n-5},...
    cout(end) = .5*cout(end);           % rectify the value for c_0
    cout = cout(3:end);
    n = n-1;
    c = cout;
end
gout = fun(chebpolyval(cout));          % construct fun from {c_r}