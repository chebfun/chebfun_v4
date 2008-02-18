function varargout = size(f)
% SIZE Size of a chebfun.
% SIZE(F) returns size of chebfun F. Currently chebfuns can only be defined
% as columns so the size is equal to length(F) x 1.

% Ricardo Pachon and Lloyd N. Trefethen, 2007, Chebfun Version 2.0
m = length(f);
n = 1;
if(nargout<=1)
  varargout{1}=[m n];
else
  varargout{1}=m;
  varargout{2}=n;
end
