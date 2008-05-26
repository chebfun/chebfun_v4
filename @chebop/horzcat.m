function A = horzcat(varargin)
% HORZCAT   Horizontally concatenate chebops.

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
bs1 = cellfun( @(A) A.blocksize(1), varargin );
if any(bs1~=bs1(1))
  error('chebop:horzcat:badsize','Each block must have the same number of rows.')
end

% Domain compatability.
dom = domaincheck( varargin{:} );

% Cat the varmats.
V = cellfun( @(A) A.varmat, varargin, 'uniform',false );
V = horzcat(V{:});

% Cat the operators.
op = cellfun( @(A) A.oper, varargin, 'uniform',false );
op = horzcat( op{:} );

% We disable differential order.
difford = 0;

A = chebop( V, op, dom, difford );

% Update the block size.
bs2 = cellfun( @(A) A.blocksize(2), varargin );
A.blocksize = [bs1(1) sum(bs2)];

end
