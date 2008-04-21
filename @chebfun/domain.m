function varargout = domain(f)
% DOMAIN Domain of definition
%
% I = DOMAIN(F) returns the domain of definition of the chebfun F. This
% includes breakpoint information.
% 
% [A,B] = DOMAIN(F) returns the endpoints of the domain.
%
% See also domain/domain.

%  Chebfun Version 2.0

if isempty(f)
  varargout = domain;
elseif(nargout<=1)
  varargout{1} = domain(f.ends);
else
  varargout{1} = f.ends(1);
  varargout{2} = f.ends(end);
end
