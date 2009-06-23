function w = clencurt(a,b,m)

%CLENCURT  Weights of Clenshaw-Curtis quadrature rule.
%
%   W = CLENCURT(A,B,M) calculates the weights W of the M-point
%   Clenshaw-Curtis rule on the interval (A,B). Here, W is a M-dimensional
%   row vector.
%
%   For speed up, an entry to an internal table of the basic quadrature
%   rule is generated for each new value of M.
%
%   Example:
%
%       w = clencurt(0,pi,15); x = chebpts(domain(0,pi),15);
%       w*sin(x)

% Copyright 2009 by Folkmar Bornemann. 
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.
% $Id$

persistent table    % cache the weights for the interval [-1,1]

if ~isa(table,'struct')
    table.w = cell(2^16,1);
end

if m<2
    error('Use at least two quadrature points.');
end
if m==2
    w = (b-a)*[1/2 1/2];
    return;
end

if m > length(table.w) || isempty(table.w{m})
    m = m-1;
    % cf. J. Waldvogel, BIT 43, pp. 1-18, 2003
    M = (1:2:m-1)'; l = length(M); n = m-l;
    v0 = [2./M./(M-2); 1/M(end); zeros(n,1)];
    v2 = -v0(1:end-1)-v0(end:-1:2);
    g0 = -ones(m,1); g0(1+l)=g0(1+l)+m; g0(1+n)=g0(1+n)+m;
    g = g0/(m^2-1+mod(m,2));
    w = ifft(v2+g); w(m+1) = w(1);
    table.w{m+1} = w;
else
    w = table.w{m};
end

w = ((b-a)*w/2)';

end