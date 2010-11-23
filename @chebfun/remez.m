function [p,err,xk] = remez(f,n) 
% Best polynomial approximation.
%
% P = REMEZ(F,N) computes the chebfun of the best polynomial approximation
% of degree N of a chebfun F defined in [a,b]. It uses the barycentric
% Remez algorithm (see Pachon and Trefethen, "Barycentric-Remez algorithms
% for best polynomial approximation in the chebfun system", BIT Numerical
% Mathematics 49 (2009), 721-741).
%
% [P,ERR] = REMEZ(F,N) also returns the maximum error ERR.    
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

%  Copyright 2002-2009 by The Chebfun Team. 
%  Last commit: $Author$: $Rev$:
%  $Date$:

if numel(f) > 1, error('CHEBFUN:remez:quasi',...
        'Remez does not currently support quasimatrices'); end

if any(get(f,'exps')<0), error('CHEBFUN:remez:inf',...
        'Remez does not currently support functions which diverge to infinity'); end

spl_ini = chebfunpref('splitting');
splitting off,

if n < 15, tol = 1e-14; elseif n < 100, tol = 1e-14; elseif n <= 1000, tol = 1e-11; else tol = 2e-10; end
maxit = 25; 
[a,b] = domain(f);
xk = chebpts(n+2,[a b]);                % initial reference 
xo = xk;
sigma = ones(n+2,1); 
sigma(2:2:end) = -1;                    % alternating signs
normf = norm(f);
delta = 1;
it = 1;
deltamin = delta;
while (delta/normf > tol) && it <=maxit
    fk = feval(f,xk);
    w = bary_weights(xk);
    h = (w'*fk)/(w'*sigma);             % levelled reference error  
    if h==0, h = 1e-19; end             % perturb error if necessary
    pk = fk - h*sigma;                  % polynomial vals in the reference         
    p=chebfun(@(x)bary(x,pk,xk,w),[a b], n+1); % chebfun of trial polynomial
    e = f - p;                          % chebfun of the error    
    [xk,err] = exchange(xk,e,h,2);      % replace reference    
    if err/normf > 1e5                  % if overshoot, recompute with one-
        [xk,err] = exchange(xo,e,h,1);  % point exchange
    end
    xo = xk;
    delta = err - abs(h);               % stopping value 
    if delta<deltamin, 
        deltamin = delta; 
        pmin = p; 
        errmin = err;
        xkmin = xk;
    end
    %[num2str(delta/normf,'%5.15f') ' ' num2str(h,'%5.15f')]       % uncomment to see progress
    it = it+1;
end
p = pmin;
err = errmin;
xk = xkmin;
chebfunpref('splitting',spl_ini), 

function [xk,norme] = exchange(xk,e,h,method)

rr = [a; roots(diff(e)); b];                 % critical pts of the error
if method == 1                               % one-point exchange
    [tmp,pos] = max(abs(feval(e,rr))); pos = pos(1);
else                                         % full exchange                  
    pos = find(abs(feval(e,rr))>=abs(h));    % vals above leveled error
end
[r,m] = sort([rr(pos); xk]);   
v = ones(length(xk),1); v(2:2:end) = -1;
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
d = max(idx-length(xk)+1,1);                 % that include max of error
xk = s(d:d+length(xk)-1);
end
end

