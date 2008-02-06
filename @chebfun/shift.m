function g = shift(f,a)
% SHIFT Shift operation
% G = SHIFT(F,A) returns a chebfun G with the same domain as the chebfun F.
% The values of G are given by G(X)=F(X-A), when X-A is in the domain of F,
% and the appropriate boundary value of F when X-A lies outside the domain
% of F.

% Toby Driscoll, 6 February 2008.

% There's a chance that f is so smooth at its boundary that a global fun
% would do. But it's a much better bet that we should use a piecewise
% definition.

dom = domain(f);
fun = f.funs;
if a>0                             % shift right, use left boundary val
  fv = fun{1}.val;
  g = chebfun( fv(end), @(x) feval(f,x-a), [dom(1) dom(1)+a dom(2)] );
elseif a<0                         % shift left, use right boundary val
  fv = fun{end}.val;
  g = chebfun( @(x) feval(f,x-a), fv(1), [dom(1) dom(2)+a dom(2)] );
else
  g = f;
end
