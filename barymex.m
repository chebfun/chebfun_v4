function varargout = barymex(varargin)
% BARYMEX  barycentric code option
%   BARYMEX by itself returns the current option of barycentric code.
%   BARYMEX ON enables chebfun to use the C implementation.
%   BARYMEX OFF disables the compiled C implementation of the barycentric
%   formula and uses the m-file implementation (Default).
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2008 by The Chebfun Team. 

persistent mybarypref

% Default value
if isempty(mybarypref)
    mybarypref = false;
    mlock % Use munlock if you edit this file (or restart matlab).
end

if nargin > 1
    error('chebfun:barymex:inputarg','Input must be either ON or OFF')
end
    
if nargout == 1
    varargout = {mybarypref};
elseif nargin < 1
    if mybarypref 
        disp('BARYMEX is currently ON')
    else
        disp('BARYMEX is currently OFF')
    end
elseif nargin == 1
    if strcmpi(varargin{1},'on')
       mybarypref = true;
    else 
       mybarypref = false;
    end
end    
    