function [p,err,xk] = remez(f,n); 
% Best polynomial approximation.
%
% P = REMEZ(F,N) computes the chebfun of the best polynomial approximation
% of degree N of a chebfun F defined in [a b]. It uses the barycentri-
% Remez algorithm (see "Barycentric-Remez algorithms for best polynomial 
% approximation in the chebfun system" by Pachon and Trefethen, 2008). 
%
% [P,ERR] = REMEZ(F,N) also returns the maximum error ERR.    
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2009 by The Chebfun Team. 

if n < 15, tol = 1e-14; elseif n < 100, tol = 1e-12; else tol = 1e-10; end
[a,b] = domain(f);
xk = cos(pi*(n+1:-1:0)'/(n+1));         % initial reference 
xk = (b*(xk+1)-a*(xk-1))/2;
xo = xk;
sigma = (-1).^[0:n+1]';                 % alternating signs
normf = norm(f);
delta = 1;
while delta/normf > tol  
    fk = feval(f,xk);
    w = bary_weights(xk);
    h = (w'*fk)/(w'*sigma);             % levelled reference error  
    if h==0, h = 1e-19; end             % perturb error if necessary
    pk = fk - h*sigma;                  % polynomial vals in the reference         
    p=chebfun(@(x)bary_general(x,xk,pk,w),[a b], n+1); % chebfun of trial polynomial
    e = f - p;                          % chebfun of the error    
    [xk,err] = exchange(xk,e,h,2);      % replace reference    
    if err/normf > 1e5                  % if overshoot, recompute with one-
        [xk,err] = exchange(xo,e,h,1);  % point exchange
    end
    xo = xk;
    delta = err - abs(h);               % stopping value 
    %delta                              % uncomment to see progress
end
    
function [xk,norme] = exchange(xk,e,h,method)

rr = [a; roots(diff(e)); b];             % critical pts of the error
if method == 1                            % one-point exchange
    [tmp,pos] = max(abs(feval(e,rr))); pos = pos(1);
else                                      % full exchange                  
    pos = find(abs(feval(e,rr))>=abs(h)); % vals above leveled error
end
[r,m] = sort([rr(pos); xk]);   
er = [feval(e,rr(pos));(-1).^(0:length(xk)-1)'*h];
er = er(m);                             
s = r(1); es = er(1);                     % pts and vals to be kept
for i = 2:length(r)
  if sign(er(i)) == sign(es(end)) &...    % from adjacent pts w/ same sign 
          abs(er(i))>abs(es(end))         % keep the one w/ largest val
      s(end) = r(i); es(end) = er(i);
  elseif sign(er(i)) ~= sign(es(end))     % if sign changes, concatenate
      s = [s; r(i)]; es = [es; er(i)];    % pts and vals
  end            
end
[norme,idx] = max(abs(es));               % choose n+2 consecutive pts
d = max(idx-length(xk)+1,1);              % that include max of error
xk = s(d:d+length(xk)-1);
end
end

