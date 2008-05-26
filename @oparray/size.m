function varargout = size(A,varargin)
% SIZE   Size.

% Copyright 2008 by Toby Driscoll. See www.comlab.ox.ac.uk/chebfun.

% Same calling options as for built-in size.

[varargout{1:nargout}] = size(A.op,varargin{:});

end