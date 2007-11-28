function splitting(on_off)
%SPLITTING   CHEBFUN splitting option
%   SPLITTING ON allows the chebfun constructor to split the interval by
%   a process of automatic subdivision and edge detection.  This
%   option is recommended when working with functions with singularities.
%   SPLITTING OFF disables this kind of automatic splitting, and is
%   recommended for working with functions that are complicated but still
%   smooth.
%   Even with splitting off, breakpoints may still be introduced by
%   the MAX, MIN, ABS, CEIL, FLOOR, and ROUND commands.  One may switch
%   freely back and forth between the two modes during a chebfun computation.
%   SPLITTING, by itself, displays the current splitting state.
%

if nargin==0 
    switch getpref('chebfun_defaults','splitting')
        case 1 
            disp('SPLITTING is currently ON')
        case 0
            disp('SPLITTING is currently OFF')
    end
else
    if strcmp(on_off, 'on') || strcmp(on_off, 'ON')
        setpref('chebfun_defaults','splitting',1)
    elseif strcmp(on_off, 'off') || strcmp(on_off, 'OFF')
        setpref('chebfun_defaults','splitting',0)
    else
        error('CHEBFUN:split:UnknownOption', 'Unknown splitting option: only ON and OFF are valid options.')
    end
end