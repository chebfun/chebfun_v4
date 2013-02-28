function varargout = surf(f,varargin)
%SURF Plot of the surface represented by a chebfun2v.
% 
% SURF(F) is the surface plot of F, where F is a chebfun2v with three 
% components.
%
% SURF(F,...) allows for the same plotting options as Matlab's SURF
% command.
%
% See also CHEBFUN2/SURF. 

% Copyright 2013 by The University of Oxford and The Chebfun Developers.
% See http://www.maths.ox.ac.uk/chebfun/ for Chebfun information.

if isempty(f)
   surf([]);
   return; 
end

if isempty(f.zcheb)
    error('CHEBFUN2V:SURF','Chebfun2v does not represent a surface as it has only two components');
end

% short code, by making varargin non-empty
if ( isempty(varargin) )
    varargin = {}; 
end


% straight call to chebfun2/surf
h = surf(f.xcheb, f.ycheb, f.zcheb, varargin{:}); 

if ( nargout > 1 )
    varargout = {h}; 
end

end