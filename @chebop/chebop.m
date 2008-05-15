function A = chebop(varargin)
% CHEBOP  Chebop operator object constructor.
% CHEBOP(F), where F is a function of one argument N that returns an NxN
% matrix, returns a chebop object whose NxN finite realization is defined
% by F.
%
% CHEBOP(F,L), where L is a function that can be applied to a chebfun,
% defines an infinite-dimensional representation of the chebop as well. L
% may be empty.
%
% CHEBOP(F,L,D) specifies the domain D on which chebfuns are to be defined
% for this operator. If omitted, it defaults to [-1,1].
%
% CHEBOP(F,L,D,M) also defines a nonzero differential order for the
% operator.

% Toby Driscoll, 12 May 2008.
% Copyright 2008.

pref = chebfunpref;
if pref.splitting
  warning('chebop:chebop:splitting','SPLITTING will now be turned OFF.')
end
splitting off

% Default properties.
A.varmat = [];
A.oper = @(u) [];     % inf-dim representation
A.validoper = false;  % true if inf-dim representation is given
A.difforder = 0;
A.fundomain = domain([-1 1]);
A.realization = {};   % for future
A.lbc = struct([]);
A.rbc = struct([]);
A.numbc = 0;
A.scale = 0;
A.blocksize = [0 0];  % experimental, for block chebops
A.ID = newIDnum();    % for storage of realizations/factorizations

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
  A.blocksize = [1 1];
end
  
superiorto('double');
A = class(A,'chebop');
end