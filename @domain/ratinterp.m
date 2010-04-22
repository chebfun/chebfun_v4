function [p,q,r_handle] = ratinterp(f,d,m,varargin)
% RATIONAL INTERPOLATION
% [P,Q,R_HANDLE] = RATINTERP(F,M,N) constructs the [M/N]-rational interpolant 
% R = P/Q in M+N+1 Chebyshev points. P is a chebfun of length M+1 and Q is 
% a chebfun of length N+1. R_HANDLE is a function handle that evaluates the
% rational function using the barycentric formula.
%
% [P,Q,R_HANDLE] = RATINTERP(F,M,N,XGRID) constructs the [M/N]-rational
% interpolant R_HANDLE = P/Q on a grid XGRID of length M+N+1 which should
% normally lie in the domain of F.
%
% [P,Q,R_HANDLE] = RATINTERP(F_HANDLE,D,M,N,XGRID) uses a function handle
% F_HANDLE on a domain F to construct the rational interpolant.
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

%  Copyright 2002-2009 by The Chebfun Team. 
%  Last commit: $Author: pachon $: $Rev: 768 $:
%  $Date: 2009-11-16 12:54:19 +0000 (Mon, 16 Nov 2009) $:

%  This version of RATINTERP lives in @domain.
%  There is a companion code in @chebfun.

a = d.ends(1); b = d.ends(end);
if nargin == 3,
    n = 0; xi = chebpts(m+1,[a,b]); % polynomial interpolation in Chebyshev points
    type = 'chebyshev';
end
if nargin == 4
    if length(varargin{1}) == 1
        n = varargin{1};
        xi = chebpts(m+n+1,[a,b]);
        type = 'chebyshev';
    elseif length(varargin{1}) == m+1  % polynomial interpolation on arbitrary grid
        n = 0;
        xi = varargin{1};
        type = 'arbitrary';
    else
        error('DOMAIN:ratinterp:input','Unrecognized input sequence.'); 
    end
end
if nargin == 5
    n = varargin{1};
    xi = varargin{2};
    type = 'arbitrary';
    %if length(xi) ~= m+n+1
    %    error('DOMAIN:ratinterp:input',['The vector of nodes must be of length M+N+1 = ',num2str(N+1),'.']);
    %end
end
% init some constants
%N = m+n;
N = length(xi)-1;
xi = xi(:);
fx = f(xi);
if strcmp(type,'chebyshev')
    % get the Chebyshev coefficients of fx (not f!)
    gama = flipud( chebpoly( chebfun ( fx ) )' );
    % assemble the matrix Z
    Z = zeros(n,n+1);
    for i=m+1:N, for j=0:n
        for k=0:N
            if i + j == k || i + k == j || j + k == i || ...
               2*N - (i+j) == k || 2*N - (i+k) == j || 2*N - (j+k) == i
                if (i == N && k == N) || (j == 0 && k == 0)
                    Z(i-m,j+1) = Z(i-m,j+1) + 2 * gama(k+1);
                elseif i == N || k == N || j == 0 || k == 0
                    Z(i-m,j+1) = Z(i-m,j+1) + gama(k+1);
                else
                    Z(i-m,j+1) = Z(i-m,j+1) + gama(k+1) / 2;
                end;
            end;
        end;
    end; end;
    % get the null-space of Z
    alfa = null( Z );
    % did we get only one solution? try to restrict alfa if we did...
    if size(alfa,2)>1
        warning('DOMAIN:ratinterp','Denominator computed to be of degree %i.',n-size(alfa,2)+1);
        R = qr( flipud( alfa )' );
    	alfa = flipud( R(end,size(alfa,2):end)' );
    end;
    % construct q
    q = chebfun( chebpolyval( flipud( alfa ) ) , [a,b] );
    qi = feval(q,xi);
    % construct p
    p = chebfun( qi.* fx , [a,b] );
    c = chebpoly(p);
    p = chebfun( chebpolyval( c( n+1:end ) ) , [a,b] );
    % construct r
    w = [.5 ; ones(N,1)]; 
    w(2:2:end) = -1;
    w(end) = .5*w(end);
    w = w.* qi;
    r_handle = @(x) bary(x,fx,xi,w);
elseif strcmp(type,'arbitrary')
    % construct the complex nodes and weights
    xk = (2*xi-a-b)/(b-a);                       % map [a,b] to [-1,1]
    % construct the vandermonde-linke matrix Z
    Z = chebpoly(0:N-m); Z = Z(xk,:);    
    % get the null-space of L*Z and make qk out of it
    wxk = bary_weights(xk);
    M = Z(:,1:N-m).' * diag(fx.*wxk) * Z(:,1:n+1);
    [u,s,v] = svd(M);
    qk = Z(:,1:n+1) * v(:,end);
    % construct the interpolants
    % p = chebfun(@(x) bary(x,qk.*fx,xi,wxk),d.ends([1,end]),m+1);
    p = chebfun(@(x) bary(x,qk.*fx,xi,wxk),d.ends([1,end]),m+1);
    q = chebfun(@(x) bary(x,qk,xi,wxk),d.ends([1,end]),n+1);
    r_handle = @(x) bary(x,fx,xi,qk.*wxk);
end