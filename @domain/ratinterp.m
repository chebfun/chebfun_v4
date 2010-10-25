function [p,q,rh] = ratinterp(f,d,m,varargin)
% RATIONAL INTERPOLATION
% [P,Q,R_HANDLE] = RATINTERP(F,M,N) constructs the [M/N]-rational interpolant 
% R = P/Q of a chebfun F in M+N+1 Chebyshev points. P is a chebfun of length 
% M+1 and Q is a chebfun of length N+1. R_HANDLE is a function handle that 
% evaluates the rational function using the barycentric formula. (A function 
% handle is used because constructing a chebfun for a quotient P./Q may be very
% inefficient).
%
% [P,Q,R_HANDLE] = RATINTERP(F,M,N,XGRID) constructs the [M/N]-rational
% interpolant R_HANDLE = P/Q on a grid XGRID of length M+N+1 which should
% lie in the domain of F.
%
% RATINTERP(F,M,N,'chebpts',KIND) specifies a grid of Chebyshev points
% of the first kind if KIND = 1 and second kind if KIND = 2. If not
% specified, the kind of Chebyshev points is taken from
% CHEBFUNPREF('CHEBKIND').
%
% RATINTERP(F_HANDLE,D,M,N), RATINTERP(F_HANDLE,D,M,N,XGRID) and
% RATINTERP(F_HANDLE,D,M,N,'chebpts',KIND) use a function handle
% F_HANDLE on a domain D to construct the rational interpolant.
%
% RATINTERP uses the algorithm introduced in Pachón R., Gonnet P., van Deun J., 
% "Fast and stable rational interpolation in roots of unity and Chebyshev 
% points", submitted. The case of rational interpolation in roots of unity
% and arbitrary grids on the complex plane are also treated in that paper
% although not implemented in RATINTERP. See also CHEBPADE and CF for other
% rational approximation methods in Chebfun.
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

%  Copyright 2002-2009 by The Chebfun Team. 
%  Last commit: $Author: pachon $: $Rev: 768 $:
%  $Date: 2009-11-16 12:54:19 +0000 (Mon, 16 Nov 2009) $:

%  This version of RATINTERP lives in @domain.
%  There is a companion code in @chebfun.

a = d.ends(1); b = d.ends(end);              
chebkind = chebfunpref('chebkind');
if nargin == 3,                              % polynomial interpolation in Chebyshev points 
    p = chebfun(f,[a,b],m+1);                % (uses the Chebfun constructor)
    q = chebfun(1);
    xk = chebpts(m+1,[a,b],chebkind);
    rh = @(x) bary(x,p.vals,xk,bary_weights(xk));
    return;
elseif nargin == 4
    if length(varargin{1}) == 1              % rational interpolation in Chebyshev points
        n = varargin{1};
        xk = chebpts(m+n+1,[a,b],chebkind);
        type = 'chebyshev';
    elseif length(varargin{1}) == m+1        % polynomial interpolation in arbitrary grid
        xk = varargin{1};                    % (uses chebfun/interp1)
        p = interp1(xk,feval(f,xk),d);
        q = chebfun(1);
        rh = @(x) bary(x,p.vals,xk,bary_weights(xk));
        return;        
    else
        error('DOMAIN:ratinterp:input','Unrecognized input sequence.'); 
    end
elseif nargin == 5
    n = varargin{1};
    if length(varargin{2}) == m+n+1          % rational interpolation in arbitrary grid
        xk = varargin{2};
        type = 'arbitrary';
    else
        error('DOMAIN:ratinterp:input','Unrecognized input sequence.'); 
    end
elseif nargin == 6        
    n = varargin{1};
    if strcmp(varargin{2},'chebpts')         % rational interpolation in Chebyshev points
        chebkind = varargin{3};              % of specific kind
        xk = chebpts(m+n+1,[a,b],chebkind);
        type = 'chebyshev';
    else
        error('DOMAIN:ratinterp:input','Unrecognized input sequence.'); 
    end
end
N = m+n;
xk = xk(:);
fk = feval(f,xk);                                         % function values 
if strcmp(type,'chebyshev') 
    if chebkind == 1                                  
        D = dct(diag(fk));                                % compute C'(Phi')
        Z = dct(D(1:n+1,:)');                             % compute C'(C'(Phi'))'
        [u,s,v] = svd(Z(m+2:N+1,:));                      % svd of syst w size nx(n+1)
        qk = idct(v(:,end),N+1);                          % values of q at Cheb pts 
        wk = (-1).^(0:N)'.*sin((2*(0:N)+1)*pi/(2*N+2))';  % barycentric weights      
    elseif chebkind == 2  % <- this case can be modified to use FFTs
        xko = chebpts(m+n+1,chebkind);                    % chebpts on interval [-1,1]
        C(:,1) = ones(N+1,1); C(:,2) = xko;               % Vandermonde-type matrix
        for k = 2:N, 
            C(:,k+1) = 2*xko.*C(:,k)-C(:,k-1);            % 3-term recurrence
        end
        half = [1/2; ones(N-1,1);1/2];
        Z = C(:,m+2:N+1).' * diag(half.*fk)*C(:,1:n+1);   % modified matrix Z
        [u,s,v] = svd(Z);                                 % svd of syst w size nx(n+1)
        qk = C(:,1:n+1) * v(:,end);                       % values of q at Cheb pts 
        wk = half.*(-1).^((0:N)');                        % barycentric weights        
    end
    p = chebfun(qk.*fk,[a,b],'chebkind',chebkind);        % chebfun of numerator
    q = chebfun(qk,[a,b],'chebkind',chebkind);            % chebfun of denominator
    rh = @(x) bary(x,fk,xk,qk.*wk);                       % function handle of rat interp
elseif strcmp(type,'arbitrary')
    [C,~] = qr(fliplr(vander(xk)));                       % construct orth matrix
    Z = C(:,m+2:N+1).' * diag(fk) * C(:,1:n+1);           % assemble matrix
    [u,s,v] = svd(Z);                                     % svd of syst w size nx(n+1)
    qk = C(:,1:n+1) * v(:,end);                           % values of q at grid
    wk = bary_weights(xk);                                % barycentric weights
    p = chebfun(@(x) bary(x,qk.*fk,xk,wk),[a,b],m+1);     % chebfun of numerator
    q = chebfun(@(x) bary(x,qk,xk,wk),[a,b],n+1);         % chebfun of denominator
    rh = @(x) bary(x,fk,xk,qk.*wk);                       % handle to evaluate in C
end
