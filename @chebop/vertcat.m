function A = vertcat(varargin)
% VERTCAT   Vertically concatenate chebops. 

% Copyright 2008 by Toby Driscoll.
% See www.comlab.ox.ac.uk/chebfun.

% Take out empties.
empty = cellfun( @(A) isempty(A), varargin );
varargin(empty) = [];

% Is it now trivial?
if length(varargin)==1
  A = varargin{1};
  return
end

% Size compatability.
bs2 = cellfun( @(A) A.blocksize(2), varargin );
if any(bs2~=bs2(1))
  error('chebop:vertcat:badsize','Each block must have the same number of columns.')
end

% Domain compatability.
dom = domaincheck( varargin{:} );

% Cat the varmats.
V = cellfun( @(A) A.varmat, varargin, 'uniform',false );
V = vertcat(V{:});

% Cat the operators.
op = cellfun( @(A) A.oper, varargin, 'uniform',false );
op = vertcat( op{:} );

% We disable differential order.
difford = 0;

A = chebop( V, op, dom, difford );

% Update the block size.
bs1 = cellfun( @(A) A.blocksize(1), varargin );
A.blocksize = [sum(bs1) bs2(1)];

end
