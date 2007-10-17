function finv = invfun(varargin)
%INVFUN  Functional inverse of a chebfun.
%
%   FINV = INVFUN(F) returns a chebfun that is the functional inverse of
%   the chebfun F; that is, F composed with FINV in either order is the
%   identity map.
%
%   FINV = INVFUN(F,DOMAIN) accepts a function handle F and its domain in
%   the form of a 2-component vector. DOMAIN becomes the range of FINV.
%
%   An error is thrown if F is found not to be one-to-one.
%
%   Example (Lambert W function):
%     W = invfun( @(x) x.*exp(x), [1 4] );

%   Toby Driscoll, 20 Jan 2007.

if nargin==2
 f = chebfun(varargin{:});
else
 f = varargin{1};
end
% Find the domain of f.
intvl = get(f,'ends');
m = min(f);  m = m*(1+sign(m)*1e-12);   % shrink the range a bit...
M = max(f);  M = M*(1-sign(M)*1e-12);   % ...to improve robustness
finv = chebfun(@evalfi,[min(f) max(f)]);
   function y = evalfi(x)

   y = zeros(size(x));
   y([end 1]) = intvl([1 end]);  % endpoints map to endpoints
   for j = 2:length(x)-1
       t = roots(f-x(j));
       if length(t) > 1
           error('Given function is not one-to-one')
       end
       y(j) = t;
   end
   end  % evalfi

end  % invfun


