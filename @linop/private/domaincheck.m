function dom = domaincheck(varargin)

% Copyright 2008 by Toby Driscoll.
% See www.comlab.ox.ac.uk/chebfun.

% Are the intervals defined by the domains of the arguments the "same"?

% Answer the question strictly.
if nargin==0
  dom = domain;
  return
end
dom = domain(varargin{1});
for k = 2:nargin
  if ~eq(domain(varargin{k}),dom)
    error('chebop:domaincheck:nomatch','Function domains do not match.')
  end
end


% % Answer the question with a little floating point forgiveness.
% 
% int = cellfun( @(A) domain(A), varargin, 'uniform',false );
% s = substruct('()',{1});
% leftpt = cellfun( @(d) subsref(d,s), int);
% s = substruct('()',{2});
% rightpt = cellfun( @(d) subsref(d,s), int);
% 
% hscl = max( rightpt-leftpt );
% minleft = min(leftpt);  maxleft = max(leftpt);
% minright = min(rightpt);  maxright = max(rightpt);
% 
% if all( hscl*[maxleft-minleft maxright-minright] < 10*eps )
%   dom = domain( [minleft, maxright] );
% else
%   error('chebop:domaincheck:nomatch','Function domains do not match.')
% end

end
