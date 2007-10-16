function varargout = domain(f)
% DOMAIN Interval of definition
%
% I = DOMAIN(F) returns the vector I such that the chebfun F is defined on
% the interval [I(1) I(2)].
%
% Ricardo Pachon and Lloyd N. Trefethen, 2007, Chebfun Version 2.0
if(nargout<=1)
  varargout{1}=[f.ends(1) f.ends(end)];
else
  varargout{1}=f.ends(1);
  varargout{2}=f.ends(end);
end
