function A = chebop(varargin)

pref = chebfunpref;
if pref.splitting
  warning('chebop:chebop:splitting','SPLITTING will now be turned OFF.')
end
splitting off

A.varmat = [];
A.oper = @(u) [];
A.validoper = false;
A.difforder = 0;
A.fundomain = domain([-1 1]);
A.realization = {};
A.lbc = struct([]);
A.rbc = struct([]);
A.scale = 0;

if nargin==0
elseif nargin==1 && isa(varargin{1},'chebop')
  A = varargin{1};
else
  % First argument defines the matrix part.
  if isa(varargin{1},'function_handle')
    A.varmat = varmat( varargin{1} );
  elseif isa(varargin{1},'varmat')
    A.varmat = varargin{1};
  end
  % Second argument defines the operator.
  if nargin>=2 && ~isempty(varargin{2})
    A.oper = varargin{2};
    A.validoper = true;
  end
  % Third argument supplies the function domain. 
  if nargin>=3 
    A.fundomain = varargin{3};
  end
  if nargin>=4
    A.difforder = varargin{4};
  end
end
  
superiorto('double');
A = class(A,'chebop');
end