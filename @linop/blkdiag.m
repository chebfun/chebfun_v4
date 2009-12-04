function B = blkdiag(varargin)
% BLKDIAG Block chebop.
% B = BLKDIAG(A1,A2,...,Am), where each Aj is a chebop on a common domain,
% produces
%
%           [ A1  0 ... 0  ]
%     B =   [  0 A2 ... 0  ]
%           [       ...    ]
%           [  0  0 ... Am ]
%
% B = BLKDIAG(A,M) produces a block diagonal chebop with M copies of A on
% the diagonal.
%
% See also blkdiag.

% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.
% Copyright 2009 by Toby Driscoll.
% $Id$

% If given (A,m) as arguments, replace with {A,A,...,A}.
if nargin==2 && isnumeric(varargin{2})
  varargin = repmat(varargin(1),[1,varargin{2}]);
end

m = length(varargin);
dom = domaincheck(varargin{:});
Z = zeros(dom);  
B = chebop([],[],dom,0);

% Build B one row at a time.
for i = 1:m  
  % Build the row one column at a time.
  row = chebop([],[],dom,0);
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
