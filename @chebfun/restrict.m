function g = restrict(f,subdom)

% RESTRICT Restrict a chebfun to a subinterval.
% 
% G = RESTRICT(F,S) returns a chebfun G whose domain is S and
% which agrees (to roundoff precision) with F on that interval. S may be
% specified as the vector [A,B] or using a DOMAIN.
%
% If A==B, the result is a chebfun with a point domain. If A>B,
% the result is an empty chebfun.
%
% An equivalent syntax is G = F{A,B}.
%
% See also CHEBFUN/SUBSREF, CHEBFUN/DEFINE.

% Toby Driscoll, 9 February 2008

if isa(subdom,'domain')
  subint = subdom(:);
else
  subint = subdom;
end

g = chebfun;
if subint(1)>subint(2)
  return                                         % empty result
end

dom = domain(f);
if (subint(1)<dom(1)) || (subint(2)>dom(2))
  error('chebfun:restrict:badinterval','Given interval is not in the domain.')
end

if subint(2)==subint(1)
  % Easiest to dispose of this case separately.
  [a,j] = rescale(subint(1),f.ends);             % locn of new 'domain'
  g.funs = { fun( f.funs{j}(a) ) };
  g.nfuns = 1;
  g.ends = subint;
  g.imps = [0 0];
  return                                         % empty result
end

% We now know dom(1)<=subint(1)<subint(2)<=dom(2).
[a,j] = rescale(subint(1),f.ends);               % locn of new left endpt
[b,k] = rescale(subint(2),f.ends);               % locn of new right endpt

% If we hit a breakpoint exactly, get at it from the left, not the right.
if b==-1                                         
  b = 1;  k = k-1;                               
end

% Prune data.
g.funs = f.funs(j:k);
g.ends = [subint(1) f.ends(j+1:k) subint(2)];
g.nfuns = k-j+1;
g.imps = [0 f.imps(j+1:k) 0];                    % assumes no imps at ends!

% Trim off the end funs.
if j==k
  g.funs{1} = restrict(g.funs{1},[a b]);         % only one left
else
  g.funs{1} = restrict(g.funs{1},[a 1]);         
  g.funs{end} = restrict(g.funs{end},[-1 b]);
end
