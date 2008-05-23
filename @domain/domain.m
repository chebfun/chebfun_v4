function d = domain(varargin)
% DOMAIN  Domain object constructor.
% D = DOMAIN(A,B) or DOMAIN([A,B]) creates a domain object for the
% real interval [A,B].
%
% D = DOMAIN(V) for vector V of length at least 2 creates a domain for the
% interval [V(1),V(end)] with breakpoints at V(2:end-1).

% Copyright 2002-2008 by The Chebfun Team. See www.comlab.ox.ac.uk/chebfun.

if nargin==0
  v = [];
elseif nargin==1
  v = varargin{1};
else
  v = cat(2,varargin{:});
end

if (length(v)>1) && (v(end) < v(1))   % empty interval
  v = [];
end

d.ends = v;

superiorto('double');
d = class(d,'domain');