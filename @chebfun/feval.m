function fx = feval(f,x)
% FEVAL Evaluate at point(s)
% FEVAL(F,X) evaluates the chebfun F at the point(s) in X.
%
% See also CHEBFUN/SUBSREF.

% Toby Driscoll, 6 February 2008.

% For now this is a shell around a subsref call. 

fx = subsref(f,struct('type','()','subs',{{x}}));