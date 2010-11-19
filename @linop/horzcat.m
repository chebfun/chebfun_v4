function A = horzcat(varargin)
% HORZCAT   Horizontally concatenate linops.

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
bs1 = cellfun( @(A) A.blocksize(1), varargin );
if any(bs1~=bs1(1))
  error('LINOP:horzcat:badsize','Each block must have the same number of rows.')
end

% Domain compatability.
dom = domaincheck( varargin{:} );

% Cat the varmats.
V = cellfun( @(A) A.varmat, varargin, 'uniform',false );
V = horzcat(V{:});

% Cat the operators.
op = cellfun( @(A) A.oparray, varargin, 'uniform',false );
op = horzcat( op{:} );

% Nick H, 5/Aug/2010
% Instead of disabling, we keep track of all difforders
difford = []; isz = [];
for k = 1:numel(varargin)
    difford = [difford varargin{k}.difforder];
    isz = [isz varargin{k}.iszero];
end
A = linop( V, op, dom, difford );

% Update the block size.
bs2 = cellfun( @(A) A.blocksize(2), varargin );
A.blocksize = [bs1(1) sum(bs2)];

% Update iszero.
A.iszero = isz;

end
