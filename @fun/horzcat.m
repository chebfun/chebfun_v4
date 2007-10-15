function out = horzcat(varargin)
% HORZCAT	Horizontal concatenation
% [F G] or [F,G] is the horizontal concatenation of funs F and G.  Scalars
% can also be concatenated with funs.

% Copyright 2003 Zachary Battles, Chebfun Version 1.0
if (~isa(varargin{1},'double') & varargin{1}.trans & length(varargin)>1)
  error('Cannot concatenate different types of funs.');
end
fmax=-1;
for i=1:nargin
  if (isa(varargin{i},'double'))
    varargin{i}=varargin{i}*fun('1');
  end
  if (varargin{i}.n>fmax) fmax=varargin{i}.n; end
end
if (~isempty(varargin{1}))
  out = prolong(varargin{1},fmax);
else
  out=fun;
end
out.n=fmax;
for i=2:nargin
  if (varargin{i}.trans), error('Cannot concatenate different types of funs.'); end
  if (~isempty(varargin{i}))
    temp = prolong(varargin{i},fmax);
  else
    temp=fun;
  end
  out.val = [out.val temp.val];
end
