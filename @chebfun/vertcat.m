function f = vertcat(varargin)
% VERTCAT Concatenate chebfuns into a single chebfun.
%
% F = VERTCAT(F1,F2,...) concatenates any number of chebfuns by translating
% their domains to, in effect, create a piecewise defined chebfun F.
%
% See also CHEBFUN/HORZCAT, CHEBFUN/SUBSASGN.

% Toby Driscoll, 21 February 2008.

if nargin==0
  f = chebfun;
  return
end

f = varargin{1};
for k = 2:nargin
  newf = varargin{k};
  delta = f.ends(end) - newf.ends(1);
  f.ends = [ f.ends delta+newf.ends(2:end) ];
  f.funs = { f.funs{:}, newf.funs{:} }';
  f.imps = [ f.imps newf.imps(2:end) ];
end
f.nfuns = length(f.funs);
