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
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2009 by The Chebfun Team. 

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
  error('CHEBFUN:restrict:badinterval','Given interval is not in the domain.')
end

if subint(2)==subint(1)
  % Easiest to dispose of this case separately.
  val = feval(f,subint(1));
  g.funs = fun( val , subint) ;
  g.nfuns = 1;
  g.ends = subint;
  g.imps = [ val val ];
  return                                         % empty result
end

% We now know dom(1)<=subint(1)<subint(2)<=dom(2).
j = find( f.ends > subint(1), 1, 'first' ) -1 ;
k = find( f.ends >= subint(2), 1, 'first' ) - 1;

% Prune data.
g.funs = f.funs(j:k);
g.ends = [subint(1) f.ends(j+1:k) subint(2)];
g.nfuns = k-j+1;
g.imps = f.imps(:,j:k+1);
for l = 0:g.nfuns-1
    g.funs(l+1).exps = f.funs(j+l).exps;
end

% Trim off the end funs.
if j==k
  g.funs = [restrict(g.funs(1),subint) g.funs(2:end)];       % only one left 
else
  g.funs = [restrict(g.funs(1),g.ends(1:2)) g.funs(2:end)];         
  g.funs = [g.funs(1:end-1) restrict(g.funs(end),g.ends(end-1:end))];
end

% Bug fix (18/12/08) RodP: correct imps matrix at endpoints: 
% Note: deltas at new endpoints will be lost!
%         (10/09/09) NicH: Must adjust also for infs and exps.
imp1 = g.funs(1).vals(1);
if g.funs(1).exps(1)
    imp1 = inf;
elseif g.funs(1).exps(2)
    imp1 = imp1.*diff(g.funs(1).map.par(1:2)).^g.funs(1).exps(2);
end
g.imps(:,1) = [imp1 ; zeros(size(g.imps,1)-1,1)];

imp2 = g.funs(end).vals(end);
if g.funs(end).exps(2)
    imp2 = inf;
elseif g.funs(end).exps(1)
    imp2 = imp2.*diff(g.funs(end).map.par(1:2)).^g.funs(end).exps(1);
end
g.imps(:,end) = [imp2 ; 
                 zeros(size(g.imps,1)-1,1)];



