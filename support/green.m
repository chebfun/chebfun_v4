function g = green(y,a)

% Return chebfun Green function on [-1,1] corresponding to the
% equation  g" - a^2*g = delta(x-y) with zero BCs.
% Thus on [-1,y] and [y,1] we have respectively
%
%   C*sinh(a*(x+1)),  D*sinh(a*(x-1))
%
% Continuity at x=y is the condition
%
%   C*sinh(a*(y+1)) - D*sinh(a*(y-1)) = 0
%
% whereas differentiating tells us that the
% delta function condition is
%
%   -C*a*cosh(a*(x+1)) + D*cosh(a*(x-1)) = 1.
%
% We solve this 2x2 system numerically below.

 x = chebfun('x');
 left = -sinh(a*(x+1));
 right = sinh(a*(x-1));
 dleft = diff(left);
 dright = diff(right);
 A = [left(y)  -right(y);
      dleft(y) -dright(y)];
 c = A\[0;-1];
 length(c(1)*left)
 length(c(2)*right)
 g = max(c(1)*left,c(2)*right);
 struct(g)