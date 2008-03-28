function f = flipud(f)
% FLIPUD Flip/reverse a chebfun.
%
% G = FLIPUD(F) returns a chebfun G with the same domain as F but reversed;
% that is, G(x)=F(a+b-x), where the domain is [a,b].

% Toby Driscoll, 7 February 2008.

% Reverse the order of funs, and the funs themselves.
f.funs = cellfun( @flipud, flipud(f.funs), 'uniform',false );
% Reverse and translate the breakpoints.
domf = domain(f);
f.ends = -fliplr(f.ends) + sum(domf(:));
f.imps = fliplr(f.imps);
