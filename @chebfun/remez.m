function varargout = remez(f,varargin)
% Best polynomial or rational approximation.

% REMEZ(F,M,N) computes the best rational approximation of type [M/N] of a
% chebfun F using the Remez algorithm. The particular case REMEZ(F,N) 
% computes the best polynomial approximation of degree N .
%
% P = REMEZ(...) returns a chebfun P for the best polynomial
% approximation.
%
% [P,Q] = REMEZ(...) returns chebfuns P and Q for best rational
% approximation.
%
% [P,ERR] = REMEZ(...) and [P,Q,ERR] = REMEZ(...) also returns the maximum 
% error ERR.    
%
% [P,ERR,XK] = REMEZ(...) and [P,Q,ERR,XK] = REMEZ(...) also returns the 
% reference grid on which the error equioscillates.
%
% See Pachon and Trefethen, "Barycentric-Remez algorithms for best 
% polynomial approximation in the chebfun system", BIT Numerical 
% Mathematics 49 (2009),721-741) and Chapter 5 of "Algorithms for 
% Polynomial and Rational Approximation", D.Phil. Thesis, University of 
% Oxford, 2010.
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

%  Copyright 2002-2009 by The Chebfun Team. 
%  Last commit: $Author$: $Rev$:
%  $Date$:

if numel(f) > 1, error('CHEBFUN:remez:quasi',...
        'Remez does not currently support quasimatrices'); end

if numel(f) > 1, % Deal with quasimatrices    
    trans = false;
    if get(f,'trans')
        f = f.'; trans = true;
    end
    r = cell(1,numel(f)); p = chebfun; q = chebfun;
    s = zeros(1,numel(f));    
    for k = 1:numel(f)             % loop over chebfuns
      if (nargin < 4), M = length(f(:,k)) - 1; end
      [p(:,k) q(:,k) r{k} s(k)] = remez(f(:,k),varargin);
    end
    if trans
        r = r.'; p = p.'; q = q.';
    end
    return
end
if any(get(f,'exps')<0), 
    error('CHEBFUN:remez:inf',...
     'Remez does not currently support functions which diverge to infinity'); 
end
spl_ini = chebfunpref('splitting');
splitting off,
if nargin == 2
    N = varargin{1};
    n = 0; no = 0;
elseif nargin == 3
    m = varargin{1}; n = varargin{2};
    no = n;
    [m,n] = detectdegeneracy(f,m,n);
    N = m+n;
end
% parameters
iter = 1;
maxit = 25; 
[a,b] = domain(f);
sigma = ones(N+2,1); sigma(2:2:end) = -1;  % alternating signs
normf = norm(f); 
delta = normf; deltamin = delta;
diffx = 1;
% set tolerances according
if N < 15, 
    tol = 1e-14; 
elseif N < 100, 
    tol = 1e-14; 
elseif N <= 1000, 
    tol = 1e-11; 
elseif N > 1000
    tol = 2e-10;
end
% initial reference
flag = 0;
if f.nfuns == 1 && n > 0
    [p,q] = chebpade(f,m,n);
    % [p,q] = cf(f,m,n);
    [xk,err,e,flag] = exchange([],0,2,f,p,q,N+2);
end
if f.nfuns > 1 || n == 0 || flag == 0
    xk = chebpts(N+2,[a,b]);
    % xk = linspace(a,b,N+2);
end
xo = xk;
while (delta/normf > tol) && iter <=maxit && diffx > 0
    
    fk = feval(f,xk);                             % function values 
    w = bary_weights(xk);                         % compute barycentric weights
    % computatiom of levelled error   
    if n > 0 
        % in case of rational case, obtain simultaneously the levelled
        % error and the values of the trial denominator
       [C,~] = qr(fliplr(vander(xk)));            % orthogonal matrix wrt <,>_xk
       ZL=C(:,m+2:N+2).'*diag(fk)*C(:,1:n+1);     % left rational interp matrix
       ZR=C(:,m+2:N+2).'*diag(sigma)*C(:,1:n+1);  % right rational interp matrix 
       [v,d] = eig(ZL,ZR);                        % solve generalize eig problem
       qk_all = C(:,1:n+1)*v;                     % compute all possible qk 
       pos = find(abs(sum(sign(qk_all)) == N+2)); % signs' changes of each qk
       if isempty(pos)||length(pos)>1
         error('Trial interpolant too far from optimal');
       end    
       qk = qk_all(:,pos);                        % keep qk with unchanged sign
       h = d(pos,pos);                            % levelled reference error 
    else
       % in case of polynomial case, compute directly the levelled error
       h = (w'*fk)/(w'*sigma);                    % levelled reference error  
       qk = 1;
       q = chebfun(1); 
    end    
    if h==0, h = 1e-19; end                       % perturb error if necessary         
    pk = (fk - h*sigma).*qk;                      % vals of r x q in reference
    p =chebfun(@(x) bary(x,pk,xk,w),[a,b],N+1);   % chebfun of trial numerator
    if n > 0
     q =chebfun(@(x) bary(x,qk,xk,w),[a,b],N+1);  % chebfun of trial denominator   
    end
    [xk,err,e] = exchange(xk,h,2,f,p,q,N+2);
    if err/normf > 1e5                            % if overshoot, recompute with one-
        [xk,err,e] = exchange(xo,h,1,f,p,q,N+2);  % point exchange
    end    
    diffx = max(abs([xo-xk]));
    xo = xk;
    delta = err - abs(h);                         % stopping value 
    if delta < deltamin,                          % store poly with minimal norm       
      pmin = p; errmin = err; xkmin = xk;          
      if n > 0 , qmin = q; end  
      deltamin = delta;
    end
    iter = iter+1;
    %[num2str(delta/normf,'%5.15f') ' ' num2str(h,'%5.15f')]       % uncomment to see progress
end
p = pmin;
err = errmin;
xk = xkmin;
if no > 0 , q = qmin; end
if no == 0 
    if nargout >= 1, varargout(1) = {p};   end
    if nargout >= 2, varargout(2) = {err}; end
    if nargout == 3, varargout(3) = {xk};  end
elseif no > 0
    if nargout >= 1, varargout(1) = {p};   end
    if nargout >= 2, varargout(2) = {q}; end
    if nargout >= 3, varargout(3) = {err};  end
    if nargout == 4, varargout(4) = {xk}; end
end
chebfunpref('splitting',spl_ini), 

%-------------------------------------------------------------------------%
    function [xk,norme,e,flag] = exchange(xk, h, method, f, p, q, Npts)  
    % EXCHANGE modifies an equioscillation reference using the Remez 
    % algorithm.
    %
    % EXCHANGE(XK,H,METHOD,F,P,Q) performs one step of the Remez algorithm 
    % for the best rational approximation of the chebfun F of the target 
    % function according to the first method (METHOD = 1), i.e. exchanges 
    % only one point, or the second method (METHOD = 2), i.e. exchanges all 
    % the reference points. XK is a column vector with the reference, H is 
    % the levelled error, P is the numerator and Q is the denominator of
    % the trial rational function P/Q.
    %
    % [XK, NORME, E_HANDLE, FLAG] = EXCHANGE(...) returns the modified 
    % reference XK, the supremum norm of the error NORME (included as an 
    % output argument, since it is readily computing in EXCHANGE and is 
    % used later in REMEZ), a function handle E_HANDLE for the error, and a
    % FLAG indicating whether there were at least N+2 alternating extrema
    % of the error to form the next reference (FLAG = 1) or not (FLAG = 0).
    %
    % [XK,...] = EXCHANGE([],0,METHOD,F,P,Q,N+2) returns a grid of
    % N+2 points XK where the error F - P/Q alternates in sign (but not 
    % necessarily equioscillates). This feature of EXCHANGE is useful to 
    % start REMEZ from an initial trial function rather than an initial 
    % trial reference.    
    [a,b] = domain(f);
    e_num = (q.^2).*diff(f) - q.*diff(p) + p.*diff(q);
    rr = [a; roots(e_num); b];                   % extrema of the error
    e = @(x) feval(f,x) - feval(p,x)./feval(q,x);                  % fnc handle of error
    if method == 1                               % one-point exchange
        [tmp,pos] = max(abs(feval(e,rr))); pos = pos(1);
    else                                         % full exchange                  
        pos = find(abs(e(rr))>=abs(h));    % vals above leveled error
    end
    [r,m] = sort([rr(pos); xk]);   
    v = ones(Npts,1); v(2:2:end) = -1;
    er = [feval(e,rr(pos));v*h];
    er = er(m); 
    repeated = diff(r)==0;
    r(repeated) = []; er(repeated) = [];         % delete repeated pts
    s = r(1); es = er(1);                        % pts and vals to be kept
    for i = 2:length(r)
      if sign(er(i)) == sign(es(end)) &&...      % from adjacent pts w/ same sign 
              abs(er(i))>abs(es(end))            % keep the one w/ largest val
          s(end) = r(i); es(end) = er(i);
      elseif sign(er(i)) ~= sign(es(end))        % if sign of error changes and 
          s = [s; r(i)]; es = [es; er(i)];       % pts and vals
      end     
    end
    [norme,idx] = max(abs(es));                  % choose n+2 consecutive pts
    d = max(idx-Npts+1,1);                       % that include max of error
    if Npts<= length(s)
        xk = s(d:d+Npts-1); flag = 1;
    else
        xk = s; flag = 0;
    end
    
    % END EXCHANGE

%-------------------------------------------------------------------------%
    function [m,n] = detectdegeneracy(f,m,n)
    % DETECTDEGENERACY modifies the type of the rational approximant if
    % the function is even or odd and the defect is larger than zero.
    %
    % [M,N] = DETECTDEGENERACY(F,M,N) modifies m and n to correct the 
    % defect of the rational approximation if the target function is 
    % even or odd. In either case, the Walsh table is covered with 
    % blocks of size 2x2, e.g. for even function the best rational 
    % approximant is the same for types [m/n], [m+1/n], [m/n+1] and 
    % [m+1/n+1], with m and n even. This strategy is the same as the 
    % one proposed by van Deun and Trefethen for CF approximation in 
    % Chebfun (see chebfun/cf.m).
    ff = chebfun(f,domain(f),128);                 
    a = chebpoly(ff); a(end) = 2*a(end);
    if max(abs(a(end-1:-2:1)))/f.scl < eps, % f is an even function
        if ~(mod(m,2)||mod(n,2)), m = m + 1;
        elseif mod(m,2) && mod(n,2), n = n - 1;
        end
    elseif max(abs(a(end:-2:1)))/f.scl < eps, % f is an odd function
        if mod(m,2) && ~mod(n,2), m = m + 1; 
        elseif ~mod(m,2) && mod(n,2), n = n - 1;
        end
    end
        
    % END DETECTDEGENERACY
%-------------------------------------------------------------------------%