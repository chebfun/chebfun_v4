function f = define(f,subint,g)

% DEFINE Supply a new definition for a chebfun on an interval.
%
% F = DEFINE(F,[A B],G) uses the chebfun G to define the chebfun F in the
% interval [A,B]. 
% 
% DEFINE supports expansion/compression: the domain of G is scaled and
% translated to coincide with [A,B]. If G is a scalar numerical value, it
% is expanded into a constant function on [A,B].
%
% If G is nonempty and the domain of F is [C,D], the domain will become
% [min(A,C),max(B,D)]. At any X that is not in [A,B]U[C,D], the new F(X)=0.
%
% If G is an empty chebfun or empty matrix, the corresponding part of the 
% domain of F is deleted. If C<A<B<D, then the gap in the domain that would
% result is filled by translating [B,D] to the left by B-A units. The new
% domain is then [C,D-B+A]. If A<C or B>D, then [A,B] is removed from the
% domain, leaving a single (possibly empty) interval.
%
% An equivalent syntax is F{A,B} = G.
%
% See also CHEBFUN/SUBSASGN, CHEBFUN/RESTRICT.
%
% EXAMPLES
%
%   Sawtooth function:
%     x = chebfun('x'); s = chebfun; for j=-7:2:5, s{j,j+2}=x; end
%
%   Scalar expansion:
%     p = primes(200); f = chebfun;
%     for j = 1:length(p)-1, f{p(j),p(j+1)} = j; end
%    
%   Domain compression:
%     s = chebfun('(3*x+1).*x/4'); f = chebfun;
%     for n=0:8, f{2^(-n-1),1/2^n} = s/2^n; end
%
%   Deletion:
%     f = chebfun('abs(x)'); f{-1/2,1/2} = [];

% Toby Driscoll, 9 February 2008.

%% No change for interval [a,b] with a>b.
if subint(1)>subint(2)    
  return
  % flip
  %g = flipud(g);
  %subint = subint([2 1]);
end


%% Convert a scalar or empty input to a chebfun.
if isnumeric(g) 
  if numel(g)==1
    g = chebfun(g);
  elseif numel(g)==0
    g = chebfun;
  else
    error('chebfun:define:badassign',...
      'Must assign to a chebfun, scalar, or empty matrix.')
  end
end

%% Transform the domain of g as needed.
if ~isempty(g)                                   % translate
  g.ends = subint(1) + (g.ends-g.ends(1))*diff(subint)/diff(domain(g));
end

%% Trivial return case.
if isempty(f)
  f = g;
  return
end

%% The hard work.
domf = domain(f);
if ~isempty(g)                                   % INSERTION/OVERWRITING
  if subint(2) < domf(1)                       % extension to the left
    f.ends = [ g.ends f.ends ];
    f.funs = { g.funs{:} fun(0) f.funs{:} }';
    f.imps = [ g.imps f.imps ];
  elseif subint(1) > domf(2)                   % extension to the right
    f.ends = [ f.ends g.ends ];
    f.funs = { f.funs{:} fun(0) g.funs{:} }';
    f.imps = [ f.imps g.imps ];
  else                                         % subint intersects domf
    fleft = chebfun; fright = chebfun;
    % The following ifs are for checking the equality cases, since then you
    % get annoying functions defined at just one point. If the restriction
    % operation changes to make that empty, these if tests can disappear.
    if domf(1) < subint(1)
      fleft = restrict(f,[domf(1) subint(1)]);
     end
    if domf(2) > subint(2)
      fright = restrict(f,[subint(2) domf(2)]);
    end
    f.funs = { fleft.funs{:} g.funs{:} fright.funs{:} }';
    f.ends = [ fleft.ends(1:end-1) g.ends fright.ends(2:end) ];
    f.imps = [ fleft.imps(1:end-1) g.imps fright.imps(2:end) ];
  end
else                                             % DELETION
  if subint(2) < domf(1) || subint(1) > domf(2)
    error('chebfun:define:badremoveinterval',...
      'Interval to be removed is outside the domain.')
  else
    fleft = restrict(f,[domf(1) subint(1)]);
    fright = restrict(f,[subint(2) domf(2)]);
    if isempty(fright), f = fleft;
    elseif isempty(fleft), f = fright;
    else
      % Deletion strictly inside the domain--slide the right side over.
      f.funs = { fleft.funs{:} fright.funs{:} }';
      f.ends = [ fleft.ends(1:end-1) fright.ends-fright.ends(1)+fleft.ends(end) ];
      f.imps = [ fleft.imps(1:end-1) fright.imps ];
    end
  end
end

f.nfuns = length(f.funs);
