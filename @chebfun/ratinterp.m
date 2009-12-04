function [p,q,r_handle] = ratinterp(f,m,varargin)
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
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

%  Copyright 2002-2009 by The Chebfun Team. 
%  Last commit: $Author: pachon $: $Rev: 768 $:
%  $Date: 2009-11-16 12:54:19 +0000 (Mon, 16 Nov 2009) $:

[a,b] = domain(f);
if nargin == 2,
    n = 0; xi = chebpts(m+1,[a,b]); % polynomial interpolation in Chebyshev points
    type = 'chebyshev';
end
if nargin == 3
    if length(varargin{1}) == 1
        n = varargin{1};
        xi = chebpts(m+n+1,[a,b]);
        type = 'chebyshev';
    elseif length(varargin{1}) == m+1  % polynomial interpolation on arbitrary grid
        n = 0;
        xi = varargin{1};
        type = 'arbitrary';
    else
        error('CHEBFUN:ratinterp:input','Unrecognized input sequence.'); 
    end
end
if nargin == 4
    n = varargin{1};
    xi = varargin{2};
    type = 'arbitrary';
    if length(xi) ~= m+n+1
        error('CHEBFUN:ratinterp:input',['The vector of nodes must be of length M+N+1 = ',num2str(N+1),'.']);
    end
end
% init some constants
N = m+n;
fx = feval(f,xi);
%fx = f(xi);
if strcmp(type,'chebyshev')
    % get the Chebyshev coefficients of fx (not f!)
    gama = flipud( chebpoly( chebfun ( fx ) )' );
    gama(1) = gama(1) / 2;
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
    if size(alfa,2) > 1
        warning('CHEBFUN:RATINTERP','Ill-posed interpolation nodes! reducing ''n'' from %i to %i.',n,n-size(alfa,2)+1);
        R = qr( flipud( alfa )' );
    	alfa = flipud( R(end,size(alfa,2):end)' );
    end;
    % construct q
    q = chebfun( chebpolyval( flipud( alfa ) ) , [a,b] );
    qi = feval(q,xi);
    % construct p
    p = chebfun( qi.* fx , [a,b] );
    % construct f
    w = [.5 ; ones(N,1)]; 
    w(2:2:end) = -1;
    w(end) = .5*w(end);
    w = w.* qi;
    r = @(x) bary(x,fx,xi,w);
elseif strcmp(type,'arbitrary')
    xi = xi(:);
    xk = (2*xi-a-b)/(b-a);                      % map [a,b] to [-1,1]
    zk = xk(2:end-1) + sqrt(xk(2:end-1).^2-1);   
    zk = [xk(1); zk; conj(zk); xk(end)];         % map [-1,1] to unit circle
    wk = bary_weights(zk);
    B = [];
    for k = n+1:N
       temp = real(wk.*zk.^(k-1)).';             % assemble NxN system
       B = [B; [temp(1) 2*(temp(2:N)) temp(end)]];
    end
    for k = m+1:N
       temp = real(wk.*zk.^(k-1)).';
       B = [B; [fx(1)*temp(1) 2*fx(2:end-1).'.*temp(2:N) fx(end)*temp(end)]];
    end
    cB = cond(B(:,2:end));
    qk = real([1;B(:,2:end)\(-B(:,1))]) ;        % denominator values at nodes
    wxk = bary_weights(xk);
    p = @(x) bary(x,qk.*fx,xi,wxk);
    q = @(x) bary(x,qk,xi,wxk);
    r = @(x) bary(x,fx,xi,qk.*wxk);
end
