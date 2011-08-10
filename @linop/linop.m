function A = linop(varargin)
% LINOP  Linear chebop operator constructor.
% LINOP(F), where F is a function of one argument N that returns an NxN
% matrix, returns a linop object whose NxN finite realization is defined
% by F.
%
% LINOP(F,L), where L is a function that can be applied to a chebfun,
% defines an infinite-dimensional representation of the linop as well. L
% may be empty.
%
% LINOP(F,L,D) specifies the domain D on which chebfuns are to be defined
% for this operator. If omitted, it defaults to [-1,1].
%
% LINOP(F,L,D,M) also defines a nonzero differential order for the
% operator.
%
% Normally one does not call LINOP directly. Instead, use one of the
% five first functions in the see-also line.
%
% See also domain/eye, domain/diff, domain/cumsum, chebfun/diag,
% domain/zeros.

% Copyright 2011 by The University of Oxford and The Chebfun Developers. 
% See http://www.maths.ox.ac.uk/chebfun/ for Chebfun information.

% Default properties.
A.varmat = [];
A.oparray = oparray;     % inf-dim representation
A.difforder = 0;
A.iszero = 0;
A.isdiag = 0;
A.fundomain = domain(chebfunpref('domain'));
A.lbc = struct([]);
A.rbc = struct([]);
A.numbc = 0;
A.scale = 0;
A.blocksize = [0 0];  % for block linops
A.ID = newIDnum();    % for storage of realizations/factorizations

if nargin==0
elseif nargin==1 && isa(varargin{1},'linop')
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
    A.oparray = oparray(varargin{2});
  end
  % Third argument supplies the function domain. 
  if nargin>=3 
    d = domain( [varargin{3}] );
    A.fundomain = d;
  end
  % 4th argument is differential order
  if nargin>=4
    A.difforder = varargin{4};
  end
  A.blocksize = [1 1];
end
  
superiorto('double');
nonlin = chebop(A.fundomain);
A = class(A,'linop',nonlin);
end