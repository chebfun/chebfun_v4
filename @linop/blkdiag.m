function B = blkdiag(varargin)
% BLKDIAG Block linop.
% B = BLKDIAG(A1,A2,...,Am), where each Aj is a linop on a common domain,
% produces
%
%           [ A1  0 ... 0  ]
%     B =   [  0 A2 ... 0  ]
%           [       ...    ]
%           [  0  0 ... Am ]
%
% B = BLKDIAG(A,M) produces a block diagonal linop with M copies of A on
% the diagonal.
%
% See also blkdiag.
% See http://www.maths.ox.ac.uk/chebfun.

% Copyright 2009 by Toby Driscoll.

%  Last commit: $Author$: $Rev$:
%  $Date$:

% If given (A,m) as arguments, replace with {A,A,...,A}.
if nargin==2 && isnumeric(varargin{2})
  varargin = repmat(varargin(1),[1,varargin{2}]);
end

m = length(varargin);
dom = domaincheck(varargin{:});
Z = zeros(dom);  
B = linop([],[],dom,0);

% Build B one row at a time.
for i = 1:m  
  % Build the row one column at a time.
  row = linop([],[],dom,0);
  for j = 1:i-1
    row = [row Z];
  end
  row = [row varargin{i}];  % content on diagonal
  for j = i+1:m
    row = [ row Z ];
  end
  B = [B; row];   % insert the row
end

end
