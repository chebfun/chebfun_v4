function varargout = size(F,dim)
% SIZE   Size of a CHEBFUN.
%
% See also length, numel.

% Chebfun Version 2.0

if F(1).trans
    m = numel(F);
    n = 1;
else
    m = 1;
    n = numel(F);
end

if nargin == 1 
    if nargout == 2
        varargout = {m ,n};
    else
        varargout = {[m ,n]};
    end
elseif dim==1
    varargout = {m};
else
    varargout = {n};
end
