function [d,x,N] = domain(varargin)
% DOMAIN  Domain object constructor.
% D = DOMAIN(A,B) or DOMAIN([A,B]) creates a domain object for the
% real interval [A,B].
%
% D = DOMAIN(V) for vector V of length at least 2 creates a domain for the
% interval [V(1),V(end)] with breakpoints at V(2:end-1).
%
% [D,X] = DOMAIN(...) also returns the 'identity chebfun', the
% result of CHEBFUN('x',D).
%
% [D,X,N] = DOMAIN(...) also returns a nonlinop N on D, whose
% fields can then be filled by N.op = ..., N.lbc = ..., etc.
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2008 by The Chebfun Team. 

if nargin==0
  v = [];
elseif nargin==1
  v = varargin{1};
  if isa(v,'domain'); v = v.ends; end
else
  v = cat(2,varargin{:});
end

if (length(v)>1) && (v(end) < v(1))   % empty interval
  v = [];
end

d.ends = v;

superiorto('double');
d = class(d,'domain');

if nargout == 2
  x = chebfun(@(x) x,d);
end

if nargout == 3
  x = chebfun(@(x) x,d);
  N = chebop(d);
end

end
