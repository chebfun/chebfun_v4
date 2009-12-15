function A = vertcat(varargin)
% VERTCAT   Vertically concatenate linops. 

% See http://www.maths.ox.ac.uk/chebfun.

% Copyright 2008 by Toby Driscoll.
%  Last commit: $Author$: $Rev$:
%  $Date$:

% Take out empties.
empty = cellfun( @isempty, varargin );
varargin(empty) = [];

% Is it now trivial?
if length(varargin)==1
  A = varargin{1};
  return
end

% Size compatability.
bs2 = cellfun( @(A) A.blocksize(2), varargin );
if any(bs2~=bs2(1))
  error('LINOP:vertcat:badsize','Each block must have the same number of columns.')
end

% Domain compatability.
dom = domaincheck( varargin{:} );

% Cat the varmats.
V = cellfun( @(A) A.varmat, varargin, 'uniform',false );
V = vertcat(V{:});

% Cat the operators.
op = cellfun( @(A) A.oparray, varargin, 'uniform',false );
op = vertcat( op{:} );

% We disable differential order.
difford = 0;

A = linop( V, op, dom, difford );

% Update the block size.
bs1 = cellfun( @(A) A.blocksize(1), varargin );
A.blocksize = [sum(bs1) bs2(1)];

end
