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

% Nick H, 5/Aug/2010
% Instead of disabling, we keep track of all difforders
difford = [];
for k = 1:numel(varargin)
    difford = [difford ; varargin{k}.difforder];
end
% difford = cellfun( @(A) A.difforder, varargin, 'UniformOutput', 'false').'
% difford = 0;    % We disable differential order.

A = linop( V, op, dom, difford );

% Update the block size.
bs1 = cellfun( @(A) A.blocksize(1), varargin );
A.blocksize = [sum(bs1) bs2(1)];

end
