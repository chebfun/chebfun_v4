function A = vertcat(varargin)
% VERTCAT   Vertically concatenate linops. 

% Copyright 2011 by The University of Oxford and The Chebfun Developers. 
% See http://www.maths.ox.ac.uk/chebfun/ for Chebfun information.

% Take out empties.
empty = cellfun( @isempty, varargin );
varargin(empty) = [];

% Is it now trivial?
if length(varargin)==1
  A = varargin{1};
  return
end

% Reassign numeric inputs to linops
isnum = cellfun( @isnumeric, varargin );
if any(isnum)
    d = domain(varargin{find(~isnum,1)});
    Z = zeros(d); I = eye(d);
    idx = find(isnum);
    for k = 1:numel(idx)
        vi = varargin{idx(k)};
        tmp = [];
        for j = 1:numel(vi)
            if vi == 0
                tmp = [tmp Z];
            else
                tmp = [tmp vi(j)*I];
            end
        end      
        varargin{idx(k)} = tmp;
    end
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

% Keep track of difforders, zeros, and diags
difford = []; isz = []; isd = [];
for k = 1:numel(varargin)
    difford = [difford ; varargin{k}.difforder];
    isz = [isz ; varargin{k}.iszero];
    isd = [isd ; varargin{k}.isdiag];
end

A = linop( V, op, dom, difford );

% Update the block size.
bs1 = cellfun( @(A) A.blocksize(1), varargin );
A.blocksize = [sum(bs1) bs2(1)];


% Update iszero and isdiag.
A.iszero = isz;
A.isdiag = isd;

end
