function d = times(d,a)
% .*      Scale a domain.
% A*D or D*A for domain D and scalar A multiplies all the endpoints and
% breakpoints of D by A. If A is negative, the ordering of the points is
% then reversed.
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2008 by The Chebfun Team. 

% Swap if needed to make D the domain.
if isnumeric(d)
  t=a; a=d; d=t;
end

if ~isnumeric(a) || numel(a)~=1 || a==0 || ~isreal(a)
  error('domain:times:badoperand',...
    'Only nonzero real scalars can multiply domains.')
end

d.ends = d.ends*a;
if a<0
  d.ends = d.ends(end:-1:1);
end

end

  