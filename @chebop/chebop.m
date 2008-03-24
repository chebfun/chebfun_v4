function A = chebop(varargin)

pref = chebfunpref;
if pref.splitting
  warning('chebop:chebop:splitting','SPLITTING will now be turned OFF.')
end
splitting off

A.op = [];
A.rowidx = [];
A.realization = {};
A.constraint = struct([]);
A.scale = 0;

if nargin==0
elseif nargin==1 && isa(varargin{1},'chebop')
  A = varargin{1};
elseif nargin==1 && isa(varargin{1},'function_handle')
  A.op = varargin{1};
  for n = 1+2.^(1:9)
    A.realization{n} = A.op(n);
  end
end

superiorto('double');
A = class(A,'chebop');
end