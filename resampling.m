function resampling(on_off)
%RESAMPLING   CHEBFUN resample option
%
%   RESAMPLING ON forces the chebfun constructor to sample a function at all 
%   Chebyshev points as it adapts the number of nodes needed for an accurate
%   representation.  This option is recommended when working with chebops
%   or if the values of the function depend on the number of points.
%
%   RESAMPLING OFF allows the constructor to sample only at new nodes whenever 
%   the number of nodes is doubled. This option is recommended when the
%   evaluations are time consuming.
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2008 by The Chebfun Team. 

if nargin==0 
    switch chebfunpref('resampling')
        case 1 
            disp('RESAMPLING is currently ON')
        case 0
            disp('RESAMPLING is currently OFF')
    end
else
    if strcmpi(on_off, 'on')
        chebfunpref('resampling',true)
    elseif strcmpi(on_off, 'off') 
        chebfunpref('resampling',false)
    else
        error('CHEBFUN:resampling:UnknownOption',...
          'Unknown resampling option: only ON and OFF are valid options.')
    end
end


