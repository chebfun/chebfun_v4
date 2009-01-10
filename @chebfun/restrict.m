function Fout = restrict(F,subdom)
% RESTRICT   Restrict a chebfun to a subinterval.
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

% Copyright 2002-2008 by The Chebfun Team. See www.comlab.ox.ac.uk/chebfun.

% Deal with quasi-matrices
Fout = F;
for k = 1:numel(F)
    Fout(k) = restrictcol(F(k),subdom);
end

%----------------------------------------------
% Deal with single column
function g = restrictcol(f,subdom)

if isa(subdom,'domain')
  subint = subdom.ends;
else
  subint = subdom;
end

if subint(1)>subint(2)
   g = chebfun;
  return                                         % empty result
end

g = f;

dom = domain(f);
if (subint(1)<dom(1)) || (subint(2)>dom(2))
  error('chebfun:restrict:badinterval','Given interval is not in the domain.')
end

if subint(2)==subint(1)
  % Easiest to dispose of this case separately.
  [a,j] = rescale(subint(1),f.ends);             % locn of new 'domain'
  val = feval(f.funs(j),a);
  g.funs = fun( val ) ;
  g.nfuns = 1;
  g.ends = subint;
  g.imps = [ val val ];
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
g.imps = f.imps(:,j:k+1);

% Trim off the end funs.
if j==k
  g.funs = [restrict(g.funs(1),[a b]) g.funs(2:end)];       % only one left
else
  g.funs = [restrict(g.funs(1),[a 1]) g.funs(2:end)];         
  g.funs = [g.funs(1:end-1) restrict(g.funs(end),[-1 b])];
end

% Bug fix (18/12/08) RodP: correct imps matrix at endpoints: 
% Note: deltas at new end poits will be lost!
g.imps(:,1) = [g.funs(1).vals(1); zeros(size(g.imps,1)-1,1)];
g.imps(:,end) = [g.funs(end).vals(end); zeros(size(g.imps,1)-1,1)];


