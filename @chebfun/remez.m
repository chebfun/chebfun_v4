function [p,err] = remez(f,n); 
% Best polynomial approximation.
%
% P = REMEZ(F,N) computes the chebfun of the best polynomial approximation
% of degree N of a chebfun F defined in [-1,1]. It uses the barycentri-
% Remez algorithm (see "Barycentric-Remez algorithms for best polynomial 
% approximation in the chebfun system" by Pachon and Trefethen, 2008). 
%
% [P,ERR] = REMEZ(F,N) also returns the maximum error ERR.    

% Copyright 2002-2008 by The Chebfun Team. See www.comlab.ox.ac.uk/chebfun.

xk = cos(pi*(n+1:-1:0)'/(n+1));        % initial reference 
xo = xk;
sigma = (-1).^[0:n+1]';                % alternating signs
normf = norm(f);
delta = 1;
while delta/normf > 1e-13    
    fk = feval(f,xk);
    w = bary_weights(xk);
    h = (w'*fk)/(w'*sigma);             % levelled reference error              
    pk = fk - h*sigma;                  % polynomial vals in the reference         
    p=chebfun(@(x)bary(x,xk,pk,w),n+1); % chebfun of trial polynomial
    e = f - p;                          % chebfun of the error
    [xk,err] = exchange(xk,e,h,2);      % replace reference    
    if err/normf > 10^5                 % if overshoot, recompute with one-
        [xk,err] = exchange(xo,e,h,1);  % point exchange
    end
    xo = xk;
    delta = err - abs(h);               % stopping value 
    %delta                              % uncomment to see progress
end


    
function [xk,norme] = exchange(xk,e,h,method)

rr = [-1; roots(diff(e)); 1];             % critical pts of the error
if method == 1                            % one-point exchange
    [tmp,pos] = max(abs(feval(e,rr))); pos = pos(1);
else                                      % full exchange                  
    pos = find(abs(feval(e,rr))>=abs(h));       % vals above leveled error
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



function p = bary(x,xk,pk,w)               % barycentric interpolation
p = zeros(size(x));
numer = p; denom = p; exact = p;
I = true(size(x));                         % x(i)=false if x(i)=xk(j), some j
for j = 1:length(xk)
  xdiff = x-xk(j);
  ii = find(xdiff==0);
  exact(ii) = j;
  I(ii) = false;
  tmp = w(j)./xdiff(I);
  numer(I) = numer(I) + tmp*pk(j);
  denom(I) = denom(I) + tmp;
end
p(~I) = pk(exact(~I));
p(I) = numer(I)./denom(I);


function w = bary_weights(xk)

n = length(xk);
w = ones(n,1);
for i = 1:n
    v = 2*(xk(i)-xk);
    vv = exp(sum(log(abs(v(find(v))))));    
    w(i) = 1./(prod(sign(v(find(v))))*vv);
end